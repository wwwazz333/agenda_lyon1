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
        print("création db...................................");
        db.execute(
          "CREATE TABLE ColorsLight(nameEvent TEXT PRIMARY KEY, r INTEGER, g INTEGER, b INTEGER)",
        );
        db.execute(
          "CREATE TABLE ColorsDark(nameEvent TEXT PRIMARY KEY, r INTEGER, g INTEGER, b INTEGER)",
        );
        db.execute(
          "CREATE TABLE Tasks(id INTEGER PRIMARY KEY autoincrement, uid TEXT, task TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        print("chibrax");
      },
      onOpen: (db) {
        print("opened db");
      },
      version: 15,
    );
  }

  static Future<void> insertInto(
      String nameDB, Map<String, Object?> values) async {
    await (await db)
        .insert(nameDB, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> readDB(String nameDB) async {
    final res = await (await db).query(nameDB);
    return res;
  }
}
