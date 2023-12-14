import 'package:flutter/material.dart';
import 'package:plans/widgets/palette_colour.dart';

import '../constants.dart';
import '../models/task.dart';
import '../services/firestore.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/dialog.dart';

class TaskView extends StatelessWidget {
  final Task task;
  final String taskID;
  // to be declared in build
  late final TextEditingController headingController =
      TextEditingController(text: task.taskHeading);
  late final TextEditingController bodyController =
      TextEditingController(text: task.taskContents);

  TaskView({
    super.key,
    required this.task,
    required this.taskID,
  });

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final FirestoreService db = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans', style: headingStyle),
        backgroundColor: task.getTaskColour(),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            if (headingController.text != "") {
              // Set text field values to task values
              task.setTaskHeading(headingController.text);
              task.setTaskContents(bodyController.text);
              // Update to Firestore
              db.updateTask(task.taskID, task);

              Navigator.pop(context);
            } else if (headingController.text == "") {
              // Save before exit alert
              showDialog(
                context: context,
                builder: (context) => PlansDialog(
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
                        // Double pop back to home screen
                        // DELETE TASK
                        db.deleteTask(task.taskID);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Exit Without Saving',
                        style: bodyStyle,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        actions: [
          // Select colour
          IconButton(
            icon: const Icon(
              Icons.color_lens,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => PlansDialog(
                  dialogHeading: 'Pick a Colour',
                  dialogContent: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaletteColour(paletteColour: blue, task: task),
                          PaletteColour(paletteColour: red, task: task),
                          PaletteColour(paletteColour: green, task: task),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaletteColour(paletteColour: blueGrey, task: task),
                          PaletteColour(paletteColour: yellow, task: task),
                          PaletteColour(paletteColour: orange, task: task),
                          PaletteColour(paletteColour: colour, task: task)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaletteColour(paletteColour: brown, task: task),
                          PaletteColour(paletteColour: pink, task: task),
                          PaletteColour(paletteColour: black, task: task),
                        ],
                      ),
                    ],
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
                        // Save selected colour to task
                        // task.setTaskColour(selectedColour);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Go',
                        style: bodyStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Add a tag to the task
          IconButton(
            icon: const Icon(
              Icons.sell,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          // Delete the task
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              // show dialog to ask if sure to delete
              showDialog(
                context: context,
                builder: (context) => PlansDialog(
                  dialogHeading: "Delete Task",
                  dialogContent: const Text(
                    "Are you sure you want to delete this task?",
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
                        // Double pop back to home screen
                        // DELETE TASK
                        db.deleteTask(task.taskID);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: bodyStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: task.taskColour,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Type heading
            Align(
                alignment: Alignment.topLeft,
                child: MyTextField(
                  controller: headingController,
                  hintText: "Click here to add heading",
                  maxLines: 1,
                  fontSize: 24,
                  style: headingStyle,
                )),
            const Divider(),
            SingleChildScrollView(
              // Type body
              child: Align(
                alignment: Alignment.topLeft,
                child: MyTextField(
                  controller: bodyController,
                  hintText: "Click here to add notes",
                  maxLines: null,
                  fontSize: 18,
                  style: bodyStyle,
                  height: mediaHeight - 180,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
