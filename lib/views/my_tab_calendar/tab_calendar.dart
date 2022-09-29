import 'package:agenda_lyon1/model/date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/global_data.dart';
import '../../controller/tabcalendarui_controller.dart';
import '../../providers.dart';

class Header extends ConsumerWidget {
  final DateTime startingDate;
  const Header({required this.startingDate, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageApp);
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
                  ref.read(selectedDate.notifier).state =
                      d.add(const Duration(hours: 1));
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
  const WeekView(
      {required this.dayNumbers,
      this.dayNames = const ["D", "L", "M", "M", "J", "V", "S"],
      this.startDay = 1,
      super.key});

  final List<String> dayNames;
  final List<DateTime> dayNumbers;

  final int startDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateValue = ref.watch(selectedDate);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
          7,
          (index) => Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(3),
                child: InkWell(
                  splashColor: Colors.grey,
                  highlightColor: Colors.grey.withAlpha(50),
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  onTap: () {
                    ref.read(selectedDate.notifier).state = dayNumbers[index];
                  },
                  child: Column(
                    children: [
                      Text(
                        dayNames[(index + startDay) % 7],
                        style: (dateValue.isSameDay(dayNumbers[index]))
                            ? TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold)
                            : (DateTime.now().isSameDay(dayNumbers[index]))
                                ? const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold)
                                : const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        dayNumbers[index].day.toString(),
                        style: (dateValue.isSameDay(dayNumbers[index]))
                            ? TextStyle(color: Theme.of(context).primaryColor)
                            : (DateTime.now().isSameDay(dayNumbers[index]))
                                ? const TextStyle(color: Colors.orange)
                                : null,
                      )
                    ],
                  ),
                ),
              ))),
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
    final language = ref.watch(languageApp);
    final dayFormatter = DateFormat.EEEE(language.languageCode);

    ref.listen(selectedDate, (previous, next) {
      _controller.goToGoodPage(next);
    });

    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Header(startingDate: _controller.startingDate),
          Expanded(
              child: PageView.builder(
                  controller: _controller.pageController,
                  itemCount: null,
                  onPageChanged: (value) {
                    ref.read(selectedDate.notifier).state = ref
                        .read(selectedDate)
                        .add(Duration(
                            days:
                                (7 * _controller.getDirectionOfScroll(value))));
                  },
                  itemBuilder: ((context, index) {
                    return WeekView(
                        dayNames: _controller.dayNames(dayFormatter),
                        dayNumbers: _controller.genDateOfPage(index));
                  })))
        ],
      ),
    );
  }
}
