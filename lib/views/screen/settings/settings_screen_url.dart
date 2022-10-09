import 'dart:developer';

import 'package:agenda_lyon1/controller/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings.dart';

class SettingsScreenURL extends ConsumerStatefulWidget {
  const SettingsScreenURL({super.key});
  @override
  ConsumerState<SettingsScreenURL> createState() => _SettingsScreenURL();
}

class _SettingsScreenURL extends ConsumerState<SettingsScreenURL> {
  @override
  Widget build(BuildContext context) {
    final urlController =
        TextEditingController(text: ref.watch(SettingsApp.urlCalendarProvider));
    final urlRoomController = TextEditingController();
    const fakeUrl =
        "http://adelb.univ-lyon1.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=xxxxx&projectId=2&calType=ical&firstDate=20xx-xx-xx&lastDate=20xx-xx-xx";
    return Scaffold(
        appBar: AppBar(title: const Text("Settings")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              controller: urlController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "URL",
                  hintText: fakeUrl),
            ),
            TextField(
              controller: urlRoomController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "URL Room",
                  hintText: fakeUrl),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Annuler")),
                ElevatedButton(
                    onPressed: () {
                      log("Settings: modif url");
                      ref.read(SettingsApp.urlCalendarProvider.notifier).state =
                          urlController.text;
                      DataController().clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Confirmer"))
              ],
            )
          ],
        ));
  }
}
