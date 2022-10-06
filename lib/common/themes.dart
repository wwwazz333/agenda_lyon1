import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

final _parentTheme = ThemeData(
  primaryColor: redOnePlus,
  appBarTheme: const AppBarTheme(backgroundColor: redOnePlus),
  buttonTheme: const ButtonThemeData(buttonColor: redOnePlus),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(redOnePlus))),
  textButtonTheme: TextButtonThemeData(
      style:
          TextButton.styleFrom(textStyle: const TextStyle(color: redOnePlus))),
  switchTheme:
      SwitchThemeData(overlayColor: MaterialStateProperty.resolveWith((states) {
    return Colors.red;
  })),
);

final themes = {
  "light": FlexThemeData.light().copyWith(
      primaryColor: _parentTheme.primaryColor,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
      appBarTheme: _parentTheme.appBarTheme,
      elevatedButtonTheme: _parentTheme.elevatedButtonTheme,
      textButtonTheme: _parentTheme.textButtonTheme,
      switchTheme: _parentTheme.switchTheme,
      textTheme: ThemeData.light().textTheme.copyWith(
            headline1: const TextStyle(
                fontSize: 26, color: redOnePlus, fontWeight: FontWeight.w700),
            headline2: const TextStyle(
                fontSize: 22, color: redOnePlus, fontWeight: FontWeight.w400),
            bodyText1: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal),
            bodyText2: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
            headline3: TextStyle(
                color: _parentTheme.colorScheme.onTertiary, fontSize: 14),
          )),
  "dark": FlexThemeData.dark(darkIsTrueBlack: true).copyWith(
      primaryColor: _parentTheme.primaryColor,
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red, brightness: Brightness.dark),
      appBarTheme: _parentTheme.appBarTheme,
      elevatedButtonTheme: _parentTheme.elevatedButtonTheme,
      textButtonTheme: _parentTheme.textButtonTheme,
      backgroundColor: Colors.black,
      textTheme: ThemeData.dark().textTheme.copyWith(
            headline1: const TextStyle(
                fontSize: 26, color: redOnePlus, fontWeight: FontWeight.w700),
            headline2: const TextStyle(
                fontSize: 22, color: redOnePlus, fontWeight: FontWeight.w400),
            bodyText1: const TextStyle(color: Colors.white, fontSize: 16),
            bodyText2: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
            headline3: TextStyle(
                color: _parentTheme.colorScheme.onTertiary, fontSize: 14),
          )),
};
