import 'package:flutter/material.dart';

class AppMessage {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void success(String message) {
    show(message, Colors.green.shade700);
  }

  static void error(String message) {
    show(message, Colors.red.shade700);
  }

  static void show(String message, Color color) {
    messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
