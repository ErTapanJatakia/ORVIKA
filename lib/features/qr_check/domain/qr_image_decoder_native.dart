import 'dart:typed_data';

import 'package:mobile_scanner/mobile_scanner.dart';

import 'qr_image_decoder.dart';

Future<List<QrImageCode>> decodeQrImage({
  required Uint8List bytes,
  required String path,
}) async {
  final controller = MobileScannerController(autoStart: false);
  try {
    final capture = await controller.analyzeImage(path);
    if (capture == null) return const [];
    return capture.barcodes
        .where((barcode) =>
            barcode.rawValue != null && barcode.rawValue!.trim().isNotEmpty)
        .map((barcode) => (
              value: barcode.rawValue!,
              format: barcode.format.name,
            ))
        .toList(growable: false);
  } finally {
    await controller.dispose();
  }
}
