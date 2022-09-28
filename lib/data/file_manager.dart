import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManager {
  static const calendrierFile = "savedCal.ics";
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<File> writeString(String fileName, String txt) async {
    final file = await _localFile(fileName);
    return file.writeAsString(txt);
  }

  static Future<File> writeObject(String fileName, Object obj) async {
    final file = await _localFile(fileName);

    return file.writeAsString(jsonEncode(obj));
  }

  static Future<String> readString(String fileName) async {
    try {
      final file = await _localFile(fileName);

      // Read the file
      return await file.readAsString();
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  static Future<String?> readObject(String fileName) async {
    try {
      final file = await _localFile(fileName);

      // Read the file
      return jsonDecode(await file.readAsString());
    } catch (_) {
      return null;
    }
  }

  static Future<bool> delFile(String fileName) async {
    try {
      final file = await _localFile(fileName);
      if (await file.exists()) {
        print("le fichier exist : ${file.path}");
        file.delete();
        return true;
      }
    } catch (_) {}
    return false;
  }
}
