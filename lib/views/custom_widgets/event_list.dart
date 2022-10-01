import 'package:flutter/material.dart';
import 'card.dart/card_tile.dart';
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
          String subTitle = "";
          for (String sub in infos["subTitle"]) {
            subTitle += "$sub\n";
          }
          return CardEventTile(
            title: infos["title"],
            subTitle: subTitle.trim(),
            debut: infos["debut"],
            fin: infos["fin"],
            controller: infos["controller"],
            bgColor: infos["color"],
            nbrTask: infos["nbrTask"],
          );
        });
  }
}
