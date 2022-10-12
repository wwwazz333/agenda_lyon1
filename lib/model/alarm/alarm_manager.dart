import 'dart:developer';
import 'dart:io' show Platform;
import 'package:agenda_lyon1/model/settings/settingsapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';

import '../../controller/local_notification_service.dart';

class AlarmManager {
  static AlarmManager? instance;
  final FlutterAlarmBackgroundTrigger _alarmPlugin;
  AlarmManager._(FlutterAlarmBackgroundTrigger alarmPlugin)
      : _alarmPlugin = alarmPlugin;
  factory AlarmManager() {
    instance ??= AlarmManager._(FlutterAlarmBackgroundTrigger());
    return instance!;
  }
  void init() {
    if (!Platform.isAndroid) return;
    _setEventHandler((items) {
      log("Alarm............");
      final notif = LocalNotifService();
      notif.init();
      notif.showNotif(
          id: LocalNotifService.notifChangementEvent,
          title: "Test",
          body: "Alarm............");
      clearPassedAlarms();
      SettingsApp().pointDepart = "/alarms";
    });
  }

  Future<AlarmItem?> addAlarm(DateTime time) async {
    if (!Platform.isAndroid) return null;
    return _alarmPlugin.addAlarm(
        // Required
        time,

        //Optional
        uid: "YOUR_APP_ID_TO_IDENTIFY",
        payload: {"YOUR_EXTRA_DATA": "FOR_ALARM"},

        // screenWakeDuration: For how much time you want
        // to make screen awake when alarm triggered
        screenWakeDuration: Duration(minutes: 10));
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
}
