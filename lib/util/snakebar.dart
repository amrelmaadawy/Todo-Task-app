import 'package:flutter/material.dart';

class Snakebar {
  static void snakeBar(String massage, Color color, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        massage,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
