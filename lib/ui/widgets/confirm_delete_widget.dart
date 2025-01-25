import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/repos/firestore_service.dart';
import '../../config/constants.dart';
import 'custom_dialog_widget.dart';

class ConfirmDeleteWidget extends StatelessWidget {
  /// A widget that displays a dialog to confirm the deletion of a task.
  final FirestoreService db;
  final Task task;

  const ConfirmDeleteWidget({super.key, required this.db, required this.task});

  @override
  Widget build(BuildContext context) {
    return CustomDialogWidget(
      dialogHeading: "Delete Task",
      dialogContent: const Text(
        "Are you sure you want to delete this task?",
        style: bodyStyle,
      ),
      dialogActions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: bodyStyle,
          ),
        ),
        // Delete button
        TextButton(
          onPressed: () {
            // Delete the task from the database
            db.deleteTask(task.taskID);
            // Close the dialog and navigate to the home page
            Navigator.pop(context);
            Beamer.of(context).beamToNamed('/home');
          },
          child: const Text(
            'Delete',
            style: bodyStyle,
          ),
        ),
      ],
    );
  }
}
