import 'package:agenda_lyon1/controller/background_work.dart';
import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/settings.dart';
import 'package:agenda_lyon1/views/screen/historique_screen.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'common/themes.dart';
import 'views/custom_widgets/loading_widget.dart';
import 'views/screen/calendar_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/screen/settings/settings_screen.dart';
import 'views/screen/settings/settings_screen_url.dart';

Future<void> main() async {
  // à faire au démarrage de l'app
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  await Stockage().init();

  // démarrage app
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future loadingApp = loadCriticalSettings(context, ref);
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
        '/history': ((context) => const HistoriqueScreen()),
      },
      theme: themes["light"],
      darkTheme: themes["dark"],
      themeMode: ref.watch(SettingsProvider.themeAppProvider.state).state,
      home: FutureBuilder(
        future: loadingApp,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return const CalendarScreen();
          } else {
            return const LoadingWidget();
          }
        },
      ),
    );
  }
}
