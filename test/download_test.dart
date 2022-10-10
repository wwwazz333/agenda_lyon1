// ignore_for_file: avoid_print

import 'package:agenda_lyon1/network/file_downolader.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const url =
      "http://adelb.univ-lyon1.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=35708&projectId=2&calType=ical&firstDate=2022-10-10&lastDate=2022-10-16";

  test("affichage downloadFile", () {
    final content = FileDownloader.downloadFile(url);

    print(content);
  });
}
