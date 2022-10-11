import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      textTheme:
          GoogleFonts.openSansTextTheme(ThemeData.light().textTheme.copyWith(
                headline1: const TextStyle(
                  fontSize: 26,
                  color: ColorsEventsManager.redOnePlus,
                  fontWeight: FontWeight.w700,
                ),
                headline2: const TextStyle(
                    fontSize: 22,
                    color: ColorsEventsManager.redOnePlus,
                    fontWeight: FontWeight.w400),
                bodyText1: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
                bodyText2: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
                headline3: TextStyle(
                    color: _parentTheme.colorScheme.onTertiary, fontSize: 14),
              ))),
  "dark": FlexThemeData.dark(darkIsTrueBlack: true).copyWith(
      primaryColor: _parentTheme.primaryColor,
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red, brightness: Brightness.dark),
      appBarTheme: _parentTheme.appBarTheme,
      elevatedButtonTheme: _parentTheme.elevatedButtonTheme,
      textButtonTheme: _parentTheme.textButtonTheme,
      cardColor: const Color.fromARGB(255, 29, 29, 29),
      backgroundColor: Colors.black,
      textTheme:
          GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme.copyWith(
                headline1: const TextStyle(
                    fontSize: 26,
                    color: ColorsEventsManager.redOnePlus,
                    fontWeight: FontWeight.w700),
                headline2: const TextStyle(
                    fontSize: 22,
                    color: ColorsEventsManager.redOnePlus,
                    fontWeight: FontWeight.w400),
                bodyText1: const TextStyle(color: Colors.white, fontSize: 16),
                bodyText2: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
                headline3: TextStyle(
                    color: _parentTheme.colorScheme.onTertiary, fontSize: 14),
              ))),
};
