import 'package:agenda_lyon1/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import 'common/global_data.dart';
import 'views/custom_widgets/toggle_settings.dart';

class RadioSettings extends AbstractSettingsTile {
  final StateProvider provider;
  final List<String> entries;
  final List<dynamic> values;
  final String title;
  final String? description;

  const RadioSettings(
      {required this.provider,
      required this.entries,
      required this.values,
      required this.title,
      this.description,
      super.key});

  @override
  Widget build(BuildContext context) {
    return _RadioSettings(
      provider: provider,
      entries: entries,
      values: values,
      title: title,
      description: description,
      key: key,
    );
  }
}

class _RadioSettings extends ConsumerWidget {
  final StateProvider provider;
  final List<String> entries;
  final List<dynamic> values;
  final String title;
  final String? description;

  const _RadioSettings(
      {required this.provider,
      required this.entries,
      required this.values,
      required this.title,
      this.description,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);
    return SettingsTile(
      title: Text(title),
      description: description != null ? Text(description!) : null,
      onPressed: (context) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  values.length,
                  (index) => RadioListTile(
                        title: Text(entries[index]),
                        value: values[index],
                        groupValue: value,
                        onChanged: (value) {
                          ref.read(provider.notifier).state = value;
                        },
                      )),
            ),
          ),
        );
      },
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  final bool notifActivated;
  final bool alarmActivated;

  const SettingsScreen(
      {super.key, required this.alarmActivated, required this.notifActivated});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('URL'),
            tiles: [
              SettingsTile.navigation(
                title: const Text("URL"),
                description: Text("URL pour mettre à jour le calendrier"),
              )
            ],
          ),
          SettingsSection(
            title: Text('Général'),
            tiles: [
              SettingsToggle(
                title: "Notification",
                description: "Les notifications sont activées",
                value: notifActivated,
                keySave: "notif_activated",
              ),
              RadioSettings(
                provider: languageApp,
                entries: const ["Français", "English"],
                values: const [Locale("fr", "FR"), Locale("en", "EN")],
                title: "Langue",
                description: "Changer de langue",
              ),
              RadioSettings(
                provider: themeApp,
                entries: const ["Black", "Light"],
                values: const [MyTheme.black, MyTheme.light],
                title: "Thème",
                description: "Changer de thème",
              ),
            ],
          ),
          SettingsSection(
            title: Text('Alamres auto'),
            tiles: [
              SettingsToggle(
                title: "Alarmes auto",
                keySave: "alarm_activated",
                value: alarmActivated,
                description:
                    "Une alarme automatique vas s'activé en fontion des préférences",
              ),
              SettingsTile.navigation(
                enabled: alarmActivated,
                title: Text("Paramètre alarmes"),
                description: Text("Accéder au réglages des alarmes"),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Fonctionnalité'),
            tiles: [
              SettingsTile.navigation(
                title: Text("Utilisations"),
                description: Text(
                    "Aide pour utiliser toutes les fonctionnalitées de cette application"),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Contact'),
            tiles: [
              SettingsTile.navigation(
                title: Text("Contact"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
