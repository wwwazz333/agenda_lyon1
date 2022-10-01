import 'package:agenda_lyon1/data/file_manager.dart';
import 'package:agenda_lyon1/my_settings_screen.dart';
import 'package:agenda_lyon1/providers.dart';
import 'package:agenda_lyon1/settings.dart';
import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'settings_screen_url.dart';

Future<void> main() async {
  // à faire au démarrage de l'app

  // démarrage app
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loadSettings(ref);
    return MaterialApp(
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Agenda Lyon1',
      initialRoute: '/',
      routes: {
        '/settings': ((context) => const MySettingsScreen()),
        '/settings_url': ((context) => const SettingsScreenURL()),
      },
      // ref.watch(themeApp)
      theme: ref.watch(themeApp),
      home: FutureBuilder(
        future: loadCriticalSettings(ref),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return const CalendarScreen();
          } else {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.calendar_today,
                      size: 64,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CircularProgressIndicator(),
                  ]),
            );
          }
        },
      ),
    );
  }
}
