import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/services/auth.dart';
import '../../logic/services/url_launcher.dart';
import '../../data/repos/firestore_service.dart';
import '../../data/models/task_model.dart';

/// Provide list of tasks
final tasksProvider = StateProvider<List<Task>>((ref) => []);

/// Provide singleton for Firestore database
final database = StateProvider((ref) => FirestoreService());

/// Provide singleton for [UrlLauncher]
final url = StateProvider((ref) => UrlLauncher());

/// Provide singleton for [Auth]
final auth = StateProvider((ref) => Auth());

// Filter for tasks - not in use
// final filterProvider = StateProvider<String>((ref) => '');

// bool for isFiltered - not in use
// final isFilteredProvider = StateProvider<bool>((ref) => false);
