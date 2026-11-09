import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const viewports = <({double width, double height, double textScale})>[
    (width: 320, height: 640, textScale: 1.0),
    (width: 360, height: 800, textScale: 1.0),
    (width: 390, height: 844, textScale: 2.0),
    (width: 600, height: 900, textScale: 1.0),
    (width: 768, height: 1024, textScale: 1.5),
    (width: 1024, height: 768, textScale: 1.0),
    (width: 1440, height: 900, textScale: 1.0),
    (width: 844, height: 390, textScale: 1.0),
  ];

  testWidgets('dashboard remains usable across compact, tablet, desktop and landscape viewports',
      (tester) async {
    tester.view.devicePixelRatio = 2;
    for (final viewport in viewports) {
      tester.view.physicalSize = Size(
        viewport.width * 2,
        viewport.height * 2,
      );
      SharedPreferences.setMockInitialValues({
        'onboarding.completed.v1': true,
        'appearance.language': 'en',
        'accessibility.textScale': viewport.textScale,
      });

      await tester.pumpWidget(const OrvikaApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Your safety toolkit'),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Your safety toolkit'), findsOneWidget,
          reason: 'Dashboard heading missing at ${viewport.width}x${viewport.height}');
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Layout exception at ${viewport.width}x${viewport.height}');

      await tester.ensureVisible(find.text('Link Check'));
      await tester.pumpAndSettle();
      expect(find.text('Inspect website addresses before you open them.'),
          findsOneWidget,
          reason: 'Module description missing at ${viewport.width}x${viewport.height}');
      expect(tester.takeException(), isNull,
          reason: 'Module-card layout exception at ${viewport.width}x${viewport.height}');

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -6000));
      await tester.pumpAndSettle();
      expect(find.textContaining('ORVIKA is an early prototype'), findsOneWidget,
          reason: 'Trust note/footer area unreachable at ${viewport.width}x${viewport.height}');
      expect(tester.takeException(), isNull,
          reason: 'Scroll/footer exception at ${viewport.width}x${viewport.height}');
    }

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
