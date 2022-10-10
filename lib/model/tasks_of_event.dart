import 'package:hive_flutter/hive_flutter.dart';

import 'task.dart';

part 'tasks_of_event.g.dart';

@HiveType(typeId: 6)
class TasksOfEvent extends HiveObject {
  @HiveField(0)
  String uid;
  @HiveField(1)
  List<Task> tasks = [];

  TasksOfEvent(this.uid, this.tasks);

  int get length => tasks.length;

  Task get(int index) {
    return tasks[index];
  }

  void addTask(Task task) {
    tasks.add(task);
    save();
  }

  void remove(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      save();
    }
  }
}
