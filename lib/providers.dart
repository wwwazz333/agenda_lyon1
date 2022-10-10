import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDate = StateProvider<DateTime>((ref) => DateTime.now());
