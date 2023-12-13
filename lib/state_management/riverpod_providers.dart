import 'package:riverpod/riverpod.dart';

import '../models/task.dart';

// create a final variable for a list of tasks to be managed by Riverpod
final tasksProvider = StateProvider<List<Task>>((ref) => []);

final colourIsSelected = StateProvider<bool>((ref) => false);
