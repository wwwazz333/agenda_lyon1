import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  static Future<Database>? _db;

  static Future<Database> get db {
    return _db ??= _open();
  }

  static Future<Database> _open() async {
    return openDatabase(
      join(await getDatabasesPath(), "database.db"),
      onCreate: (db, version) {
        print("création db");
        return db.execute(
          'CREATE TABLE IF NOT EXISTS ColorsBlack(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      // version: 1,
    );
  }

  static Future<void> insertInto(String nameDB, String name, int age) async {
    await (await db).insert(nameDB, {'name': name, 'age': age},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> readDB(String nameDB) async {
    return await (await db).query(nameDB);
  }
}
