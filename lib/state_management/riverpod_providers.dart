import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../models/task.dart';

final taskColour = StateProvider<Color>((ref) => Colors.black);
final taskHeading = StateProvider<String>((ref) => "New Task");
final taskBody = StateProvider<String>((ref) => "");

// create a final variable for a list of tasks to be managed by Riverpod
final tasksProvider = StateProvider<List<Task>>((ref) => []);

final colourIsSelected = StateProvider<bool>((ref) => false);
