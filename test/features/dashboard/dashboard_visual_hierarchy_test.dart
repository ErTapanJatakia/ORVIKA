import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('brand identity remains readable and bounded on narrow screens',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;

    for (final width in [320.0, 360.0, 390.0]) {
      tester.view.physicalSize = Size(width, 800);
      SharedPreferences.setMockInitialValues({
        'appearance.language': 'en',
        'onboarding.completed.v1': true,
      });

      await tester.pumpWidget(OrvikaApp(key: ValueKey('brand-$width')));
      await tester.pumpAndSettle();

      final wordmark = find.text('ORVIKA').first;
      expect(find.text('ORVIKA'), findsWidgets);
      final rect = tester.getRect(wordmark);
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(width));

      final brandHeading = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.header == true &&
            widget.properties.label ==
                'ORVIKA — Personal Cyber Safety Intelligence',
      );
      expect(brandHeading, findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('dashboard hero and toolkit remain distinct semantic headings',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    SharedPreferences.setMockInitialValues({'appearance.language': 'en', 'onboarding.completed.v1': true});

    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Check before'), findsOneWidget);
    expect(find.text('Your safety toolkit'), findsOneWidget);
    expect(find.textContaining('Eight focused capabilities'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
