import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants.dart';

class LoginFieldWidget extends ConsumerWidget {
  final TextEditingController textController;
  final bool obscurePassword;
  final String hintText;
  final double mediaWidth;

  const LoginFieldWidget({
    super.key,
    required this.textController,
    required this.obscurePassword,
    required this.hintText,
    required this.mediaWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: mediaWidth * 0.8,
      height: 60,
      child: TextField(
        controller: textController,
        textInputAction: TextInputAction.next,
        obscureText: obscurePassword,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: blueGrey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(64),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueGrey,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
        ),
        style: bodyStyle,
      ),
    );
  }
}
