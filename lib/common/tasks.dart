import '../data/db_manager.dart';

const String tableTasks = "Tasks";

Map<String, List<String>> tasks = {};

Future<void> loadTasks() async {
  tasks = {};
  final res = await DBManager.readDB(tableTasks);
  for (var row in res) {
    if (!tasks.containsKey(row["uid"])) {
      tasks[row["uid"]] = [];
    }
    tasks[row["uid"]]!.add(row["task"]);
  }
}

void addTask(String uid, String task) {
  if (!tasks.containsKey(uid)) {
    tasks[uid] = [];
  }
  tasks[uid]!.add(task);
  DBManager.insertInto(tableTasks, {"uid": uid, "task": task});
}

void removeTask(String uid, int index) {
  if (tasks.containsKey(uid)) {
    DBManager.removeWhere(
        tableTasks, "uid = ? and task = ?", [uid, tasks[uid]![index]]);
    tasks[uid]!.removeAt(index);
  }
}
