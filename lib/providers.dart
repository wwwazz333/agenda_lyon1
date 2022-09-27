import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/global_data.dart';

final selectedDate = StateProvider<DateTime>((ref) => DateTime.now());

final languageApp = StateProvider<Locale>((ref) => languages.values.first);

final themeApp = StateProvider<ThemeData>((ref) => themes.values.first);

final urlCalendar = StateProvider<String>((ref) => "");
