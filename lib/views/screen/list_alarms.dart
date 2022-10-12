import 'package:agenda_lyon1/model/alarm/alarm_manager.dart';
import 'package:agenda_lyon1/views/custom_widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarmes"),
        actions: [
          IconButton(
              onPressed: () {
                AlarmManager()
                    .addAlarm(DateTime.now().add(Duration(seconds: 10)));
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
              final alarms =
                  (snapshot.data as List<AlarmItem>).reversed.toList();
              return ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) => AlarmCard(alarms[index].time),
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

class AlarmCard extends StatelessWidget {
  final DateTime? date;
  const AlarmCard(this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          date != null ? Text(date!.toIso8601String()) : const Text("erreur"),
    );
  }
}
