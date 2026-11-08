import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'qr_image_decoder.dart';

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

Future<List<QrImageCode>> decodeQrImage({
  required Uint8List bytes,
  required String path,
}) async {
  if (bytes.isEmpty) {
    throw const FormatException('The selected image is empty.');
  }

  String? objectUrl;
  try {
    final detector = _BarcodeDetector();
    final blob = web.Blob(
      [bytes.toJS].toJS,
      web.BlobPropertyBag(type: _mimeType(path)),
    );
    objectUrl = web.URL.createObjectURL(blob);
    final image = web.document.createElement('img') as web.HTMLImageElement;
    image.src = objectUrl;
    await image.decode().toDart;

    final detected = await detector.detect(image).toDart;
    return detected.toDart
        .where((barcode) => barcode.rawValue.toDart.trim().isNotEmpty)
        .map((barcode) => (
              value: barcode.rawValue.toDart,
              format: barcode.format.toDart,
            ))
        .toList(growable: false);
  } on JSException {
    throw UnsupportedError(
      'This browser does not provide image barcode detection. Try a supported browser or use live camera scanning.',
    );
  } finally {
    if (objectUrl != null) web.URL.revokeObjectURL(objectUrl);
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
