import 'dart:js_interop';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'qr_image_decoder.dart';
import 'qr_image_pixel_decoder.dart';

@JS('BarcodeDetector')
extension type _BarcodeDetector._(JSObject _) implements JSObject {
  external factory _BarcodeDetector();
  external JSPromise<JSArray<_DetectedBarcode>> detect(JSAny source);
}

@JS()
extension type _DetectedBarcode._(JSObject _) implements JSObject {
  external JSString get rawValue;
  external JSString get format;
}

const int _maxDecodePixels = 8 * 1024 * 1024;

Future<List<QrImageCode>> decodeQrImage({
  required Uint8List bytes,
  required String path,
}) async {
  if (bytes.isEmpty) {
    throw const FormatException('The selected image is empty.');
  }

  String? objectUrl;
  try {
    final blob = web.Blob(
      [bytes.toJS].toJS,
      web.BlobPropertyBag(type: _mimeType(path)),
    );
    objectUrl = web.URL.createObjectURL(blob);
    final image = web.document.createElement('img') as web.HTMLImageElement;
    image.src = objectUrl;
    try {
      await image.decode().toDart;
    } catch (_) {
      throw const FormatException(
        'This browser could not read the selected image format. Try a PNG or JPEG image.',
      );
    }

    // Use the native API when available, but never make it a requirement.
    final nativeResults = await _tryNativeBarcodeDetector(image);
    if (nativeResults.isNotEmpty) return nativeResults;

    final sourceWidth = image.naturalWidth;
    final sourceHeight = image.naturalHeight;
    if (sourceWidth <= 0 || sourceHeight <= 0) {
      throw const FormatException('The selected image has invalid dimensions.');
    }

    // Bound memory and CPU use for very large camera/gallery images.
    final sourcePixels = sourceWidth * sourceHeight;
    final scale = sourcePixels > _maxDecodePixels
        ? math.sqrt(_maxDecodePixels / sourcePixels)
        : 1.0;
    final decodeWidth = math.max(1, (sourceWidth * scale).floor()).toInt();
    final decodeHeight = math.max(1, (sourceHeight * scale).floor()).toInt();

    final canvas = web.document.createElement('canvas') as web.HTMLCanvasElement;
    canvas.width = decodeWidth;
    canvas.height = decodeHeight;
    final rawContext = canvas.getContext('2d');
    if (rawContext == null) {
      throw const FormatException('The browser could not prepare this image for scanning.');
    }
    final context = rawContext as web.CanvasRenderingContext2D;
    context.drawImage(
      image,
      0,
      0,
      decodeWidth.toDouble(),
      decodeHeight.toDouble(),
    );
    final rgba = context
        .getImageData(0, 0, decodeWidth, decodeHeight)
        .data
        .toDart;

    return decodeQrImagePixels(
      width: decodeWidth,
      height: decodeHeight,
      rgba: rgba,
    );
  } on FormatException {
    rethrow;
  } catch (_) {
    throw const FormatException(
      'This image could not be decoded on this browser. Try another image.',
    );
  } finally {
    if (objectUrl != null) web.URL.revokeObjectURL(objectUrl);
  }
}

Future<List<QrImageCode>> _tryNativeBarcodeDetector(
  web.HTMLImageElement image,
) async {
  try {
    final detector = _BarcodeDetector();
    final detected = await detector.detect(image).toDart;
    return detected.toDart
        .where((barcode) => barcode.rawValue.toDart.trim().isNotEmpty)
        .map((barcode) => (
              value: barcode.rawValue.toDart,
              format: barcode.format.toDart,
            ))
        .toList(growable: false);
  } catch (_) {
    // Missing API, unsupported formats and native decode errors all fall back
    // to the bundled pure-Dart decoder below.
    return const [];
  }
}

String _mimeType(String path) {
  final name = path.toLowerCase();
  if (name.endsWith('.png')) return 'image/png';
  if (name.endsWith('.webp')) return 'image/webp';
  if (name.endsWith('.gif')) return 'image/gif';
  if (name.endsWith('.bmp')) return 'image/bmp';
  if (name.endsWith('.avif')) return 'image/avif';
  if (name.endsWith('.heic')) return 'image/heic';
  if (name.endsWith('.heif')) return 'image/heif';
  if (name.endsWith('.tif') || name.endsWith('.tiff')) return 'image/tiff';
  return 'image/jpeg';
}
