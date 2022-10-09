// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settingsapp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAppAdapter extends TypeAdapter<SettingsApp> {
  @override
  final int typeId = 0;

  @override
  SettingsApp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsApp()
      .._changeIds = (fields[0] as List).cast<int>()
      .._notifEnabled = fields[1] as bool
      .._jourFeriesEnabled = fields[2] as bool
      .._alarmesAvancesEnabled = fields[3] as bool
      .._appIsDarkMode = fields[4] as bool
      .._languageApp = fields[5] as String
      .._urlCalendar = fields[6] as String?
      .._themeApp = fields[7] as ThemeMode?
      .._cardTimeLineDisplay = fields[8] as bool
      .._firstHourDisplay = fields[9] as int
      .._lastHourDisplay = fields[10] as int;
  }

  @override
  void write(BinaryWriter writer, SettingsApp obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj._changeIds)
      ..writeByte(1)
      ..write(obj._notifEnabled)
      ..writeByte(2)
      ..write(obj._jourFeriesEnabled)
      ..writeByte(3)
      ..write(obj._alarmesAvancesEnabled)
      ..writeByte(4)
      ..write(obj._appIsDarkMode)
      ..writeByte(5)
      ..write(obj._languageApp)
      ..writeByte(6)
      ..write(obj._urlCalendar)
      ..writeByte(7)
      ..write(obj._themeApp)
      ..writeByte(8)
      ..write(obj._cardTimeLineDisplay)
      ..writeByte(9)
      ..write(obj._firstHourDisplay)
      ..writeByte(10)
      ..write(obj._lastHourDisplay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAppAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
