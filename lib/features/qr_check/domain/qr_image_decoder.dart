import 'dart:typed_data';

import 'qr_image_decoder_native.dart'
    if (dart.library.js_interop) 'qr_image_decoder_web.dart' as platform;

typedef QrImageCode = ({String value, String format});

Future<List<QrImageCode>> decodeQrImage({
  required Uint8List bytes,
  required String path,
}) {
  return platform.decodeQrImage(bytes: bytes, path: path);
}
