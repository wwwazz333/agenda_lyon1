import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

part 'color_event.g.dart';

@HiveType(typeId: 4)
class ColorEvent extends HiveObject {
  @HiveField(0)
  int _colorInt = 0;

  ColorEvent();
  ColorEvent.fromColor(Color color) : _colorInt = color.value;

  Color get color => Color(_colorInt);

  set color(Color color) => _colorInt = color.value;
}
