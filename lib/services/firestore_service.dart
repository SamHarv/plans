import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/models/task_model.dart';
import '/constants.dart';

class FirestoreService {
  // Get collection of users
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Get collection of the user's tasks
  final CollectionReference tasks = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('tasks');

  // Create new task for current user
  Future<void> addTask({required Task task}) async {
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .doc(task.taskID)
        .set({
      'userID': FirebaseAuth.instance.currentUser?.uid,
      'taskID': task.taskID,
      'taskColour': getStringFromColour(task.taskColour),
      'taskHeading': task.taskHeading,
      'taskContents': task.taskContents,
      'taskTag': task.taskTag,
      'timestamp': Timestamp.now(),
    });
  }

  // Create new user
  Future<void> addUser({required String userID}) async {
    await users.doc(userID).set({
      'userID': userID,
    });
  }

  // Get all tasks for current user
  Stream<QuerySnapshot> getTasks() {
    return users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get tasks by filter for current user
  Stream<QuerySnapshot> getFilteredTasks(String filter, bool isFiltered) {
    if (!isFiltered) {
      return users
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('tasks')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return users
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('tasks')
          .where('taskTag', isEqualTo: filter)
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  // Get single task by taskID
  Future<Task> getTask(String taskID) async {
    final task = await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .doc(taskID)
        .get();
    return Task(
      taskID: task['taskID'],
      taskColour: getColourFromString(task['taskColour']),
      taskHeading: task['taskHeading'],
      taskContents: task['taskContents'],
      taskTag: task['taskTag'],
    );
  }

  String getStringFromColour(Color colour) {
    if (colour == blue) {
      return "Color(0xff014c63)";
    } else if (colour == red) {
      return "Color(0xff890000)";
    } else if (colour == yellow) {
      return "Color(0xffba9600)";
    } else if (colour == green) {
      return "Color(0xff3b5828)";
    } else if (colour == orange) {
      return "Color(0xffae3d00)";
    } else if (colour == blueGrey) {
      return "Color(0xff607d8b)";
    } else if (colour == brown) {
      return "Color(0xff4e4544)";
    } else if (colour == pink) {
      return "Color(0xff7f7384)";
    } else if (colour == black) {
      return "Color(0xff101820)";
    } else {
      return "Color(0xff374854)";
    }
  }

  // Get colour from String
  Color getColourFromString(String colourString) {
    const String blueString = "Color(0xff014c63)";
    const String redString = "Color(0xff890000)";
    const String yellowString = "Color(0xffba9600)";
    const String greenString = "Color(0xff3b5828)";
    const String orangeString = "Color(0xffae3d00)";
    const String blueGreyString = "Color(0xff607d8b)";
    const String brownString = "Color(0xff4e4544)";
    const String pinkString = "Color(0xff7f7384)";
    const String blackString = "Color(0xff101820)";

    switch (colourString) {
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

  // Update task for current user
  Future<void> updateTask(String taskID, Task newTask) async {
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .doc(taskID)
        .update({
      'taskID': taskID,
      'taskColour': getStringFromColour(newTask.taskColour),
      'taskHeading': newTask.taskHeading,
      'taskContents': newTask.taskContents,
      'taskTag': newTask.taskTag,
      'timestamp': Timestamp.now(),
    });
  }

  // Update timestamp for task for reordering
  Future<void> updateTimeStamp(String taskID) async {
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .doc(taskID)
        .update({
      'timestamp': Timestamp.now(),
    });
  }

  // Delete task for current user
  Future<void> deleteTask(String taskID) async {
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .doc(taskID)
        .delete();
  }
}
