import 'package:agenda_lyon1/model/date.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

part 'event_calendrier.g.dart';

@HiveType(typeId: 2)
class EventCalendrier extends HiveObject
    implements Comparable<EventCalendrier> {
  @HiveField(0)
  String _nameEvent = "";
  String get summary {
    return _nameEvent;
  }

  @HiveField(1)
  List<String> _salle = [];
  List<String> get salle {
    return _salle;
  }

  @HiveField(2)
  String _description = "";
  String get description {
    return _description;
  }

  @HiveField(3)
  String _uid = "";
  String get uid {
    return _uid;
  }

  @HiveField(4)
  DateTime _date = DateTime.fromMicrosecondsSinceEpoch(0);
  DateTime get date {
    return _date;
  }

  @HiveField(5)
  int _duree = 0;

  ///durée en seconds
  Duration get duree {
    return Duration(seconds: _duree);
  }

  DateTime get dateFin => date.add(duree);

  String get heureDebut {
    return DateFormat.Hm().format(date);
  }

  String get heureFin {
    return DateFormat.Hm().format(date.add(duree));
  }

  EventCalendrier();
  EventCalendrier.data(this._date, Duration duree, this._nameEvent, this._salle,
      this._description, this._uid)
      : _duree = duree.inSeconds;

  void parseLine(String str) {
    final splited = str.split(":");
    splited.removeWhere((element) => element.isEmpty);
    if (splited.length < 2) {
      return;
    }
    final title = splited[0];
    if (title == "DTSTART") {
      //20220318T090000Z
      _date = getDateTime(splited[1]);
    } else if (title == "DTEND") {
      var fin = getDateTime(splited[1]);
      _duree = (Duration(hours: fin.hour, minutes: fin.minute) -
              Duration(hours: date.hour, minutes: date.minute))
          .inSeconds;
    } else if (title == "SUMMARY") {
      _nameEvent = splited[1];
    } else if (title == "LOCATION") {
      _salle = splited[1].split("\\,");
    } else if (title == "DESCRIPTION") {
      _description = str
          .substring(str.indexOf(":") + 1)
          .trim()
          .replaceAll("\\n", "\n")
          .replaceAll(RegExp("^\n*|\n*\$"), "");
    } else if (title == "UID") {
      _uid = splited[1];
    }
  }

  DateTime getDateTime(String str) {
    final year = str.substring(0, 4);
    final month = str.substring(4, 6);
    final day = str.substring(6, 8);
    final hour = str.substring(9, 11);
    final min = str.substring(11, 13);

    DateFormat format = DateFormat("yyyy-MM-dd HH:mm"); //20220318090000
    DateTime time = format.parse("$year-$month-$day $hour:$min");
    return time.toLocaleFrance();
  }

  bool dateOverlap(EventCalendrier ev) {
    const before = Duration(milliseconds: -1);
    const after = Duration(milliseconds: 1);
    return date.isAtSameMomentAs(ev.date) &&
            dateFin.isAtSameMomentAs(ev.dateFin) ||
        (date.isIn(ev.date, ev.dateFin.add(before)) ||
            dateFin.isIn(ev.date.add(after), ev.dateFin) ||
            ev.date.isIn(date, dateFin.add(before)) ||
            ev.dateFin.isIn(date.add(after), dateFin));
  }

  @override
  int compareTo(EventCalendrier other) {
    return date.compareTo(other.date);
  }

  @override
  String toString() => "$summary, $date";
}
