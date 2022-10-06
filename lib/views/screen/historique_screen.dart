import 'package:agenda_lyon1/controller/history_controller.dart';
import 'package:agenda_lyon1/data/db_manager.dart';
import 'package:agenda_lyon1/model/calendrier.dart';
import 'package:agenda_lyon1/model/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers.dart';
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
    final language = ref.watch(languageApp);
    final formatter = DateFormat.yMMMMEEEEd(language.languageCode);
    const double bigLogo = 200;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
        actions: [
          IconButton(
              onPressed: () {
                historyController.clearHistory();
              },
              icon: const Icon(Icons.cleaning_services))
        ],
      ),
      body: Stack(children: [
        FutureBuilder(
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
                            DateTime.fromMillisecondsSinceEpoch(
                                data[index]["oldDate"]),
                            DateTime.fromMillisecondsSinceEpoch(
                                data[index]["newDate"]))));
              }
            } else {
              return const LoadingWidget();
            }
          },
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Size biggest = constraints.biggest;
            return Stack(
              children: <Widget>[
                PositionedTransition(
                  rect: RelativeRectTween(
                    begin: RelativeRect.fromSize(
                        Rect.fromLTWH(size.width / 2 - bigLogo / 2,
                            size.height - bigLogo / 2, bigLogo, bigLogo),
                        biggest),
                    end: RelativeRect.fromSize(
                        Rect.fromLTWH(size.width / 2 - bigLogo / 2, 0 - bigLogo,
                            bigLogo, bigLogo),
                        biggest),
                  ).animate(CurvedAnimation(
                    parent: historyController.controllerAnimation,
                    curve: Curves.easeInCirc,
                  )),
                  child: const Icon(
                    Icons.cleaning_services,
                    size: bigLogo,
                  ),
                ),
              ],
            );
          },
        )
      ]),
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
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          change.name,
          style: Theme.of(context).textTheme.headline1,
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
    ));
  }
}
