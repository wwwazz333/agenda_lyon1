import 'dart:io' show Platform;
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/alarm/alarm.dart';
import 'package:flutter/services.dart';

class AlarmManager {
  static AlarmManager? instance;
  AlarmManager._();
  factory AlarmManager() {
    instance ??= AlarmManager._();
    return instance!;
  }

  static const methodChannel = MethodChannel("alarmChannel");
  bool isInit = false;

  List<Alarm> get _alarms => Stockage().alarmsBox.values.toList();

  static void Function() callBack = () {};
  Future<void> init() async {
    if (isInit) return;
    if (!Platform.isAndroid) return;
    isInit = true;
  }

  Future<bool> addAlarm(DateTime time, [bool removable = true]) async {
    if (!Platform.isAndroid) return false;
    final alarm = Alarm(dateTime: time, removable: removable);
    alarm.id = await Stockage().alarmsBox.add(alarm);

    return await methodChannel
        .invokeMethod("setAlarm", {"time": time.millisecondsSinceEpoch});
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

  Future<void> clearPassedAlarms() async {
    if (!Platform.isAndroid) return;

    final currDate = DateTime.now();

    final alarms = _alarms.where((a) => a.dateTime.compareTo(currDate) < 0);
    await Future.forEach(alarms, remove);
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

  Future<void> clearAll() async {
    if (!Platform.isAndroid) return;
    _alarms.forEach(remove);
  }
}
