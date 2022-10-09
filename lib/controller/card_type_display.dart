import 'package:flutter/material.dart';

class CardTypeDisplay extends ChangeNotifier {
  bool _cardTimeLineDisplay = true;
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

  set cardTimeLineDisplayNoListener(bool newVal) {
    _cardTimeLineDisplay = newVal;
  }

  set firstHourDisplay(int newVal) {
    _firstHourDisplay = newVal;
    notifyListeners();
  }

  set firstHourDisplayNoListener(int newVal) {
    _firstHourDisplay = newVal;
  }

  set lastHourDisplay(int newVal) {
    _lastHourDisplay = newVal;
    notifyListeners();
  }

  set lastHourDisplayNoListener(int newVal) {
    _lastHourDisplay = newVal;
  }

  void setHours(int firstHour, int lastHour) {
    _firstHourDisplay = firstHour;
    _lastHourDisplay = lastHour;
    notifyListeners();
  }

  void setHoursNoListener(int firstHour, int lastHour) {
    _firstHourDisplay = firstHour;
    _lastHourDisplay = lastHour;
  }
}
