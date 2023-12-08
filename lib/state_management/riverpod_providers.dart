import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

final taskColour = StateProvider<Color>((ref) => Colors.black);
final taskHeading = StateProvider<String>((ref) => "New Task");
final taskBody = StateProvider<String>((ref) => "");
