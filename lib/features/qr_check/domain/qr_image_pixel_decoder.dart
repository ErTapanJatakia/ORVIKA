import 'dart:typed_data';

import 'package:zxing_lib/common.dart';
import 'package:zxing_lib/multi.dart';
import 'package:zxing_lib/zxing.dart';

import 'qr_image_decoder.dart';

/// Decodes RGBA pixels with the bundled, pure-Dart ZXing fallback.
///
/// Several local luminance interpretations are attempted because colourful
/// codes can have poor contrast after a conventional RGB-to-gray conversion.
/// No image data leaves the current process.
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

  final channels = <int>[0, 1, 2, -1];
  final results = <String, QrImageCode>{};

  for (final channel in channels) {
    final pixels = Int32List(pixelCount);
    var minValue = 255;
    var maxValue = 0;

    for (var index = 0; index < pixelCount; index++) {
      final offset = index * 4;
      final alpha = rgba[offset + 3];
      final red = _composite(rgba[offset], alpha);
      final green = _composite(rgba[offset + 1], alpha);
      final blue = _composite(rgba[offset + 2], alpha);
      final value = switch (channel) {
        0 => red,
        1 => green,
        2 => blue,
        _ => (red * 299 + green * 587 + blue * 114) ~/ 1000,
      };
      if (value < minValue) minValue = value;
      if (value > maxValue) maxValue = value;
      pixels[index] = 0xff000000 | (value << 16) | (value << 8) | value;
    }

    // Stretch luminance to the full range when a photograph or design has
    // compressed contrast. Avoid amplifying essentially flat images.
    if (maxValue - minValue >= 24) {
      final range = maxValue - minValue;
      for (var index = 0; index < pixelCount; index++) {
        final value = pixels[index] & 0xff;
        final stretched = ((value - minValue) * 255 ~/ range).clamp(0, 255).toInt();
        pixels[index] =
            0xff000000 | (stretched << 16) | (stretched << 8) | stretched;
      }
    }

    final bitmap = BinaryBitmap(
      HybridBinarizer(RGBLuminanceSource(width, height, pixels)),
    );

    try {
      final decoded = GenericMultipleBarcodeReader(MultiFormatReader())
          .decodeMultiple(
        bitmap,
        const DecodeHint(alsoInverted: true, tryHarder: true),
      );
      for (final result in decoded) {
        if (result.text.trim().isEmpty) continue;
        final code = (
          value: result.text,
          format: result.barcodeFormat.name,
        );
        results.putIfAbsent('${code.format}: ${code.value}', () => code);
      }
      if (results.isNotEmpty) break;
    } on NotFoundException {
      // Try the next channel/contrast interpretation before giving up.
    }
  }

  return results.values.toList(growable: false);
}

int _composite(int value, int alpha) =>
    (value * alpha + 255 * (255 - alpha)) ~/ 255;
