import 'package:flutter/material.dart';
import 'package:plans/widgets/tasks_reorderable.dart';

import '../constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colour,
      appBar: AppBar(
        title: const Text(
          'Plans',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: colour,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TasksReorderable(),
      ),
    );
  }
}
