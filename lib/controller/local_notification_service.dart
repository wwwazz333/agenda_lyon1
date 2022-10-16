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
import 'alarm_ring.dart';

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
      onDidReceiveBackgroundNotificationResponse:
          LocalNotifService.notificationTapBackground,
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
    } else if (details.id == notifAlarm) {
      log("Alarm............");
      AlarmManager().clearPassedAlarms();
      SettingsApp().pointDepart = "/alarm";
      if (navigatorKey.currentContext != null) {
        Navigator.of(navigatorKey.currentContext!)
            .pushNamed(SettingsApp().pointDepart);
      }
    }
  }

  Future<NotificationDetails> _notificationDetails() async {
    const androidNotifDetails = AndroidNotificationDetails(
      "channelId",
      "channelName",
      channelDescription: 'déscription',
      category: AndroidNotificationCategory("Changement"),
      playSound: false,
      autoCancel: true,
      ongoing: false,
      enableVibration: true,
      colorized: true,
    );

    const darwinNotificationDetails = DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotifDetails, iOS: darwinNotificationDetails);
  }

  Future<NotificationDetails> _notificationDetailsAlarm() async {
    const androidNotifDetails = AndroidNotificationDetails(
        "channelId", "Alarmes",
        channelDescription:
            'affichage des alarmes (ne surtout pas désactivé si vous utiliser les alarmes).',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        autoCancel: false,
        usesChronometer: true,
        visibility: NotificationVisibility.public,
        ongoing: true,
        enableVibration: true,
        colorized: true,
        category: AndroidNotificationCategory.alarm,
        color: ColorsEventsManager.redOnePlus,
        actions: [
          AndroidNotificationAction('stop', 'Stop'),
          AndroidNotificationAction('snooze', 'Snooze'),
        ]);

    return const NotificationDetails(android: androidNotifDetails);
  }

  Future<void> showNotif(
      {required int id, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotifService.show(id, title, body, details);
  }

  Future<void> showAlarm({required int id}) async {
    AlarmRing().start();
    final details = await _notificationDetailsAlarm();
    await _localNotifService.show(
        LocalNotifService.notifAlarm, "Alarme", "", details,
        payload: "start:alarm");
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) async {
    log("notif res : ${notificationResponse.payload}, ${notificationResponse.input}, ${notificationResponse.actionId}");
    log("Hello, world! isolate=${Isolate.current.hashCode}");
    // handle action
    switch (notificationResponse.actionId) {
      case "stop":
        AlarmRing().stop();
        break;
      case "snooze":
        AlarmRing().stop();
        WidgetsFlutterBinding.ensureInitialized();
        await Stockage().init();
        await AlarmManager().init();
        AlarmManager()
            .addAlarm(DateTime.now().add(const Duration(seconds: 10)));
        break;
      default:
    }
  }

  Future<void> setupEntryPoint() async {
    final notifLaunchDetails = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();

    if ((notifLaunchDetails?.notificationResponse?.payload ?? "") != "") {
      final payload = (notifLaunchDetails?.notificationResponse?.payload)!;
      final splited = payload.split(':');
      if (splited[0] == "start") {
        SettingsApp().pointDepart = "/${splited[1]}";
      }
    }
  }
}
