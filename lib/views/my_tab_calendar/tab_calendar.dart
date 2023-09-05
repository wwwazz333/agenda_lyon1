import 'dart:developer';

import 'package:agenda_lyon1/model/date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/global_data.dart';
import '../../controller/tabcalendarui_controller.dart';
import '../../providers.dart';
import '../../model/settings/settings.dart';

class Header extends ConsumerWidget {
  final DateTime startingDate;
  const Header({required this.startingDate, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(SettingsProvider.languageAppProvider);
    final monthFormatter = DateFormat.yMMM(language.languageCode);

    final dateValue = ref.watch(selectedDate);

    return Row(
      children: [
        Expanded(
            child: InkWell(
                onTap: () async {
                  final d = (await showDatePicker(
                        locale: language,
                        context: context,
                        initialDate: dateValue,
                        firstDate: firstDate,
                        lastDate:
                            dateValue.add(const Duration(days: 365 * 100)),
                      )) ??
                      dateValue;
                  ref.read(selectedDate.notifier).state = d.midi();
                },
                child: Row(
                  children: [
                    Text(
                      monthFormatter.format(dateValue).capitalize(),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Icon(Icons.edit),
                  ],
                ))),
        Padding(
          padding: const EdgeInsets.all(5),
          child: InkWell(
            onTap: () {
              ref.read(selectedDate.notifier).state = DateTime.now();
            },
            child: const Icon(
              Icons.today,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
}

class WeekView extends ConsumerWidget {
  const WeekView({required this.dayNumbers, this.startDay = 1, super.key});

  final List<DateTime> dayNumbers;

  final int startDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateValue = ref.watch(selectedDate);
    final language = ref.watch(SettingsProvider.languageAppProvider);
    final dayFormatter = DateFormat.E(language.languageCode);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final dayDate = dayNumbers[(index) % 7].midi();
        return Expanded(
            child: Padding(
          padding: const EdgeInsets.all(3),
          child: InkWell(
            splashColor: Colors.grey,
            highlightColor: Colors.grey.withAlpha(50),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            onTap: () {
              ref.read(selectedDate.notifier).state = dayDate.midi();
              var a = ref.read(selectedDate);
              log(a.toString());
            },
            child: Column(
              children: [
                Text(
                  dayFormatter.format(dayDate).capitalize().replaceAll(".", ""),
                  style: (dateValue.midi().isSameDay(dayDate))
                      ? TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)
                      : (DateTime.now().midi().isSameDay(dayDate))
                          ? const TextStyle(
                              color: Colors.orange, fontWeight: FontWeight.bold)
                          : const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  dayDate.day.toString(),
                  style: (dateValue.isSameDay(dayDate))
                      ? TextStyle(color: Theme.of(context).primaryColor)
                      : (DateTime.now().isSameDay(dayDate))
                          ? const TextStyle(color: Colors.orange)
                          : null,
                )
              ],
            ),
          ),
        ));
      }),
    );
  }
}

class TabCalendar extends ConsumerWidget {
  final TabCalendarUIController _controller;

  TabCalendar({required DateTime startingDate, int startDayWeek = 1, super.key})
      : _controller = TabCalendarUIController(
            startingDate: startingDate, startDayWeek: startDayWeek);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(selectedDate, (previous, next) {
      _controller.goToGoodPage(next);
    });

    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Header(startingDate: _controller.startingDate),
          SizedBox(
            height: 55,
            child: PageView.builder(
                controller: _controller.pageController,
                itemCount: null,
                onPageChanged: (value) {
                  ref.read(selectedDate.notifier).state = ref
                      .read(selectedDate)
                      .add(Duration(
                          days: (7 * _controller.getDirectionOfScroll(value))));
                },
                itemBuilder: ((context, index) {
                  return WeekView(dayNumbers: _controller.genDateOfPage(index));
                })),
          )
        ],
      ),
    );
  }
}
