import 'package:hive_flutter/hive_flutter.dart';

import '../model/settingsapp.dart';

class Stockage {
  static Stockage? instance;
  Stockage._();
  factory Stockage() {
    instance ??= Stockage._();
    return instance!;
  }

  late Box settingsAppBox;
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SettingsAppAdapter());
    settingsAppBox = await Hive.openBox<SettingsApp>("settingsAppBox");
  }
}
