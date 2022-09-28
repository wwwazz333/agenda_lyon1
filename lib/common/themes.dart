import 'package:flutter/material.dart';

import 'colors.dart';

final themes = {
  "light": ThemeData(
      brightness: Brightness.light,
      primaryColor: redOnePlus,
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
  "dark": ThemeData(
      brightness: Brightness.dark,
      primaryColor: redOnePlus,
      backgroundColor: Colors.black,
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
};
