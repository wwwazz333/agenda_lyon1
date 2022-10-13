import 'dart:developer';
import 'dart:io' show Platform;
import 'package:agenda_lyon1/model/settings/settingsapp.dart';
import 'package:flutter/cupertino.dart';

import '../../common/global_data.dart';
import '../../controller/local_notification_service.dart';

class AlarmManager {
  static AlarmManager? instance;
  AlarmManager._();
  factory AlarmManager() {
    instance ??= AlarmManager._();
    return instance!;
  }
  static void Function() callBack = () {};
  Future<void> init() async {
    if (!Platform.isAndroid) return;
    await _alarmPlugin.requestPermission().then((isGranted) {
      if (isGranted) {
        _setEventHandler((items) {
          log("Alarm............");
          final notif = LocalNotifService();
          notif.init();
          notif.showNotif(
              id: LocalNotifService.notifChangementEvent,
              title: "Test",
              body: "Alarm............");
          clearPassedAlarms();
          SettingsApp().pointDepart = "/alarm";
          if (navigatorKey.currentContext != null) {
            Navigator.of(navigatorKey.currentContext!)
                .pushNamed(SettingsApp().pointDepart);
          }
        });
      }
    });
  }

  Future<AlarmItem?> addAlarm(DateTime time) async {
    if (!Platform.isAndroid) return null;
    return _alarmPlugin.addAlarm(
        // Required
        time,
        //Optional
        uid: "com.agenda-lyon1.agenda",
        screenWakeDuration: const Duration(minutes: 10));
  }

  Future<List<AlarmItem>?> getAllAlarms() async {
    if (!Platform.isAndroid) return null;
    await clearPassedAlarms();
    return _alarmPlugin.getAllAlarms();
  }

  Future<void> clearPassedAlarms() async {
    if (!Platform.isAndroid) return;

    ///attention pas faire de boucle d'appel
    final alarms = (await _alarmPlugin.getAllAlarms());

    final currDate = DateTime.now();

    for (var a in alarms.where((a) =>
        a.id != null && a.time != null && a.time!.compareTo(currDate) < 0)) {
      _alarmPlugin.deleteAlarm(a.id!);
    }
  }

  void _setEventHandler(void Function(List<AlarmItem>) alarmEvent) {
    if (!Platform.isAndroid) return;

    _alarmPlugin.onForegroundAlarmEventHandler(alarmEvent);
  }

  Future<void> remove(int id) async {
    if (!Platform.isAndroid) return;
    return await _alarmPlugin.deleteAlarm(id);
  }

  Future<void> clearAll() async {
    if (!Platform.isAndroid) return;
    _alarmPlugin.deleteAllAlarms();
  }
}
