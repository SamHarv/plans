import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/providers/riverpod_providers.dart';
import '../widgets/reorderable_tasks_widget.dart';
import '../widgets/o2_tech_icon.dart';
import '../../config/constants.dart';
import '../../data/models/task_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
          O2TechIcon(),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ReorderableTasksWidget(),
      ),
      // Comment out below
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColour,
        onPressed: () {
          final newTask = Task(
            taskColour: colour,
            taskID: db.generateTaskID(),
          );
          try {
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
