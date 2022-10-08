import 'dart:convert';
import 'dart:developer';

import 'package:agenda_lyon1/common/colors.dart';
import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:agenda_lyon1/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import 'common/global_data.dart';
import 'data/db_manager.dart';

class SettingsNames {
  static const String changeIds = "nbrChange";
  static const String notifEnabled = "notifEnabled";
  static const String jourFeriesEnabled = "jourFeriesEnabled";
  static const String alamresAvancesEnabled = "alamresAvancesEnabled";
  static const String urlCalendar = "urlCalendar";
  static const String isDark = "isDark";
  static const String language = "language";
  static const String cardTimeLineDisplay = "cardTimeLineDisplay";
  static const String firstHourDisplay = "firstHourDisplay";
  static const String lastHourDisplay = "lastHourDisplay";
}

class SettingsApp {
  static bool _notifEnabled = true;
  static bool _jourFeriesEnabled = false;
  static bool _alamresAvancesEnabled = false;
  static List<int> _changeIds = [];

  static List<int> get changeIds => _changeIds;
  static set changeIds(List<int> newVal) {
    _changeIds = newVal;
    DataReader.save(SettingsNames.changeIds, json.encode(newVal));
  }

  static bool get notifEnabled {
    return _notifEnabled;
  }

  static bool get jourFeriesEnabled {
    return _jourFeriesEnabled;
  }

  static bool get alamresAvancesEnabled {
    return _alamresAvancesEnabled;
  }

  static set notifEnabled(bool newVal) {
    _notifEnabled = newVal;
    DataReader.save(SettingsNames.notifEnabled, newVal);
  }

  static set jourFeriesEnabled(bool newVal) {
    _jourFeriesEnabled = newVal;
    DataReader.save(SettingsNames.jourFeriesEnabled, newVal);
  }

  static set alamresAvancesEnabled(bool newVal) {
    _alamresAvancesEnabled = newVal;
    DataReader.save(SettingsNames.alamresAvancesEnabled, newVal);
  }
}

bool _criticalSettingsLoaded = false;
Future<bool> loadCriticalSettings(BuildContext context, WidgetRef ref) async {
  if (!_criticalSettingsLoaded) {
    List<String> defStrList = [];
    await Future.wait([
      DBManager.open(),
      DataReader.getString(SettingsNames.urlCalendar, "")
          .then((value) => ref.read(urlCalendar.notifier).state = value),
      DataReader.getBool(SettingsNames.isDark).then((value) {
        ref.read(themeApp.notifier).state =
            value ? ThemeMode.dark : ThemeMode.light;
        appIsDarkMode = value;
      }),
      DataReader.getString(
              SettingsNames.language, languages.values.first.languageCode)
          .then((value) =>
              ref.read(languageApp.notifier).state = languages[value]!),
      DataReader.getBool(SettingsNames.cardTimeLineDisplay, true).then(
          (value) =>
              ref.read(cardTypeDisplay).cardTimeLineDisplayNoListener = value),
      DataReader.getInt(SettingsNames.firstHourDisplay, 6).then((value) =>
          ref.read(cardTypeDisplay).firstHourDisplayNoListener = value),
      DataReader.getInt(SettingsNames.lastHourDisplay, 20).then((value) =>
          ref.read(cardTypeDisplay).lastHourDisplayNoListener = value),
      DataReader.getString(SettingsNames.changeIds, json.encode(defStrList))
          .then((value) {
        SettingsApp.changeIds =
            (json.decode(value) as List<dynamic>).map((e) => e as int).toList();
        DataReader.save(SettingsNames.changeIds, json.encode(defStrList));
      }),
      DataReader.getBool(SettingsNames.notifEnabled, true)
          .then((value) => SettingsApp.notifEnabled = value),
      DataReader.getBool(SettingsNames.jourFeriesEnabled)
          .then((value) => SettingsApp.jourFeriesEnabled = value),
      DataReader.getBool(SettingsNames.alamresAvancesEnabled)
          .then((value) => SettingsApp.alamresAvancesEnabled = value),
    ]);
    _criticalSettingsLoaded = true;
  }
  log("fin loadCriticalSettings");
  return true;
}

void setUpListeners(WidgetRef ref) {
  ref.listen(urlCalendar, (previous, next) {
    DataReader.save(SettingsNames.urlCalendar, next);
    log("Listener: urlCalendar");
  });

  ref.listen(themeApp, (previous, next) {
    if (previous != next) {
      DataReader.save(SettingsNames.isDark, ThemeMode.system);
      appIsDarkMode = next == ThemeMode.dark;
      countColor = 0;
      log("Listener: themeApp");
    }
  });

  ref.listen(languageApp, (previous, next) {
    if (previous != next) {
      DataReader.save(SettingsNames.language, next.languageCode);
    }
    log("Listener: languageApp");
  });

  final cardTypeToDisplay = ref.read(cardTypeDisplay);
  cardTypeToDisplay.addListener(() {
    log("changement pour cardTypeDisplay");
    DataReader.save(SettingsNames.cardTimeLineDisplay,
        cardTypeToDisplay.cardTimeLineDisplay);
    DataReader.save(
        SettingsNames.firstHourDisplay, cardTypeToDisplay.firstHourDisplay);
    DataReader.save(
        SettingsNames.lastHourDisplay, cardTypeToDisplay.lastHourDisplay);
    log("Listener: cardTypeToDisplay");
  });
}

void loadSettings(WidgetRef ref) {
  setUpListeners(ref);

  log("fin loadSettings");
}
