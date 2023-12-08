import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/task.dart';
import '../widgets/custom_text_field.dart';

class TaskView extends StatelessWidget {
  final Task task;
  final String taskID;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans', style: headingStyle),
        backgroundColor: task.taskColour,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.color_lens,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.sell,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: task.taskColour,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
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
