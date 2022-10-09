import 'package:agenda_lyon1/controller/history_controller.dart';
import 'package:agenda_lyon1/model/calendrier.dart';
import 'package:agenda_lyon1/model/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../model/settings.dart';
import '../custom_widgets/loading_widget.dart';

class HistoriqueScreen extends ConsumerStatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  ConsumerState<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends ConsumerState<HistoriqueScreen>
    with TickerProviderStateMixin {
  late final HistoryController historyController = HistoryController(this);

  @override
  void initState() {
    historyController.controllerAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(SettingsProvider.languageAppProvider);
    final formatter = DateFormat.yMMMMEEEEd(language.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
      ),
      body: FutureBuilder(
        future: historyController.loadingDBHistory,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final data = (snapshot.data as List<Map<String, dynamic>>);

            if (data.isEmpty) {
              return Center(
                child: Text(
                  "Aucun changements d'emplois du temps n'a été enregistré.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => ChangementCard(
                      formatter: formatter,
                      change: Changement(
                          data[index]["name"],
                          getChangementType(data[index]["typeChange"]),
                          data[index]["oldDate"] == 0
                              ? null
                              : DateTime.fromMillisecondsSinceEpoch(
                                  data[index]["oldDate"]),
                          data[index]["newDate"] == 0
                              ? null
                              : DateTime.fromMillisecondsSinceEpoch(
                                  data[index]["newDate"]))));
            }
          } else {
            return const LoadingWidget();
          }
        },
      ),
    );
  }
}

class ChangementCard extends StatelessWidget {
  final Changement change;
  final DateFormat formatter;
  const ChangementCard(
      {required this.change, required this.formatter, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            change.name,
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          Text(
            (change.oldDate == null)
                ? "ajouté aux : ${change.newDate!.affichageDateHeure(formatter)}"
                : (change.newDate == null)
                    ? "supprimé du : ${change.oldDate!.affichageDateHeure(formatter)}"
                    : "déplacé du : ${change.oldDate!.affichageDateHeure(formatter)}\naux : ${change.newDate!.affichageDateHeure(formatter)}",
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    ));
  }
}
