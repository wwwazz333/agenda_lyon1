import 'dart:convert';
import 'dart:developer';

import 'package:agenda_lyon1/common/colors.dart';
import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:agenda_lyon1/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/global_data.dart';
import 'common/themes.dart';
import 'data/db_manager.dart';

class SettingsNames {
  static const String changeIds = "nbrChange";
}

class SettingsApp {
  static bool _notifEnabled = true;
  static bool _jourFeriesEnabled = false;
  static bool _alamresAvancesEnabled = false;
  static List<int> changeIds = [];

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
    DataReader.save("notifEnabled", _notifEnabled);
  }

  static set jourFeriesEnabled(bool newVal) {
    _jourFeriesEnabled = newVal;
    DataReader.save("jourFeriesEnabled", _notifEnabled);
  }

  static set alamresAvancesEnabled(bool newVal) {
    _alamresAvancesEnabled = newVal;
    DataReader.save("alamresAvancesEnabled", _notifEnabled);
  }
}

bool _criticalSettingsLoaded = false;
Future<bool> loadCriticalSettings(WidgetRef ref) async {
  if (!_criticalSettingsLoaded) {
    List<String> defStrList = [];
    await Future.wait([
      DBManager.open(),
      DataReader.getString("urlCalendar", "")
          .then((value) => ref.read(urlCalendar.notifier).state = value),
      DataReader.getBool("isDark").then((value) {
        ref.read(themeApp.notifier).state =
            value ? themes["dark"]! : themes["light"]!;
        appIsDarkMode = value;
      }),
      DataReader.getString("language", languages.values.first.languageCode)
          .then((value) =>
              ref.read(languageApp.notifier).state = languages[value]!),
      DataReader.getBool("cardTimeLineDisplay").then((value) =>
          ref.read(cardTypeDisplay).cardTimeLineDisplayNoListener = value),
      DataReader.getInt("firstHourDisplay", 6).then((value) =>
          ref.read(cardTypeDisplay).firstHourDisplayNoListener = value),
      DataReader.getInt("lastHourDisplay", 20).then((value) =>
          ref.read(cardTypeDisplay).lastHourDisplayNoListener = value),
      DataReader.getString(SettingsNames.changeIds, json.encode(defStrList))
          .then((value) {
        SettingsApp.changeIds =
            (json.decode(value) as List<dynamic>).map((e) => e as int).toList();
        DataReader.save(SettingsNames.changeIds, json.encode(defStrList));
      })
    ]);
    _criticalSettingsLoaded = true;
  }
  log("fin loadCriticalSettings");
  return true;
}

void setUpListeners(WidgetRef ref) {
  ref.listen(urlCalendar, (previous, next) {
    DataReader.save("urlCalendar", next);
    log("Listener: urlCalendar");
  });

  ref.listen(themeApp, (previous, next) {
    if (previous != next) {
      DataReader.save("isDark", next == themes["dark"]);
      appIsDarkMode = next == themes["dark"];
      countColor = 0;
      log("Listener: themeApp");
    }
  });

  ref.listen(languageApp, (previous, next) {
    if (previous != next) {
      DataReader.save("language", next.languageCode);
    }
    log("Listener: languageApp");
  });

  final cardTypeToDisplay = ref.read(cardTypeDisplay);
  cardTypeToDisplay.addListener(() {
    log("changement pour cardTypeDisplay");
    DataReader.save(
        "cardTimeLineDisplay", cardTypeToDisplay.cardTimeLineDisplay);
    DataReader.save("firstHourDisplay", cardTypeToDisplay.firstHourDisplay);
    DataReader.save("lastHourDisplay", cardTypeToDisplay.lastHourDisplay);
    log("Listener: cardTypeToDisplay");
  });
}

void loadSettings(WidgetRef ref) {
  setUpListeners(ref);
  DataReader.getBool("notifEnabled", true)
      .then((value) => SettingsApp.notifEnabled = value);

  DataReader.getBool("jourFeriesEnabled")
      .then((value) => SettingsApp.jourFeriesEnabled = value);

  DataReader.getBool("alamresAvancesEnabled")
      .then((value) => SettingsApp.alamresAvancesEnabled = value);

  log("fin loadSettings");
}
