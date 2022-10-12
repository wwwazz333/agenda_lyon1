import 'dart:io' show Platform;
import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';

class AlarmManager {
  static AlarmManager? instance;
  final FlutterAlarmBackgroundTrigger _alarmPlugin;
  AlarmManager._(FlutterAlarmBackgroundTrigger alarmPlugin)
      : _alarmPlugin = alarmPlugin;
  factory AlarmManager() {
    instance ??= AlarmManager._(FlutterAlarmBackgroundTrigger());
    return instance!;
  }

  Future<AlarmItem?> addAlarm(DateTime time) async {
    if (!Platform.isAndroid) return null;
    return _alarmPlugin.addAlarm(
        // Required
        DateTime.now().add(Duration(seconds: 10)),

        //Optional
        uid: "YOUR_APP_ID_TO_IDENTIFY",
        payload: {"YOUR_EXTRA_DATA": "FOR_ALARM"},

        // screenWakeDuration: For how much time you want
        // to make screen awake when alarm triggered
        screenWakeDuration: Duration(minutes: 10));
  }
}
