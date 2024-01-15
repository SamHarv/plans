import 'package:flutter/material.dart';
import 'package:plans/services/firestore.dart';
import 'package:riverpod/riverpod.dart';

import '../models/task.dart';

// create a final variable for a list of tasks to be managed by Riverpod
final tasksProvider = StateProvider<List<Task>>((ref) => []);

final colourIsSelected = StateProvider<bool>((ref) => false);
final selectedColourProvider = StateProvider<Color>((ref) => Colors.black);

final database = StateProvider((ref) => FirestoreService());

// final loggedIn = StateProvider<bool>((ref) => false);
final registered = StateProvider<bool>((ref) => true);
