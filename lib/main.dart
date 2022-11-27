import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:agenda_lyon1/common/global_data.dart';
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/settings/settings.dart';
import 'package:agenda_lyon1/views/screen/historique_screen.dart';
import 'package:agenda_lyon1/views/screen/list_alarms.dart';
import 'package:agenda_lyon1/views/screen/search_room.dart';
import 'package:agenda_lyon1/views/screen/settings/settings_alarm.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'common/themes.dart';
import 'controller/background_work.dart';
import 'views/screen/calendar_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/screen/settings/settings_screen.dart';
import 'views/screen/settings/settings_screen_url.dart';

Future<void> main() async {
  // à faire au démarrage de l'app
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  await Stockage().init();
  loadCriticalSettings();
  final container = ProviderContainer();
  setUpListeners(container);

  // démarrage app
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyApp();
}

class _MyApp extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    log("main isoalte = ${Isolate.current.hashCode}");
    return MaterialApp(
      navigatorKey: navigatorKey,
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
      initialRoute: "/",
      routes: {
        '/settings': ((context) => const MySettingsScreen()),
        '/settings_url': ((context) => const SettingsScreenURL()),
        '/history': ((context) => const HistoriqueScreen()),
        '/list_alarms': ((context) => const ListAlarms()),
        '/list_alarms/settings': ((context) => const SettingsAlarm()),
        '/search_room': ((context) => const SearchRoom()),
      },
      theme: themes["light"],
      darkTheme: themes["dark"],
      themeMode: ref.watch(SettingsProvider.themeAppProvider),
      home: const CalendarScreen(),
    );
  }
}
