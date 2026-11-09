import 'dart:typed_data';

import 'package:zxing_lib/common.dart';
import 'package:zxing_lib/multi.dart';
import 'package:zxing_lib/zxing.dart';

import 'qr_image_decoder.dart';

/// Decodes RGBA pixels with the bundled, pure-Dart ZXing fallback.
///
/// This keeps Web image scanning independent of the browser BarcodeDetector API
/// and avoids sending image content to an external service.
List<QrImageCode> decodeQrImagePixels({
  required int width,
  required int height,
  required List<int> rgba,
}) {
  if (width <= 0 || height <= 0) {
    throw const FormatException('The selected image has invalid dimensions.');
  }

  final pixelCount = width * height;
  if (rgba.length != pixelCount * 4) {
    throw const FormatException('The selected image pixels could not be read.');
  }

  final argb = Int32List(pixelCount);
  for (var index = 0; index < pixelCount; index++) {
    final offset = index * 4;
    final alpha = rgba[offset + 3];
    final red = (rgba[offset] * alpha + 255 * (255 - alpha)) ~/ 255;
    final green = (rgba[offset + 1] * alpha + 255 * (255 - alpha)) ~/ 255;
    final blue = (rgba[offset + 2] * alpha + 255 * (255 - alpha)) ~/ 255;
    argb[index] = 0xff000000 | (red << 16) | (green << 8) | blue;
  }

  final bitmap = BinaryBitmap(
    HybridBinarizer(RGBLuminanceSource(width, height, argb)),
  );

  try {
    final decoded = GenericMultipleBarcodeReader(MultiFormatReader())
        .decodeMultiple(bitmap, const DecodeHint(alsoInverted: true));
    return decoded
        .where((result) => result.text.trim().isNotEmpty)
        .map((result) => (
              value: result.text,
              format: result.barcodeFormat.name,
            ))
        .toList(growable: false);
  } on NotFoundException {
    return const [];
  }
}
