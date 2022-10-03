import 'event_calendrier.dart';
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
    return add(Duration(minutes: _getTimeZone(this)));
  }

  DateTime midi() {
    return add(Duration(hours: 12 - hour));
  }
}

int _getTimeZone(DateTime forr) {
  final locationFrance = tz.getLocation('Europe/Paris');
  return tz.TZDateTime.from(forr, locationFrance).timeZoneOffset.inMinutes;
}
