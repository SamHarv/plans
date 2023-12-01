import 'package:flutter/material.dart';
import './constants.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const Plans());
}

class Plans extends StatelessWidget {
  const Plans({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plans',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colour,
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
