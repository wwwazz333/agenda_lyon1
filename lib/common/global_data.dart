import 'package:flutter/material.dart';

final firstDate = DateTime(1999, 12, 26, 12); //must be on 0 time

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
