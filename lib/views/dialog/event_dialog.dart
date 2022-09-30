import 'package:agenda_lyon1/common/tasks.dart';
import 'package:flutter/material.dart';

import '../../model/event_calendrier.dart';

Future<bool> showEventDialog(BuildContext context, EventCalendrier ev) async {
  bool hasToUpdate = false;
  final titleStyle = Theme.of(context).textTheme.headline2;
  final infoStyle = Theme.of(context).textTheme.bodyText1;

  await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text(
              ev.summary,
              style: Theme.of(context).textTheme.headline1,
            ),
            content: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
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
                    ),
                    StatefulBuilder(
                      builder: (context, setState) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tâches",
                                style: titleStyle,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final txt = await showStringPicker(
                                        context, "Nouvelle tâche") as String?;
                                    if (txt != null) {
                                      hasToUpdate = true;

                                      setState(
                                        () {
                                          if (txt.isNotEmpty) {
                                            addTask(ev.uid, txt);
                                          }
                                        },
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.add))
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // géré par le scrollable parent
                            itemCount: tasks[ev.uid] != null
                                ? tasks[ev.uid]!.length
                                : 0,
                            itemBuilder: (context, index) => InkWell(
                              onLongPress: () async {
                                final res = await showConfirmDel(
                                    context, tasks[ev.uid]![index]) as bool?;
                                if (res == true) {
                                  hasToUpdate = true;

                                  setState(
                                    () {
                                      removeTask(ev.uid, index);
                                    },
                                  );
                                }
                              },
                              child: Text(tasks[ev.uid]![index]),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          )));

  return hasToUpdate;
}

Future<dynamic> showStringPicker(BuildContext context, String title) {
  TextEditingController controller = TextEditingController();
  return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text(title),
            content: TextField(
              autofocus: true,
              controller: controller,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, controller.text);
                  },
                  child: const Text(
                    "OK",
                  )),
            ],
          )));
}

Future<dynamic> showConfirmDel(BuildContext context, String task) {
  return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Supprimer la tâche ?"),
            content: Text(task),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    "Annuler",
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    "Confirmer",
                  )),
            ],
          )));
}
