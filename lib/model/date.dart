import 'package:intl/intl.dart';

import 'event/event_calendrier.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

extension Date on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isDuring(EventCalendrier ev, {required bool borneInclude}) {
    return (borneInclude)
        ? (compareTo(ev.date) >= 0 && compareTo(ev.date.add(ev.duree)) <= 0)
        : (compareTo(ev.date) > 0 && compareTo(ev.date.add(ev.duree)) < 0);
  }

  bool isIn(DateTime start, DateTime end, [bool bornesInclude = true]) {
    return bornesInclude
        ? (compareTo(start) >= 0 && compareTo(end) <= 0)
        : (compareTo(start) > 0 && compareTo(end) < 0);
  }

  DateTime toLocaleFrance() {
    return add(Duration(minutes: _getTimeZone(this)));
  }

  DateTime midi() {
    return add(Duration(hours: 12 - hour, minutes: -minute, seconds: -second));
  }

  String affichageDateHeure(DateFormat formatter) {
    final hourFormat = DateFormat.Hm();
    return "${formatter.format(this)}, ${hourFormat.format(this)}";
  }

  String affichageHeure() {
    final hourFormat = DateFormat.Hm();
    return hourFormat.format(this);
  }
}

bool timeZoneInitilized = false;
int _getTimeZone(DateTime forr) {
  if (!timeZoneInitilized) {
    tz.initializeTimeZones();
    timeZoneInitilized = true;
  }
  final locationFrance = tz.getLocation('Europe/Paris');
  return tz.TZDateTime.from(forr, locationFrance).timeZoneOffset.inMinutes;
}

extension DurationDisplay on Duration {
  String displayHasTime() {
    return DateTime(2000, 1, 1, inHours, inMinutes % 60).affichageHeure();
  }
}
