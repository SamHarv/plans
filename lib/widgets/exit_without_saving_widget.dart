import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '/services/firestore_service.dart';
import '/constants.dart';
import '/models/task_model.dart';
import 'custom_dialog_widget.dart';

class ExitWithoutSavingWidget extends StatelessWidget {
  final FirestoreService db;
  final Task task;
  const ExitWithoutSavingWidget(
      {super.key, required this.db, required this.task});

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
          onPressed: () {
            // Stay on Task
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: bodyStyle,
          ),
        ),
        TextButton(
          onPressed: () {
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
