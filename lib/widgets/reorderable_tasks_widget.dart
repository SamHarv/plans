import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../services/firestore.dart';
import '../state_management/riverpod_providers.dart';
import '../models/task_model.dart';

class ReorderableTasksWidget extends ConsumerStatefulWidget {
  const ReorderableTasksWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReorderableTasksWidgetState();
}

class _ReorderableTasksWidgetState
    extends ConsumerState<ReorderableTasksWidget> {
  late FirestoreService db;
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();

    // Initialise database and tasks
    db = ref.read(database);
    tasks = ref.read(tasksProvider);

    // Get tasks and map them to list for implementation
    // This allows reordering of tasks
    db.getTasks().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        tasks = snapshot.docs.map((doc) {
          return Task(
            taskID: doc['taskID'],
            taskColour: db.getColourFromString(doc['taskColour']),
            taskHeading: doc['taskHeading'],
            taskContents: doc['taskContents'],
            taskTag: doc['taskTag'],
          );
        }).toList();
      }
    });
  }

  // Update order of tasks in database by updating timestamp
  // May need to find a way to improve efficiency
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
    // Listen to task changes
    return StreamBuilder<QuerySnapshot>(
      stream: db.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final tasksFromSnapshot = snapshot.data!.docs.map((doc) {
            return Task(
              taskID: doc['taskID'],
              taskColour: db.getColourFromString(doc['taskColour']),
              taskHeading: doc['taskHeading'],
              taskContents: doc['taskContents'],
              taskTag: doc['taskTag'],
            );
          }).toList();

          // Build tasks for reordering and navigation to
          final tasks = tasksFromSnapshot.map((task) {
            return InkResponse(
              borderRadius: BorderRadius.circular(64),
              key: ValueKey(task.taskID),
              onTap: () {
                final destinationTask = Task(
                  taskColour: task.taskColour,
                  taskHeading: task.taskHeading,
                  taskContents: task.taskContents,
                  taskTag: task.taskTag,
                  taskID: task.taskID,
                );
                Beamer.of(context)
                    .beamToNamed('/task-page', data: destinationTask);
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
                        color: task.taskColour == colour ? blueGrey : colour,
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
            // Make task edges rounded when highlighted
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