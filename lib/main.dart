import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:agenda_lyon1/common/global_data.dart';
import 'package:agenda_lyon1/controller/local_notification_service.dart';
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/alarm/alarm_manager.dart';
import 'package:agenda_lyon1/model/settings/settings.dart';
import 'package:agenda_lyon1/model/settings/settingsapp.dart';
import 'package:agenda_lyon1/views/screen/alarm_screen.dart';
import 'package:agenda_lyon1/views/screen/historique_screen.dart';
import 'package:agenda_lyon1/views/screen/list_alarms.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/themes.dart';
import 'views/screen/calendar_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/screen/settings/settings_screen.dart';
import 'views/screen/settings/settings_screen_url.dart';

Future<void> main() async {
  // à faire au démarrage de l'app
  WidgetsFlutterBinding.ensureInitialized();
  await AlarmManager().init();
  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true,
  // );

  await LocalNotifService().setupEntryPoint();
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
    log("point : ${SettingsApp().pointDepart}");
    super.initState();
    initAutoStart();
  }

  Future<void> initAutoStart() async {
    try {
      //check auto-start availability.
      var test = (await isAutoStartAvailable ?? false);
      print(test);
      //if available then navigate to auto-start setting page.
      if (true) await getAutoStartPermission();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

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
      initialRoute: SettingsApp().pointDepart,
      routes: {
        '/settings': ((context) => const MySettingsScreen()),
        '/settings_url': ((context) => const SettingsScreenURL()),
        '/history': ((context) => const HistoriqueScreen()),
        '/list_alarms': ((context) => const ListAlarms()),
        '/alarm': ((context) => const AlarmScreen()),
      },
      theme: themes["light"],
      darkTheme: themes["dark"],
      themeMode: ref.watch(SettingsProvider.themeAppProvider),
      home: const CalendarScreen(),
    );
  }
}
