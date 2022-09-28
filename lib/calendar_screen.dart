import 'package:agenda_lyon1/controller/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/calendarui_controller.dart';
import 'providers.dart';
import 'views/custom_widgets/navigator.dart';
import 'views/my_tab_calendar/tab_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreen createState() => _CalendarScreen();
}

class _CalendarScreen extends ConsumerState<CalendarScreen> {
  late final CalendarUIController _controller;

  _CalendarScreen({DateTime? startingDate}) {
    _controller = CalendarUIController(startingDate: startingDate);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedDate, (previous, next) {
      _controller.goToGoodPage(next);
    });

    DataController().addListenerUpdate(
        "updateCalendarScreenView",
        () => setState(
              () {},
            ));

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: DataController().loadCalendrier(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
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
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: const FloatingNavButton(),
    );
  }
}
