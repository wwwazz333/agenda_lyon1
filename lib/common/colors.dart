import 'package:agenda_lyon1/data/db_manager.dart';
import 'package:flutter/material.dart';

Future<void> loadColors() async {
  final darks = await DBManager.readDB("ColorsDark");
  for (var row in darks) {
    fixedColorsDark[row["nameEvent"]] =
        Color.fromARGB(255, row["r"], row["g"], row["b"]);
  }

  final light = await DBManager.readDB("ColorsLight");
  for (var row in light) {
    fixedColorsLight[row["nameEvent"]] =
        Color.fromARGB(255, row["r"], row["g"], row["b"]);
  }
}

void addColor(String linkedTitel, Color color, bool isDarkColor) {
  if (isDarkColor) {
    fixedColorsDark[linkedTitel] = color;
    DBManager.insertInto("ColorsDark", {
      "nameEvent": linkedTitel,
      "r": color.red,
      "g": color.green,
      "b": color.blue,
    });
  } else {
    fixedColorsLight[linkedTitel] = color;
    DBManager.insertInto("ColorsLight", {
      "nameEvent": linkedTitel,
      "r": color.red,
      "g": color.green,
      "b": color.blue,
    });
  }
}

const Color redOnePlus = Color.fromARGB(255, 230, 23, 75);

int countColor = 0;

Map<String, Color> fixedColorsDark = {};
Map<String, Color> fixedColorsLight = {};
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
