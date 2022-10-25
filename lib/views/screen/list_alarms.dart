import 'package:agenda_lyon1/common/global_data.dart';
import 'package:agenda_lyon1/model/alarm/alarm.dart';
import 'package:agenda_lyon1/model/alarm/alarm_manager.dart';
import 'package:agenda_lyon1/views/custom_widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
                // if (await pickADate(context, language)) {
                //   setState(() {});
                // }
                await AlarmManager()
                    .addAlarm(DateTime.now().add(const Duration(seconds: 10)));
                setState(() {});
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: AlarmManager().getAllAlarms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              final alarms = (snapshot.data as List<Alarm>).reversed.toList();
              return ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) =>
                    AlarmCard(alarms[index].dateTime, formatter, () async {
                  await AlarmManager().remove(alarms[index]);
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

Future<bool> pickADate(BuildContext context, Locale? locale) async {
  final date = DateTime.now();
  final datePicked = await showDatePicker(
    locale: locale,
    initialDate: date,
    firstDate: date,
    lastDate: date.add(const Duration(days: 365 * 100)),
    context: context,
  );
  if (datePicked != null) {
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
      AlarmManager().addAlarm(alarmTime);
      return true;
    }
  }
  return false;
}

class AlarmCard extends StatelessWidget {
  final DateTime? date;
  final void Function() removeSelf;
  final DateFormat formatter;
  static DateFormat timeFormmatter = DateFormat.Hm();
  const AlarmCard(this.date, this.formatter, this.removeSelf, {super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: date != null
          ? Text(
              "${formatter.format(date!).capitalize().replaceAll(".", "")} ${timeFormmatter.format(date!)}")
          : const Text("erreur"),
    );
  }
}
