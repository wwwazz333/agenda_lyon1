import 'event_calendrier.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

extension Date on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isDuring(EventCalendrier ev, {required bool borneInclude}) {
    return (borneInclude)
        ? (compareTo(ev.date) >= 0 && compareTo(ev.date.add(ev.duree)) <= 0)
        : (compareTo(ev.date) > 0 && compareTo(ev.date.add(ev.duree)) < 0);
  }

  DateTime toLocaleFrance() {
    return toUtc().add(Duration(minutes: _getTimeZone(this)));
  }
}

int _getTimeZone(DateTime forr) {
  tz.initializeTimeZones();
  final locationFrance = tz.getLocation('Europe/Paris');
  return tz.TZDateTime.from(forr, locationFrance).timeZoneOffset.inMinutes;
}
