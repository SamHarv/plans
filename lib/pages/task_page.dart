import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/widgets/confirm_delete_widget.dart';
import '/widgets/exit_without_saving_widget.dart';
import '/state_management/riverpod_providers.dart';
import '/widgets/palette_colour_widget.dart';
import '/constants.dart';
import '/models/task_model.dart';
import '/widgets/custom_text_field_widget.dart';
import '/widgets/custom_dialog_widget.dart';

class TaskPage extends ConsumerStatefulWidget {
  final Task task;
  final String taskID;

  const TaskPage({
    super.key,
    required this.task,
    required this.taskID,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
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
      onPopInvoked: (didPop) {
        if (didPop && headingController.text != "") {
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
                color: Colors.white,
              ),
              onPressed: () {
                if (headingController.text != "") {
                  widget.task.taskHeading = headingController.text;
                  widget.task.taskContents = bodyController.text;
                  widget.task.taskColour = widget.task.taskColour;
                  db.updateTask(widget.task.taskID, widget.task);
                  Beamer.of(context).beamToNamed('/home');
                } else if (headingController.text == "") {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ExitWithoutSavingWidget(db: db, task: widget.task),
                  );
                }
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.undo, color: Colors.white),
                onPressed: () => bodyUndoController.undo(),
              ),
              IconButton(
                icon: const Icon(Icons.redo, color: Colors.white),
                onPressed: () => bodyUndoController.redo(),
              ),
              IconButton(
                icon: const Icon(Icons.color_lens, color: Colors.white),
                onPressed: () {
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
                                setState(() {
                                  widget.task.taskColour =
                                      widget.task.taskColour;
                                });
                                db.updateTask(widget.taskID, widget.task);

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
                  setState(() {});
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
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
          body: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomTextFieldWidget(
                    undoController: headingUndoController,
                    onUpdate: (text) {
                      // widget.task.taskHeading = text;
                      // db.updateTask(widget.taskID, widget.task);
                    },
                    controller: headingController,
                    hintText: "Click here to add heading",
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
                          if (text.length > 2 &&
                              (text.substring(text.length - 3, text.length) ==
                                  '.. ')) {
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
                          // Constantly save
                          // widget.task.taskContents = text;
                          // db.updateTask(widget.taskID, widget.task);
                        },
                        controller: bodyController,
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CustomDialogWidget(
                  dialogHeading: "Add Tag",
                  dialogContent: CustomTextFieldWidget(
                    undoController: UndoHistoryController(),
                    onUpdate: (text) {
                      widget.task.taskTag = text;
                      db.updateTask(widget.taskID, widget.task);
                    },
                    controller: TextEditingController(),
                    hintText: widget.task.taskTag == ""
                        ? "Add Tag"
                        : widget.task.taskTag,
                    maxLines: 1,
                    fontSize: 18,
                    style: bodyStyle,
                  ),
                  dialogActions: [
                    TextButton(
                      onPressed: () {
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
            child: const Icon(
              Icons.sell,
              color: colour,
            ),
          )),
    );
  }
}
