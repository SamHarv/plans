import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plans/constants.dart';
import '../models/task.dart';

class TasksReorderable extends ConsumerStatefulWidget {
  const TasksReorderable({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TasksReorderableState();
}

class _TasksReorderableState extends ConsumerState<TasksReorderable> {
  final tasks = [
    Task(
      taskID: "0",
      taskColour: Colors.red,
      taskHeading: "Task 1",
      taskContents: "This is the first task",
      taskTag: "Tag 1",
      taskPriority: "High",
    ),
    Task(
      taskID: "1",
      taskColour: Colors.blue,
      taskHeading: "Task 2",
      taskContents: "",
      taskTag: "Tag 2",
      taskPriority: "Medium",
    ),
    Task(
      taskID: "2",
      taskColour: colour,
      taskHeading: "Task 3",
      taskContents: "This is the third task",
      taskTag: "Tag 3",
      taskPriority: "Low",
    ),
    Task(
      taskID: "3",
      taskColour: Colors.yellow,
      taskHeading: "Task 4",
      taskContents: "This is the fourth task",
      taskTag: "Tag 4",
      taskPriority: "High",
    ),
    Task(
      taskID: "4",
      taskColour: Colors.green,
      taskHeading: "Task 5",
      taskContents: "This is the fifth task",
      taskTag: "Tag 5",
      taskPriority: "Medium",
    ),
    Task(
      taskID: "5",
      taskColour: Colors.orange,
      taskHeading: "Task 6",
      taskContents: "This is the sixth task",
      taskTag: "Tag 6",
      taskPriority: "Low",
    ),
    Task(
      taskID: "6",
      taskColour: Colors.blueGrey,
      taskHeading: "Task 7",
      taskContents: "This is the seventh task",
      taskTag: "Tag 7",
      taskPriority: "High",
    ),
    Task(
      taskID: "7",
      taskColour: Colors.teal,
      taskHeading: "Task 8",
      taskContents: "This is the eighth task",
      taskTag: "Tag 8",
      taskPriority: "Medium",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    void updateOrder(int oldIndex, int newIndex) {
      setState(() {
        if (newIndex > oldIndex) {
          newIndex--;
        }
        final Task task = tasks.removeAt(oldIndex);
        tasks.insert(newIndex, task);
      });
    }

    return ReorderableListView(
      //buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) => updateOrder(oldIndex, newIndex),
      children: [
        for (final task in tasks)
          InkResponse(
            key: ValueKey(task),
            onTap: () {
              final destinationTask = Task(
                taskColour: task.taskColour,
                taskHeading: task.taskHeading,
                taskContents: task.taskContents,
                taskTag: task.taskTag,
                taskPriority: task.taskPriority,
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
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: task.taskColour,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          task.taskColour == colour ? Colors.blueGrey : colour,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      task.taskHeading,
                      style: headingStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
