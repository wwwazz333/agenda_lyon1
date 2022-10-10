import 'package:agenda_lyon1/model/changements/changement.dart';
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
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SettingsAppAdapter());
    Hive.registerAdapter(ChangementAdapter());
    settingsAppBox = await Hive.openBox<SettingsApp>("settingsAppBox");
    changementsBox = await Hive.openBox<Changement>("changementsBox");
  }

  bool get changementHasChange {
    return changementsBox.values
        .where((element) => !element.changeSaw)
        .isNotEmpty;
  }
}
