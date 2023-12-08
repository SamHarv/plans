import 'dart:math';

import 'package:flutter/material.dart';

class Task {
  String taskID;
  Color taskColour;
  String taskHeading;
  String taskContents;
  String taskTag;
  String taskPriority;

  Task({
    required this.taskID,
    required this.taskColour,
    required this.taskHeading,
    required this.taskContents,
    required this.taskTag,
    required this.taskPriority,
  });

  // generate random task ID betweem 0 and 999999
  void generateTaskID() {
    taskID = Random().nextInt(999999).toString();
  }

  Color getTaskColour() {
    return taskColour;
  }

  String getTaskContents() {
    return taskContents;
  }

  String getTaskHeading() {
    return taskHeading;
  }

  String getTaskID() {
    return taskID;
  }

  String getTaskPriority() {
    return taskPriority;
  }

  String getTaskTag() {
    return taskTag;
  }

  void setTaskColour(Color newColour) {
    taskColour = newColour;
  }

  void setTaskContents(String newContents) {
    taskContents = newContents;
  }

  void setTaskHeading(String newHeading) {
    taskHeading = newHeading;
  }

  void setTaskID(String newID) {
    taskID = newID;
  }

  void setTaskPriority(String newPriority) {
    taskPriority = newPriority;
  }

  void setTaskTag(String newTag) {
    taskTag = newTag;
  }
}
