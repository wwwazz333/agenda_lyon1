import 'package:flutter/material.dart';

import 'colors.dart';

final _parentTheme = ThemeData(
  primaryColor: redOnePlus,
  appBarTheme: const AppBarTheme(backgroundColor: redOnePlus),
  buttonTheme: const ButtonThemeData(buttonColor: redOnePlus),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(redOnePlus))),
);

final themes = {
  "light": ThemeData(
      brightness: Brightness.light,
      primaryColor: _parentTheme.primaryColor,
      appBarTheme: _parentTheme.appBarTheme,
      elevatedButtonTheme: _parentTheme.elevatedButtonTheme,
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
  "dark": ThemeData(
      brightness: Brightness.dark,
      primaryColor: _parentTheme.primaryColor,
      appBarTheme: _parentTheme.appBarTheme,
      buttonTheme: _parentTheme.buttonTheme,
      elevatedButtonTheme: _parentTheme.elevatedButtonTheme,
      backgroundColor: Colors.black,
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
};
