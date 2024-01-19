import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

class CustomDialog extends ConsumerWidget {
  // Custom dialog
  final String dialogHeading;
  // Content not limited to text (e.g. colour palette)
  final Widget? dialogContent;
  final List<Widget> dialogActions;

  const CustomDialog(
      {super.key,
      required this.dialogHeading,
      this.dialogContent,
      required this.dialogActions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(
        dialogHeading,
        style: headingStyle,
      ),
      content: dialogContent,
      backgroundColor: Colors.black,
      actions: dialogActions,
    );
  }
}
