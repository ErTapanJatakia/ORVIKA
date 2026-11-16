import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';

void main() {
  Future<void> expectLiveResultAnnouncement(
    WidgetTester tester, {
    required Widget screen,
    required String input,
    required String action,
  }) async {
    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.enterText(find.byType(TextField), input);
    await tester.tap(find.text(action));
    await tester.pumpAndSettle();

    final announcement = find.byWidgetPredicate(
      (widget) => widget is Semantics && widget.properties.liveRegion,
      description: 'a live-region result announcement',
    );
    expect(announcement, findsOneWidget);

    final semantics = tester.widget<Semantics>(announcement);
    expect(semantics.properties.label, isNotNull);
    expect(semantics.properties.label, isNotEmpty);
    expect(tester.takeException(), isNull);
  }

  testWidgets('Link Check announces completed analysis to assistive technology',
      (tester) async {
    await expectLiveResultAnnouncement(
      tester,
      screen: const LinkCheckScreen(),
      input: 'https://example.com',
      action: 'Analyse address',
    );
  });

  testWidgets('QR Check announces decoded-content assessment to assistive technology',
      (tester) async {
    await expectLiveResultAnnouncement(
      tester,
      screen: const QrCheckScreen(),
      input: 'https://example.com',
      action: 'Inspect QR content',
    );
  });

  testWidgets('Message Check announces completed inspection to assistive technology',
      (tester) async {
    await expectLiveResultAnnouncement(
      tester,
      screen: const MessageCheckScreen(),
      input: 'Your account will be suspended. Verify immediately at https://example.com',
      action: 'Inspect message',
    );
  });
}
