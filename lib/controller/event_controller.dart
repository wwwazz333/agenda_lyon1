import 'package:agenda_lyon1/common/colors.dart';
import 'package:agenda_lyon1/common/tasks.dart';
import 'package:agenda_lyon1/data/db_manager.dart';
import 'package:agenda_lyon1/model/date.dart';
import 'package:flutter/cupertino.dart';

import '../common/global_data.dart';
import '../model/event_calendrier.dart';
import '../model/event_timeline.dart';
import '../views/dialog/event_dialog.dart';

class EventController {
  final EventCalendrier _ev;
  EventController(this._ev);

  double getPositionY({required int startHour, required double oneHourH}) {
    return oneHourH * (_ev.date.hour - startHour) +
        oneHourH / 60 * _ev.date.minute;
  }

  double getHeight({required double oneHourH}) {
    return (oneHourH / 60 * _ev.duree.inMinutes).abs();
  }

  void onTap(BuildContext context) {
    showEventDialog(context, _ev);
  }
}

class DayController {
  final List<EventCalendrier> _eventOfDay;
  final EventTimeLineModel _eventTimeLineModel;
  DayController(this._eventOfDay)
      : _eventTimeLineModel = EventTimeLineModel(_eventOfDay);

  int get length {
    return _eventOfDay.length;
  }

  Map<String, dynamic> getOverlapAndPosX(int index) {
    if (index > _eventOfDay.length) {
      return {};
    }
    int indexGroupe = 0;
    int indexInGroup = 0;
    int count = 0;
    for (var grp in _eventTimeLineModel.groupedEvent) {
      indexInGroup = 0;
      for (var _ in grp) {
        if (count == index) {
          return {
            "Overlap": _eventTimeLineModel.groupedEvent[indexGroupe].length,
            "PosX": indexInGroup,
          };
        }
        indexInGroup++;
        count++;
      }
      indexGroupe++;
    }

    return {};
  }

  Map<String, dynamic> infoEvent(int index) {
    final ev = _eventOfDay[index];
    Color? bgColor;
    if (appIsDarkMode) {
      bgColor = fixedColorsDark[ev.summary];
      if (bgColor == null) {
        bgColor = colorsDark[countColor++ % colorsDark.length];
        DBManager.insertInto("ColorsDark", {
          "nameEvent": ev.summary,
          "r": bgColor.red,
          "g": bgColor.green,
          "b": bgColor.blue,
        });
      }
    } else {
      bgColor = fixedColorsLight[ev.summary];
      if (bgColor == null) {
        bgColor = colorsLight[countColor++ % colorsLight.length];
        DBManager.insertInto("ColorsLight", {
          "nameEvent": ev.summary,
          "r": bgColor.red,
          "g": bgColor.green,
          "b": bgColor.blue,
        });
      }
    }
    return {
      "title": ev.summary,
      "subTitle": ev.salle,
      "debut": ev.heureDebut,
      "fin": ev.heureFin,
      "color": bgColor,
      "controller": EventController(ev),
      "nbrTask": tasks[ev.uid] != null ? tasks[ev.uid]!.length : 0,
    };
  }

  bool isCurrDate() {
    if (_eventOfDay.isNotEmpty) {
      return _eventOfDay[0].date.isSameDay(DateTime.now());
    }
    return false;
  }
}
