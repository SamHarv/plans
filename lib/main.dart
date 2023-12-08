import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './constants.dart';
import 'routes.dart';

void main() {
  runApp(const ProviderScope(child: Plans()));
}

class Plans extends StatelessWidget {
  const Plans({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Plans',
      debugShowCheckedModeBanner: false,
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colour,
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
