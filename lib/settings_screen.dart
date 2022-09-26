import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsToggle extends AbstractSettingsTile {
  final String title;
  final String? description;
  final String keySave;
  final bool value;
  final Function? onChange;
  const SettingsToggle(
      {super.key,
      required this.title,
      required this.keySave,
      required this.value,
      this.onChange,
      this.description});

  @override
  Widget build(BuildContext context) {
    return _SettingsToggle(
      title: title,
      description: description,
      value: value,
      keySave: keySave,
      onChange: onChange,
      key: key,
    );
  }
}

class _SettingsToggle extends StatefulWidget {
  final String title;
  final String? description;
  final String keySave;
  bool value;
  final Function? onChange;

  _SettingsToggle(
      {super.key,
      required this.title,
      required this.keySave,
      required this.value,
      this.onChange,
      this.description});

  @override
  State<_SettingsToggle> createState() => _SettingsToggleState();
}

class _SettingsToggleState extends State<_SettingsToggle> {
  @override
  Widget build(BuildContext context) {
    return SettingsTile.switchTile(
      title: Text(widget.title),
      initialValue: widget.value,
      description:
          (widget.description != null) ? Text(widget.description!) : null,
      onToggle: (value) {
        setState(() {
          widget.value = !widget.value;
          DataReader.save(widget.keySave, widget.value);
          widget.onChange != null ? widget.onChange!(value) : null;
        });
        ;
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final bool notifActivated;
  final bool alarmActivated;
  const SettingsScreen(
      {super.key, required this.alarmActivated, required this.notifActivated});

  @override
  Widget build(BuildContext context) {
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
              SettingsTile(
                title: Text("Langue"),
                description: Text("Changer la langue"),
              ),
              SettingsTile(
                title: Text("Thème"),
                description: Text("Changer de thème"),
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
                onChange: (value) {},
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
