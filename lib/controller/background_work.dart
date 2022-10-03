import 'dart:developer';

import 'package:workmanager/workmanager.dart';

import 'local_notification_service.dart';

const updateCalendrier = "com.agenda_lyon1.workUpdate.calendrier";

void testWork() {
  Workmanager().registerPeriodicTask(updateCalendrier, updateCalendrier,
      initialDelay: const Duration(minutes: 15),
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace);
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case updateCalendrier:
        log("Work: new one here, whit inputData = $inputData");
        final notif = LocalNotifService();
        notif.init();
        notif.showNotif(id: 1, title: "Update", body: "Bravo tu a reuçi ");
        // testWork();
        break;
    }
    return Future.value(true);
  });
}
