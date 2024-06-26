import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/task_model.dart';
import '/state_management/riverpod_providers.dart';

class PaletteColourWidget extends ConsumerStatefulWidget {
  final Color paletteColour;
  final Task task;

  const PaletteColourWidget({
    super.key,
    required this.task,
    required this.paletteColour,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaletteColourWidgetState();
}

class _PaletteColourWidgetState extends ConsumerState<PaletteColourWidget> {
  @override
  Widget build(BuildContext context) {
    final db = ref.read(database);

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        setState(() {
          db.updateTask(widget.task.taskID, widget.task);
          widget.task.taskColour = widget.paletteColour;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.paletteColour,
          ),
        ),
      ),
    );
  }
}
