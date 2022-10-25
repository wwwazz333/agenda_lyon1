import 'dart:developer';
import 'dart:isolate';
import 'package:agenda_lyon1/model/alarm/alarm_manager.dart';
import 'package:agenda_lyon1/model/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../common/global_data.dart';
import '../data/stockage.dart';
import '../model/settings/settingsapp.dart';

class LocalNotifService {
  static const notifChangementEvent = 1;
  static const notifAlarm = 2;
  LocalNotifService();
  final _localNotifService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification:
                onDidReceiveNotificationResponseDarwin);
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifService.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponseDarwin(
      int id, String? title, String? body, String? payload) {
    log("id: $id");
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    log("intent notif isoalte = ${Isolate.current.hashCode}");
    log("id: ${details.id} & payload = ${details.payload}");
    if (details.id == notifChangementEvent) {
      onNotificationClick.add(details.payload);
    } else if (details.id == notifAlarm) {}
  }

  Future<NotificationDetails> _notificationDetailsChangement() async {
    const androidNotifDetails = AndroidNotificationDetails(
      "changements",
      "Changementes",
      channelDescription:
          "Avertissement des changements dans l'empoloi du temps.",
      category: AndroidNotificationCategory("Changement"),
      playSound: false,
      autoCancel: true,
      ongoing: false,
      enableVibration: true,
      colorized: true,
      color: ColorsEventsManager.redOnePlus,
    );

    const darwinNotificationDetails = DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotifDetails, iOS: darwinNotificationDetails);
  }

  Future<void> showNotif(
      {required int id, required String title, required String body}) async {
    final details = await _notificationDetailsChangement();
    await _localNotifService.show(id, title, body, details);
  }

  Future<void> clear(int id) async {
    await _localNotifService.cancel(id);
  }

  Future<void> clearAlarm() async {
    await clear(LocalNotifService.notifAlarm);
  }

  Future<void> setupEntryPoint() async {
    final notifLaunchDetails = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();

    if ((notifLaunchDetails?.notificationResponse?.payload ?? "") != "") {
      final payload = (notifLaunchDetails?.notificationResponse?.payload)!;
      final splited = payload.split(':');
      if (splited[0] == "start") {
        SettingsApp().pointDepart = "/${splited[1]}";
        if (navigatorKey.currentContext != null) {
          Navigator.of(navigatorKey.currentContext!)
              .pushNamed(SettingsApp().pointDepart);
        }
      }
    }
  }
}
