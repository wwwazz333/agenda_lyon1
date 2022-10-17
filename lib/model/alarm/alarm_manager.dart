import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:isolate';
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/alarm/alarm.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';

import '../../controller/alarm_ring.dart';
import '../../controller/local_notification_service.dart';

class AlarmManager {
  static AlarmManager? instance;
  AlarmManager._();
  factory AlarmManager() {
    instance ??= AlarmManager._();
    return instance!;
  }
  bool isInit = false;

  List<Alarm> get _alarms => Stockage().alarmsBox.values.toList();

  static void Function() callBack = () {};
  Future<void> init() async {
    if (isInit) return;
    if (!Platform.isAndroid) return;
    await AndroidAlarmManager.initialize();
    isInit = true;
  }

  Future<void> addAlarm(DateTime time, [bool removable = true]) async {
    if (!Platform.isAndroid) return;
    final alarm = Alarm(dateTime: time, removable: removable);
    alarm.id = await Stockage().alarmsBox.add(alarm);

    AndroidAlarmManager.oneShotAt(alarm.dateTime, alarm.id!, handeler,
        alarmClock: true,
        allowWhileIdle: true,
        exact: true,
        rescheduleOnReboot: true,
        wakeup: true);
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
      return await AndroidAlarmManager.cancel(alarm.id!);
    }
    return false;
  }

  Future<void> clearAll() async {
    if (!Platform.isAndroid) return;
    _alarms.forEach(remove);
  }

  @pragma('vm:entry-point')
  static void handeler() async {
    WidgetsFlutterBinding.ensureInitialized();

    final DateTime now = DateTime.now();

    AlarmRing().start();

    final int isolateId = Isolate.current.hashCode;
    log("[$now] Hello, world! isolate=$isolateId function='$handeler'");
    log("fin isolate");
  }
}
