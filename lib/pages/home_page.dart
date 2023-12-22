import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plans/state_management/riverpod_providers.dart';
// import 'package:plans/widgets/dialog.dart';
import 'package:plans/widgets/tasks_reorderable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../models/task.dart';

final Uri _url = Uri.parse('https://oxygentech.com.au');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(database);
    String generateTaskID() {
      var generatedID = Random().nextInt(999999).toString();
      // check if generatedID is in db already
      db.getTasks().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.forEach((doc) {
            if (doc['taskID'] == generatedID) {
              // if generatedID is in db, generate new ID
              generateTaskID();
            }
          });
        }
      });
      return generatedID;
    }

    return Scaffold(
      backgroundColor: colour,
      appBar: AppBar(
        title: const Text(
          'Plans',
          style: headingStyle,
        ),
        backgroundColor: colour,
        actions: [
          // Filter tasks
          // IconButton(
          //   icon: const Icon(
          //     Icons.filter_alt,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (context) => PlansDialog(
          //         dialogHeading: 'Filter Tasks',
          //         // Add UI and logic to filter by keyword in heading, content,
          //         // or tag
          //         dialogContent: const Placeholder(),
          //         dialogActions: [
          //           TextButton(
          //             onPressed: () {
          //               Navigator.pop(context);
          //             },
          //             child: const Text(
          //               'Cancel',
          //               style: bodyStyle,
          //             ),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               // Execute search filter
          //               Navigator.pop(context);
          //             },
          //             child: const Text(
          //               'Filter',
          //               style: bodyStyle,
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
          // Navigate to profile/ auth page
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate to profile/ auth page when built
              // Beamer.of(context).beamToNamed('/profile');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: InkWell(
              child: Image.asset(
                // O2Tech logo => navigate home
                'images/1.png',
                fit: BoxFit.contain,
                height: 24.0,
              ),
              onTap: () => _launchUrl(),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TasksReorderable(), // build reorderable list of tasks
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Create blank new task
          final newTask = Task(
            taskColour: colour,
            taskID: generateTaskID(), // this will change when saved to database
          );
          db.addTask(task: newTask);

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
