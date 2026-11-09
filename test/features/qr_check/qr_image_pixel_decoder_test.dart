import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/qr_check/domain/qr_image_pixel_decoder.dart';
import 'package:zxing_lib/common.dart';
import 'package:zxing_lib/zxing.dart';

void main() {
  group('bundled Web image decoder', () {
    test('decodes QR codes without browser BarcodeDetector support', () {
      const payload = 'https://orvika.example/check';
      final matrix = MultiFormatWriter().encode(
        payload,
        BarcodeFormat.qrCode,
        256,
        256,
      );

      final results = decodeQrImagePixels(
        width: matrix.width,
        height: matrix.height,
        rgba: _toRgba(matrix),
      );

      expect(results, hasLength(1));
      expect(results.single.value, payload);
      expect(results.single.format, 'qrCode');
    });

    test('decodes colourful QR modules using channel-specific contrast', () {
      const payload = 'ORVIKA-COLOUR-QR';
      final matrix = MultiFormatWriter().encode(
        payload,
        BarcodeFormat.qrCode,
        320,
        320,
      );
      final rgba = _toColourRgba(matrix);

      final results = decodeQrImagePixels(
        width: matrix.width,
        height: matrix.height,
        rgba: rgba,
      );

      expect(results, hasLength(1));
      expect(results.single.value, payload);
      expect(results.single.format, 'qrCode');
    });

    test('decodes a linear Code 128 barcode', () {
      const payload = 'ORVIKA-123456';
      final matrix = MultiFormatWriter().encode(
        payload,
        BarcodeFormat.code128,
        420,
        140,
      );

      final results = decodeQrImagePixels(
        width: matrix.width,
        height: matrix.height,
        rgba: _toRgba(matrix),
      );

      expect(results, hasLength(1));
      expect(results.single.value, payload);
      expect(results.single.format, 'code128');
    });

    test('rejects pixel buffers whose dimensions do not match', () {
      expect(
        () => decodeQrImagePixels(
          width: 2,
          height: 2,
          rgba: Uint8List(4),
        ),
        throwsFormatException,
      );
    });
  });
}

Uint8List _toRgba(BitMatrix matrix) {
  final rgba = Uint8List(matrix.width * matrix.height * 4);
  for (var y = 0; y < matrix.height; y++) {
    for (var x = 0; x < matrix.width; x++) {
      final value = matrix.get(x, y) ? 0 : 255;
      final offset = (y * matrix.width + x) * 4;
      rgba[offset] = value;
      rgba[offset + 1] = value;
      rgba[offset + 2] = value;
      rgba[offset + 3] = 255;
    }
  }
  return rgba;
}

Uint8List _toColourRgba(BitMatrix matrix) {
  final rgba = Uint8List(matrix.width * matrix.height * 4);
  for (var y = 0; y < matrix.height; y++) {
    for (var x = 0; x < matrix.width; x++) {
      final offset = (y * matrix.width + x) * 4;
      // A green background and magenta modules have weak luminance contrast
      // but strong individual-channel contrast.
      if (matrix.get(x, y)) {
        rgba[offset] = 255;
        rgba[offset + 1] = 0;
        rgba[offset + 2] = 255;
      } else {
        rgba[offset] = 0;
        rgba[offset + 1] = 255;
        rgba[offset + 2] = 0;
      }
      rgba[offset + 3] = 255;
    }
  }
  return rgba;
}
