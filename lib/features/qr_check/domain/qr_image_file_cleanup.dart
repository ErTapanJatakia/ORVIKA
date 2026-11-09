import 'qr_image_file_cleanup_stub.dart'
    if (dart.library.io) 'qr_image_file_cleanup_io.dart' as platform;

/// Deletes the picker-created temporary file on native platforms.
/// Browser-selected files are managed by the browser and need no file deletion.
Future<void> deleteTemporaryQrImage(String path) =>
    platform.deleteTemporaryQrImage(path);
