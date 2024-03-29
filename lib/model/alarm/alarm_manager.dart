import 'dart:io' show Platform;
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/alarm/alarm.dart';
import 'package:agenda_lyon1/model/calendrier/calendrier.dart';
import 'package:agenda_lyon1/model/date.dart';
import 'package:agenda_lyon1/model/event/event_calendrier.dart';
import 'package:agenda_lyon1/model/settings/settingsapp.dart';
import 'package:flutter/services.dart';

import 'parametrage_horiare.dart';

class AlarmManager {
  static AlarmManager? instance;
  AlarmManager._();
  factory AlarmManager() {
    instance ??= AlarmManager._();
    return instance!;
  }

  static const methodChannel = MethodChannel("alarmChannel");

  List<Alarm> get _alarms => Stockage().alarmsBox.values.toList();

  static void Function() callBack = () {};

  Future<bool> addAlarm(Alarm alarm) async {
    if (!Platform.isAndroid) return false;
    var others = await getAllAlarmsWhere(
        (alarmOther) => alarmOther.dateTime.isAtSameMomentAs(alarm.dateTime));

    if (others.isEmpty) {
      alarm.id = await Stockage().alarmsBox.add(alarm);
    }
    return await methodChannel.invokeMethod("setAlarm", {
      "time": alarm.dateTime.millisecondsSinceEpoch,
      "enabled": alarm.isSet
    });
  }

  Future<bool> updateAlarm(Alarm alarm) async {
    if (!Platform.isAndroid) return false;
    alarm.save();

    return await methodChannel.invokeMethod("setAlarm", {
      "time": alarm.dateTime.millisecondsSinceEpoch,
      "enabled": alarm.isSet
    });
  }

  Future<List<Alarm>?> getAllAlarms() async {
    if (!Platform.isAndroid) return null;
    await clearPassedAlarms();
    return _alarms;
  }

  Future<List<Alarm>> getAllAlarmsWhere(bool Function(Alarm) test) async {
    if (!Platform.isAndroid) return [];
    await clearPassedAlarms();
    return _alarms.where(test).toList();
  }

  Future<List<Alarm>> getAllAlarmsSorted() async {
    if (!Platform.isAndroid) return [];
    await clearPassedAlarms();
    return _alarms..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> clearAlarmsWhere(bool Function(Alarm) test) async {
    if (!Platform.isAndroid) return;

    final alarms = _alarms.where(test);
    await Future.forEach(alarms, remove);
  }

  Future<void> clearPassedAlarms() async {
    clearAlarmsWhere((a) => a.dateTime.compareTo(DateTime.now()) < 0);
  }

  Future<void> clearAll() async {
    if (!Platform.isAndroid) return;
    _alarms.forEach(remove);
  }

  Future<bool> remove(Alarm alarm) async {
    if (!Platform.isAndroid) return false;
    alarm.delete();
    if (alarm.id != null) {
      return await methodChannel.invokeMethod(
          "cancelAlarm", {"time": alarm.dateTime.millisecondsSinceEpoch});
    }
    return false;
  }

  ///Si les [alarmAreActivate] == false => supprime toutes les alarmes
  ///
  ///Sinon paramètres les alarmes avec la liste de parametres [parametrageHoraire]
  Future<void> setAllAlarmsWith(
      Calendrier calendrier, List<ParametrageHoraire> parametrageHoraire,
      [bool alarmAreActivate = true]) async {
    if (!Platform.isAndroid) return;
    if (!alarmAreActivate) {
      await clearAll();
      return;
    }

    DateTime now = DateTime.now();
    DateTime limit = now.add(const Duration(days: 7));
    DateTime lastDate = now.subtract(const Duration(days: 1));

    Map<int, Alarm> stocked = {};
    for (EventCalendrier event in calendrier.events) {
      if (event.date.isAfter(limit)) {
        break;
      }
      if (!event.date.isSameDay(lastDate)) {
        for (ParametrageHoraire para in parametrageHoraire) {
          var alarmTime = para.getHoraireSonnerieFor(event.date);
          if (alarmTime != null &&
              alarmTime.isAfter(now) &&
              (event.duree.inHours < 8 || !SettingsApp().jourFeriesEnabled)) {
            stocked[alarmTime.millisecondsSinceEpoch] =
                Alarm(dateTime: alarmTime, removable: false);
          }
        }
      }
      lastDate = event.date;
    }
    var alarmToDel = await getAllAlarmsWhere((alarm) => !alarm.removable);
    for (var a in alarmToDel) {
      if (stocked.containsKey(a.dateTime.millisecondsSinceEpoch)) {
        stocked[a.dateTime.millisecondsSinceEpoch] = a;
      }
    }

    await clearAlarmsWhere((alarm) => alarm.removable == false);
    for (var a in stocked.values) {
      addAlarm(a);
    }
  }
}
