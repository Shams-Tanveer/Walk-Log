import 'package:flutter/material.dart';

class SnackBarUtility {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text) {
    final snackBar = SnackBar(
      content: Text(
        text!,
        style: TextStyle(fontSize: 16),
      ),
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
