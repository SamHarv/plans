import 'package:flutter/material.dart';
import '../widgets/task_box.dart';

class TasksReorderable extends StatefulWidget {
  const TasksReorderable({super.key});

  @override
  State<TasksReorderable> createState() => _TasksReorderableState();
}

class _TasksReorderableState extends State<TasksReorderable> {
  final List<TaskBox> tasks = [
    const TaskBox(
      boxColour: Colors.red,
      heading: '1',
    ),
    const TaskBox(
      boxColour: Colors.orange,
      heading: '2',
    ),
    const TaskBox(
      boxColour: Colors.yellow,
      heading: '3',
    ),
    const TaskBox(
      boxColour: Colors.green,
      heading: '4',
    ),
    const TaskBox(
      boxColour: Colors.blue,
      heading: '5',
    ),
    const TaskBox(
      boxColour: Colors.indigo,
      heading: '6',
    ),
    const TaskBox(
      boxColour: Colors.pinkAccent,
      heading: '7',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    void updateOrder(int oldIndex, int newIndex) {
      setState(() {
        if (newIndex > oldIndex) {
          newIndex--;
        }
        final TaskBox task = tasks.removeAt(oldIndex);
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
              updateOrder(1, 5);
              updateOrder(0, 4);
              updateOrder(2, 3);
              updateOrder(3, 6);
              updateOrder(4, 1);
              updateOrder(5, 2);
              updateOrder(6, 7);
            },
            child: SizedBox(
              //key: ValueKey(task),
              height: 100,
              width: double.infinity,
              child: task,
            ),
          ),
      ],
    );
  }
}
