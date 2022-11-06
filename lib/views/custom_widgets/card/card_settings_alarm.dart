import 'package:agenda_lyon1/model/alarm/parametrage_horiare.dart';
import 'package:flutter/material.dart';
import '../../../model/date.dart';

class SettingsAlarmCard extends StatefulWidget {
  final ParametrageHoraire parametrageHoraire;
  final void Function() remove;
  const SettingsAlarmCard(this.parametrageHoraire,
      {required this.remove, super.key});

  @override
  State<SettingsAlarmCard> createState() => _SettingsAlarmCardState();
}

class _SettingsAlarmCardState extends State<SettingsAlarmCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                      text: (widget.parametrageHoraire.relative ? " - " : ""),
                      children: [
                        TextSpan(
                            text: widget.parametrageHoraire.reglageHoraire
                                .displayHasTime()),
                        if (!widget.parametrageHoraire.relative)
                          WidgetSpan(child: Icon(Icons.alarm))
                      ]),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Row(
                  children: [
                    const Text("Relative"),
                    Switch.adaptive(
                      value: widget.parametrageHoraire.relative,
                      onChanged: (value) {
                        setState(() {
                          widget.parametrageHoraire.relative =
                              !widget.parametrageHoraire.relative;
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
                Text(widget.parametrageHoraire.debutMatch.displayHasTime()),
                Text(widget.parametrageHoraire.finMatch.displayHasTime())
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  7,
                  (index) => Column(
                        children: [
                          Text("D"),
                          Checkbox(
                            value: true,
                            onChanged: (value) {},
                          )
                        ],
                      )),
            )
          ],
        ),
      ),
    );
  }
}
