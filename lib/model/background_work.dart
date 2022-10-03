import 'dart:developer';

import 'package:workmanager/workmanager.dart';

const updateCalendrier = "com.agenda_lyon1.workUpdate.calendrier";

void testWork() {
  Workmanager().registerOneOffTask(updateCalendrier, updateCalendrier,
      initialDelay: const Duration(minutes: 1),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace);
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case updateCalendrier:
        log("Work: new one here, whit inputData = $inputData");
        testWork();
        break;
    }
    return Future.value(true);
  });
}
