import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../model/color/colors.dart';

final _parentTheme = ThemeData(
  primaryColor: ColorsEventsManager.redOnePlus,
  appBarTheme:
      const AppBarTheme(backgroundColor: ColorsEventsManager.redOnePlus),
  buttonTheme:
      const ButtonThemeData(buttonColor: ColorsEventsManager.redOnePlus),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(ColorsEventsManager.redOnePlus))),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          textStyle: const TextStyle(color: ColorsEventsManager.redOnePlus))),
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
      cardColor: const Color.fromARGB(255, 237, 237, 237),
      checkboxTheme: const CheckboxThemeData(
          checkColor: MaterialStatePropertyAll(Colors.white),
          fillColor: MaterialStatePropertyAll(ColorsEventsManager.redOnePlus)),
      textTheme: ThemeData.light().textTheme.copyWith(
            displayLarge: const TextStyle(
              fontSize: 26,
              color: ColorsEventsManager.redOnePlus,
              fontWeight: FontWeight.w700,
            ),
            displayMedium: const TextStyle(
                fontSize: 22,
                color: ColorsEventsManager.redOnePlus,
                fontWeight: FontWeight.w400),
            bodyLarge: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal),
            bodyMedium: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
            displaySmall: TextStyle(
                color: _parentTheme.colorScheme.onTertiary, fontSize: 14),
          )),
  "dark": FlexThemeData.dark(darkIsTrueBlack: true).copyWith(
      primaryColor: _parentTheme.primaryColor,
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
          backgroundColor: Colors.black),
      appBarTheme: _parentTheme.appBarTheme,
      elevatedButtonTheme: _parentTheme.elevatedButtonTheme,
      textButtonTheme: _parentTheme.textButtonTheme,
      cardColor: const Color.fromARGB(255, 29, 29, 29),
      checkboxTheme: const CheckboxThemeData(
          checkColor: MaterialStatePropertyAll(Colors.white),
          fillColor: MaterialStatePropertyAll(ColorsEventsManager.redOnePlus)),
      textTheme: ThemeData.dark().textTheme.copyWith(
            displayLarge: const TextStyle(
                fontSize: 26,
                color: ColorsEventsManager.redOnePlus,
                fontWeight: FontWeight.w700),
            displayMedium: const TextStyle(
                fontSize: 22,
                color: ColorsEventsManager.redOnePlus,
                fontWeight: FontWeight.w400),
            bodyLarge: const TextStyle(color: Colors.white, fontSize: 16),
            bodyMedium: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
            displaySmall: TextStyle(
                color: _parentTheme.colorScheme.onTertiary, fontSize: 14),
          )),
};
