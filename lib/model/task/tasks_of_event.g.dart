// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_of_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasksOfEventAdapter extends TypeAdapter<TasksOfEvent> {
  @override
  final int typeId = 6;

  @override
  TasksOfEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasksOfEvent(
      fields[0] as String,
      (fields[1] as List).cast<Task>(),
    );
  }

  @override
  void write(BinaryWriter writer, TasksOfEvent obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasksOfEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
