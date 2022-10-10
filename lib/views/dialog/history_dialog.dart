import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/views/screen/historique_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/changements/changement.dart';

Future<void> showHistoryDialog(
    BuildContext context, String languageCode) async {
  final formatter = DateFormat.yMMMMEEEEd(languageCode);
  List<Changement> changes = Stockage()
      .changementsBox
      .values
      .where((element) => !element.changeSaw)
      .toList();

  for (var element in changes) {
    element.changeSaw = true;
    element.save();
  }

  await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Changes"),
            content: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: changes.length,
                itemBuilder: (context, index) => ChangementCard(
                    change: changes[index], formatter: formatter),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          )));
}
