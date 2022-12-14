import 'package:agenda_lyon1/model/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../model/settings/settingsapp.dart';

class MySettingsScreen extends ConsumerStatefulWidget {
  const MySettingsScreen({super.key});

  @override
  ConsumerState<MySettingsScreen> createState() => _MySettingsScreen();
}

class _MySettingsScreen extends ConsumerState<MySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final cardTypeToDisplay =
        ref.read(SettingsProvider.cardTypeDisplayProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SettingsList(
        darkTheme: SettingsThemeData(
            titleTextColor: Theme.of(context).primaryColor,
            settingsListBackground: Theme.of(context).colorScheme.background),
        sections: [
          SettingsSection(
            title: const Text("URL"),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.link),
                title: const Text("URL"),
                onPressed: (context) {
                  Navigator.pushNamed(context, "/settings_url");
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Général'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    SettingsApp().notifEnabled = value;
                  });
                },
                initialValue: SettingsApp().notifEnabled,
                leading: const Icon(Icons.notifications),
                title: const Text('Notification'),
              ),
              // SettingsTile(
              //   leading: const Icon(Icons.language),
              //   title: const Text('Language'),
              //   trailing: DropdownButton(
              //     value: ref.watch(SettingsProvider.languageAppProvider),
              //     items: List.generate(
              //         languages.length,
              //         (index) => DropdownMenuItem(
              //               value: languages.values.elementAt(index),
              //               child: Text(
              //                   languages.values.elementAt(index).fullName()),
              //             )),
              //     onChanged: (value) {
              //       if (value != null) {
              //         ref
              //             .read(SettingsProvider.languageAppProvider.notifier)
              //             .state = value;
              //       }
              //     },
              //   ),
              // ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  if (ref.read(SettingsProvider.themeAppProvider) ==
                      ThemeMode.dark) {
                    ref.read(SettingsProvider.themeAppProvider.notifier).state =
                        ThemeMode.light;
                  } else {
                    ref.read(SettingsProvider.themeAppProvider.notifier).state =
                        ThemeMode.dark;
                  }
                },
                initialValue: ref.watch(SettingsProvider.themeAppProvider) ==
                    ThemeMode.dark,
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark mode'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  ref
                      .read(SettingsProvider.cardTypeDisplayProvider)
                      .cardTimeLineDisplay = value;
                },
                initialValue: ref
                    .watch(SettingsProvider.cardTypeDisplayProvider)
                    .cardTimeLineDisplay,
                leading: const Icon(Icons.timeline),
                title: const Text('Affichage Time Line'),
              ),
              SettingsTile(
                title: const Text("Horaire affiché"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${cardTypeToDisplay.firstHourDisplay}h"),
                    const Icon(Icons.arrow_right),
                    Text("${cardTypeToDisplay.lastHourDisplay}h"),
                  ],
                ),
                enabled: cardTypeToDisplay.cardTimeLineDisplay,
                onPressed: (context) async {
                  Picker(
                      adapter: NumberPickerAdapter(data: [
                        NumberPickerColumn(
                          initValue: cardTypeToDisplay.firstHourDisplay,
                          begin: 0,
                          end: 24,
                          suffix: const Text(" h"),
                        ),
                        NumberPickerColumn(
                          initValue: cardTypeToDisplay.lastHourDisplay,
                          begin: 0,
                          end: 24,
                          suffix: const Text(" h"),
                        )
                      ]),
                      delimiter: [
                        PickerDelimiter(
                            child: Container(
                          width: 30.0,
                          alignment: Alignment.center,
                          child: const Icon(Icons.arrow_right),
                        ))
                      ],
                      hideHeader: true,
                      title:
                          const Text("Sélectionez l'heure de début et de fin"),
                      selectedTextStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      confirmText: "Confirmer",
                      cancelText: "Annuler",
                      onConfirm: (Picker picker, List value) {
                        cardTypeToDisplay.setHours(value[0], value[1]);
                      }).showDialog(context);
                },
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    SettingsApp().jourFeriesEnabled = value;
                  });
                },
                initialValue: SettingsApp().jourFeriesEnabled,
                leading: const Icon(Icons.calendar_month_sharp),
                title: const Text('Détection jours feries'),
                description: SettingsApp().jourFeriesEnabled
                    ? const Text(
                        "La détéction des jours feries est activé pour les alarmes. (les cours de 8h ou plus ne déclancherons pas d'alarmes)")
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
