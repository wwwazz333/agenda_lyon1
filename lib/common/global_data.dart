import 'package:flutter/material.dart';

DateTime get firstDate => DateTime(1999, 12, 26, 0); //must be on 0 time

const languages = {
  "fr": Locale("fr", "FR"),
  "en": Locale("en", "EN"),
};

extension FullName on Locale {
  String fullName() {
    switch (languageCode) {
      case 'en':
        return 'English';

      default:
        return 'Français';
    }
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

extension CapString on String {
  String capitalize() {
    if (length >= 2) {
      return substring(0, 1).toUpperCase() + toLowerCase().substring(1);
    } else {
      return toUpperCase();
    }
  }
}
