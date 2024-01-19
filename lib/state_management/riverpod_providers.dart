import 'package:plans/services/firestore.dart';
import 'package:riverpod/riverpod.dart';

import '../models/task_model.dart';

// List of tasks
final tasksProvider = StateProvider<List<Task>>((ref) => []);

// Firestore database
final database = StateProvider((ref) => FirestoreService());
