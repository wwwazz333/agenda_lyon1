import 'package:flutter/material.dart';

import '../../model/event_calendrier.dart';

void showEventDialog(BuildContext context, EventCalendrier ev) {
  final titleStyle = Theme.of(context).textTheme.headline6;
  final infoStyle = Theme.of(context).textTheme.bodyText1;
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text(
              ev.summary,
              style: titleStyle,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Déscription",
                      style: titleStyle,
                    )),
                Text(
                  ev.description,
                  style: infoStyle,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Salle",
                      style: titleStyle,
                    )),
                Text(
                  ev.salle,
                  style: infoStyle,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Horaire",
                      style: titleStyle,
                    )),
                Text(
                  "${ev.date}",
                  style: infoStyle,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Durée",
                      style: titleStyle,
                    )),
                Text("${ev.duree.inHours}:${ev.duree.inMinutes % 60}"),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Heures restantes",
                      style: titleStyle,
                    )),
                Text(
                  "...",
                  style: infoStyle,
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          )));
}
