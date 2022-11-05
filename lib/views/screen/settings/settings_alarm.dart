import 'package:agenda_lyon1/model/alarm/parametrage_horiare.dart';
import 'package:flutter/material.dart';

import '../../../data/stockage.dart';
import '../../../model/settings/settingsapp.dart';
import '../../custom_widgets/card/card_settings_alarm.dart';

class SettingsAlarm extends StatefulWidget {
  const SettingsAlarm({super.key});

  @override
  State<SettingsAlarm> createState() => _SettingsAlarmState();
}

class _SettingsAlarmState extends State<SettingsAlarm> {
  List<ParametrageHoraire> get _settingsAlarms =>
      Stockage().settingsAlarmBox.values.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètre alarmes"), actions: [
        if (SettingsApp().alarmAcitvated)
          IconButton(
              onPressed: () async {
                final temp = ParametrageHoraire(const Duration(),
                    const Duration(hours: 24), const Duration(minutes: 50));
                Stockage().settingsAlarmBox.add(temp);
                setState(() {});
              },
              icon: const Icon(Icons.add)),
        Switch.adaptive(
          activeColor: Colors.white,
          value: SettingsApp().alarmAcitvated,
          onChanged: (value) {
            setState(() {
              SettingsApp().alarmAcitvated = !SettingsApp().alarmAcitvated;
            });
          },
        )
      ]),
      body: (SettingsApp().alarmAcitvated)
          ? ListView.builder(
              itemCount: _settingsAlarms.length,
              itemBuilder: (context, index) =>
                  SettingsAlarmCard(_settingsAlarms[index]),
            )
          : const Center(child: Text("Système d'alarme désactivé.")),
    );
  }
}
