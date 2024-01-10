import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../constants.dart';

class FirestoreService {
  // get collection of tasks
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  // create
  Future<void> addTask({required Task task}) async {
    await tasks.doc(task.taskID).set({
      'taskID': task.taskID,
      'taskColour': task.taskColour.toString(),
      'taskHeading': task.taskHeading,
      'taskContents': task.taskContents,
      'taskTag': task.taskTag,
      'timestamp': Timestamp.now(),
    });
  }

  // read
  Stream<QuerySnapshot> getTasks() {
    return tasks.orderBy('timestamp', descending: true).snapshots();
    // return tasks.orderBy('order', descending: false).snapshots();
  }

  // get single task by taskID
  Future<Task> getTask(String taskID) async {
    final task = await tasks.doc(taskID).get();
    return Task(
      taskID: task['taskID'],
      taskColour: colorFromString(task['taskColour']),
      taskHeading: task['taskHeading'],
      taskContents: task['taskContents'],
      taskTag: task['taskTag'],
    );
  }

  // get colour from String
  Color colorFromString(String colorString) {
    //const String colourString = "Color(0xff374854)";
    const String blueString = "Color(0xff014c63)";
    const String redString = "Color(0xff890000)";
    const String yellowString = "Color(0xffba9600)";
    const String greenString = "Color(0xff3b5828)";
    const String orangeString = "Color(0xffae3d00)";
    const String blueGreyString =
        "MaterialColor(primary value: Color(0xff607d8b))";
    const String brownString = "Color(0xff4e4544)";
    const String pinkString = "Color(0xff7f7384)";
    const String blackString = "Color(0xff101820)";

    switch (colorString) {
      case blueString:
        return blue;
      case redString:
        return red;
      case yellowString:
        return yellow;
      case greenString:
        return green;
      case orangeString:
        return orange;
      case blueGreyString:
        return blueGrey;
      case brownString:
        return brown;
      case pinkString:
        return pink;
      case blackString:
        return black;
      default:
        return colour;
    }
  }

  // update
  Future<void> updateTask(String taskID, Task newTask) async {
    await tasks.doc(taskID).update({
      'taskID': taskID,
      'taskColour': newTask.taskColour.toString(),
      'taskHeading': newTask.taskHeading,
      'taskContents': newTask.taskContents,
      'taskTag': newTask.taskTag,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> updateTimeStamp(String taskID) async {
    await tasks.doc(taskID).update({
      'timestamp': Timestamp.now(),
    });
  }

  // delete
  Future<void> deleteTask(String taskID) async {
    // get index of task, then update all tasks with higher index to -1
    await tasks.doc(taskID).delete();
  }
}
