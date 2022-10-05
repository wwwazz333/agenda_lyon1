import 'dart:developer';

import 'package:agenda_lyon1/controller/data_controller.dart';
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
        DataController().addListenerUpdate("sendNotif", (hasChange) {
          if (hasChange) {
            final notif = LocalNotifService();
            notif.init();
            notif.showNotif(
                id: 1,
                title: "Changement EDT",
                body: "Vous avez des changements dans votre EDT, regardez !");
          }
        });
        await DataController().update();

        if (Platform.isIOS) {
          launchPerodicalWork();
        }
        break;
    }
    return Future.value(true);
  });
}
