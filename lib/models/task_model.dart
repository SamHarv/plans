import 'package:flutter/material.dart';
import 'package:plans/constants.dart';

class Task {
  String taskID;
  Color taskColour;
  String taskHeading;
  String taskContents;
  String taskTag;

  Task({
    required this.taskID,
    this.taskColour = colour,
    this.taskHeading = "",
    this.taskContents = "",
    this.taskTag = "",
  });
}
