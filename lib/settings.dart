import 'dart:convert';
import 'dart:developer';

import 'package:agenda_lyon1/common/colors.dart';
import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/global_data.dart';
import 'controller/card_type_display.dart';
import 'data/db_manager.dart';

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

class SettingsApp {
  static List<int> _changeIds = [];
  static bool _notifEnabled = true;
  static bool _jourFeriesEnabled = false;
  static bool _alarmesAvancesEnabled = false;
  static bool _appIsDarkMode = false;
  static CardTypeDisplay? _cardTypeDisplay;
  static Locale? _languageApp;
  static String? _urlCalendar;

  static ThemeMode? _themeApp;

  ///providers
  ///TODO: #3 on change must save SettingsApp
  static final cardTypeDisplayProvider =
      ChangeNotifierProvider<CardTypeDisplay>((ref) => CardTypeDisplay());
  static final languageAppProvider =
      StateProvider<Locale>((ref) => languages.values.first);

  static final themeAppProvider =
      StateProvider<ThemeMode>((ref) => ThemeMode.system);

  static final urlCalendarProvider = StateProvider<String>((ref) => "");

  ///getters
  static List<int> get changeIds => _changeIds;

  static bool get notifEnabled => _notifEnabled;

  static bool get jourFeriesEnabled => _jourFeriesEnabled;

  static bool get alamresAvancesEnabled => _alarmesAvancesEnabled;

  static bool get appIsDarkMode => _appIsDarkMode;
  static Locale get languageApp => _languageApp ?? languages["fr"]!;
  static CardTypeDisplay get cardTypeDisplay =>
      _cardTypeDisplay ?? CardTypeDisplay();
  static String get urlCalendar => _urlCalendar ?? "";
  static ThemeMode get themeApp => _themeApp ?? ThemeMode.light;

  ///setters
  static set changeIds(List<int> newVal) {
    _changeIds = newVal;
    DataReader.save(SettingsNames.changeIds, json.encode(newVal));
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
    _alarmesAvancesEnabled = newVal;
    DataReader.save(SettingsNames.alarmesAvancesEnabled, newVal);
  }

  static set appIsDarkMode(bool newVal) {
    _appIsDarkMode = newVal;
    DataReader.save(SettingsNames.isDark, newVal);
  }

  static set languageApp(Locale value) {
    if (value.languageCode != _languageApp?.languageCode) {
      _languageApp = value;
      DataReader.save(SettingsNames.language, value.languageCode);
    }
  }

  static set urlCalendar(String value) {
    _urlCalendar = value;
    DataReader.save(SettingsNames.urlCalendar, value);
  }

  static set themeApp(ThemeMode value) {
    _themeApp = value;
    DataReader.save(SettingsNames.isDark, value == ThemeMode.dark);
  }
}

bool _criticalSettingsLoaded = false;
Future<bool> loadCriticalSettings(BuildContext context, WidgetRef ref) async {
  if (!_criticalSettingsLoaded) {
    List<String> defStrList = [];
    await Future.wait([
      DBManager.open(),
      DataReader.getString(SettingsNames.urlCalendar, "").then((value) {
        ref.read(SettingsApp.urlCalendarProvider.notifier).state = value;
        SettingsApp.urlCalendar = value;
      }),
      DataReader.getBool(SettingsNames.isDark).then((value) {
        ref.read(SettingsApp.themeAppProvider.notifier).state =
            value ? ThemeMode.dark : ThemeMode.light;
        SettingsApp.appIsDarkMode = value;
      }),
      DataReader.getString(
              SettingsNames.language, languages.values.first.languageCode)
          .then((value) {
        ref.read(SettingsApp.languageAppProvider.notifier).state =
            languages[value]!;
        SettingsApp.languageApp = languages[value] ?? languages["fr"]!;
      }),
      DataReader.getBool(SettingsNames.cardTimeLineDisplay, true).then((value) {
        ref
            .read(SettingsApp.cardTypeDisplayProvider)
            .cardTimeLineDisplayNoListener = value;
        SettingsApp.cardTypeDisplay.cardTimeLineDisplay = value;
      }),
      DataReader.getInt(SettingsNames.firstHourDisplay, 6).then((value) {
        ref
            .read(SettingsApp.cardTypeDisplayProvider)
            .firstHourDisplayNoListener = value;
        SettingsApp.cardTypeDisplay.firstHourDisplay = value;
      }),
      DataReader.getInt(SettingsNames.lastHourDisplay, 20).then((value) {
        ref
            .read(SettingsApp.cardTypeDisplayProvider)
            .lastHourDisplayNoListener = value;
        SettingsApp.cardTypeDisplay.lastHourDisplay = value;
      }),
      DataReader.getString(SettingsNames.changeIds, json.encode(defStrList))
          .then((value) {
        SettingsApp.changeIds =
            (json.decode(value) as List<dynamic>).map((e) => e as int).toList();
      }),
      DataReader.getBool(SettingsNames.notifEnabled, true)
          .then((value) => SettingsApp.notifEnabled = value),
      DataReader.getBool(SettingsNames.jourFeriesEnabled)
          .then((value) => SettingsApp.jourFeriesEnabled = value),
      DataReader.getBool(SettingsNames.alarmesAvancesEnabled)
          .then((value) => SettingsApp.alamresAvancesEnabled = value),
    ]);
    _criticalSettingsLoaded = true;
  }
  log("fin loadCriticalSettings");
  return true;
}

void setUpListeners(WidgetRef ref) {
  ref.listen(SettingsApp.urlCalendarProvider, (previous, next) {
    DataReader.save(SettingsNames.urlCalendar, next);
    log("Listener: urlCalendar");
  });

  ref.listen(SettingsApp.themeAppProvider, (previous, next) {
    if (previous != next) {
      DataReader.save(SettingsNames.isDark, ThemeMode.system);
      SettingsApp.appIsDarkMode = next == ThemeMode.dark;
      countColor = 0;
      log("Listener: themeApp");
    }
  });

  ref.listen(SettingsApp.languageAppProvider, (previous, next) {
    if (previous != next) {
      DataReader.save(SettingsNames.language, next.languageCode);
    }
    log("Listener: languageApp");
  });

  final cardTypeToDisplay = ref.read(SettingsApp.cardTypeDisplayProvider);
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
