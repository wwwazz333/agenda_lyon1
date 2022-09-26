import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/calendarui_controller.dart';
import 'providers.dart';
import 'views/custom_widgets/navigator.dart';
import 'views/my_tab_calendar/tab_calendar.dart';

class CalendarScreen extends ConsumerWidget {
  late final CalendarUIController _controller;

  CalendarScreen({DateTime? startingDate, super.key}) {
    _controller = CalendarUIController(startingDate: startingDate);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(selectedDate, (previous, next) {
      _controller.goToGoodPage(next);
    });

    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabCalendar(startingDate: _controller.startingDate),
          Expanded(
            child: PageView.builder(
              controller: _controller.pageController,
              itemCount: null,
              onPageChanged: (newPage) {
                ref.read(selectedDate.notifier).state =
                    _controller.getDateOfIndex(newPage);
              },
              itemBuilder: (context, index) {
                return _controller.genCardEvent(index);
              },
            ),
          )
        ],
      )),
      floatingActionButton: const FloatingNavButton(),
    );
  }
}
