import '../data/db_manager.dart';

Map<String, List<String>> tasks = {};

Future<void> loadTasks() async {
  tasks = {};
  final res = await DBManager.readDB("Tasks");
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
  DBManager.insertInto("Tasks", {"uid": uid, "task": task});
}

void removeTask(String uid, int index) {
  if (!tasks.containsKey(uid)) {
    tasks[uid]!.removeAt(index);
  }
  DBManager.insertInto("Tasks", {"uid": uid, "task": task});
}
