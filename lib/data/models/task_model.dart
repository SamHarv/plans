import 'package:flutter/material.dart';
import '../../config/constants.dart';

/// [Task] model to represent a task entry
class Task {
  String taskID;
  Color taskColour;
  String taskHeading;
  String taskContents;
  String taskTag;

  Task({
    required this.taskID,
    this.taskColour = colour, // Default colour
    this.taskHeading = "",
    this.taskContents = "",
    this.taskTag = "", // Not in use
  });
}
