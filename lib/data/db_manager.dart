import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  static const _nameDataBase = "clients";
  static Future<Database>? _db;

  static Future<Database> get db {
    return _db ??= _open();
  }

  static Future<Database> _open() async {
    return openDatabase(
      join(await getDatabasesPath(), "$_nameDataBase.db"),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS $_nameDataBase(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertClient(String name, int age) async {
    await (await db).insert(_nameDataBase, {'name': name, 'age': age},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> readDB() async {
    return await (await db).query(_nameDataBase);
  }
}
