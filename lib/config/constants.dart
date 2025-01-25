import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary colour
const colour = Color.fromARGB(255, 55, 72, 84);

/// Secondary colour
const secondaryColour = Colors.white;

/// Colours for palette
const blue = Color.fromARGB(255, 1, 76, 99);
const red = Color.fromARGB(255, 137, 0, 0);
const yellow = Color.fromARGB(255, 186, 150, 0);
const green = Color.fromARGB(255, 59, 88, 40);
const orange = Color.fromARGB(255, 174, 61, 0);
const blueGrey = Color.fromRGBO(96, 125, 139, 1);
const brown = Color.fromARGB(255, 78, 69, 68);
const pink = Color.fromARGB(255, 127, 115, 132);
const black = Color.fromARGB(255, 16, 24, 32);

const headingStyle = TextStyle(
  color: secondaryColour,
  fontFamily: 'Roboto',
  fontSize: 24,
);

const bodyStyle = TextStyle(
  color: secondaryColour,
  fontFamily: 'Roboto',
  fontSize: 18,
);

const gapH20 = SizedBox(height: 20);

const gapH80 = SizedBox(height: 80);

/// To be displayed in app bar
final appTitle = Text(
  'Plans',
  style: GoogleFonts.caveat(
    textStyle: const TextStyle(
      color: secondaryColour,
      fontSize: 40,
      fontFamily: 'Caveat',
    ),
  ),
);

// Display an alert dialog with a message
void showMessage(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: colour,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(color: secondaryColour),
          ),
        ),
      );
    },
  );
}
