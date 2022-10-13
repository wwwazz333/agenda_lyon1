import 'package:hive_flutter/hive_flutter.dart';

part 'alarm.g.dart';

@HiveType(typeId: 7)
class Alarm extends HiveObject {
  Alarm({required this.dateTime, this.removable = true});

  @HiveField(0)
  DateTime dateTime;
  @HiveField(1)
  bool removable;
  @HiveField(2)
  int? id;
  @HiveField(3)
  bool isSet = false;
}
