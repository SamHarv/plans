import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plans/state_management/riverpod_providers.dart';
import 'package:plans/widgets/palette_colour.dart';

import '../constants.dart';
import '../models/task.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/dialog.dart';

class TaskView extends ConsumerStatefulWidget {
  final Task task;
  final String taskID;
  // to be declared in build
  late final TextEditingController headingController =
      TextEditingController(text: task.taskHeading);
  late final TextEditingController bodyController =
      TextEditingController(text: task.taskContents);
  late final UndoHistoryController headingUndoController =
      UndoHistoryController();
  late final UndoHistoryController bodyUndoController = UndoHistoryController();

  TaskView({
    super.key,
    required this.task,
    required this.taskID,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskViewState();
}

class _TaskViewState extends ConsumerState<TaskView> {
  @override
  Widget build(BuildContext context) {
    final db = ref.read(database);
    // final mediaHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: true,
      // Save in the event that pop fails
      onPopInvoked: (didPop) {
        if (didPop && widget.headingController.text != "") {
          // Set text field values to task values
          widget.task.setTaskHeading(widget.headingController.text);
          widget.task.setTaskContents(widget.bodyController.text);
          // Update to Firestore
          db.updateTask(widget.task.taskID, widget.task);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Plans',
            style: GoogleFonts.caveat(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontFamily: 'Caveat',
              ),
            ),
          ),
          backgroundColor: widget.task.getTaskColour(),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              if (widget.headingController.text != "") {
                // Set text field values to task values
                widget.task.setTaskHeading(widget.headingController.text);
                widget.task.setTaskContents(widget.bodyController.text);
                // Update to Firestore
                db.updateTask(widget.task.taskID, widget.task);

                Navigator.pop(context);
              } else if (widget.headingController.text == "") {
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
                          db.deleteTask(widget.task.taskID);
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
            // undo
            IconButton(
              icon: const Icon(
                Icons.undo,
                color: Colors.white,
              ),
              onPressed: () {
                widget.bodyUndoController.undo();
              },
            ),
            // redo
            IconButton(
              icon: const Icon(
                Icons.redo,
                color: Colors.white,
              ),
              onPressed: () {
                widget.bodyUndoController.redo();
              },
            ),
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
                    dialogContent: GestureDetector(
                      onTapCancel: () {
                        setState(() {});
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PaletteColour(
                                  paletteColour: blue, task: widget.task),
                              PaletteColour(
                                  paletteColour: red, task: widget.task),
                              PaletteColour(
                                  paletteColour: green, task: widget.task),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PaletteColour(
                                  paletteColour: blueGrey, task: widget.task),
                              PaletteColour(
                                  paletteColour: yellow, task: widget.task),
                              PaletteColour(
                                  paletteColour: orange, task: widget.task),
                              PaletteColour(
                                  paletteColour: colour, task: widget.task)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PaletteColour(
                                  paletteColour: brown, task: widget.task),
                              PaletteColour(
                                  paletteColour: pink, task: widget.task),
                              PaletteColour(
                                  paletteColour: black, task: widget.task),
                            ],
                          ),
                        ],
                      ),
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
                          db.updateTask(widget.taskID, widget.task);
                          setState(() {});
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
            // IconButton(
            //   icon: const Icon(
            //     Icons.sell,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {},
            // ),
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
                          db.deleteTask(widget.task.taskID);
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
        backgroundColor: widget.task.taskColour,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              // Type heading
              const SizedBox(height: 16),
              Align(
                  alignment: Alignment.topLeft,
                  child: MyTextField(
                    undoController: widget.headingUndoController,
                    onUpdate: (text) {
                      widget.task.setTaskHeading(text);
                      db.updateTask(widget.taskID, widget.task);
                    },
                    controller: widget.headingController,
                    hintText: "Click here to add heading",
                    maxLines: 1,
                    fontSize: 24,
                    style: headingStyle,
                  )),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: MyTextField(
                      undoController: widget.bodyUndoController,
                      onUpdate: (text) {
                        widget.task.setTaskContents(text);
                        db.updateTask(widget.taskID, widget.task);
                      },

                      controller: widget.bodyController,
                      hintText: "Click here to add notes",
                      maxLines: null,
                      fontSize: 18,
                      style: bodyStyle,
                      // height: mediaHeight - 140,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
