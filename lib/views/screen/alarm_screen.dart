import 'package:agenda_lyon1/controller/alarm_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:slidable_button/slidable_button.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  void startAlarm() {
    AlarmRing().start();
  }

  void stopAlarm() {
    AlarmRing().stop();

    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  void snoozeAlarm() {}
  @override
  Widget build(BuildContext context) {
    startAlarm();
    DateFormat formatter = DateFormat.Hm();
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "Alarme",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 54),
                ),
                Text(
                  formatter.format(DateTime.now()),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 72),
                )
              ],
            ),
            Column(
              children: [
                ElevatedButton.icon(
                    onPressed: snoozeAlarm,
                    icon: const Icon(Icons.snooze),
                    label: const Text("Snooze")),
                const SizedBox(
                  height: 16,
                ),
                HorizontalSlidableButton(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 64,
                  completeSlideAt: 1,
                  onChanged: (position) {
                    if (position == SlidableButtonPosition.end) {
                      stopAlarm();
                    }
                  },
                  color: Theme.of(context).highlightColor,
                  buttonColor: Theme.of(context).primaryColor,
                  buttonWidth: 60.0,
                  dismissible: false,
                  label: const Center(child: Icon(Icons.alarm)),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.alarm_off),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
