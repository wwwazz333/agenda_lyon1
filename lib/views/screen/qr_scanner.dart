import 'dart:developer';

import 'package:barcode_scan2/barcode_scan2.dart';

Future<String?> scanQR() async {
  try {
    ScanResult res = await BarcodeScanner.scan();

    if (res.type == ResultType.Barcode) {
      return res.rawContent;
    }
  } catch (e) {
    log(e.toString());
  }

  return null;
}
