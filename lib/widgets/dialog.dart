import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

class PlansDialog extends ConsumerWidget {
  // Custom dialog
  final String dialogHeading;
  final Widget? dialogContent;
  final List<Widget> dialogActions;

  const PlansDialog(
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
