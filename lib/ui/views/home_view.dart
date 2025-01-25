import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/providers/providers.dart';
import '../widgets/reorderable_tasks_widget.dart';
import '../widgets/o2_tech_icon_widget.dart';
import '../../config/constants.dart';
import '../../data/models/task_model.dart';

class HomeView extends ConsumerStatefulWidget {
  /// Home page to display all tasks and create new ones
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final db = ref.read(database);
    return Scaffold(
      backgroundColor: colour,
      appBar: AppBar(
        title: appTitle,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: colour,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: secondaryColour,
            ),
            onPressed: () => Beamer.of(context).beamToNamed('/sign-in'),
          ),
          O2TechIconWidget(), // Launch O2Tech website
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ReorderableTasksWidget(), // Display all tasks
      ),
      // Add new task
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColour,
        onPressed: () {
          // Create new task object with unique ID
          final newTask = Task(
            taskColour: colour,
            taskID: db.generateTaskID(),
          );
          try {
            // Add task to database and navigate to task page
            db.addTask(task: newTask);
            Beamer.of(context).beamToNamed('/task-page', data: newTask);
          } catch (e) {
            showMessage(e.toString(), context);
          }
        },
        child: const Icon(
          Icons.add,
          color: colour,
        ),
      ),
    );
  }
}
