import 'package:agenda_lyon1/common/global_data.dart';
import 'package:agenda_lyon1/model/alarm/alarm.dart';
import 'package:agenda_lyon1/model/alarm/alarm_manager.dart';
import 'package:agenda_lyon1/views/custom_widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controller/data_controller.dart';
import '../../model/settings/settings.dart';
import '../custom_widgets/navigator.dart';

class ListAlarms extends ConsumerStatefulWidget {
  const ListAlarms({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListAlarmsState();
}

class _ListAlarmsState extends ConsumerState<ListAlarms> {
  @override
  void initState() {
    AlarmManager().setAllAlarmsWith(DataController().calendrier, [
      ParametrageHoraire(const Duration(), const Duration(hours: 24),
          const Duration(minutes: 50)),
    ]).then((value) => setState(
          () {},
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(SettingsProvider.languageAppProvider);
    final formatter = DateFormat.MMMEd(language.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarmes"),
        actions: [
          IconButton(
              onPressed: () async {
                var alarmTime = await pickADate(context, language);
                if (alarmTime != null) {
                  AlarmManager()
                      .addAlarm(Alarm(dateTime: alarmTime, removable: true));
                  setState(() {});
                }
                // await AlarmManager()
                //     .addAlarm(DateTime.now().add(const Duration(seconds: 10)));
                // setState(() {});
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: AlarmManager().getAllAlarmsSorted(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              final alarms = (snapshot.data as List<Alarm>).reversed.toList();
              return ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) =>
                    AlarmCard(alarms[index], formatter, () async {
                  await AlarmManager().remove(alarms[index]);
                  setState(() {});
                }, () async {
                  alarms[index].isSet = !alarms[index].isSet;
                  await AlarmManager().updateAlarm(alarms[index]);
                  setState(() {});
                }),
              );
            } else {
              return const Center(
                child: Text("Disponible uniquement sous android."),
              );
            }
          } else {
            return const LoadingWidget();
          }
        },
      ),
      floatingActionButton: const FloatingNavButton(),
    );
  }
}

Future<DateTime?> pickADate(BuildContext context, Locale? locale) async {
  DateTime? date = DateTime.now();
  date = await showDatePicker(
    locale: locale,
    initialDate: date,
    firstDate: date,
    lastDate: date.add(const Duration(days: 365 * 100)),
    context: context,
  );
  if (date != null) {
    final timeOfDay = await showTimePicker(
        helpText: "Sélectionner une heure",
        builder: (context, child) => MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child ?? const LoadingWidget(),
            ),
        context: context,
        initialTime: TimeOfDay.fromDateTime(date));
    if (timeOfDay != null) {
      final alarmTime = DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
      return alarmTime;
    }
  }
  return null;
}

class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final void Function() removeSelf;
  final void Function() toggleEnable;
  final DateFormat formatter;
  static DateFormat timeFormmatter = DateFormat.Hm();
  const AlarmCard(
      this.alarm, this.formatter, this.removeSelf, this.toggleEnable,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.bodyText1,
                children: [
              TextSpan(
                  text: formatter
                      .format(alarm.dateTime)
                      .capitalize()
                      .replaceAll(".", "")),
              const TextSpan(
                text: " ",
              ),
              TextSpan(
                text: timeFormmatter.format(alarm.dateTime),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(fontSize: 36),
              )
            ])),
        trailing: alarm.removable
            ? IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: removeSelf)
            : Switch.adaptive(
                value: alarm.isSet,
                onChanged: (value) {
                  toggleEnable();
                },
              ),
      ),
    );
  }
}
