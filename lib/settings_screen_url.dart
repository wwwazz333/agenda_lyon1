import 'package:agenda_lyon1/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreenURL extends ConsumerStatefulWidget {
  const SettingsScreenURL({super.key});

  @override
  _SettingsScreenURL createState() => _SettingsScreenURL();
}

class _SettingsScreenURL extends ConsumerState<SettingsScreenURL> {
  @override
  Widget build(BuildContext context) {
    final urlController = TextEditingController(text: ref.watch(urlCalendar));
    final urlRoomController = TextEditingController();
    return Scaffold(
        appBar: AppBar(title: const Text("Settings")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: urlController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "URL",
                  hintText: ".............."),
            ),
            TextFormField(
              controller: urlRoomController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "URL Room",
                  hintText: ".............."),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      ref.read(urlCalendar.notifier).state = urlController.text;
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            )
          ],
        ));
  }
}
