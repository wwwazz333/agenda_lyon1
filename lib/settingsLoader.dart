import 'package:agenda_lyon1/common/global_data.dart';
import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:agenda_lyon1/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoaderSettings extends StatefulWidget {
  const LoaderSettings({super.key});

  @override
  State<LoaderSettings> createState() => _LoaderSettingsState();
}

class _LoaderSettingsState extends State<LoaderSettings> {
  Widget widgetToLoad = const Text("Loading...");
  @override
  Widget build(BuildContext context) {
    DataReader.getBool("notif_activated").then((notif) =>
        DataReader.getBool("alarm_activated").then((alarm) => setState(
              () {
                widgetToLoad = SettingsScreen(
                  alarmActivated: alarm,
                  notifActivated: notif,
                );
              },
            )));

    return widgetToLoad;
  }
}
