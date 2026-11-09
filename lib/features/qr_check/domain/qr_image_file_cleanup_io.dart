import 'dart:io';

Future<void> deleteTemporaryQrImage(String path) async {
  if (path.isEmpty) return;
  try {
    final file = File(path);
    if (await file.exists()) await file.delete();
  } on FileSystemException {
    // Cache cleanup is best-effort; never block QR inspection or navigation.
  }
}
