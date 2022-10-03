import 'dart:developer';

import 'package:agenda_lyon1/data/file_manager.dart';
import 'package:agenda_lyon1/providers.dart';
import 'package:agenda_lyon1/settings.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'controller/data_controller.dart';
import 'views/screen/calendar_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/screen/settings/settings_screen.dart';
import 'views/screen/settings/settings_screen_url.dart';

const updateCalendrier = "com.agenda_lyon1.workUpdate.calendrier";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // switch (task) {
    //   case updateCalendrier:
    //     log("Task:  here, whit inputData = $inputData");
    //     await DataController().update();
    //     break;
    // }
    return Future.value(true);
  });
}

Future<void> main() async {
  // à faire au démarrage de l'app
  WidgetsFlutterBinding.ensureInitialized();
  log(DateTime.now().toString());
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  // démarrage app
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends ConsumerState<MyApp> {
  late final Future loadingApp;
  @override
  void initState() {
    loadingApp = loadCriticalSettings(ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        future: loadingApp,
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
