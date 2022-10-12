import 'dart:developer';

import 'package:agenda_lyon1/controller/background_work.dart';
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/alarm/alarm_manager.dart';
import 'package:agenda_lyon1/model/settings/settings.dart';
import 'package:agenda_lyon1/model/settings/settingsapp.dart';
import 'package:agenda_lyon1/views/screen/historique_screen.dart';
import 'package:agenda_lyon1/views/screen/list_alarms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';
import 'package:workmanager/workmanager.dart';
import 'common/themes.dart';
import 'views/screen/calendar_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/screen/settings/settings_screen.dart';
import 'views/screen/settings/settings_screen_url.dart';

Future<void> main() async {
  // à faire au démarrage de l'app
  WidgetsFlutterBinding.ensureInitialized();
  FlutterAlarmBackgroundTrigger.initialize();
  AlarmManager().init();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
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
  void initState() {
    log(SettingsApp().pointDepart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      initialRoute: SettingsApp().pointDepart,
      routes: {
        '/settings': ((context) => const MySettingsScreen()),
        '/settings_url': ((context) => const SettingsScreenURL()),
        '/history': ((context) => const HistoriqueScreen()),
        '/alarms': ((context) => const ListAlarms()),
      },
      theme: themes["light"],
      darkTheme: themes["dark"],
      themeMode: ref.watch(SettingsProvider.themeAppProvider),
      home: const CalendarScreen(),
    );
  }
}
