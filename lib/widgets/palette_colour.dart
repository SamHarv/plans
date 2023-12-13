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

        ref.watch(colourIsSelected)
            ? ref.read(colourIsSelected.notifier).state = false
            : ref.read(colourIsSelected.notifier).state = true;
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
              // Currently all colours have border together
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
