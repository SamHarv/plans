import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plans/constants.dart';
import 'package:plans/services/firestore.dart';
import 'package:plans/state_management/riverpod_providers.dart';
import '../models/task.dart';

class TasksReorderable extends ConsumerStatefulWidget {
  const TasksReorderable({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TasksReorderableState();
}

class _TasksReorderableState extends ConsumerState<TasksReorderable> {
  late FirestoreService db;
  late List<Task> tasks;
  // late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();

    // Load tasks from Firestore and update the state
    db = ref.read(database);
    tasks = ref.read(tasksProvider);

    db.getTasks().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // setState(() {
        tasks = snapshot.docs.map((doc) {
          return Task(
            taskID: doc['taskID'],
            taskColour: db.colorFromString(doc['taskColour']),
            taskHeading: doc['taskHeading'],
            taskContents: doc['taskContents'],
            taskTag: doc['taskTag'],
          );
        }).toList();
        // });
      }
    });
  }

  Future<void> updateOrder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    tasks.insert(newIndex, tasks.removeAt(oldIndex));
    tasks = tasks.reversed.toList();
    final batch = FirebaseFirestore.instance.batch();
    for (Task task in tasks) {
      batch.update(db.tasks.doc(task.taskID), {'timestamp': Timestamp.now()});
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    // Update order of tasks when dragged

    return StreamBuilder<QuerySnapshot>(
      stream: db.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final tasksFromSnapshot = snapshot.data!.docs.map((doc) {
            return Task(
              taskID: doc['taskID'],
              taskColour: db.colorFromString(doc['taskColour']),
              taskHeading: doc['taskHeading'],
              taskContents: doc['taskContents'],
              taskTag: doc['taskTag'],
            );
          }).toList();

          final tasks = tasksFromSnapshot.map((task) {
            return InkResponse(
              borderRadius: BorderRadius.circular(64),
              key: ValueKey(task.taskID), // issue here
              onTap: () {
                // create task to navigate to based off selected task
                final destinationTask = Task(
                  taskColour: task.taskColour,
                  taskHeading: task.taskHeading,
                  taskContents: task.taskContents,
                  taskTag: task.taskTag,
                  taskID: task.taskID,
                );
                // if (task has subtasks) {
                // Navigate to subtask display taking task as argument;
                // } else {
                // Navigate to task display taking task as argument;
                // }
                // Open corresponding task
                Beamer.of(context)
                    .beamToNamed('/task-view', data: destinationTask);
              },
              child: SizedBox(
                //key: ValueKey(task),
                height: 100,
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: task.taskColour,
                      borderRadius: BorderRadius.circular(64),
                      border: Border.all(
                        // Have border if taskColour matches background colour
                        color: task.taskColour == colour
                            ? Colors.blueGrey
                            : colour,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        child: Text(
                          task.taskHeading,
                          style: headingStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList();
          return ReorderableListView(
            // make task edges rounded when moving
            proxyDecorator: (child, index, animation) => Material(
              borderRadius: BorderRadius.circular(64),
              child: child,
            ),

            onReorder: (oldIndex, newIndex) async {
              await updateOrder(oldIndex, newIndex);
            },
            children: tasks,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
