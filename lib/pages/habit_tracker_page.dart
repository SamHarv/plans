import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/constants.dart';
import '/state_management/riverpod_providers.dart';

final _url = Uri.parse('https://oxygentech.com.au');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

class HabitTrackerPage extends ConsumerStatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HabitTrackerPageState();
}

class _HabitTrackerPageState extends ConsumerState<HabitTrackerPage> {
  @override
  Widget build(BuildContext context) {
    // final db = ref.read(database);
    return PopScope(
      canPop: true,
      // Ensure task is saved on swipe to exit
      onPopInvoked: (didPop) {
        // db.updateHabitTracker();
      },
      child: Scaffold(
        appBar: AppBar(
          title: appTitle,
          backgroundColor: colour,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              // db.updateHabitTracker();
              Beamer.of(context).beamToNamed('/home');
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: InkWell(
                child: Image.asset(
                  'images/2.png',
                  fit: BoxFit.contain,
                  height: 24.0,
                ),
                onTap: () => _launchUrl(),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        backgroundColor: colour,
        body: Container(), // TODO: Add calendar with ability to change colours
        // on day click. case blank = green, case green = red, case red = blank
      ),
    );
  }
}
