import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '/models/task_model.dart';
import '/services/firestore_service.dart';
import '/constants.dart';
import 'custom_dialog_widget.dart';

class ConfirmDeleteWidget extends StatelessWidget {
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
        TextButton(
          onPressed: () {
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
