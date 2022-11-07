import 'package:agenda_lyon1/model/alarm/parametrage_horiare.dart';
import 'package:agenda_lyon1/views/dialog/error_dialog.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import '../../../common/error/paremetre_error.dart';
import '../../../model/date.dart';
import '../loading_widget.dart';

class SettingsAlarmCard extends StatefulWidget {
  final ParametrageHoraire parametrageHoraire;
  final void Function() remove;
  const SettingsAlarmCard(this.parametrageHoraire,
      {required this.remove, super.key});

  @override
  State<SettingsAlarmCard> createState() => _SettingsAlarmCardState();
}

class _SettingsAlarmCardState extends State<SettingsAlarmCard> {
  final controller = CustomPopupMenuController();
  static const List<String> daysName = [
    "Lun",
    "Mar",
    "Mer",
    "Jeu",
    "Ven",
    "Sam",
    "Dim",
  ];
  bool get isRelative => widget.parametrageHoraire.relative;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        controller.showMenu();
      },
      child: Card(
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        widget.parametrageHoraire.reglageHoraire = await pickTime(
                            context, widget.parametrageHoraire.reglageHoraire,
                            clockDisplay: !isRelative,
                            msg: isRelative
                                ? "L'alarme sonnera ... de temps avant le 1er cours"
                                : "L'alarme sonnera à ...");
                        setState(() {});
                      },
                      child: Text.rich(
                        TextSpan(text: (isRelative ? " - " : ""), children: [
                          TextSpan(
                              text:
                                  "${widget.parametrageHoraire.reglageHoraire.displayHasTime()} "),
                          WidgetSpan(
                              child: Icon(
                            isRelative ? Icons.timelapse : Icons.alarm,
                            size: 36,
                          ))
                        ]),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    Text(
                      (isRelative) ? "Placé en amont" : "Placé à l'heure",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Row(
                      children: [
                        Text(
                          (isRelative) ? "Relative" : "Fixe",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch.adaptive(
                          value: isRelative,
                          onChanged: (value) {
                            setState(() {
                              widget.parametrageHoraire.relative = !isRelative;
                              widget.parametrageHoraire.save();
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          try {
                            widget.parametrageHoraire.debutMatch = await pickTime(
                                context, widget.parametrageHoraire.debutMatch,
                                msg:
                                    "Condition pour la sonnerie de l'alarme : Heure minimal du 1er cours pour que l'alarme sonne");
                            setState(() {});
                          } on ParmettreError catch (e) {
                            showErrorDialog(context, e.error);
                          }
                        },
                        child: Text(widget.parametrageHoraire.debutMatch
                            .displayHasTime())),
                    const Icon(Icons.arrow_forward),
                    GestureDetector(
                        onTap: () async {
                          try {
                            widget.parametrageHoraire.finMatch = await pickTime(
                                context, widget.parametrageHoraire.finMatch,
                                msg:
                                    "Condition pour la sonnerie de l'alarme : Heure maxiaml du 1er cours pour que l'alarme sonne");
                            setState(() {});
                          } on ParmettreError catch (e) {
                            showErrorDialog(context, e.error);
                          }
                        },
                        child: Text(widget.parametrageHoraire.finMatch
                            .displayHasTime()))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      7,
                      (index) => Column(
                            children: [
                              Text(
                                daysName[index],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Checkbox(
                                value: ParametrageHoraire.isOneOf(
                                    (index + 2) % 8,
                                    widget.parametrageHoraire.enabledDay),
                                onChanged: (value) {
                                  int i = (index + 2) % 8;

                                  if (widget.parametrageHoraire.enabledDay
                                      .contains(i)) {
                                    widget.parametrageHoraire.enabledDay
                                        .remove(i);
                                  } else {
                                    widget.parametrageHoraire.enabledDay.add(i);
                                  }
                                  setState(() {});
                                  widget.parametrageHoraire.save();
                                },
                              )
                            ],
                          )),
                )
              ],
            ),
            CustomPopupMenu(
              menuBuilder: () => ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.grey,
                  child: IconButton(
                      iconSize: 64,
                      color: Colors.black,
                      onPressed: () {
                        widget.remove();
                        controller.hideMenu();
                      },
                      icon: const Icon(Icons.remove_circle_outline)),
                ),
              ),
              pressType: PressType.singleClick,
              controller: controller,
              child: const Center(),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Duration> pickTime(BuildContext context, Duration previous,
    {bool clockDisplay = true, String msg = "Sélectionner une heure"}) async {
  TimeOfDay? timeOfDay = await showTimePicker(
      helpText: msg,
      confirmText: "VALIDER",
      cancelText: "ANNULER",
      errorInvalidText: "Horaire invalide",
      builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? const LoadingWidget(),
          ),
      context: context,
      initialEntryMode:
          clockDisplay ? TimePickerEntryMode.dial : TimePickerEntryMode.input,
      initialTime:
          TimeOfDay(hour: previous.inHours, minute: previous.inMinutes % 60));
  if (timeOfDay != null) {
    return Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
  }
  return previous;
}
