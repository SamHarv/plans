import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/constants.dart';

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
  late SharedPreferences _prefs;
  List<Color> dayColour = List.filled(364, colour);
  List<Color> colourOptions = [colour, green, red];

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSavedColors();
  }

  void _loadSavedColors() {
    for (int i = 0; i < 364; i++) {
      final int? colorIndex = _prefs.getInt('color_$i');
      if (colorIndex != null) {
        setState(() {
          dayColour[i] = colourOptions[colorIndex];
        });
      }
    }
  }

  Future<void> _saveColor(int index, int colorIndex) async {
    await _prefs.setInt('color_$index', colorIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appTitle,
        backgroundColor: colour,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: 364,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                switch (dayColour[index]) {
                  case colour:
                    dayColour[index] = green;
                    await _saveColor(index, 1);
                    break;
                  case green:
                    dayColour[index] = red;
                    await _saveColor(index, 2);
                    break;
                  case red:
                    dayColour[index] = colour;
                    await _saveColor(index, 0);
                    break;
                  default:
                    dayColour[index] = colour;
                }
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: dayColour[index] == colour
                        ? Colors.blueGrey
                        : dayColour[index],
                    width: 1,
                  ),
                  color: dayColour[index],
                  borderRadius: BorderRadius.circular(64),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
