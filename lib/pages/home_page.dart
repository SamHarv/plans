import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '/state_management/riverpod_providers.dart';
import '/widgets/reorderable_tasks_widget.dart';
import '../constants.dart';
import '../models/task_model.dart';

final Uri _url = Uri.parse('https://oxygentech.com.au');

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
    // Navigate to sign in page if no user signed in
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
              // if generatedID is in db, generate new ID
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
        title: Text(
          'Plans',
          style: GoogleFonts.caveat(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'Caveat',
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: colour,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate to sign in page
              Beamer.of(context).beamToNamed('/sign-in');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: InkWell(
              child: Image.asset(
                // O2Tech logo => navigate to webpage
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
        child: ReorderableTasksWidget(), // build reorderable list of tasks
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
          Beamer.of(context).beamToNamed('/task-page', data: newTask);
        },
        child: const Icon(
          Icons.add,
          color: colour,
        ),
      ),
    );
  }
}
