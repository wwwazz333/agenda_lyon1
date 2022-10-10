import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../common/global_data.dart';
part 'settingsapp.g.dart';

@HiveType(typeId: 0)
class SettingsApp extends HiveObject {
  static SettingsApp? instance;
  SettingsApp._();
  factory SettingsApp() {
    instance ??= SettingsApp._();
    return instance!;
  }

  @HiveField(0)
  bool _notifEnabled = true;
  @HiveField(1)
  bool _jourFeriesEnabled = false;
  @HiveField(2)
  bool _alarmesAvancesEnabled = false;
  @HiveField(3)
  bool _appIsDarkMode = false;
  @HiveField(4)
  String _languageApp = "fr";
  @HiveField(5)
  String? _urlCalendar;
  @HiveField(6)
  ThemeMode? _themeApp;

  @HiveField(7)
  bool _cardTimeLineDisplay = true;
  @HiveField(8)
  int _firstHourDisplay = 8;
  @HiveField(9)
  int _lastHourDisplay = 20;

  ///getters

  bool get notifEnabled => _notifEnabled;

  bool get jourFeriesEnabled => _jourFeriesEnabled;

  bool get alamresAvancesEnabled => _alarmesAvancesEnabled;

  bool get appIsDarkMode => _appIsDarkMode;
  Locale get languageApp => languages[_languageApp] ?? languages["fr"]!;

  String get urlCalendar => _urlCalendar ?? "";
  ThemeMode get themeApp => _themeApp ?? ThemeMode.light;

  bool get cardTimeLineDisplay => _cardTimeLineDisplay;
  int get firstHourDisplay => _firstHourDisplay;
  int get lastHourDisplay => _lastHourDisplay;

  ///setters

  set notifEnabled(bool newVal) {
    _notifEnabled = newVal;
    save();
  }

  set jourFeriesEnabled(bool newVal) {
    _jourFeriesEnabled = newVal;
    save();
  }

  set alamresAvancesEnabled(bool newVal) {
    _alarmesAvancesEnabled = newVal;
    save();
  }

  set appIsDarkMode(bool newVal) {
    _appIsDarkMode = newVal;
    save();
  }

  set languageApp(Locale value) {
    if (value.languageCode != _languageApp) {
      _languageApp = value.languageCode;
      save();
    }
  }

  set urlCalendar(String value) {
    _urlCalendar = value;
    save();
  }

  set themeApp(ThemeMode value) {
    _themeApp = value;
    save();
  }

  set cardTimeLineDisplay(bool value) {
    _cardTimeLineDisplay = value;
    save();
  }

  set firstHourDisplay(int value) {
    _firstHourDisplay = value;
    save();
  }

  set lastHourDisplay(int value) {
    _lastHourDisplay = value;
    save();
  }

  void copy(SettingsApp other) {
    if (this == other) return;
    _notifEnabled = other._notifEnabled;
    _jourFeriesEnabled = other._jourFeriesEnabled;
    _alarmesAvancesEnabled = other._alarmesAvancesEnabled;
    _appIsDarkMode = other._appIsDarkMode;
    _languageApp = other._languageApp;
    _urlCalendar = other._urlCalendar;
    _themeApp = other._themeApp;
  }
}
