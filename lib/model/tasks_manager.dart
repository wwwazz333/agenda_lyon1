import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/model/task.dart';
import 'package:agenda_lyon1/model/tasks_of_event.dart';
import 'package:hive/hive.dart';

class TasksManager {
  static TasksManager? instance;
  TasksManager._();
  factory TasksManager() {
    instance ??= TasksManager._();
    return instance!;
  }

  Box<TasksOfEvent> get _box => Stockage().tasksBox;

  TasksOfEvent taskOfEvent(String uid) {
    return _box.get(uid, defaultValue: TasksOfEvent(uid, [])) ??
        TasksOfEvent(uid, []);
  }

  void addTask(String uid, String task) {
    taskOfEvent(uid).addTask(Task(uid, task));
  }

  void removeTask(String uid, int index) {
    taskOfEvent(uid).remove(index);
  }
}
