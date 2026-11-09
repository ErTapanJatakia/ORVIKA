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
      final rgba = _toRgba(matrix);

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
      final rgba = _toRgba(matrix);

      final results = decodeQrImagePixels(
        width: matrix.width,
        height: matrix.height,
        rgba: rgba,
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
