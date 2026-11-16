import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const scenarios = <({Size size, double textScale})>[
    (size: Size(320, 720), textScale: 1),
    (size: Size(360, 800), textScale: 2),
    (size: Size(390, 844), textScale: 2),
    (size: Size(560, 900), textScale: 1.5),
    (size: Size(768, 1024), textScale: 2),
    (size: Size(1280, 900), textScale: 1),
  ];

  for (final scenario in scenarios) {
    testWidgets(
      'brand header and hero remain within ${scenario.size.width.toInt()}px at ${scenario.textScale}x text scale',
      (tester) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = scenario.size;
        SharedPreferences.setMockInitialValues({
          'onboarding.completed.v1': true,
          'appearance.language': 'en',
          'accessibility.textScale': scenario.textScale,
        });

        await tester.pumpWidget(const OrvikaApp());
        await tester.pumpAndSettle();

        final brand = find.text('ORVIKA').first;
        expect(find.text('ORVIKA'), findsWidgets);
        final brandText = tester.widget<Text>(brand);
        expect(brandText.maxLines, 1);
        expect(brandText.softWrap, isFalse);

        final brandFit = find.ancestor(of: brand, matching: find.byType(FittedBox)).first;
        expect(tester.getSize(brandFit).width, lessThanOrEqualTo(130));

        final heroHeading = find.textContaining('Check before');
        expect(heroHeading, findsOneWidget);
        final heroRect = tester.getRect(heroHeading);
        expect(heroRect.left, greaterThanOrEqualTo(0));
        expect(heroRect.right, lessThanOrEqualTo(scenario.size.width));

        expect(
          tester.takeException(),
          isNull,
          reason: 'Dashboard layout failed at ${scenario.size.width} and ${scenario.textScale}x',
        );
      },
    );
  }
}
