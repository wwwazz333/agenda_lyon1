import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  static Future<Database>? _db;

  static Future<Database> get db {
    return _db ??= open();
  }

  static Future<Database> open() async {
    return openDatabase(
      join(await getDatabasesPath(), "database.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE Tasks(id INTEGER PRIMARY KEY autoincrement, uid TEXT, task TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> insertInto(
      String nameDB, Map<String, Object?> values) async {
    await (await db)
        .insert(nameDB, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removeWhere(
      String nameDB, String where, List<Object> whereArgs) async {
    await (await db).delete(nameDB, where: where, whereArgs: whereArgs);
  }

  static Future<void> updateWhere(String nameDB, Map<String, Object?> to,
      String where, List<Object> whereArgs) async {
    await (await db).update(nameDB, to, where: where, whereArgs: whereArgs);
  }

  static Future<List<Map<String, dynamic>>> readDB(String nameDB,
      {String? orderBy}) async {
    final res = await (await db).query(nameDB, orderBy: orderBy);

    return res;
  }

  static Future<List<Map<String, dynamic>>> getWhere(
      String nameDB, List<String> column, String where, List<Object?> whereArgs,
      {String? orderBy}) async {
    final res = await (await db).query(nameDB,
        columns: column, where: where, whereArgs: whereArgs, orderBy: orderBy);
    return res;
  }

  static Future<int?> getMaxId() async {
    final liste = await (await db).rawQuery("SELECT max(id) from History");
    if (liste.isNotEmpty) {
      return liste[0]["max(id)"] as int;
    }
    return null;
  }
}
