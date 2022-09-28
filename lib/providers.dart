import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/global_data.dart';

final selectedDate = StateProvider<DateTime>((ref) => DateTime.now());

final languageApp = StateProvider<Locale>((ref) => languages.values.first);

final themeApp = StateProvider<ThemeData>((ref) => themes.values.first);

final urlCalendar = StateProvider<String>((ref) => "");

final cardTypeDisplay =
    ChangeNotifierProvider<CardTypeDisplay>((ref) => CardTypeDisplay());

class CardTypeDisplay extends ChangeNotifier {
  bool _cardTimeLineDisplay = false;
  int _firstHourDisplay = 8;
  int _lastHourDisplay = 20;

  bool get cardTimeLineDisplay {
    return _cardTimeLineDisplay;
  }

  int get firstHourDisplay {
    return _firstHourDisplay;
  }

  int get lastHourDisplay {
    return _lastHourDisplay;
  }

  set cardTimeLineDisplay(bool newVal) {
    _cardTimeLineDisplay = newVal;
    notifyListeners();
  }

  set firstHourDisplay(int newVal) {
    _firstHourDisplay = newVal;
    notifyListeners();
  }

  set lastHourDisplay(int newVal) {
    _lastHourDisplay = newVal;
    notifyListeners();
  }

  void setHours(int firstHour, int lastHour) {
    _firstHourDisplay = firstHour;
    _lastHourDisplay = lastHour;
    notifyListeners();
  }
}
