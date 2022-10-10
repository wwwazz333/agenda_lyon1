import 'package:agenda_lyon1/model/calendrier.dart';
import 'package:agenda_lyon1/model/changements/changement.dart';
import 'package:agenda_lyon1/model/color_event.dart';
import 'package:agenda_lyon1/model/event_calendrier.dart';
import 'package:agenda_lyon1/model/task.dart';
import 'package:agenda_lyon1/model/tasks_of_event.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/settingsapp.dart';

class Stockage {
  static Stockage? instance;
  Stockage._();
  factory Stockage() {
    instance ??= Stockage._();
    return instance!;
  }

  late Box<SettingsApp> settingsAppBox;
  late Box<Changement> changementsBox;
  late Box<Calendrier> calendrierBox;

  late Box<ColorEvent> colorsEventsLightBox;
  late Box<ColorEvent> colorsEventsDarkBox;

  late Box<TasksOfEvent> tasksBox;
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SettingsAppAdapter());
    Hive.registerAdapter(ChangementAdapter());
    Hive.registerAdapter(CalendrierAdapter());
    Hive.registerAdapter(EventCalendrierAdapter());
    Hive.registerAdapter(ColorEventAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TasksOfEventAdapter());
    settingsAppBox = await Hive.openBox<SettingsApp>("settingsAppBox");
    changementsBox = await Hive.openBox<Changement>("changementsBox");
    calendrierBox = await Hive.openBox<Calendrier>("calendrierBox");

    colorsEventsLightBox =
        await Hive.openBox<ColorEvent>("colorsEventsLightBox");
    colorsEventsDarkBox = await Hive.openBox<ColorEvent>("colorsEventsDarkBox");

    tasksBox = await Hive.openBox<TasksOfEvent>("tasksBox");
  }

  bool get changementHasChange {
    return changementsBox.values
        .where((element) => !element.changeSaw)
        .isNotEmpty;
  }
}
