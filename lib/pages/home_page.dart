import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:plans/widgets/dialog.dart';
import 'package:plans/widgets/tasks_reorderable.dart';

import '../constants.dart';
import '../models/task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colour,
      appBar: AppBar(
        title: const Text(
          'Plans',
          style: headingStyle,
        ),
        backgroundColor: colour,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => PlansDialog(
                  dialogHeading: 'Filter Tasks',
                  dialogContent: const Placeholder(),
                  dialogActions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: bodyStyle,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Filter',
                        style: bodyStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: InkWell(
              child: Image.asset(
                'images/1.png',
                fit: BoxFit.contain,
                height: 24.0,
              ),
              onTap: () => Beamer.of(context).beamToNamed('/'),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TasksReorderable(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Create blank new task
          final newTask = Task(
            taskColour: colour,
            taskID: '0000',
          );
          // Navigate to blank task view
          Beamer.of(context).beamToNamed('/task-view', data: newTask);
        },
        child: const Icon(
          Icons.add,
          color: colour,
        ),
      ),
    );
  }
}
