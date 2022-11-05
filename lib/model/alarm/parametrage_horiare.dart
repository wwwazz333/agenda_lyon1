import 'package:hive_flutter/hive_flutter.dart';

part 'parametrage_horiare.g.dart';

@HiveType(typeId: 8)
class ParametrageHoraire extends HiveObject {
  ///les bornes sont comprise

  @HiveField(0)
  int _debutMatch;

  Duration get debutMatch => Duration(seconds: _debutMatch);
  set debutMatch(Duration newVal) {
    _debutMatch = newVal.inSeconds;
  }

  ///les bornes sont comprise
  @HiveField(1)
  int _finMatch;

  Duration get finMatch => Duration(seconds: _finMatch);
  set finMatch(Duration newVal) {
    _finMatch = newVal.inSeconds;
  }

  @HiveField(2)
  int _reglageHoraire;

  Duration get reglageHoraire => Duration(seconds: _reglageHoraire);
  set reglageHoraire(Duration newVal) {
    _reglageHoraire = newVal.inSeconds;
  }

  ///si true -> sera plaser par rapport à l'horaire indiquer
  ///
  ///si false -> sera plaser à l'horaire indiquer
  @HiveField(3)
  bool relative = true;

  ParametrageHoraire._()
      : _debutMatch = 0,
        _finMatch = 24 * 3600,
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
    if (date.isAfter(debut) && date.isBefore(fin) ||
        date.isAtSameMomentAs(debut) ||
        date.isAtSameMomentAs(fin)) {
      if (relative) {
        return date.subtract(reglageHoraire);
      } else {
        return DateTime(date.year, date.month, date.day).add(reglageHoraire);
      }
    }
    return null;
  }
}
