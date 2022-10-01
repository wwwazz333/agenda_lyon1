import 'package:agenda_lyon1/controller/data_controller.dart';
import 'package:agenda_lyon1/views/custom_widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/calendarui_controller.dart';
import 'providers.dart';
import 'views/custom_widgets/event_timeline.dart';
import 'views/custom_widgets/navigator.dart';
import 'views/my_tab_calendar/tab_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreen();
}

class _CalendarScreen extends ConsumerState<CalendarScreen> {
  late final CalendarUIController _controller;

  _CalendarScreen({DateTime? startingDate}) {
    _controller = CalendarUIController(startingDate: startingDate);
  }

  late final Future loadingFuture;

  @override
  void initState() {
    loadingFuture = DataController().load();
    DataController().addListenerUpdate(
        "updateCalendarScreenView",
        () => setState(
              () {},
            ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final typeCardToDisplay = ref.watch(cardTypeDisplay);
    ref.listen(selectedDate, (previous, next) {
      _controller.goToGoodPage(next);
    });
    ref.listen(
      urlCalendar,
      (previous, next) {
        setState(() {});
        DataController().updateCalendrier(next);
      },
    );
    ref.listen(
      themeApp,
      (previous, next) {
        setState(() {});
      },
    );
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: loadingFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabCalendar(startingDate: _controller.startingDate),
                  Expanded(
                    child: PageView.builder(
                      physics: const CustomPageViewScrollPhysics(),
                      controller: _controller.pageController,
                      itemCount: null,
                      onPageChanged: (newPage) {
                        ref.read(selectedDate.notifier).state =
                            _controller.getDateOfIndex(newPage);
                      },
                      itemBuilder: (context, index) {
                        return (typeCardToDisplay.cardTimeLineDisplay
                            ? EventTimeLine(
                                DataController().genDayController(
                                    _controller.getDateOfIndex(index)),
                                firstHour: typeCardToDisplay.firstHourDisplay,
                                lastHour: typeCardToDisplay.lastHourDisplay,
                              )
                            : EventList(
                                DataController().genDayController(
                                    _controller.getDateOfIndex(index)),
                                firstHour: typeCardToDisplay.firstHourDisplay,
                                lastHour: typeCardToDisplay.lastHourDisplay,
                              ));
                      },
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.calendar_today),
                      SizedBox(
                        height: 16,
                      ),
                      CircularProgressIndicator(),
                    ]),
              );
            }
          },
        ),
      ),
      floatingActionButton: const FloatingNavButton(),
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 100,
        stiffness: 100,
        damping: 1,
      );
}
