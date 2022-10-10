// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendrier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendrierAdapter extends TypeAdapter<Calendrier> {
  @override
  final int typeId = 3;

  @override
  Calendrier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Calendrier(
      (fields[0] as List).cast<EventCalendrier>(),
    );
  }

  @override
  void write(BinaryWriter writer, Calendrier obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj._events);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendrierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
