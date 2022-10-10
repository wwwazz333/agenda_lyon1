import 'package:hive_flutter/hive_flutter.dart';

part 'task.g.dart';

@HiveType(typeId: 5)
class Task {
  @HiveField(0)
  String uid;
  @HiveField(1)
  String text;

  Task(this.uid, this.text);
}
