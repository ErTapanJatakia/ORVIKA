import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';

Finder _featureScrollable() => find.descendant(
      of: find.byType(IntelligenceScreen),
      matching: find.byType(Scrollable),
    ).first;

Future<void> _reveal(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    180,
    scrollable: _featureScrollable(),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'Intelligence remains readable and usable across narrow, tablet and desktop widths',
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
          key: ValueKey('intelligence-$width'),
          home: const IntelligenceScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Understand the signal.'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('OFFLINE REFERENCE'), findsOneWidget);
      expect(find.text('10 reference entries'), findsOneWidget);
      expect(
        tester.getSize(find.byType(ListView)).width,
        lessThanOrEqualTo(760),
        reason: 'Intelligence content should remain constrained at width $width',
      );
      expect(tester.takeException(), isNull,
          reason: 'Intelligence layout overflow at width $width');

      await _reveal(tester, find.text('Internationalised domain / Punycode'));
      await tester.tap(find.text('Internationalised domain / Punycode'));
      await tester.pumpAndSettle();
      expect(find.text('WHAT TO NOTICE'), findsOneWidget);
      expect(find.textContaining('xn--'), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Expanded Intelligence entry overflow at width $width');
    }
  });

  testWidgets('Intelligence search, category filters and empty state remain usable',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: IntelligenceScreen()),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Punycode');
    await tester.pumpAndSettle();
    expect(find.text('1 reference entries'), findsOneWidget);
    expect(find.text('Internationalised domain / Punycode'), findsOneWidget);

    await tester.tap(find.text('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('10 reference entries'), findsOneWidget);

    await tester.tap(find.text('QR codes'));
    await tester.pumpAndSettle();
    expect(find.text('2 reference entries'), findsOneWidget);
    expect(find.text('QR payment request'), findsOneWidget);
    expect(find.text('Unencrypted HTTP'), findsNothing);

    await tester.enterText(find.byType(TextField), 'no-such-indicator');
    await tester.pumpAndSettle();
    expect(find.text('0 reference entries'), findsOneWidget);
    expect(find.textContaining('No matching indicators'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Intelligence supports RTL and 200 percent text scaling',
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
            child: IntelligenceScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final headingContext = tester.element(find.text('Understand the signal.'));
    expect(Directionality.of(headingContext), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(headingContext).scale(10), 20);
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
