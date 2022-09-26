import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../common/global_data.dart';

class TabCalendarUIController {
  final DateTime startingDate;
  final int startDayWeek;
  late final PageController _pageController;
  late final DateTime firstDay; //init in controller

  List<String>? _dayNames;

  TabCalendarUIController({
    required this.startingDate,
    required this.startDayWeek,
  }) {
    firstDay = firstDayOfWeek(date: startingDate, startDayWeek: startDayWeek);
    _pageController =
        PageController(initialPage: getIndexPageOfDate(startingDate));
  }

  PageController get pageController {
    return _pageController;
  }

  List<String> dayNames(DateFormat dayFormatter) {
    dayFormatter.locale;
    _dayNames ??= List.generate(
      7,
      (index) {
        return dayFormatter
            .format(firstDayOfWeek(date: startingDate, startDayWeek: 0)
                .add(Duration(days: index)))
            .capitalize()
            .substring(0, 3);
      },
    );
    return _dayNames!;
  }

  DateTime firstDayOfWeek({required DateTime date, required int startDayWeek}) {
    final utcDate = DateTime.utc(date.year, date.month, date.day, 12);
    if (startDayWeek < 7) {
      return utcDate.subtract(Duration(days: utcDate.weekday - startDayWeek));
    }
    return utcDate.subtract(Duration(days: utcDate.weekday % 7));
  }

  int getIndexPageOfDate(DateTime date) {
    return Jiffy(date.add(Duration(days: -startDayWeek - 1)))
        .diff(Jiffy(firstDate), Units.WEEK)
        .toInt();
  }

  void goToGoodPage(DateTime newDate) {
    if (_pageController.page != null &&
        _pageController.page == _pageController.page!.toInt().toDouble() &&
        getIndexPageOfDate(newDate) != _pageController.page) {
      //si scroll pas la page mais doit changer
      _pageController.jumpToPage(getIndexPageOfDate(newDate));
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
      final fir = Jiffy(firstDate).add(hours: 12);
      fir.add(weeks: indexPage, days: i + 2);
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
