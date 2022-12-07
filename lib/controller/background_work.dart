import 'dart:developer';

import 'package:agenda_lyon1/controller/data_controller.dart';
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io' show Platform;
import '../model/alarm/alarm_manager.dart';
import '../model/settings/settingsapp.dart';
import 'local_notification_service.dart';

const updateCalendrier = "com.agenda_lyon1.background.updateCalendrier";

void launchPerodicalWork() {
  if (Platform.isAndroid) {
    Workmanager().registerPeriodicTask(updateCalendrier, updateCalendrier,
        initialDelay: const Duration(seconds: 10),
        frequency: const Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingWorkPolicy.replace);
  } else if (Platform.isIOS) {
    Workmanager().registerOneOffTask(updateCalendrier, updateCalendrier,
        initialDelay: const Duration(hours: 1),
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case updateCalendrier:
        log("----------------BACKGROUND----------------");

        await DataController().loadCalendrier();
        final notif = LocalNotifService();
        await notif.init();
        DataController().addListenerUpdate("sendNotif", () {
          if (Stockage().changementHasChange) {
            notif.showNotif(
                id: LocalNotifService.notifChangementEvent,
                title: "Changement EDT",
                body: "Vous avez des changements dans votre EDT, regardez !");
          } else {
            notif.showNotif(
                id: LocalNotifService.notifChangementEvent,
                title: "Changement EDT",
                body: "Aucun changement");
          }
        });
        notif.showNotif(
            id: LocalNotifService.notifChangementEvent,
            title: "Background",
            body:
                "nombre de cours : ${DataController().calendrier.events.length}");
        await DataController().update();
        await AlarmManager().setAllAlarmsWith(
            DataController().calendrier,
            Stockage().settingsAlarmBox.values.toList(),
            SettingsApp().alarmAcitvated);

        if (Platform.isIOS) {
          launchPerodicalWork();
        }
        log("fin");
        break;
    }
    return Future.value(true);
  });
}
