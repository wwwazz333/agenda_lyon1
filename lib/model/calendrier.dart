import 'dart:convert';
import 'package:flutter_logs/flutter_logs.dart';
import '../common/error/file_error.dart';
import '../data/file_manager.dart';
import 'date.dart';
import 'event_calendrier.dart';

enum _StateLecture { close, open, event }

class Calendrier {
  List<EventCalendrier> _events = [];

  List<EventCalendrier> get events => _events;

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
  Calendrier.fromJson(Map<String, dynamic> json) {
    _events = [];
    for (var jsonObj in jsonDecode(json["events"])) {
      _events.add(EventCalendrier.fromJson(jsonObj));
    }
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
      // await Future.delayed(
      //     const Duration(microseconds: 1)); //pour évité les freeze
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

  ///return all the [Changement] between [this] and [newCalendrier]
  List<Changement> getChangementTo(Calendrier newCalendrier) {
    List<Changement> changements = [];
    changements.addAll(events
        .where((oldEvent) => newCalendrier.events
            .where((newEvent) => oldEvent.uid == newEvent.uid)
            .isEmpty)
        .map(
            (e) => Changement(e.summary, ChangementType.delete, e.date, null)));

    changements.addAll(newCalendrier.events
        .where((newEvent) =>
            events.where((oldEvent) => oldEvent.uid == newEvent.uid).isEmpty)
        .map((e) => Changement(e.summary, ChangementType.add, null, e.date)));

    for (EventCalendrier oldEvent in events) {
      changements.addAll(newCalendrier.events
          .where((newEvent) =>
              oldEvent.uid == newEvent.uid &&
              !oldEvent.date.isAtSameMomentAs(newEvent.date))
          .map((e) => Changement(
              e.summary, ChangementType.move, oldEvent.date, e.date)));
    }
    final List<Changement> ajout = changements
        .where((element) => element.changementType == ChangementType.add)
        .toList();
    final List<Changement> suppr = changements
        .where(
            (changement) => changement.changementType == ChangementType.delete)
        .toList();
    List<Changement> toRemove = [];
    for (Changement change in suppr) {
      final same = ajout.where((element) => element.name == change.name);
      if (same.isNotEmpty) {
        final adding = same.first;
        changements.add(Changement(
            adding.name, ChangementType.move, change.oldDate, adding.newDate));
        toRemove.add(adding);
        toRemove.add(change);
      }
    }
    for (var element in toRemove) {
      changements.remove(element);
    }

    return changements;
  }

  static writeCalendrierFile(String content, String fileName) {
    if (mayBeValideFormat(content)) {
      FileManager.writeString(fileName, content);
    } else {
      throw InvalideFormatException("Le format du calendrier n'est pas valide");
    }
  }

  Map<String, dynamic> toJson() => {
        "events": jsonEncode(_events),
      };
}

enum ChangementType {
  add,
  delete,
  move;
}

class Changement {
  String name;
  DateTime? oldDate, newDate;
  ChangementType changementType;

  Changement(this.name, this.changementType, this.oldDate, this.newDate);

  @override
  String toString() {
    return "$name, $changementType, $oldDate, $newDate";
  }
}
