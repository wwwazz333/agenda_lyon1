// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_calendrier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventCalendrierAdapter extends TypeAdapter<EventCalendrier> {
  @override
  final int typeId = 2;

  @override
  EventCalendrier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventCalendrier()
      .._nameEvent = fields[0] as String
      .._salle = (fields[1] as List).cast<String>()
      .._description = fields[2] as String
      .._uid = fields[3] as String
      .._date = fields[4] as DateTime
      .._duree = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, EventCalendrier obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._nameEvent)
      ..writeByte(1)
      ..write(obj._salle)
      ..writeByte(2)
      ..write(obj._description)
      ..writeByte(3)
      ..write(obj._uid)
      ..writeByte(4)
      ..write(obj._date)
      ..writeByte(5)
      ..write(obj._duree);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventCalendrierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
