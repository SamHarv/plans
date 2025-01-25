import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/logic/providers/riverpod_providers.dart';

class O2TechIcon extends ConsumerWidget {
  /// The [O2TechIcon] is a custom widget that displays the O2Tech logo to
  /// launch the O2Tech website.

  const O2TechIcon({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final urlLauncher = ref.read(url);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
      child: InkWell(
        child: Image.asset(
          'images/2.png', // O2Tech logo
          fit: BoxFit.contain,
          height: 24.0,
        ),
        onTap: () => urlLauncher.launchO2Tech(), // Launch the O2Tech website
      ),
    );
  }
}
