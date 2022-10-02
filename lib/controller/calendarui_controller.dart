import 'package:agenda_lyon1/model/date.dart';
import 'package:flutter/material.dart';

import '../common/global_data.dart';
import '../views/custom_widgets/event_timeline.dart';
import 'data_controller.dart';

class CalendarUIController {
  final DateTime _startingDate;
  late PageController _pageController;

  CalendarUIController({DateTime? startingDate})
      : _startingDate = startingDate ?? DateTime.now() {
    _pageController =
        PageController(initialPage: getIndexOfDate(_startingDate.midi()));
  }

  DateTime get startingDate {
    return _startingDate;
  }

  PageController get pageController {
    return _pageController;
  }

  DateTime getDateOfIndex(int index) {
    return firstDate.add(Duration(days: index));
  }

  int getIndexOfDate(DateTime date) {
    return date.difference(firstDate).inDays;
  }

  void goToGoodPage(DateTime newDate) {
    if (pageController.page! == pageController.page!.toInt().toDouble()) {
      //si scroll pas la page mais que date change
      pageController.jumpToPage(getIndexOfDate(newDate.midi()));
    }
  }

  Widget genCardEvent(int index) {
    return EventTimeLine(
      DataController().genDayController(getDateOfIndex(index)),
      firstHour: 8,
      lastHour: 18,
    );
  }
}
