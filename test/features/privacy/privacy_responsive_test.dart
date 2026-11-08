import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Privacy self-audit stays readable across phone, tablet and desktop widths',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [
      280.0,
      320.0,
      360.0,
      390.0,
      430.0,
      600.0,
      760.0,
      1024.0,
      1920.0,
    ]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey('privacy-$width'),
          home: const PrivacyScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Take control of your privacy.'), findsOneWidget);
      expect(find.text('0 of 12 practices reviewed'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(
        tester.getSize(find.byType(ListView)).width,
        lessThanOrEqualTo(760),
        reason: 'Privacy content should be constrained at width $width',
      );
      expect(tester.takeException(), isNull,
          reason: 'Privacy layout overflow at width $width');
    }
  });

  testWidgets('Privacy guidance and review control remain usable on a narrow screen',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: PrivacyScreen()));
    await tester.pumpAndSettle();

    final firstPractice = find.text('Use unique passwords for important accounts');
    await tester.ensureVisible(firstPractice);
    await tester.tap(firstPractice);
    await tester.pumpAndSettle();

    expect(find.text('WHY IT MATTERS'), findsOneWidget);
    expect(find.text('WHAT YOU CAN DO'), findsOneWidget);
    expect(find.text('IMPORTANT LIMIT'), findsOneWidget);

    final review = find.byType(CheckboxListTile).first;
    await tester.ensureVisible(review);
    await tester.tap(review);
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, 1200));
    await tester.pumpAndSettle();
    expect(find.text('1 of 12 practices reviewed'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getStringList('privacy.reviewed.v1'),
      contains('account-unique-passwords'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Privacy screen supports RTL and 200 percent text scaling',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: PrivacyScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final heading = find.text('Take control of your privacy.');
    expect(heading, findsOneWidget);
    expect(Directionality.of(tester.element(heading)), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(tester.element(heading)).scale(10), 20);
    expect(tester.takeException(), isNull);
  });
}
