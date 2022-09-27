import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/global_data.dart';

final selectedDate = StateProvider<DateTime>((ref) => DateTime.now());

final languageApp = StateProvider<Locale>((ref) => const Locale("fr", "FR"));

final themeApp = StateProvider<MyTheme>((ref) => MyTheme.light);
