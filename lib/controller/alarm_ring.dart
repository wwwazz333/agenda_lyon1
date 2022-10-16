import 'dart:io' show Platform;

import 'package:ringtone_player/ringtone_player.dart';

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
        contentTitle: 'Alarm',
        contentText: 'Alarm is active',
        subText: 'Subtext',
      ),
    );
  }

  void stop() {
    if (!Platform.isAndroid) return;
    RingtonePlayer.stop();
  }
}
