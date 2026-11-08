import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';

Finder _featureScrollable() => find.descendant(
      of: find.byType(MessageCheckScreen),
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
      'Message Check remains usable across narrow, tablet and desktop widths',
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
          key: ValueKey('message-check-$width'),
          home: const MessageCheckScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pause. Inspect. Then respond.'), findsOneWidget,
          reason: 'heading should remain available at width $width');
      expect(find.byType(TextField), findsOneWidget,
          reason: 'message input should remain available at width $width');
      expect(find.text('Inspect message'), findsOneWidget,
          reason: 'inspection action should remain available at width $width');
      expect(
        tester.getSize(find.byType(ListView)).width,
        lessThanOrEqualTo(760),
        reason: 'content width should remain readable at width $width',
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).maxLength,
        10000,
      );
      expect(tester.takeException(), isNull,
          reason: 'Message Check layout overflow at width $width');

      await _reveal(tester, find.byType(TextField));
      await tester.enterText(
        find.byType(TextField),
        'URGENT: Share your OTP immediately at https://example.test',
      );
      await _reveal(tester, find.text('Inspect message'));
      await tester.tap(find.text('Inspect message'));
      await tester.pumpAndSettle();
      await _reveal(tester, find.text('OTP or authentication-code reference'));

      expect(find.text('OTP or authentication-code reference'), findsOneWidget,
          reason: 'analysis finding should render at width $width');
      expect(find.text('Link or web address detected'), findsOneWidget,
          reason: 'detected-link finding should render at width $width');
      expect(find.text('https://example.test'), findsOneWidget,
          reason: 'detected address should remain readable at width $width');
      expect(find.textContaining('No message was uploaded'), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Message Check result overflow at width $width');
    }
  });

  testWidgets('Message Check supports RTL and 200 percent text scaling',
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
            child: MessageCheckScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final headingContext =
        tester.element(find.text('Pause. Inspect. Then respond.'));
    expect(Directionality.of(headingContext), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(headingContext).scale(10), 20);

    await _reveal(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField),
        'URGENT: Share your OTP immediately.');
    await _reveal(tester, find.text('Inspect message'));
    await tester.tap(find.text('Inspect message'));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('OTP or authentication-code reference'));

    expect(find.text('OTP or authentication-code reference'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
