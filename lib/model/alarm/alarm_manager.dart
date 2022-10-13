import 'dart:developer';
import 'dart:io' show Platform;
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/alarm/alarm.dart';
import 'package:background_fetch/background_fetch.dart';

class AlarmManager {
  static AlarmManager? instance;
  AlarmManager._();
  factory AlarmManager() {
    instance ??= AlarmManager._();
    return instance!;
  }
  List<Alarm> get _alarms => Stockage().alarmsBox.values.toList();

  static void Function() callBack = () {};
  Future<void> init() async {
    if (!Platform.isAndroid) return;
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  Future<void> addAlarm(DateTime time, [bool removable = true]) async {
    if (!Platform.isAndroid) return;
    final alarm = Alarm(dateTime: time, removable: removable);
    alarm.id = await Stockage().alarmsBox.add(alarm);
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

  bool remove(Alarm alarm) {
    if (!Platform.isAndroid) return false;
    alarm.delete();
    return true;
  }

  Future<void> clearAll() async {
    if (!Platform.isAndroid) return;
    _alarms.forEach(remove);
  }

  void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      // This task has exceeded its allowed running-time.
      // You must stop what you're doing and immediately .finish(taskId)
      log("[BackgroundFetch] Headless task timed-out: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }
    log('[BackgroundFetch] Headless event received.');
    // Do your work here...
    BackgroundFetch.finish(taskId);
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
  }

  void _onClickEnable(enabled) {
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  void _onClickStatus() async {
    int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');
  }
}
