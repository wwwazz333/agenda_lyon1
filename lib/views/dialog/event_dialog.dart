import 'package:agenda_lyon1/model/color/colors.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/settings/settingsapp.dart';
import '../../model/event/event_calendrier.dart';
import '../../model/task/tasks_manager.dart';

Future<bool> showEventDialog(BuildContext context, EventCalendrier ev) async {
  bool hasToUpdate = false;
  final titleStyle = Theme.of(context).textTheme.headline2;
  final infoStyle = Theme.of(context).textTheme.bodyText1;

  var bgColor = ColorsEventsManager()
      .getColorOrGen(ev.summary, SettingsApp().appIsDarkMode);

  await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return GestureDetector(
                    onTap: () async {
                      Color? color =
                          await showColorPicker(context, bgColor) as Color?;
                      if (color != null && color != bgColor) {
                        setState(
                          () {
                            bgColor = color;
                            ColorsEventsManager().addColor(
                                ev.summary, color, SettingsApp().appIsDarkMode);
                            hasToUpdate = true;
                          },
                        );
                      }
                    },
                    child: RichText(
                        text: TextSpan(
                            text: "${ev.summary}\t",
                            style: Theme.of(context).textTheme.headline1!,
                            children: [
                          WidgetSpan(
                              child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: bgColor),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.edit),
                            ),
                          ))
                        ])));
              },
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
                      ev.salle.join(", "),
                      style: infoStyle,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Horaire",
                          style: titleStyle,
                        )),
                    Text(
                      DateFormat.Hm().format(ev.date),
                      style: infoStyle,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Durée",
                          style: titleStyle,
                        )),
                    Text(
                        "${ev.duree.inHours}:${(ev.duree.inMinutes % 60).toString().padLeft(2, '0')}"),
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
                                            TasksManager().addTask(ev.uid, txt);
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
                            itemCount:
                                TasksManager().taskOfEvent(ev.uid).length,

                            itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(1),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary,
                                  child: InkWell(
                                    onLongPress: () async {
                                      final res = await showConfirmDel(
                                          context,
                                          TasksManager()
                                              .taskOfEvent(ev.uid)
                                              .get(index)
                                              .text) as bool?;
                                      if (res == true) {
                                        hasToUpdate = true;

                                        setState(
                                          () {
                                            TasksManager()
                                                .removeTask(ev.uid, index);
                                          },
                                        );
                                      }
                                    },
                                    child: TaskWidget(TasksManager()
                                        .taskOfEvent(ev.uid)
                                        .get(index)
                                        .text),
                                  ),
                                )),
                          )
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

class TaskWidget extends StatelessWidget {
  final String txt;
  const TaskWidget(this.txt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Text(
        txt,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}

Future<dynamic> showColorPicker(
    BuildContext context, Color defaultColor) async {
  return await showColorPickerDialog(
    context,
    defaultColor,
    actionButtons: const ColorPickerActionButtons(
      okButton: true,
      closeButton: true,
      dialogActionButtons: false,
      dialogActionIcons: false,
    ),
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.accent: false,
      ColorPickerType.wheel: true,
    },
    wheelDiameter: 250,
    enableTooltips: true,
    enableTonalPalette: true,
  );
}

Future<dynamic> showStringPicker(BuildContext context, String title) {
  TextEditingController controller = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline1,
            ),
            content: TextField(
              style: Theme.of(context).textTheme.bodyText1,
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
          ));
}

Future<dynamic> showConfirmDel(BuildContext context, String task) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              "Supprimer la tâche ?",
              style: Theme.of(context).textTheme.headline1,
            ),
            content: Text(
              task,
              style: Theme.of(context).textTheme.bodyText1,
            ),
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
          ));
}
