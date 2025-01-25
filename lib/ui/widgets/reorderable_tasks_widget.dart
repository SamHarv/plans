import 'dart:async';

import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants.dart';
import '../../data/repos/firestore_service.dart';
import '../../logic/providers/riverpod_providers.dart';
import '../../data/models/task_model.dart';

class ReorderableTasksWidget extends ConsumerStatefulWidget {
  /// Reorderable list of tasks for home page

  const ReorderableTasksWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReorderableTasksWidgetState();
}

class _ReorderableTasksWidgetState
    extends ConsumerState<ReorderableTasksWidget> {
  late FirestoreService db;
  late List<Task> tasks;
  // late String filter; // not in use
  // late bool isFiltered; // not in use

  @override
  void initState() {
    super.initState();

    db = ref.read(database);
    tasks = ref.read(tasksProvider);
    // filter = ref.read(filterProvider); // not in use
    // isFiltered = ref.read(isFilteredProvider); // not in use

    // get tasks - necessary for reordering
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

  // Update order of tasks
  Future<void> updateOrder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    tasks.insert(newIndex, tasks.removeAt(oldIndex));
    // Reverse list to update timestamp in correct order
    tasks = tasks.reversed.toList();
    final batch = FirebaseFirestore.instance.batch();
    // Using indexed numerical key rather than actual time to update timestamp
    // for improved efficiency
    for (int i = 0; i < tasks.length; i++) {
      batch.update(db.tasks.doc(tasks[i].taskID), {'timestamp': i});
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to task changes
    return StreamBuilder<QuerySnapshot>(
      stream: db.getTasks(),
      builder: (context, snapshot) {
        // Display error message if error occurs
        if (snapshot.hasError) {
          return Center(
            child: Text('An error occurred: ${snapshot.error}'),
          );
        }
        // Display loading spinner while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: secondaryColour,
            ),
          );
        }
        // Display message if no tasks are found
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No entries found!\n\n'
                    'Add a new task by tapping the + button below.',
                    style: headingStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                // Image.asset('images/arrow.png'),
              ],
            ),
          );
        }
        // Display tasks if tasks are found
        if (snapshot.data!.docs.isNotEmpty && snapshot.data != null) {
          final tasksFromSnapshot = snapshot.data!.docs.map((doc) {
            return Task(
              taskID: doc['taskID'],
              taskColour: db.getColourFromString(doc['taskColour']),
              taskHeading: doc['taskHeading'],
              taskContents: doc['taskContents'],
              taskTag: doc['taskTag'],
            );
          }).toList();

          // Build tasks for reordering and navigation to task page
          final tasks = tasksFromSnapshot.map((task) {
            return InkResponse(
              borderRadius: BorderRadius.circular(64),
              key: ValueKey(task.taskID),
              onTap: () {
                // Get task and navigate to task page
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: task.taskColour,
                    borderRadius: BorderRadius.circular(64),
                    border: Border.all(
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
            );
          }).toList();
          return ReorderableListView(
            // buildDefaultDragHandles: false,
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
            child: CircularProgressIndicator(
              color: secondaryColour,
            ),
          );
        }
      },
    );
  }
}
