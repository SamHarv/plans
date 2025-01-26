import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/confirm_delete_widget.dart';
import '../widgets/exit_without_saving_widget.dart';
import '../widgets/palette_colour_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/custom_dialog_widget.dart';
import '../../config/constants.dart';
import '../../data/models/task_model.dart';
import '../../logic/providers/providers.dart';

class TaskView extends ConsumerStatefulWidget {
  /// UI for a single task

  final Task task;
  final String taskID;

  const TaskView({super.key, required this.task, required this.taskID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskViewState();
}

class _TaskViewState extends ConsumerState<TaskView> {
  @override
  Widget build(BuildContext context) {
    final headingController =
        TextEditingController(text: widget.task.taskHeading);
    final bodyController =
        TextEditingController(text: widget.task.taskContents);
    final headingUndoController = UndoHistoryController();
    final bodyUndoController = UndoHistoryController();
    final db = ref.read(database);
    return PopScope(
      canPop: true,
      // Ensure task is saved on swipe to exit
      onPopInvokedWithResult: (context, result) {
        if (headingController.text != "") {
          widget.task.taskHeading = headingController.text;
          widget.task.taskContents = bodyController.text;
          db.updateTask(widget.task.taskID, widget.task);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: appTitle,
          backgroundColor: widget.task.taskColour,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: secondaryColour,
            ),
            onPressed: () {
              // Save and go back to home if heading is not empty
              if (headingController.text != "") {
                widget.task.taskHeading = headingController.text;
                widget.task.taskContents = bodyController.text;
                widget.task.taskColour = widget.task.taskColour;
                db.updateTask(widget.task.taskID, widget.task);
                Beamer.of(context).beamToNamed('/home');
              } else if (headingController.text == "") {
                // Show dialog if heading is empty
                showDialog(
                  context: context,
                  builder: (context) =>
                      ExitWithoutSavingWidget(db: db, task: widget.task),
                );
              }
            },
          ),
          actions: [
            // Undo typing
            IconButton(
              icon: const Icon(Icons.undo, color: secondaryColour),
              onPressed: () => bodyUndoController.undo(),
            ),
            // Redo typing
            IconButton(
              icon: const Icon(Icons.redo, color: secondaryColour),
              onPressed: () => bodyUndoController.redo(),
            ),
            // Select colour of background
            IconButton(
              icon: const Icon(Icons.color_lens, color: secondaryColour),
              onPressed: () {
                // Save task text before changing colour
                if (headingController.text != "") {
                  widget.task.taskHeading = headingController.text;
                  widget.task.taskContents = bodyController.text;
                  widget.task.taskColour = widget.task.taskColour;
                  db.updateTask(widget.task.taskID, widget.task);
                }
                // Show dialog to pick colour
                showDialog(
                  context: context,
                  builder: (context) => StatefulBuilder(
                    builder: (context, state) {
                      return CustomDialogWidget(
                        dialogHeading: 'Pick a Colour',
                        dialogContent: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PaletteColourWidget(
                                  paletteColour: blue,
                                  task: widget.task,
                                ),
                                PaletteColourWidget(
                                  paletteColour: red,
                                  task: widget.task,
                                ),
                                PaletteColourWidget(
                                  paletteColour: green,
                                  task: widget.task,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PaletteColourWidget(
                                  paletteColour: blueGrey,
                                  task: widget.task,
                                ),
                                PaletteColourWidget(
                                  paletteColour: yellow,
                                  task: widget.task,
                                ),
                                PaletteColourWidget(
                                  paletteColour: orange,
                                  task: widget.task,
                                ),
                                PaletteColourWidget(
                                  paletteColour: colour,
                                  task: widget.task,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PaletteColourWidget(
                                  paletteColour: brown,
                                  task: widget.task,
                                ),
                                PaletteColourWidget(
                                  paletteColour: pink,
                                  task: widget.task,
                                ),
                                PaletteColourWidget(
                                  paletteColour: black,
                                  task: widget.task,
                                ),
                              ],
                            ),
                          ],
                        ),
                        dialogActions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: bodyStyle,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Update task with new colour
                              setState(() {
                                widget.task.taskColour = widget.task.taskColour;
                              });
                              db.updateTask(widget.taskID, widget.task);
                              // Pop the dialog
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Go',
                              style: bodyStyle,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
                setState(() {}); // Update UI with new colour
              },
            ),
            // Delete task
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: secondaryColour,
              ),
              onPressed: () {
                // Show dialog to confirm deletion
                showDialog(
                  context: context,
                  builder: (context) =>
                      ConfirmDeleteWidget(db: db, task: widget.task),
                );
              },
            ),
          ],
        ),
        backgroundColor: widget.task.taskColour,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Heading field
                  Align(
                    alignment: Alignment.topLeft,
                    child: CustomTextFieldWidget(
                      undoController: headingUndoController,
                      // onUpdate functionality slowed down the app
                      onUpdate: (text) {
                        // widget.task.taskHeading = text;
                        // db.updateTask(widget.taskID, widget.task);
                      },
                      controller: headingController,
                      hintText: "Click to add heading",
                      maxLines: 1,
                      fontSize: 24,
                      style: headingStyle,
                    ),
                  ),
                  const Divider(),
                  // Content field
                  Expanded(
                    child: SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomTextFieldWidget(
                          undoController: bodyUndoController,
                          onUpdate: (text) {
                            // Add dot point by entering '.. '
                            if (text.substring(text.length - 3, text.length) ==
                                '.. ') {
                              bodyController.text =
                                  '${text.substring(0, text.length - 3)}• ';
                            }
                            // If last paragraph/ item starts with a dot, add another
                            // on a new line when \n is entered
                            List textList = text.split('\n');
                            if (textList.length > 1 &&
                                text.substring(text.length - 1, text.length) ==
                                    '\n' &&
                                textList[textList.length - 2][0] == '•' &&
                                textList[textList.length - 2] != '• ') {
                              bodyController.text = '$text• ';
                            }
                          },
                          controller: bodyController,
                          hintText: "Click to add notes",
                          maxLines: null,
                          fontSize: 18,
                          style: bodyStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Save button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FloatingActionButton.small(
                  backgroundColor: secondaryColour,
                  onPressed: () {
                    // Save task if heading is not empty
                    if (headingController.text != "") {
                      widget.task.taskHeading = headingController.text;
                      widget.task.taskContents = bodyController.text;
                      widget.task.taskColour = widget.task.taskColour;
                      db.updateTask(widget.task.taskID, widget.task);
                    }
                    // Show dialog to confirm save
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialogWidget(
                        dialogHeading: 'Saved',
                        dialogActions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'OK',
                              style: bodyStyle,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Icon(
                    Icons.save,
                    color: widget.task.taskColour,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
