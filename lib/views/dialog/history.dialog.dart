import 'package:agenda_lyon1/data/db_manager.dart';
import 'package:agenda_lyon1/model/calendrier.dart';
import 'package:agenda_lyon1/views/screen/historique_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showHistoryDialog(
    BuildContext context, List<int> Ids, String languageCode) async {
  if (Ids.length >= 100) {
    return;
  }
  final formatter = DateFormat.yMMMMEEEEd(languageCode);
  String where = "";
  for (int id in Ids) {
    where += " id = ? or ";
  }
  if (where.length > 3) {
    where = where.substring(0, where.length - 3);
  }
  List<Changement> changes =
      (await DBManager.getWhere("History", ["*"], where, Ids))
          .map((row) => Changement(
              row["name"],
              getChangementType(row["typeChange"]),
              row["oldDate"] == 0
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(row["oldDate"]),
              row["newDate"] == 0
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(row["newDate"])))
          .toList();

  await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Changes"),
            content: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Ids.length,
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
