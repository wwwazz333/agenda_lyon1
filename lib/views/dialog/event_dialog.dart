import 'package:flutter/material.dart';

import '../../model/event_calendrier.dart';

void showEventDialog(BuildContext context, EventCalendrier ev) {
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text(ev.summary),
            content: Text(ev.description),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          )));
}
