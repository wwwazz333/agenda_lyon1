import '../model/event_calendrier.dart';

final firstDate = DateTime(2000, 1, 1); //must be on 0 time
const calendarDurationDay = 365 * 2;
// const sizeOfCalendarInWeeks = 52 * 2;

final List<EventCalendrier> eventsCalendrierTestList = [
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 8), const Duration(hours: 1),
      "Maths", "S10", "Joubert Aude", "_uid"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 9),
      const Duration(hours: 2, minutes: 30), "PHP", "S14", "autre", "_uid"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 16), const Duration(hours: 2),
      "Angalis", "028", "prof anglais", "_uid"),
  EventCalendrier.data(DateTime.utc(2022, 9, 19, 8), const Duration(hours: 1),
      "Maths", "S10", "Joubert Aude", "_uid"),
  EventCalendrier.data(DateTime.utc(2022, 9, 19, 9),
      const Duration(hours: 2, minutes: 30), "PHP", "S14", "autre", "_uid"),
  EventCalendrier.data(DateTime.utc(2022, 9, 19, 16), const Duration(hours: 2),
      "Angalis", "028", "prof anglais", "_uid"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 8), const Duration(hours: 1),
      "Maths", "S10", "Joubert Aude", "_uid"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 9),
      const Duration(hours: 2, minutes: 30), "PHP", "S14", "autre", "_uid"),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 16), const Duration(hours: 2),
      "Angalis", "028", "prof anglais", "_uid"),
];

final List<EventCalendrier> eventsCalendrierComplexTestList = [
  EventCalendrier.data(
      DateTime.utc(2022, 9, 18, 8), const Duration(hours: 5), "A", "", " ", ""),
  EventCalendrier.data(
      DateTime.utc(2022, 9, 18, 9), const Duration(hours: 7), "B", "", "", ""),
  EventCalendrier.data(
      DateTime.utc(2022, 9, 18, 9), const Duration(hours: 5), "C", "", "", ""),
  EventCalendrier.data(DateTime.utc(2022, 9, 18, 11), const Duration(hours: 3),
      "D", "", " ", ""),
  EventCalendrier.data(
      DateTime.utc(2022, 9, 18, 14), const Duration(hours: 4), "E", "", "", ""),
  EventCalendrier.data(
      DateTime.utc(2022, 9, 18, 20), const Duration(hours: 2), "F", "", "", ""),
];
