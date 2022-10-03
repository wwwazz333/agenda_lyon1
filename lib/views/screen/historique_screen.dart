import 'dart:developer';

import 'package:agenda_lyon1/data/db_manager.dart';
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
  late Future<List<Map<String, dynamic>>> loadingDBHistory;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  @override
  void initState() {
    loadingDBHistory = DBManager.readDB("History");

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
    super.initState();
  }

  String affichageDateHeure(DateTime date, DateFormat formatter) {
    final hourFormat = DateFormat.Hm();
    return "${formatter.format(date)}, ${hourFormat.format(date)}";
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
                DBManager.removeWhere("History", "1 = ?", [1]).then(
                  (value) {
                    loadingDBHistory = DBManager.readDB("History");
                    _controller.reset();
                    _controller.forward();
                  },
                );
              },
              icon: const Icon(Icons.cleaning_services))
        ],
      ),
      body: Stack(children: [
        FutureBuilder(
          future: loadingDBHistory,
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
                    itemBuilder: (context, index) {
                      final oldDate = data[index]["oldDate"];
                      final newDate = data[index]["newDate"];
                      return Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data[index]["name"],
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Text(
                            (oldDate == null)
                                ? "ajouté aux : ${affichageDateHeure(DateTime.fromMillisecondsSinceEpoch(newDate), formatter)}"
                                : (newDate == null)
                                    ? "supprimé du : ${affichageDateHeure(DateTime.fromMillisecondsSinceEpoch(oldDate), formatter)}"
                                    : "déplacé du : ${affichageDateHeure(DateTime.fromMillisecondsSinceEpoch(oldDate), formatter)}\naux : ${affichageDateHeure(DateTime.fromMillisecondsSinceEpoch(newDate), formatter)}",
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ));
                    });
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
                    parent: _controller,
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
