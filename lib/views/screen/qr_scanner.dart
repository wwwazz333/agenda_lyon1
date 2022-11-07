import 'package:barcode_scan2/barcode_scan2.dart';

Future<String?> scanQR() async {
  ScanResult res = await BarcodeScanner.scan();

  if (res.type == ResultType.Barcode) {
    return res.rawContent;
  }
  return null;
}
