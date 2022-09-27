import 'dart:convert';
import 'dart:io';
import 'package:flutter_logs/flutter_logs.dart';

import '../common/error/network_error.dart';

class FileDownloader {
  static Future<String> downloadFile(String url) async {
    FlutterLogs.logInfo("Download", "url", "start download...");
    try {
      final request = await HttpClient().getUrl(Uri.parse(url));
      final HttpClientResponse response = await request.close();
      if (response.statusCode ~/ 100 != 2) {
        FlutterLogs.logError(
            "Download", "error", "errorCode : ${response.statusCode}");
        if (response.statusCode ~/ 100 == 4) {
          throw DownloadError("Error URL", response.statusCode);
        }
        throw DownloadError("Error", response.statusCode);
      } else {
        final contentOfFile = await response.transform(utf8.decoder).join();
        // FlutterLogs.logInfo("Download", "url", contentOfFile);
        return Future.value(contentOfFile);
      }
    } on SocketException catch (_) {
      FlutterLogs.logError("Download", "error", "téléchargement impossible");
      throw NetworkError("No Network");
    }
  }
}
