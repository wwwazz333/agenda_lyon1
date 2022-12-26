import 'package:flutter/material.dart';

void showMessageDialog(BuildContext context, String titre, String msg) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titre),
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
