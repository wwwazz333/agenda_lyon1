import 'dart:developer';

import 'package:agenda_lyon1/controller/data_controller.dart';
import 'package:agenda_lyon1/model/background_work.dart';
import 'package:agenda_lyon1/views/custom_widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import '../../controller/calendarui_controller.dart';
import '../../providers.dart';
import '../custom_widgets/event_timeline.dart';
import '../custom_widgets/navigator.dart';
import '../my_tab_calendar/tab_calendar.dart';

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
    Future.delayed(const Duration(seconds: 2))
        .then((value) => DataController().update());
    DataController().addListenerUpdate(
        "updateCalendarScreenView",
        () => setState(
              () {
                log("Task: update calendar screen");
              },
            ));
    // Work().testWork();
    testWork();
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
        DataController().update();
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
                      Icon(
                        Icons.calendar_today,
                        size: 64,
                      ),
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
