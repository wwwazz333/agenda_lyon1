import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/color/color_event.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ColorsEventsManager {
  static ColorsEventsManager? instance;
  ColorsEventsManager._();
  factory ColorsEventsManager() {
    instance ??= ColorsEventsManager._();
    return instance!;
  }

  void addColor(String linkedTitel, Color color, bool isDarkColor) {
    if (isDarkColor) {
      Stockage()
          .colorsEventsDarkBox
          .put(linkedTitel, ColorEvent.fromColor(color));
    } else {
      Stockage()
          .colorsEventsLightBox
          .put(linkedTitel, ColorEvent.fromColor(color));
    }
  }

  Color getColorOrGen(String linkedTitle, bool isDarkColor) {
    Box<ColorEvent> box;
    List<Color> defaults;
    if (isDarkColor) {
      box = Stockage().colorsEventsDarkBox;
      defaults = colorsDark;
    } else {
      box = Stockage().colorsEventsLightBox;
      defaults = colorsLight;
    }

    ColorEvent? color = box.get(linkedTitle);

    if (color == null) {
      color = ColorEvent.fromColor(defaults[countColor++ % defaults.length]);
      box.put(linkedTitle, color);
    }
    return color.color;
  }

  Color? goodColorFontOnBackground(Color bgColor) {
    final grayscale = (0.299 * bgColor.red) +
        (0.587 * bgColor.green) +
        (0.114 * bgColor.blue);

    Color? newColor;
    if (grayscale > 128) {
      //is light
      newColor = Colors.black;
    } else {
      //is dark
      newColor = Colors.white;
    }
    return newColor;
  }

  static const Color redOnePlus = Color.fromARGB(255, 230, 23, 75);

  int countColor = 0;
  List<Color> colorsDark = const [
    Color.fromARGB(255, 99, 39, 39),
    Color.fromARGB(255, 99, 99, 39),
    Color.fromARGB(255, 18, 124, 138),
    Color.fromARGB(255, 39, 39, 99),
    Color.fromARGB(255, 99, 80, 39),
    Color.fromARGB(255, 58, 99, 39),
    Color.fromARGB(255, 39, 58, 99),
    Color.fromARGB(255, 80, 39, 99),
    Color.fromARGB(255, 70, 39, 99),
    Color.fromARGB(255, 99, 39, 68),
    Color.fromARGB(255, 53, 39, 99),
    Color.fromARGB(255, 99, 39, 85),
    Color.fromARGB(255, 85, 99, 39),
    Color.fromARGB(255, 39, 99, 53),
    Color.fromARGB(255, 99, 39, 60),
    Color.fromARGB(255, 99, 78, 39),
    Color.fromARGB(255, 52, 64, 76),
    Color.fromARGB(255, 39, 60, 99),
  ];

  List<Color> colorsLight = const [
    Color.fromARGB(255, 255, 204, 79),
    Color.fromARGB(255, 255, 204, 204),
    Color.fromARGB(255, 255, 79, 204),
    Color.fromARGB(255, 255, 204, 164),
    Color.fromARGB(255, 255, 118, 204),
    Color.fromARGB(255, 255, 79, 118),
    Color.fromARGB(255, 255, 164, 79),
    Color.fromARGB(255, 255, 139, 204),
    Color.fromARGB(255, 255, 143, 79),
    Color.fromARGB(255, 255, 204, 79),
    Color.fromARGB(255, 108, 79, 204),
    Color.fromARGB(255, 204, 79, 174),
    Color.fromARGB(255, 174, 204, 79),
    Color.fromARGB(255, 79, 204, 108),
    Color.fromARGB(255, 204, 79, 123),
    Color.fromARGB(255, 204, 160, 79),
    Color.fromARGB(255, 79, 204, 160),
    Color.fromARGB(255, 79, 123, 204),
  ];
}
