// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parametrage_horiare.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParametrageHoraireAdapter extends TypeAdapter<ParametrageHoraire> {
  @override
  final int typeId = 8;

  @override
  ParametrageHoraire read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParametrageHoraire._()
      .._debutMatch = fields[0] as int
      .._finMatch = fields[1] as int
      .._reglageHoraire = fields[2] as int
      ..relative = (fields[3] ?? true) as bool
      ..enabledDay =
          ((fields[4] ?? ParametrageHoraire.defaultEnabledDays) as List)
              .cast<int>();
  }

  @override
  void write(BinaryWriter writer, ParametrageHoraire obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._debutMatch)
      ..writeByte(1)
      ..write(obj._finMatch)
      ..writeByte(2)
      ..write(obj._reglageHoraire)
      ..writeByte(3)
      ..write(obj.relative)
      ..writeByte(4)
      ..write(obj.enabledDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParametrageHoraireAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
