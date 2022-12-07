import 'dart:developer';
import 'dart:isolate';
import 'package:agenda_lyon1/model/color/colors.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifService {
  static const notifChangementEvent = 1;
  static const notifAlarm = 2;
  static LocalNotifService? _instance;

  LocalNotifService._() {
    init();
  }
  factory LocalNotifService() {
    _instance ??= LocalNotifService._();
    return _instance!;
  }
  // final _localNotifService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  bool isInit = false;

  Future<void> init() async {
    if (isInit) return;
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'background',
              channelKey: 'changements',
              channelName: 'Changements',
              channelDescription:
                  "Avertissement des changements dans l'empoloi du temps.",
              defaultColor: ColorsEventsManager.redOnePlus,
              ledColor: Colors.white)
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'background', channelGroupName: 'Background')
        ],
        debug: false);
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // final DarwinInitializationSettings initializationSettingsDarwin =
    //     DarwinInitializationSettings(
    //         onDidReceiveLocalNotification:
    //             onDidReceiveNotificationResponseDarwin);
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(
    //   android: initializationSettingsAndroid,
    //   iOS: initializationSettingsDarwin,
    // );

    // await _localNotifService.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    // );
    isInit = true;
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

  // Future<NotificationDetails> _notificationDetailsChangement() async {
  //   const androidNotifDetails = AndroidNotificationDetails(
  //     "changements",
  //     "Changementes",
  //     channelDescription:
  //         "Avertissement des changements dans l'empoloi du temps.",
  //     category: AndroidNotificationCategory("Changement"),
  //     playSound: false,
  //     autoCancel: true,
  //     ongoing: false,
  //     enableVibration: true,
  //     colorized: true,
  //     color: ColorsEventsManager.redOnePlus,
  //   );

  //   const darwinNotificationDetails = DarwinNotificationDetails();

  //   return const NotificationDetails(
  //       android: androidNotifDetails, iOS: darwinNotificationDetails);
  // }

  Future<void> showNotif(
      {required int id, required String title, required String body}) async {
    // final details = await _notificationDetailsChangement();
    // await _localNotifService.show(id, title, body, details);

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: "changements",
            title: title,
            body: body,
            actionType: ActionType.Default));
  }

  Future<void> clear(int id) async {
    // await _localNotifService.cancel(id);
    AwesomeNotifications().cancel(id);
  }

  Future<void> clearAlarm() async {
    // await clear(LocalNotifService.notifAlarm);
    AwesomeNotifications().cancelAll();
  }
}
