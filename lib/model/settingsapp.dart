import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../common/global_data.dart';
import '../data/shared_pref.dart';
import 'settings.dart';
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
  List<int> _changeIds = [];
  @HiveField(1)
  bool _notifEnabled = true;
  @HiveField(2)
  bool _jourFeriesEnabled = false;
  @HiveField(3)
  bool _alarmesAvancesEnabled = false;
  @HiveField(4)
  bool _appIsDarkMode = false;
  @HiveField(5)
  Locale? _languageApp;
  @HiveField(6)
  String? _urlCalendar;
  @HiveField(7)
  ThemeMode? _themeApp;

  @HiveField(8)
  bool _cardTimeLineDisplay = true;
  @HiveField(9)
  int _firstHourDisplay = 8;
  @HiveField(10)
  int _lastHourDisplay = 20;

  ///getters

  List<int> get changeIds => _changeIds;

  bool get notifEnabled => _notifEnabled;

  bool get jourFeriesEnabled => _jourFeriesEnabled;

  bool get alamresAvancesEnabled => _alarmesAvancesEnabled;

  bool get appIsDarkMode => _appIsDarkMode;
  Locale get languageApp => _languageApp ?? languages["fr"]!;

  String get urlCalendar => _urlCalendar ?? "";
  ThemeMode get themeApp => _themeApp ?? ThemeMode.light;

  bool get cardTimeLineDisplay => _cardTimeLineDisplay;
  int get firstHourDisplay => _firstHourDisplay;
  int get lastHourDisplay => _lastHourDisplay;

  ///setters
  set changeIds(List<int> newVal) {
    _changeIds = newVal;
    DataReader.save(SettingsNames.changeIds, json.encode(newVal));
  }

  set notifEnabled(bool newVal) {
    _notifEnabled = newVal;
    DataReader.save(SettingsNames.notifEnabled, newVal);
  }

  set jourFeriesEnabled(bool newVal) {
    _jourFeriesEnabled = newVal;
    DataReader.save(SettingsNames.jourFeriesEnabled, newVal);
  }

  set alamresAvancesEnabled(bool newVal) {
    _alarmesAvancesEnabled = newVal;
    DataReader.save(SettingsNames.alarmesAvancesEnabled, newVal);
  }

  set appIsDarkMode(bool newVal) {
    _appIsDarkMode = newVal;
    DataReader.save(SettingsNames.isDark, newVal);
  }

  set languageApp(Locale value) {
    if (value.languageCode != _languageApp?.languageCode) {
      _languageApp = value;
      DataReader.save(SettingsNames.language, value.languageCode);
    }
  }

  set urlCalendar(String value) {
    _urlCalendar = value;
    DataReader.save(SettingsNames.urlCalendar, value);
  }

  set themeApp(ThemeMode value) {
    _themeApp = value;
    DataReader.save(SettingsNames.isDark, value == ThemeMode.dark);
  }

  set cardTimeLineDisplay(bool value) {
    _cardTimeLineDisplay = value;
    DataReader.save(SettingsNames.cardTimeLineDisplay, value);
  }

  set firstHourDisplay(int value) {
    _firstHourDisplay = value;
    DataReader.save(SettingsNames.lastHourDisplay, value);
  }

  set lastHourDisplay(int value) {
    _lastHourDisplay = value;
    DataReader.save(SettingsNames.firstHourDisplay, value);
  }
}
