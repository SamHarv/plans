import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../models/task.dart';
import '../state_management/riverpod_providers.dart';

class PaletteColour extends ConsumerStatefulWidget {
  final Color paletteColour;
  final Task task;

  const PaletteColour({
    super.key,
    required this.task,
    this.paletteColour = colour,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaletteColourState();
}

class _PaletteColourState extends ConsumerState<PaletteColour> {
  @override
  Widget build(BuildContext context) {
    final db = ref.read(database);

    return InkWell(
      // make splash circular
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        // set colour

        // update the state on tap
        db.updateTask(widget.task.taskID, widget.task);
        setState(() {
          widget.task.setTaskColour(widget.paletteColour);
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
            // border: Border.all(
            //   // display colour based on db status
            //   color: widget.task.getTaskColour() == widget.paletteColour
            //       ? Colors.white
            //       : widget.paletteColour,
            //   width: 1,
            // ),
          ),
        ),
      ),
    );
  }
}
