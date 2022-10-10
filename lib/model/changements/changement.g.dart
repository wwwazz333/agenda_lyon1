// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChangementAdapter extends TypeAdapter<Changement> {
  @override
  final int typeId = 1;

  @override
  Changement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Changement(
      fields[1] as String,
      fields[4] as String,
      fields[0] as DateTime,
      fields[2] as DateTime?,
      fields[3] as DateTime?,
    )..changeSaw = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, Changement obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dateChange)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.oldDate)
      ..writeByte(3)
      ..write(obj.newDate)
      ..writeByte(4)
      ..write(obj.changementTypeString)
      ..writeByte(5)
      ..write(obj.changeSaw);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
