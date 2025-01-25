import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'config/constants.dart';
import 'logic/routes/routes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        fontFamily: 'Roboto',
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
