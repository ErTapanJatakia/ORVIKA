import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/accessibility/presentation/wcag_conformance_badge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Wcag22AaBadge', () {
    testWidgets('renders the bundled asset rather than a network image',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Wcag22AaBadge(),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
      expect((image.image as AssetImage).assetName, Wcag22AaBadge.assetPath);
      expect(image.width, 88);
      expect(image.height, 31);
    });

    test('bundled badge is a valid 368 by 130 PNG', () async {
      final data = await rootBundle.load(Wcag22AaBadge.assetPath);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      expect(
        bytes.take(8).toList(),
        <int>[137, 80, 78, 71, 13, 10, 26, 10],
      );

      final pngHeader = ByteData.sublistView(data);
      expect(pngHeader.getUint32(16, Endian.big), 368);
      expect(pngHeader.getUint32(20, Endian.big), 130);
    });

    testWidgets('exposes a clear non-certification semantics label',
        (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Wcag22AaBadge(),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label?.contains('not W3C certification') ==
                  true,
        ),
        findsOneWidget,
      );
      semantics.dispose();
    });
  });
}
