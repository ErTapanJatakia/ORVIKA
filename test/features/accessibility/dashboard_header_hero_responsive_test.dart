import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final viewport in <Size>[
    const Size(320, 720),
    const Size(390, 844),
    const Size(768, 1024),
    const Size(1280, 900),
  ]) {
    testWidgets(
      'dashboard header and hero render without layout exceptions at ${viewport.width.toInt()}px',
      (tester) async {
        SharedPreferences.setMockInitialValues({
          'onboarding.completed.v1': true,
          'appearance.language': 'en',
        });
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = viewport;

        await tester.pumpWidget(const OrvikaApp());
        await tester.pumpAndSettle();

        expect(find.text('ORVIKA'), findsOneWidget);
        expect(find.textContaining('Check before'), findsOneWidget);
        expect(
          find.text('PERSONAL CYBER SAFETY INTELLIGENCE'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      },
    );
  }
}
