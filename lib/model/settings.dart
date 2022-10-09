import 'dart:convert';
import 'dart:developer';

import 'package:agenda_lyon1/common/colors.dart';
import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/global_data.dart';
import '../data/db_manager.dart';
import 'settingsapp.dart';

class SettingsNames {
  static const String changeIds = "nbrChange";
  static const String notifEnabled = "notifEnabled";
  static const String jourFeriesEnabled = "jourFeriesEnabled";
  static const String alarmesAvancesEnabled = "alamresAvancesEnabled";
  static const String urlCalendar = "urlCalendar";
  static const String isDark = "isDark";
  static const String language = "language";
  static const String cardTimeLineDisplay = "cardTimeLineDisplay";
  static const String firstHourDisplay = "firstHourDisplay";
  static const String lastHourDisplay = "lastHourDisplay";
}

class SettingsProvider {
  ///TODO: #3 on change must save SettingsApp
  static final cardTypeDisplayProvider =
      ChangeNotifierProvider<CardTypeDisplay>((ref) => CardTypeDisplay());
  static final languageAppProvider =
      StateProvider<Locale>((ref) => languages.values.first);

  static final themeAppProvider =
      StateProvider<ThemeMode>((ref) => ThemeMode.system);

  static final urlCalendarProvider = StateProvider<String>((ref) => "");
}

bool _criticalSettingsLoaded = false;
bool loadCriticalSettings() {
  if (!_criticalSettingsLoaded) {
    SettingsApp().copy(
        Stockage().settingsAppBox.get("default", defaultValue: SettingsApp()));

    // List<String> defStrList = [];
    // await Future.wait([
    //   DBManager.open(),
    //   DataReader.getString(SettingsNames.urlCalendar, "").then((value) {
    //     ref.read(SettingsProvider.urlCalendarProvider.notifier).state = value;
    //     SettingsApp().urlCalendar = value;
    //   }),
    //   DataReader.getBool(SettingsNames.isDark).then((value) {
    //     ref.read(SettingsProvider.themeAppProvider.notifier).state =
    //         value ? ThemeMode.dark : ThemeMode.light;
    //     SettingsApp().appIsDarkMode = value;
    //   }),
    //   DataReader.getString(
    //           SettingsNames.language, languages.values.first.languageCode)
    //       .then((value) {
    //     ref.read(SettingsProvider.languageAppProvider.notifier).state =
    //         languages[value]!;
    //     SettingsApp().languageApp = languages[value] ?? languages["fr"]!;
    //   }),
    //   DataReader.getBool(SettingsNames.cardTimeLineDisplay, true).then((value) {
    //     ref
    //         .read(SettingsProvider.cardTypeDisplayProvider)
    //         .cardTimeLineDisplayNoListener = value;
    //   }),
    //   DataReader.getInt(SettingsNames.firstHourDisplay, 6).then((value) {
    //     ref
    //         .read(SettingsProvider.cardTypeDisplayProvider)
    //         .firstHourDisplayNoListener = value;
    //   }),
    //   DataReader.getInt(SettingsNames.lastHourDisplay, 20).then((value) {
    //     ref
    //         .read(SettingsProvider.cardTypeDisplayProvider)
    //         .lastHourDisplayNoListener = value;
    //   }),
    //   DataReader.getString(SettingsNames.changeIds, json.encode(defStrList))
    //       .then((value) {
    //     SettingsApp().changeIds =
    //         (json.decode(value) as List<dynamic>).map((e) => e as int).toList();
    //   }),
    //   DataReader.getBool(SettingsNames.notifEnabled, true)
    //       .then((value) => SettingsApp().notifEnabled = value),
    //   DataReader.getBool(SettingsNames.jourFeriesEnabled)
    //       .then((value) => SettingsApp().jourFeriesEnabled = value),
    //   DataReader.getBool(SettingsNames.alarmesAvancesEnabled)
    //       .then((value) => SettingsApp().alamresAvancesEnabled = value),
    // ]);
    _criticalSettingsLoaded = true;
  }
  log("fin loadCriticalSettings");
  return true;
}

void setUpListeners(ProviderContainer ref) {
  ref.read(SettingsProvider.urlCalendarProvider.notifier).state =
      SettingsApp().urlCalendar;
  ref.read(SettingsProvider.themeAppProvider.notifier).state =
      SettingsApp().appIsDarkMode ? ThemeMode.dark : ThemeMode.light;
  ref.read(SettingsProvider.languageAppProvider.notifier).state =
      SettingsApp().languageApp;
  ref.listen(SettingsProvider.urlCalendarProvider, (previous, next) {
    SettingsApp().urlCalendar = next;
    log("Listener: urlCalendar");
  });

  ref.listen(SettingsProvider.themeAppProvider, (previous, next) {
    if (previous != next) {
      SettingsApp().appIsDarkMode = next == ThemeMode.dark;
      countColor = 0;
      log("Listener: themeApp");
    }
  });

  ref.listen(SettingsProvider.languageAppProvider, (previous, next) {
    if (previous != next) {
      SettingsApp().languageApp = next;
    }
    log("Listener: languageApp");
  });
}

// void loadSettings(WidgetRef ref) {
//   setUpListeners(ref);

//   log("fin loadSettings");
// }

class CardTypeDisplay extends ChangeNotifier {
  bool get cardTimeLineDisplay {
    return SettingsApp().cardTimeLineDisplay;
  }

  int get firstHourDisplay {
    return SettingsApp().firstHourDisplay;
  }

  int get lastHourDisplay {
    return SettingsApp().lastHourDisplay;
  }

  set cardTimeLineDisplay(bool newVal) {
    cardTimeLineDisplayNoListener = newVal;
    notifyListeners();
  }

  set cardTimeLineDisplayNoListener(bool newVal) {
    SettingsApp().cardTimeLineDisplay = newVal;
  }

  set firstHourDisplay(int newVal) {
    firstHourDisplayNoListener = newVal;
    notifyListeners();
  }

  set firstHourDisplayNoListener(int newVal) {
    SettingsApp().firstHourDisplay = newVal;
  }

  set lastHourDisplay(int newVal) {
    lastHourDisplayNoListener = newVal;
    notifyListeners();
  }

  set lastHourDisplayNoListener(int newVal) {
    SettingsApp().lastHourDisplay = newVal;
  }

  void setHours(int firstHour, int lastHour) {
    setHoursNoListener(firstHour, lastHour);
    notifyListeners();
  }

  void setHoursNoListener(int firstHour, int lastHour) {
    SettingsApp().firstHourDisplay = firstHour;
    SettingsApp().lastHourDisplay = lastHour;
  }
}
