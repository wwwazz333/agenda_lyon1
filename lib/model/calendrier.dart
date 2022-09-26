import 'package:flutter_logs/flutter_logs.dart';
import '../common/error/file_error.dart';
import '../data/file_manager.dart';
import 'date.dart';
import 'event_calendrier.dart';

enum _StateLecture { close, open, event }

class Calendrier {
  List<EventCalendrier> _events = [];

  set events(List<EventCalendrier> newEvents) {
    _events = newEvents;
    _events.sort();
  }

  int get size {
    return _events.length;
  }

  List<DateTime> get listDays {
    List<DateTime> days = [];
    for (var ev in _events) {
      if (!days.contains(ev.date)) {
        days.add(ev.date);
      }
    }
    days.sort();
    return days;
  }

  Calendrier(this._events);
  Calendrier.load(String txtIcs) {
    loadFromString(txtIcs);
  }

  void loadFromString(String txtIcs) {
    final List<EventCalendrier> tempEvents = [];
    final lines = txtIcs.split(RegExp("\n(?=[A-Z])"));
    var stateCal = _StateLecture.close;
    for (var line in lines) {
      line = line.trim();

      if (line == "BEGIN:VCALENDAR") {
        stateCal = _StateLecture.open;
      } else if (stateCal == _StateLecture.open) {
        if (line == "END:VCALENDAR") {
          stateCal = _StateLecture.close;
          break;
        } else if (line == "BEGIN:VEVENT") {
          if (tempEvents.isNotEmpty &&
              tempEvents.last.date == DateTime.fromMicrosecondsSinceEpoch(0)) {
            FlutterLogs.logError("Event", "Calendrier", "date is wrong");
          }
          tempEvents.add(EventCalendrier());
          stateCal = _StateLecture.event;
        }
      } else if (stateCal == _StateLecture.event) {
        if (line == "END:VEVENT") {
          stateCal = _StateLecture.open;
        } else {
          tempEvents.last.parseLine(line);
        }
      }
    }
    events = tempEvents;
    if (_events.isEmpty) FlutterLogs.logWarn("Event", "_events", "is empty");
  }

  List<EventCalendrier> getEventsOfDay(DateTime date) {
    final List<EventCalendrier> eventsOfDay = [];
    for (var ev in _events) {
      if (ev.date.isSameDay(date)) {
        eventsOfDay.add(ev);
      }
    }
    return eventsOfDay;
  }

  List<EventCalendrier> getEventsDuring(DateTime date) {
    final List<EventCalendrier> eventsDuring = [];
    for (var ev in _events) {
      if (date.isDuring(ev, borneInclude: true)) {
        eventsDuring.add(ev);
      }
    }
    return eventsDuring;
  }

  static bool mayBeValideFormat(String str) {
    const begin = "BEGIN:VCALENDAR";
    return str.length >= begin.length && str.startsWith(begin);
  }

  static writeCalendrierFile(String content, String fileName) {
    if (mayBeValideFormat(content)) {
      FileManager.writeString(fileName, content);
    } else {
      throw InvalideFormatException("Le format du calendrier n'est pas valide");
    }
  }
}
