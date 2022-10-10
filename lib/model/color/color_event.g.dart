// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorEventAdapter extends TypeAdapter<ColorEvent> {
  @override
  final int typeId = 4;

  @override
  ColorEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorEvent().._colorInt = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, ColorEvent obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj._colorInt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
