import 'package:agenda_lyon1/model/date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../common/global_data.dart';

class TabCalendarUIController {
  final DateTime startingDate;
  final int startDayWeek;
  late final PageController _pageController;
  DateFormat? lastFormatter;

  TabCalendarUIController({
    required this.startingDate,
    required this.startDayWeek,
  }) {
    _pageController =
        PageController(initialPage: getIndexPageOfDate(startingDate));
  }

  PageController get pageController {
    return _pageController;
  }

  int getIndexPageOfDate(DateTime date) {
    final d = Jiffy(date.midi()).endOf(Units.DAY).add(days: -startDayWeek);
    final f = Jiffy(firstDate);
    return d.diff(f, Units.WEEK).toInt();
  }

  void goToGoodPage(DateTime newDate) {
    final newIndex = getIndexPageOfDate(newDate);
    if (_pageController.page != null &&
        _pageController.page == _pageController.page!.floorToDouble() &&
        newIndex != _pageController.page) {
      //si scroll pas la page mais doit changer
      _pageController.jumpToPage(newIndex);
    }
  }

  int getDirectionOfScroll(int value) {
    if (_pageController.page != null &&
        _pageController.page! != value.toDouble()) {
      var direction = 1;
      if (_pageController.page! > value.toDouble()) {
        //prev page
        direction = -1;
      }
      return direction;
    }
    return 0;
  }

  List<DateTime> genDateOfPage(int indexPage) {
    return List.generate(7, (i) {
      final fir = Jiffy(firstDate);
      fir.add(weeks: indexPage, days: i + startDayWeek);
      return fir.dateTime;
    });
  }
}

extension CapString on String {
  String capitalize() {
    if (length >= 2) {
      return substring(0, 1).toUpperCase() + toLowerCase().substring(1);
    } else {
      return toUpperCase();
    }
  }
}
