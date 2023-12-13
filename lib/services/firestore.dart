import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class FirestoreService {
  // get collection of tasks
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  // create
  Future<void> addTask({required Task task}) async {
    await tasks.add({
      'taskID': task.generateTaskID(),
      'taskColour': task.taskColour.toString(),
      'taskHeading': task.taskHeading,
      'taskContents': task.taskContents,
      'taskTag': task.taskTag,
      'timestamp': Timestamp.now(),
    });
  }

  // read

  // update

  // delete
}
