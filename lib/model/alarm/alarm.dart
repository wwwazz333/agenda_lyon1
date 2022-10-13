import 'package:hive_flutter/hive_flutter.dart';

part 'alarm.g.dart';

@HiveType(typeId: 7)
class Alarm {
  Alarm({required this.dateTime, required this.id, this.removable = true});

  @HiveField(0)
  DateTime dateTime;
  @HiveField(1)
  int id;
  @HiveField(2)
  bool removable;
}
