import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../state_management/riverpod_providers.dart';

class PaletteColour extends ConsumerWidget {
  final Color paletteColour;
  final bool isSelected;
  const PaletteColour({
    super.key,
    this.paletteColour = colour,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // set colour
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
            color: paletteColour,
            border: Border.all(
              color: ref.watch(colourIsSelected) ? Colors.white : paletteColour,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
