import 'dart:developer';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifService {
  static const notifChangementEvent = 1;
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
    await _localNotifService.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponseDarwin(
      int id, String? title, String? body, String? payload) {
    log("id: $id");
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    log("id: ${details.id} & payload = ${details.payload}");
    if (details.id == notifChangementEvent) {
      onNotificationClick.add(details.payload);
    }
  }

  Future<NotificationDetails> _notificationDetails() async {
    const androidNotifDetails = AndroidNotificationDetails(
        "channelId", "channelName",
        channelDescription: 'déscription',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: false);

    const darwinNotificationDetails = DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotifDetails, iOS: darwinNotificationDetails);
  }

  Future<void> showNotif(
      {required int id, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotifService.show(id, title, body, details);
  }
}
