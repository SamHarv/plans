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
  // Dummy data until DB is up and running
  final tasks = [
    Task(
      taskID: "0",
      taskColour: blue,
      taskHeading: "Task 1",
      taskContents: "This is the first task",
      taskTag: "Tag 1",
    ),
    Task(
      taskID: "1",
      taskColour: red,
      taskHeading: "Task 2",
      taskContents: "",
      taskTag: "Tag 2",
    ),
    Task(
      taskID: "2",
      taskColour: colour,
      taskHeading: "Task 3",
      taskContents: "This is the third task",
      taskTag: "Tag 3",
    ),
    Task(
      taskID: "3",
      taskColour: yellow,
      taskHeading: "Task 4",
      taskContents: "This is the fourth task",
      taskTag: "Tag 4",
    ),
    Task(
      taskID: "4",
      taskColour: green,
      taskHeading: "Task 5",
      taskContents: "This is the fifth task",
      taskTag: "Tag 5",
    ),
    Task(
      taskID: "5",
      taskColour: orange,
      taskHeading: "Task 6",
      taskContents: "This is the sixth task",
      taskTag: "Tag 6",
    ),
    Task(
      taskID: "6",
      taskColour: blueGrey,
      taskHeading: "Task 7",
      taskContents: "This is the seventh task",
      taskTag: "Tag 7",
    ),
    Task(
      taskID: "7",
      taskColour: brown,
      taskHeading: "Task 8",
      taskContents: "This is the eighth task",
      taskTag: "Tag 8",
    ),
    Task(
      taskID: "8",
      taskColour: pink,
      taskHeading: "Task 9",
      taskContents: "This is the ninth task",
      taskTag: "Tag 9",
    ),
    Task(
      taskID: "9",
      taskColour: black,
      taskHeading: "Task 10",
      taskContents: "This is the tenth task",
      taskTag: "Tag 10",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Update order of tasks when dragged
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
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: task.taskColour,
                    borderRadius: BorderRadius.circular(64),
                    border: Border.all(
                      // Have border if taskColour matches background colour
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
