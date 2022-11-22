import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../common/error/network_error.dart';

class FileDownloader {
  static Future<String> downloadFile(String url) async {
    try {
      final request = await HttpClient().getUrl(Uri.parse(url));
      final HttpClientResponse response = await request.close();
      if (response.statusCode ~/ 100 != 2) {
        log("Download : errorCod : ${response.statusCode}");
        if (response.statusCode ~/ 100 == 4) {
          throw DownloadError("Error URL", response.statusCode);
        }
        throw DownloadError("Error", response.statusCode);
      } else {
        final contentOfFile = await response.transform(utf8.decoder).join();
        return Future.value(contentOfFile);
      }
    } on SocketException catch (_) {
      log("Download : téléchargement impossible");
      throw NetworkError("No Network");
    }
  }
}
