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

  // List<String> dayNames(DateFormat dayFormatter) {
  //   if (lastFormatter != null && lastFormatter?.locale != dayFormatter.locale) {
  //     _dayNames = null;
  //   }
  //   _dayNames ??= List.generate(
  //     7,
  //     (index) {
  //       return dayFormatter
  //           .format(firstDayOfWeek(date: startingDate, startDayWeek: 0)
  //               .add(Duration(days: index)))
  //           .capitalize()
  //           .substring(0, 3);
  //     },
  //   );
  //   lastFormatter = dayFormatter;
  //   return _dayNames!;
  // }

  // DateTime firstDayOfWeek({required DateTime date, required int startDayWeek}) {
  //   final utcDate = DateTime.utc(date.year, date.month, date.day, 12);
  //   if (startDayWeek < 7) {
  //     return utcDate.subtract(Duration(days: utcDate.weekday - startDayWeek));
  //   }
  //   return utcDate.subtract(Duration(days: utcDate.weekday % 7));
  // }

  int getIndexPageOfDate(DateTime date) {
    final d = Jiffy(date.midi().add(Duration(days: -1)));
    final f = Jiffy(firstDate);
    final diff = d.diff(f, Units.WEEK).toInt();
    return diff;
  }

  void goToGoodPage(DateTime newDate) {
    if (_pageController.page != null &&
        _pageController.page == _pageController.page!.toInt().toDouble() &&
        getIndexPageOfDate(newDate.midi()) != _pageController.page) {
      //si scroll pas la page mais doit changer
      _pageController.jumpToPage(getIndexPageOfDate(newDate.midi()));
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
