import 'dart:async';

import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants.dart';
import '../../data/database/firestore.dart';
import '../../logic/providers/providers.dart';
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
  late Firestore db;
  List<Task> _localTasks = [];
  bool _isReordering = false;

  @override
  void initState() {
    super.initState();
    db = ref.read(database);
  }

  // Update order of tasks
  Future<void> updateOrder(int oldIndex, int newIndex) async {
    // Set flag to prevent multiple simultaneous reordering operations
    if (_isReordering) return;

    setState(() {
      _isReordering = true;
    });

    try {
      // Adjust indices for removing and inserting
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      // Create a new list to avoid direct state mutation
      List<Task> updatedTasks = List.from(_localTasks);
      final Task movedTask = updatedTasks.removeAt(oldIndex);
      updatedTasks.insert(newIndex, movedTask);

      // Update local state first for immediate UI feedback
      setState(() {
        // updatedTasks = updatedTasks.reversed.toList();
        _localTasks = updatedTasks;
      });

      // Create batch update
      final batch = FirebaseFirestore.instance.batch();

      // Update positions in Firestore (use index as position)
      for (int i = 0; i < updatedTasks.length; i++) {
        batch.update(db.tasks.doc(updatedTasks[i].taskID),
            {'timestamp': updatedTasks.length - i});
      }

      // Commit batch update
      await batch.commit();
    } catch (e) {
      // Handle errors - possibly revert the local state if needed
      print('Error updating task order: $e');

      // Refresh from server if there was an error
      // This could create a visual "jump" but ensures data consistency
      final snapshot = await db.getTasks().first;
      setState(() {
        _localTasks = snapshot.docs.map((doc) {
          return Task(
            taskID: doc['taskID'],
            taskColour: db.getColourFromString(doc['taskColour']),
            taskHeading: doc['taskHeading'],
            taskContents: doc['taskContents'],
            taskTag: doc['taskTag'],
          );
        }).toList();
      });
    } finally {
      // Reset reordering flag
      setState(() {
        _isReordering = false;
      });
    }
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
        if (snapshot.connectionState == ConnectionState.waiting &&
            _localTasks.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: secondaryColour,
            ),
          );
        }

        // Update local tasks only if we're not in the middle of reordering
        // This prevents the list from jumping during drag operations
        if (snapshot.hasData && !_isReordering) {
          _localTasks = snapshot.data!.docs.map((doc) {
            return Task(
              taskID: doc['taskID'],
              taskColour: db.getColourFromString(doc['taskColour']),
              taskHeading: doc['taskHeading'],
              taskContents: doc['taskContents'],
              taskTag: doc['taskTag'],
            );
          }).toList();
        }

        // Display message if no tasks are found
        if (_localTasks.isEmpty) {
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

        // Build tasks for reordering and navigation to task page
        final taskWidgets = _localTasks.map((task) {
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
          // Improve performance by using a key based on the list content
          key: ValueKey(_localTasks.map((t) => t.taskID).join('-')),
          // Make task edges rounded when highlighted
          proxyDecorator: (child, index, animation) => Material(
            elevation: 4.0, // Add elevation for better visual feedback
            borderRadius: BorderRadius.circular(64),
            child: child,
          ),
          onReorder: (oldIndex, newIndex) async {
            await updateOrder(oldIndex, newIndex);
          },
          children: taskWidgets,
        );
      },
    );
  }
}
