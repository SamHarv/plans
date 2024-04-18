import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/state_management/riverpod_providers.dart';
import '/widgets/reorderable_tasks_widget.dart';
import '/constants.dart';
import '/models/task_model.dart';

final _url = Uri.parse('https://oxygentech.com.au');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Beamer.of(context).beamToNamed('/sign-in');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.read(database);

    // Recursively generate unique taskID
    String generateTaskID() {
      var generatedID = Random().nextInt(999999).toString();
      db.getTasks().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            if (doc['taskID'] == generatedID) {
              generateTaskID();
            }
          }
        }
      });
      return generatedID;
    }

    return Scaffold(
      backgroundColor: colour,
      appBar: AppBar(
        title: appTitle,
        automaticallyImplyLeading: false,
        backgroundColor: colour,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list_alt,
              color: Colors.white,
            ),
            onPressed: () {
              // Dialog to add filter
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Filter Tasks',
                    style: headingStyle,
                  ),
                  backgroundColor: Colors.black,
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text(
                              'All',
                              style: bodyStyle,
                            ),
                            leading: Radio(
                              activeColor: colour,
                              value: '',
                              groupValue: ref.watch(filterProvider),
                              onChanged: (value) {
                                setState(() {
                                  ref.read(filterProvider.notifier).state =
                                      value.toString();
                                  ref.read(isFilteredProvider.notifier).state =
                                      false;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'O2Tech',
                              style: bodyStyle,
                            ),
                            leading: Radio(
                              activeColor: colour,
                              value: 'O2Tech',
                              groupValue: ref.watch(filterProvider),
                              onChanged: (value) {
                                setState(() {
                                  ref.read(filterProvider.notifier).state =
                                      value.toString();
                                  ref.read(isFilteredProvider.notifier).state =
                                      true;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Personal',
                              style: bodyStyle,
                            ),
                            leading: Radio(
                              activeColor: colour,
                              value: 'Personal',
                              groupValue: ref.watch(filterProvider),
                              onChanged: (value) {
                                setState(() {
                                  ref.read(filterProvider.notifier).state =
                                      value.toString();
                                  ref.read(isFilteredProvider.notifier).state =
                                      true;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Go',
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
            onPressed: () {
              Beamer.of(context).beamToNamed('/sign-in');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: InkWell(
              child: Image.asset(
                'images/2.png',
                fit: BoxFit.contain,
                height: 24.0,
              ),
              onTap: () => _launchUrl(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ReorderableTasksWidget(),
      ),
      // Comment out below
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => Beamer.of(context).beamToNamed('/habit-tracker'),
              child: const Icon(
                Icons.calendar_month,
                color: colour,
              ),
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                final newTask = Task(
                  taskColour: colour,
                  taskID: generateTaskID(),
                );
                db.addTask(task: newTask);
                Beamer.of(context).beamToNamed('/task-page', data: newTask);
                // showDialog(
                //   context: context,
                //   builder: (context) => CustomDialogWidget(
                //     dialogHeading: "Select Task Type",
                //     dialogActions: [
                //       TextButton(
                //         onPressed: () {
                //           Navigator.pop(context);
                //         },
                //         child: const Text(
                //           'Cancel',
                //           style: bodyStyle,
                //         ),
                //       ),
                //       TextButton(
                //         onPressed: () {
                //           final newTask = Task(
                //             taskColour: colour,
                //             taskID: generateTaskID(),
                //           );
                //           db.addTask(task: newTask);
                //           Beamer.of(context)
                //               .beamToNamed('/task-page', data: newTask);
                //         },
                //         child: const Text(
                //           'Note',
                //           style: bodyStyle,
                //         ),
                //       ),
                //       TextButton(
                //         onPressed: () {
                //           // TODO: Create new checklist
                //           // final newTask = Task(
                //           //   taskColour: colour,
                //           //   taskID: generateTaskID(),
                //           // );
                //           // db.addTask(task: newTask);
                //           // Beamer.of(context)
                //           //     .beamToNamed('/task-page', data: newTask);
                //         },
                //         child: const Text(
                //           'Checklist',
                //           style: bodyStyle,
                //         ),
                //       ),
                //     ],
                //   ),
                // );
              },
              child: const Icon(
                Icons.add,
                color: colour,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
