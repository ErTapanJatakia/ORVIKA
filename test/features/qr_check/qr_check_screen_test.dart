import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';

Finder _featureScrollable() => find.descendant(
      of: find.byType(QrCheckScreen),
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
  testWidgets('QR Check remains usable across narrow, tablet and desktop widths',
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
          key: ValueKey('qr-check-$width'),
          home: const QrCheckScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Look before you scan.'), findsOneWidget,
          reason: 'heading should remain available at width $width');
      expect(find.byType(TextField), findsOneWidget,
          reason: 'decoded payload input should remain available at width $width');
      expect(find.text('Inspect QR content'), findsOneWidget,
          reason: 'inspection action should remain available at width $width');
      expect(
        tester.getSize(find.byType(ListView)).width,
        lessThanOrEqualTo(760),
        reason: 'content width should remain readable at width $width',
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).maxLength,
        8192,
        reason: 'the input should enforce the analyzer payload limit',
      );
      expect(tester.takeException(), isNull,
          reason: 'QR Check layout overflow at width $width');

      await _reveal(tester, find.byType(TextField));
      await tester.enterText(
        find.byType(TextField),
        r'WIFI:T:WPA;S:Office;P:example-password;;',
      );
      await _reveal(tester, find.text('Inspect QR content'));
      await tester.tap(find.text('Inspect QR content'));
      await tester.pumpAndSettle();
      await _reveal(tester, find.text('Wi-Fi configuration'));

      expect(find.text('Wi-Fi configuration'), findsOneWidget,
          reason: 'inspection result should render at width $width');
      expect(find.textContaining('will not connect automatically'), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'QR Check result overflow at width $width');
    }
  });

  testWidgets('QR Check remains usable with RTL and 200 percent text scaling',
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
            child: QrCheckScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final headingContext = tester.element(find.text('Look before you scan.'));
    expect(Directionality.of(headingContext), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(headingContext).scale(10), 20);

    await _reveal(tester, find.byType(TextField));
    await tester.enterText(
      find.byType(TextField),
      'upi://pay?pa=merchant@example&pn=Merchant',
    );
    await _reveal(tester, find.text('Inspect QR content'));
    expect(find.text('Inspect QR content'), findsOneWidget);
    await tester.tap(find.text('Inspect QR content'));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('UPI payment request'));

    expect(find.text('UPI payment request'), findsOneWidget);
    expect(find.textContaining('will not initiate or approve a payment'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
