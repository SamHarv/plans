import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../../config/constants.dart';

/// Firestore service to interact with Firestore database
class Firestore {
  /// Get collection of users
  final users = FirebaseFirestore.instance.collection('users');

  /// Get collection of a user's tasks
  final tasks = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('tasks');

  /// Create new task for current user
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

  // Recursively generate unique taskID for a new task
  String generateTaskID() {
    final generatedID = Random().nextInt(999999).toString();
    getTasks().listen((snapshot) {
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

  /// Create new user
  Future<void> addUser({required String userID}) async {
    await users.doc(userID).set({
      'userID': userID,
    });
  }

  /// Get all tasks for current user
  Stream<QuerySnapshot> getTasks() {
    return users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get tasks by filter for current user - not in use
  // Stream<QuerySnapshot> getFilteredTasks(String filter, bool isFiltered) {
  //   if (!isFiltered) {
  //     return users
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .collection('tasks')
  //         .orderBy('timestamp', descending: true)
  //         .snapshots();
  //   } else {
  //     return users
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .collection('tasks')
  //         .where('taskTag', isEqualTo: filter)
  //         .orderBy('timestamp', descending: true)
  //         .snapshots();
  //   }
  // }

  /// Get single task by taskID
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

  /// Get the string representation of a colour
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

  /// Get colour from String
  Color getColourFromString(String colourString) {
    const blueString = "Color(0xff014c63)";
    const redString = "Color(0xff890000)";
    const yellowString = "Color(0xffba9600)";
    const greenString = "Color(0xff3b5828)";
    const orangeString = "Color(0xffae3d00)";
    const blueGreyString = "Color(0xff607d8b)";
    const brownString = "Color(0xff4e4544)";
    const pinkString = "Color(0xff7f7384)";
    const blackString = "Color(0xff101820)";

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

  /// Update task for current user
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

  /// Update timestamp for task for chronological reordering
  Future<void> updateTimeStamp(String taskID) async {
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .doc(taskID)
        .update({
      'timestamp': Timestamp.now(),
    });
  }

  /// Delete current task for current user
  Future<void> deleteTask(String taskID) async {
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .doc(taskID)
        .delete();
  }
}
