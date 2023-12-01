import 'package:flutter/material.dart';

class TaskBox extends StatelessWidget {
  final Color boxColour;
  final String heading;
  final String? body;
  //final Tag tag;

  const TaskBox({
    super.key,
    required this.boxColour,
    required this.heading,
    this.body,
    //this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: boxColour,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            heading,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
