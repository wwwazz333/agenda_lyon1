import 'package:flutter/material.dart';

import 'card_event.dart';
import 'event_display.dart';

class EventList extends EventDisplay {
  const EventList(super.dayController,
      {required super.firstHour,
      required super.lastHour,
      super.oneHoureH,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dayController.length,
        itemBuilder: (context, index) {
          final infos = dayController.infoEvent(index);
          return CardEventList(
            title: infos["title"],
            subTitle: infos["subTitle"],
            debut: infos["debut"],
            fin: infos["fin"],
            controller: infos["controller"],
          );
        });
  }
}
