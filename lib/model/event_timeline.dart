import 'package:agenda_lyon1/model/date.dart';

import 'event_calendrier.dart';

class EventTimeLineModel {
  final List<EventCalendrier> _eventList;
  List<List<EventCalendrier>>? _groupedEvent;
  EventTimeLineModel(this._eventList);

  List<List<EventCalendrier>> get groupedEvent {
    return _groupedEvent ??= _initGroupedEvent();
  }

  List<List<EventCalendrier>> _initGroupedEvent() {
    List<List<EventCalendrier>> newGroupedEvent = [[]];
    for (int i = 0; i < _eventList.length; i++) {
      while (i + 1 < _eventList.length &&
          _eventList[i + 1].date.isDuring(_eventList[i], borneInclude: false)) {
        newGroupedEvent.last.add(_eventList[i]);
        i++;
      }
      newGroupedEvent.last.add(_eventList[i]);
      newGroupedEvent.add([]);
    }
    return newGroupedEvent;
  }
}
