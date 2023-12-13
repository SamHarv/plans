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
    return GestureDetector(
      onTap: () {
        // set colour
        // This is changing the border for all colours

        //!task.isSelected;

        // if (task.isSelected) {
        //   task.isSelected = false;
        // } else {
        //   task.isSelected = true;
        // }
        //task.isSelected != task.isSelected;
        // setState(() {
        //   widget.task.isSelected = !widget.task.isSelected;
        //   if (widget.task.isSelected) {
        //     widget.task.taskColour = widget.paletteColour;
        //   }
        // });

        // if (widget.task.getTaskColour() == widget.paletteColour) {
        //   widget.task.setIsSelected(true);
        // } else {
        //   widget.task.setIsSelected(false);
        // }

        // widget.task.getIsSelected()
        //     ? widget.task.setIsSelected(false)
        //     : widget.task.setIsSelected(true);

        ref.watch(colourIsSelected)
            ? ref.read(colourIsSelected.notifier).state = false
            : ref.read(colourIsSelected.notifier).state = true;

        // widget.task.isSelected = ref.watch(colourIsSelected);

        // widget.task.taskColour = widget.paletteColour;
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.paletteColour,
            border: Border.all(
              color: ref.watch(colourIsSelected)
                  ? Colors.white
                  : widget.paletteColour,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
