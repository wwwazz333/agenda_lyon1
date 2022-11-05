import 'package:agenda_lyon1/controller/history_controller.dart';
import 'package:agenda_lyon1/model/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../model/changements/changement.dart';
import '../../model/settings/settings.dart';

class HistoriqueScreen extends ConsumerStatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  ConsumerState<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends ConsumerState<HistoriqueScreen>
    with TickerProviderStateMixin {
  late final HistoryController historyController = HistoryController();

  @override
  void initState() {
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
      body: historyController.historique.isNotEmpty
          ? ListView.builder(
              itemCount: historyController.historique.length,
              itemBuilder: (context, index) => ChangementCard(
                  formatter: formatter,
                  change: historyController.historique[index]))
          : Center(
              child: Text(
                "Aucun changements d'emplois du temps n'a été enregistré.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
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
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            (change.oldDate == null)
                ? "ajouté aux : ${change.newDate!.affichageDateHeure(formatter)}"
                : (change.newDate == null)
                    ? "supprimé du : ${change.oldDate!.affichageDateHeure(formatter)}"
                    : "déplacé du : ${change.oldDate!.affichageDateHeure(formatter)}\naux : ${change.newDate!.affichageDateHeure(formatter)}",
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    ));
  }
}
