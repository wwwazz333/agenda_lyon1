import 'dart:developer';

import 'package:workmanager/workmanager.dart';
import 'dart:io' show Platform;
import 'local_notification_service.dart';

const updateCalendrier = "com.agenda_lyon1.workUpdate.calendrier";

void launchPerodicalWork() {
  if (Platform.isAndroid) {
    Workmanager().registerPeriodicTask(updateCalendrier, updateCalendrier,
        initialDelay: const Duration(hours: 1),
        frequency: const Duration(hours: 1),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingWorkPolicy.replace);
  } else if (Platform.isIOS) {
    Workmanager().registerOneOffTask(updateCalendrier, updateCalendrier,
        initialDelay: const Duration(hours: 1),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case updateCalendrier:
        log("Work: new one here, whit inputData = $inputData");
        final notif = LocalNotifService();
        notif.init();
        notif.showNotif(id: 1, title: "Update", body: "Bravo tu a reuçi ");
        if (Platform.isIOS) {
          launchPerodicalWork();
        }
        break;
    }
    return Future.value(true);
  });
}
