import 'dart:developer';

import 'package:agenda_lyon1/controller/data_controller.dart';
import 'package:agenda_lyon1/controller/background_work.dart';
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/settings/settings.dart';
import 'package:agenda_lyon1/model/settings/settingsapp.dart';
import 'package:agenda_lyon1/views/custom_widgets/event_list.dart';
import 'package:agenda_lyon1/views/custom_widgets/loading_widget.dart';
import 'package:agenda_lyon1/views/dialog/history_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final GlobalKey _keyTabHeader = GlobalKey();

  _CalendarScreen({DateTime? startingDate}) {
    _controller = CalendarUIController(startingDate: startingDate);
  }
  Size _getSizeOf(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;

    return renderBox != null ? renderBox.size : const Size(0, 0);
  }

  late final Future loadingFuture;

  void showDialogHistoryIfNeeded() {
    if (Stockage().changementHasChange) {
      showHistoryDialog(context,
          ref.watch(SettingsProvider.languageAppProvider).languageCode);
    }
  }

  @override
  void initState() {
    loadingFuture = DataController().load();
    loadingFuture.then((value) => Future.delayed(const Duration(seconds: 2))
        .then((value) => DataController().update()));
    DataController().addListenerUpdate(
        "updateCalendarScreenView",
        () => setState(
              () {
                showDialogHistoryIfNeeded();
              },
            ));
    launchPerodicalWork();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(SettingsApp().urlCalendarRoom);
    showDialogHistoryIfNeeded();
    final typeCardToDisplay =
        ref.watch(SettingsProvider.cardTypeDisplayProvider);
    ref.listen(selectedDate, (previous, next) {
      _controller.goToGoodPage(next);
    });
    ref.listen(
      SettingsProvider.urlCalendarProvider,
      (previous, next) {
        setState(() {});
        DataController().update();
      },
    );
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: loadingFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              final availableHeight = MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom;
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabCalendar(
                    startingDate: _controller.startingDate,
                    key: _keyTabHeader,
                  ),
                  Expanded(
                    child: PageView.builder(
                      physics: const CustomPageViewScrollPhysics(),
                      controller: _controller.pageController,
                      itemCount: null,
                      onPageChanged: (newPage) {
                        log("onPageChanged");
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
                                oneHoureH: (availableHeight -
                                        _getSizeOf(_keyTabHeader).height) /
                                    (typeCardToDisplay.lastHourDisplay -
                                        typeCardToDisplay.firstHourDisplay),
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
              return const LoadingWidget();
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
