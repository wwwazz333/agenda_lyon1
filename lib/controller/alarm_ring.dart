import 'dart:io' show Platform;

import 'package:ringtone_player/ringtone_player.dart';

import 'local_notification_service.dart';

class AlarmRing {
  static AlarmRing? instance;
  AlarmRing._();
  factory AlarmRing() {
    instance ??= AlarmRing._();
    return instance!;
  }

  void start() {
    if (!Platform.isAndroid) return;
    RingtonePlayer.alarm(
      volume: 1,
      alarmMeta: AlarmMeta(
        'com.example.agenda_lyon1.MainActivity',
        'ic_alarm_notification',
        contentTitle: 'Alarme',
        contentText: 'Alarme activé',
      ),
    );
    final notif = LocalNotifService();
    notif.init();
    notif.showAlarm(id: LocalNotifService.notifChangementEvent);
  }

  void stop() {
    if (!Platform.isAndroid) return;
    RingtonePlayer.stop();
    LocalNotifService().clearAlarm();
  }

  Duration snooze() {
    ///TODO : change time snooze
    if (!Platform.isAndroid) return const Duration(seconds: 0);
    return const Duration(seconds: 10);
  }
}
