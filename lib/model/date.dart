import 'event_calendrier.dart';

extension Date on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isDuring(EventCalendrier ev, {required bool borneInclude}) {
    return (borneInclude)
        ? (compareTo(ev.date) >= 0 && compareTo(ev.date.add(ev.duree)) <= 0)
        : (compareTo(ev.date) > 0 && compareTo(ev.date.add(ev.duree)) < 0);
  }
}
