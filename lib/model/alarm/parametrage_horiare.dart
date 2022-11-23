import 'package:agenda_lyon1/common/error/paremetre_error.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';

part 'parametrage_horiare.g.dart';

@HiveType(typeId: 8)
class ParametrageHoraire extends HiveObject {
  static List<int> get defaultEnabledDays => [2, 3, 4, 5, 6];

  ///les bornes sont comprise
  @HiveField(0)
  int _debutMatch;

  Duration get debutMatch => Duration(seconds: _debutMatch);
  set debutMatch(Duration newVal) {
    if (newVal.inSeconds > finMatch.inSeconds) {
      throw ParmettreError("la borne de début est après la borne de fin");
    }
    _debutMatch = newVal.inSeconds;
    save();
  }

  ///les bornes sont comprise
  @HiveField(1)
  int _finMatch;

  Duration get finMatch => Duration(seconds: _finMatch);
  set finMatch(Duration newVal) {
    if (newVal.inSeconds < debutMatch.inSeconds) {
      throw ParmettreError("la borne de fin est avant la borne de début");
    }
    _finMatch = newVal.inSeconds;
    save();
  }

  @HiveField(2)
  int _reglageHoraire;

  Duration get reglageHoraire => Duration(seconds: _reglageHoraire);
  set reglageHoraire(Duration newVal) {
    _reglageHoraire = newVal.inSeconds;
    save();
  }

  ///si true -> sera plaser par rapport à l'horaire indiquer
  ///
  ///si false -> sera plaser à l'horaire indiquer
  @HiveField(3)
  bool relative = true;

  @HiveField(4)
  List<int> enabledDay = ParametrageHoraire.defaultEnabledDays;

  ParametrageHoraire._()
      : _debutMatch = 0,
        _finMatch = 23 * 3600 + 59 * 60,
        _reglageHoraire = 6 * 3600;

  ParametrageHoraire(
      Duration debutMatch, Duration finMatch, Duration reglageHoraire,
      [this.relative = true])
      : _debutMatch = debutMatch.inSeconds,
        _finMatch = finMatch.inSeconds,
        _reglageHoraire = reglageHoraire.inSeconds;

  DateTime? getHoraireSonnerieFor(DateTime date) {
    DateTime debut = DateTime(date.year, date.month, date.day).add(debutMatch);
    DateTime fin = DateTime(date.year, date.month, date.day).add(finMatch);
    if ((date.isAfter(debut) && date.isBefore(fin) ||
            date.isAtSameMomentAs(debut) ||
            date.isAtSameMomentAs(fin)) &&
        isOneOf(Jiffy(date).day, enabledDay)) {
      if (relative) {
        return date.subtract(reglageHoraire);
      } else {
        return DateTime(date.year, date.month, date.day).add(reglageHoraire);
      }
    }
    return null;
  }

  static bool isOneOf(int day, List<int> days) {
    for (int d in days) {
      if (d == day) {
        return true;
      }
    }

    return false;
  }

  @override
  String toString() => "$debutMatch -> $finMatch = $reglageHoraire";
}
