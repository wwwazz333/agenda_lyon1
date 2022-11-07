import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Erreur"),
      content: Text(msg),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}
