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
          "CREATE TABLE ColorsLight(nameEvent TEXT PRIMARY KEY, r INTEGER, g INTEGER, b INTEGER)",
        );
        db.execute(
          "CREATE TABLE ColorsDark(nameEvent TEXT PRIMARY KEY, r INTEGER, g INTEGER, b INTEGER)",
        );
        db.execute(
          "CREATE TABLE Tasks(id INTEGER PRIMARY KEY autoincrement, uid TEXT, task TEXT)",
        );
        db.execute(
          "CREATE TABLE History(id INTEGER PRIMARY KEY autoincrement, name TEXT, oldDate INTEGER, newDate INTEGER)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute(
          "CREATE TABLE if not exists ColorsLight(nameEvent TEXT PRIMARY KEY, r INTEGER, g INTEGER, b INTEGER)",
        );
        db.execute(
          "CREATE TABLE if not exists ColorsDark(nameEvent TEXT PRIMARY KEY, r INTEGER, g INTEGER, b INTEGER)",
        );
        db.execute(
          "CREATE TABLE if not exists Tasks(id INTEGER PRIMARY KEY autoincrement, uid TEXT, task TEXT)",
        );
        db.execute(
          "CREATE TABLE if not exists History(id INTEGER PRIMARY KEY autoincrement, name TEXT, typeChange TEXT, oldDate INTEGER, newDate INTEGER)",
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

  static Future<List<Map<String, dynamic>>> readDB(String nameDB) async {
    final res = await (await db).query(nameDB);
    return res;
  }
}
