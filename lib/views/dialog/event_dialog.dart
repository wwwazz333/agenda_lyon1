import 'package:flutter/material.dart';

import '../../model/event_calendrier.dart';

void showEventDialog(BuildContext context, EventCalendrier ev) {
  final titleStyle = Theme.of(context).textTheme.headline6;
  final infoStyle = Theme.of(context).textTheme.bodyText1;

  final List<String> taches = [];

  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text(
              ev.summary,
              style: titleStyle,
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
                                        context, "Nouvelle tâche");
                                    if (txt != null) {
                                      taches.add(txt);
                                      setState(
                                        () {},
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
                            itemCount: taches.length,
                            itemBuilder: (context, index) =>
                                Text(taches[index]),
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
}

Future<dynamic> showStringPicker(BuildContext context, String title) async {
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
                  child: const Text("OK"))
            ],
          )));
}
