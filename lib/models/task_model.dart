import 'package:flutter/material.dart';

class TaskModel {
  int taskID;
  Color taskColour;
  String taskHeading;
  String taskBody;
  String taskTag;

  TaskModel({
    required this.taskID,
    required this.taskColour,
    required this.taskHeading,
    required this.taskBody,
    required this.taskTag,
  });

  void generateTaskID() {
    // Generate random task ID
    // while (taskID exists in list) {generateTaskID();}
    // Assign generated unique ID to task
  }
}
