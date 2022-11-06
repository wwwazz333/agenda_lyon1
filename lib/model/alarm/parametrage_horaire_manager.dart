import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/alarm/parametrage_horiare.dart';

class ParametrageHoraireManager {
  static add(ParametrageHoraire parametrageHoraire) {
    Stockage().settingsAlarmBox.add(parametrageHoraire);
  }

  static remove(int at) {
    Stockage().settingsAlarmBox.deleteAt(at);
  }
}
