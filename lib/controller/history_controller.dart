import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/changements/changement.dart';

class HistoryController {
  late List<Changement> historique;

  HistoryController() {
    historique = Stockage().changementsBox.values.toList();
    historique.sort(((a, b) => a.dateChange.compareTo(b.dateChange)));
  }
}
