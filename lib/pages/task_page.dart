import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '/state_management/riverpod_providers.dart';
import '/widgets/palette_colour_widget.dart';
import '../constants.dart';
import '../models/task_model.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dialog.dart';

class TaskPage extends ConsumerStatefulWidget {
  final Task task;
  final String taskID;
  // Text controllers to be declared in build
  late final TextEditingController headingController =
      TextEditingController(text: task.taskHeading);
  late final TextEditingController bodyController =
      TextEditingController(text: task.taskContents);
  late final UndoHistoryController headingUndoController =
      UndoHistoryController();
  late final UndoHistoryController bodyUndoController = UndoHistoryController();

  TaskPage({
    super.key,
    required this.task,
    required this.taskID,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  // For later implementation of checklist functionality
  // bool checklist = false;
  @override
  Widget build(BuildContext context) {
    final db = ref.read(database);
    return PopScope(
      canPop: true,
      // Ensure task is saved on swipe to exit
      onPopInvoked: (didPop) {
        if (didPop && widget.headingController.text != "") {
          // Set text field values to task values
          widget.task.taskHeading = widget.headingController.text;
          widget.task.taskContents = widget.bodyController.text;
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
          backgroundColor: widget.task.taskColour,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              if (widget.headingController.text != "") {
                // Set text field values to task values
                widget.task.taskHeading = widget.headingController.text;
                widget.task.taskContents = widget.bodyController.text;
                // Update to Firestore
                db.updateTask(widget.task.taskID, widget.task);
                Beamer.of(context).beamToNamed('/home');
              } else if (widget.headingController.text == "") {
                // Alert to indicate task will not be saved
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
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
                          db.deleteTask(widget.task.taskID);
                          Beamer.of(context).beamToNamed('/home');
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
                  builder: (context) => CustomDialog(
                    dialogHeading: 'Pick a Colour',
                    dialogContent: GestureDetector(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PaletteColourWidget(
                                  paletteColour: blue, task: widget.task),
                              PaletteColourWidget(
                                  paletteColour: red, task: widget.task),
                              PaletteColourWidget(
                                  paletteColour: green, task: widget.task),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PaletteColourWidget(
                                  paletteColour: blueGrey, task: widget.task),
                              PaletteColourWidget(
                                  paletteColour: yellow, task: widget.task),
                              PaletteColourWidget(
                                  paletteColour: orange, task: widget.task),
                              PaletteColourWidget(
                                  paletteColour: colour, task: widget.task)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PaletteColourWidget(
                                  paletteColour: brown, task: widget.task),
                              PaletteColourWidget(
                                  paletteColour: pink, task: widget.task),
                              PaletteColourWidget(
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
                          // Save selected colour to task and update UI
                          setState(() {
                            widget.task.taskColour = widget.task.taskColour;
                            db.updateTask(widget.taskID, widget.task);
                          });
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
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                // Show dialog to ask if sure to delete
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
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
                          // Delete the task
                          db.deleteTask(widget.task.taskID);
                          Navigator.pop(context);
                          Beamer.of(context).beamToNamed('/home');
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
              const SizedBox(height: 16),
              // Heading
              Align(
                  alignment: Alignment.topLeft,
                  child: CustomTextField(
                    undoController: widget.headingUndoController,
                    onUpdate: (text) {
                      widget.task.taskHeading = text;
                      db.updateTask(widget.taskID, widget.task);
                    },
                    controller: widget.headingController,
                    hintText: "Click here to add heading",
                    maxLines: 1,
                    fontSize: 24,
                    style: headingStyle,
                  )),
              const Divider(),
              // Content field
              Expanded(
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomTextField(
                      undoController: widget.bodyUndoController,
                      onUpdate: (text) {
                        // Add dot point by entering '.. '
                        if (text.length > 2 &&
                            (text.substring(text.length - 3, text.length) ==
                                '.. ')) {
                          widget.bodyController.text =
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
                          widget.bodyController.text = '$text• ';
                        }
                        // Constantly save
                        widget.task.taskContents = text;
                        db.updateTask(widget.taskID, widget.task);
                      },
                      controller: widget.bodyController,
                      hintText: "Click here to add notes",
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
      ),
    );
  }
}
