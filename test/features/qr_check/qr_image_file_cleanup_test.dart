import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/qr_check/domain/qr_image_file_cleanup.dart';

void main() {
  group('deleteTemporaryQrImage', () {
    test('deletes the picker-created temporary image file', () async {
      final directory = await Directory.systemTemp.createTemp('orvika-qr-cleanup-');
      addTearDown(() => directory.delete(recursive: true));
      final image = File('${directory.path}/selected-image.jpg');
      await image.writeAsBytes(<int>[0xff, 0xd8, 0xff]);

      await deleteTemporaryQrImage(image.path);

      expect(await image.exists(), isFalse);
    });

    test('is safe for empty and already-missing paths', () async {
      final directory = await Directory.systemTemp.createTemp('orvika-qr-cleanup-');
      addTearDown(() => directory.delete(recursive: true));
      final missing = File('${directory.path}/missing-image.jpg');

      await expectLater(deleteTemporaryQrImage(''), completes);
      await expectLater(deleteTemporaryQrImage(missing.path), completes);
    });
  });
}
