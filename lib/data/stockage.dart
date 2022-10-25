import 'package:agenda_lyon1/model/alarm/alarm.dart';
import 'package:agenda_lyon1/model/calendrier/calendrier.dart';
import 'package:agenda_lyon1/model/changements/changement.dart';
import 'package:agenda_lyon1/model/color/color_event.dart';
import 'package:agenda_lyon1/model/event/event_calendrier.dart';
import 'package:agenda_lyon1/model/task/task.dart';
import 'package:agenda_lyon1/model/task/tasks_of_event.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/settings/settingsapp.dart';

class Stockage {
  static Stockage? instance;
  Stockage._();
  factory Stockage() {
    instance ??= Stockage._();
    return instance!;
  }

  bool isInit = false;

  late Box<SettingsApp> settingsAppBox;
  late Box<Changement> changementsBox;
  late Box<Calendrier> calendrierBox;

  late Box<ColorEvent> colorsEventsLightBox;
  late Box<ColorEvent> colorsEventsDarkBox;

  late Box<TasksOfEvent> tasksBox;

  late Box<Alarm> alarmsBox;
  Future<void> init() async {
    if (isInit) return;
    await Hive.initFlutter();
    Hive.registerAdapter(SettingsAppAdapter());
    Hive.registerAdapter(ChangementAdapter());
    Hive.registerAdapter(CalendrierAdapter());
    Hive.registerAdapter(EventCalendrierAdapter());
    Hive.registerAdapter(ColorEventAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TasksOfEventAdapter());
    Hive.registerAdapter(AlarmAdapter());
    settingsAppBox = await Hive.openBox<SettingsApp>("settingsAppBox");
    changementsBox = await Hive.openBox<Changement>("changementsBox");
    calendrierBox = await Hive.openBox<Calendrier>("calendrierBox");

    colorsEventsLightBox =
        await Hive.openBox<ColorEvent>("colorsEventsLightBox");
    colorsEventsDarkBox = await Hive.openBox<ColorEvent>("colorsEventsDarkBox");

    tasksBox = await Hive.openBox<TasksOfEvent>("tasksBox");
    alarmsBox = await Hive.openBox<Alarm>("alarmsBox");

    isInit = true;
  }

  bool get changementHasChange {
    return changementsBox.values
        .where((element) => !element.changeSaw)
        .isNotEmpty;
  }
}
