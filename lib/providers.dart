import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDate = StateProvider<DateTime>((ref) => DateTime.now());

final languageApp = StateProvider<Locale>((ref) => const Locale("fr", "FR"));
