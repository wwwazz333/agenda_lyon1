import 'dart:developer';

import 'package:agenda_lyon1/common/colors.dart';
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/global_data.dart';
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
    }
  });

  ref.listen(SettingsProvider.languageAppProvider, (previous, next) {
    if (previous != next) {
      SettingsApp().languageApp = next;
    }
  });
}

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
    SettingsApp().cardTimeLineDisplay = newVal;
    notifyListeners();
  }

  set firstHourDisplay(int newVal) {
    SettingsApp().firstHourDisplay = newVal;
    notifyListeners();
  }

  set lastHourDisplay(int newVal) {
    SettingsApp().lastHourDisplay = newVal;
    notifyListeners();
  }

  void setHours(int firstHour, int lastHour) {
    SettingsApp().firstHourDisplay = firstHour;
    SettingsApp().lastHourDisplay = lastHour;
    notifyListeners();
  }
}
