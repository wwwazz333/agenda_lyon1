import 'package:agenda_lyon1/common/colors.dart';
import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:agenda_lyon1/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/global_data.dart';

class SettingsApp {
  static bool _notifEnabled = true;
  static bool _jourFeriesEnabled = false;
  static bool _alamresAvancesEnabled = false;

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

void loadCriticalSettings(ProviderContainer ref) {
  DataReader.getString("urlCalendar", "")
      .then((value) => ref.read(urlCalendar.notifier).state = value);
  ref.listen(urlCalendar, (previous, next) {
    DataReader.save("urlCalendar", next);
  });

  DataReader.getBool("isDark").then((value) {
    ref.read(themeApp.notifier).state =
        value ? themes["dark"]! : themes["light"]!;
    appIsDarkMode = value;
  });

  ref.listen(themeApp, (previous, next) {
    if (previous != next) {
      DataReader.save("isDark", next == themes["dark"]);
      appIsDarkMode = next == themes["dark"];
      countColor = 0;
    }
  });

  DataReader.getString("language", languages.values.first.languageCode).then(
      (value) => ref.read(languageApp.notifier).state = languages[value]!);

  ref.listen(languageApp, (previous, next) {
    if (previous != next) {
      DataReader.save("language", next.languageCode);
    }
  });

  DataReader.getBool("cardTimeLineDisplay")
      .then((value) => ref.read(cardTypeDisplay).cardTimeLineDisplay = value);
  DataReader.getInt("firstHourDisplay", 6)
      .then((value) => ref.read(cardTypeDisplay).firstHourDisplay = value);
  DataReader.getInt("lastHourDisplay", 20)
      .then((value) => ref.read(cardTypeDisplay).lastHourDisplay = value);

  ref.listen(cardTypeDisplay, (previous, next) {
    DataReader.save("cardTimeLineDisplay", next.cardTimeLineDisplay);
    DataReader.save("firstHourDisplay", next.firstHourDisplay);
    DataReader.save("lastHourDisplay", next.lastHourDisplay);
  });
}

void loadSettings(WidgetRef ref) {
  DataReader.getBool("notifEnabled", true)
      .then((value) => SettingsApp.notifEnabled = value);

  DataReader.getBool("jourFeriesEnabled")
      .then((value) => SettingsApp.jourFeriesEnabled = value);

  DataReader.getBool("alamresAvancesEnabled")
      .then((value) => SettingsApp.alamresAvancesEnabled = value);
}
