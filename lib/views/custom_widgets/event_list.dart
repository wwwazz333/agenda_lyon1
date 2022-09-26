import 'package:flutter/material.dart';

import '../../controller/event_controller.dart';
import 'card_event.dart';

class EventList extends StatelessWidget {
  final DayController _dayController;
  const EventList(this._dayController, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _dayController.length,
        itemBuilder: (context, index) {
          final infos = _dayController.infoEvent(index);
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
