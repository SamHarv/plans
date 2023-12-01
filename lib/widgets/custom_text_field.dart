import 'package:flutter/material.dart';

import '/constants.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.mediaWidth,
    required this.controller,
    required this.hintText,
    required this.obscure,
    this.height,
    this.suffix,
    this.keyboardType,
  }) : super(key: key);

  final double mediaWidth;
  final double? height;
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final String? suffix;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: mediaWidth <= 750 ? mediaWidth * 0.35 : mediaWidth * 0.2,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          suffixText: suffix,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(32)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: colour),
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
        ),
      ),
    );
  }
}
