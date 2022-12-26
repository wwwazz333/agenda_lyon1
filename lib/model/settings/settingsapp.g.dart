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
      .._notifEnabled = fields[0] as bool
      .._jourFeriesEnabled = fields[1] as bool
      .._alarmesAvancesEnabled = fields[2] as bool
      .._appIsDarkMode = fields[3] as bool
      .._languageApp = fields[4] as String
      .._urlCalendar = fields[5] as String?
      .._themeApp = fields[6] as ThemeMode?
      .._cardTimeLineDisplay = fields[7] as bool
      .._firstHourDisplay = fields[8] as int
      .._lastHourDisplay = fields[9] as int
      .._alarmAcitvated = fields[10] as bool
      .._urlCalendarRoom = fields[11] as String?
      .._appVersion = fields[12] as String?;
  }

  @override
  void write(BinaryWriter writer, SettingsApp obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj._notifEnabled)
      ..writeByte(1)
      ..write(obj._jourFeriesEnabled)
      ..writeByte(2)
      ..write(obj._alarmesAvancesEnabled)
      ..writeByte(3)
      ..write(obj._appIsDarkMode)
      ..writeByte(4)
      ..write(obj._languageApp)
      ..writeByte(5)
      ..write(obj._urlCalendar)
      ..writeByte(6)
      ..write(obj._themeApp)
      ..writeByte(7)
      ..write(obj._cardTimeLineDisplay)
      ..writeByte(8)
      ..write(obj._firstHourDisplay)
      ..writeByte(9)
      ..write(obj._lastHourDisplay)
      ..writeByte(10)
      ..write(obj._alarmAcitvated)
      ..writeByte(11)
      ..write(obj._urlCalendarRoom)
      ..writeByte(12)
      ..write(obj._appVersion);
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
