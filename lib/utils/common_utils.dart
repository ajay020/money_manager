import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String capitalize(String input) {
  return input.isEmpty
      ? input
      : '${input[0].toUpperCase()}${input.substring(1)}';
}
