import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../data/shared_pref.dart';

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
