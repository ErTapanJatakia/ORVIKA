import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _scrollUntilBuilt(
  WidgetTester tester,
  Finder scrollView,
  Finder target, {
  int maxAttempts = 24,
}) async {
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    if (target.evaluate().isNotEmpty) return;
    await tester.drag(scrollView, const Offset(0, -420));
    await tester.pumpAndSettle();
  }
  expect(
    target,
    findsOneWidget,
    reason: 'Dashboard content was not built after deterministic outer-scroll increments.',
  );
}

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

  testWidgets(
    'dashboard content remains reachable across responsive viewports',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
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

        await tester.pumpWidget(OrvikaApp(
          key: ValueKey('viewport-${viewport.width}-${viewport.height}'),
        ));
        await tester.pumpAndSettle();

        expect(
          find.byType(SentinelDashboard),
          findsOneWidget,
          reason: 'Dashboard did not load at ${viewport.width}x${viewport.height}',
        );
        final scrollView = find.byType(CustomScrollView);
        expect(
          scrollView,
          findsOneWidget,
          reason: 'Expected one dashboard scroll surface at ${viewport.width}x${viewport.height}',
        );

        // Increment the outer dashboard scroll until each lazy sliver target
        // is mounted. This avoids relying on nested Scrollable discovery.
        final heading = find.text('Your safety toolkit');
        await _scrollUntilBuilt(tester, scrollView, heading);
        expect(heading, findsOneWidget);

        final moduleDescription =
            find.text('Inspect website addresses before you open them.');
        await _scrollUntilBuilt(tester, scrollView, moduleDescription);
        expect(
          moduleDescription,
          findsOneWidget,
          reason: 'Link Check description missing at ${viewport.width}x${viewport.height}',
        );
        expect(
          tester.takeException(),
          isNull,
          reason: 'Dashboard or module layout exception at ${viewport.width}x${viewport.height}',
        );

        await tester.drag(scrollView, const Offset(0, -10000));
        await tester.pumpAndSettle();
        final trustNote = find.textContaining('ORVIKA is an early prototype');
        await _scrollUntilBuilt(tester, scrollView, trustNote);
        expect(
          trustNote,
          findsOneWidget,
          reason: 'Trust note/footer was not reachable at ${viewport.width}x${viewport.height}',
        );
        expect(
          tester.takeException(),
          isNull,
          reason: 'Scroll/footer layout exception at ${viewport.width}x${viewport.height}',
        );
      }
    },
  );
}
