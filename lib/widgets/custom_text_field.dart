import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
    required this.fontSize,
    required this.style,
    required this.onUpdate,
    required this.undoController,
    this.height,
  }) : super(key: key);

  final double? height;
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final double fontSize;
  final TextStyle style;
  final Function(String) onUpdate;
  final UndoHistoryController undoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: TextField(
        undoController: undoController,
        onChanged: onUpdate,
        textCapitalization: TextCapitalization.sentences,
        maxLines: maxLines, // multi line
        controller: controller,
        style: style,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: fontSize,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
