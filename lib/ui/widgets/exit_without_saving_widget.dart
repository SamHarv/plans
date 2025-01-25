import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../data/repos/firestore_service.dart';
import '../../config/constants.dart';
import '../../data/models/task_model.dart';
import 'custom_dialog_widget.dart';

class ExitWithoutSavingWidget extends StatelessWidget {
  /// A widget that prompts the user to enter a heading before

  final FirestoreService db;
  final Task task;

  const ExitWithoutSavingWidget({
    super.key,
    required this.db,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialogWidget(
      dialogHeading: "Enter a Heading to Save",
      dialogContent: const Text(
        "If you would like to save the task, please enter a "
        "heading.",
        style: bodyStyle,
      ),
      dialogActions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // stay on task
          child: const Text(
            'Cancel',
            style: bodyStyle,
          ),
        ),
        TextButton(
          onPressed: () {
            // Delete task if user exits without saving
            db.deleteTask(task.taskID);
            Beamer.of(context).beamToNamed('/home');
          },
          child: const Text(
            'Exit Without Saving',
            style: bodyStyle,
          ),
        ),
      ],
    );
  }
}
