import 'package:agenda_lyon1/model/date.dart';
import 'package:intl/intl.dart';


class EventCalendrier implements Comparable<EventCalendrier> {
  String _nameEvent = "";
  String get summary {
    return _nameEvent;
  }

  String _salle = "";
  String get salle {
    return _salle;
  }

  String _description = "";
  String get description {
    return _description;
  }

  String _uid = "";
  String get uid {
    return _uid;
  }

  DateTime _date = DateTime.fromMicrosecondsSinceEpoch(0);
  DateTime get date {
    return _date;
  }

  Duration _duree = const Duration(hours: 0, minutes: 0);
  Duration get duree {
    return _duree;
  }

  String get heureDebut {
    return DateFormat.Hm().format(date);
  }

  String get heureFin {
    return DateFormat.Hm().format(date.add(duree));
  }

  EventCalendrier();
  EventCalendrier.data(this._date, this._duree, this._nameEvent, this._salle,
      this._description, this._uid);

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
      _duree = Duration(hours: date.hour, minutes: date.minute) -
          Duration(hours: fin.hour, minutes: fin.minute);
    } else if (title == "SUMMARY") {
      _nameEvent = splited[1];
    } else if (title == "LOCATION") {
      _salle = splited[1].replaceAll("\\,", "n");
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

  @override
  int compareTo(EventCalendrier other) {
    return date.compareTo(other.date);
  }

  EventCalendrier.fromJson(Map<String, dynamic> json) {
    _date = DateTime.fromMillisecondsSinceEpoch(json["debut"]);
    _duree = Duration(seconds: json["duree"]);
    _nameEvent = json["name"];
    _salle = json["salle"];
    _description = json["description"];
    _uid = json["uid"];
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": summary,
        "description": description,
        "debut": date.millisecondsSinceEpoch,
        "duree": duree.inSeconds,
        "salle": salle,
      };
}
