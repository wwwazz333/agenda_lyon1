import 'package:flutter/material.dart';

import '../../controller/event_controller.dart';

abstract class EventDisplay extends StatelessWidget {
  final DayController dayController;
  const EventDisplay(this.dayController,
      {required this.firstHour,
      required this.lastHour,
      this.oneHoureH = 70,
      super.key});
  final double oneHoureH;
  final int firstHour;
  final int lastHour;
}
