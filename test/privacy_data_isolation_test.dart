import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Security-analysis input persistence boundary', () {
    testWidgets('does not persist a submitted URL or its query parameters',
        (tester) async {
      const sensitiveInput =
          'https://example.test/verify?session=private-session-marker';

      await tester.pumpWidget(
        const MaterialApp(home: LinkCheckScreen()),
      );
      await tester.enterText(find.byType(TextField), sensitiveInput);
      await tester.tap(find.text('Analyse address'));
      await tester.pumpAndSettle();

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getKeys(), isEmpty);
    });

    testWidgets('does not persist decoded QR payment content', (tester) async {
      const sensitiveInput =
          'upi://pay?pa=private-payee-marker@example.test&am=12345.67';

      await tester.pumpWidget(
        const MaterialApp(home: QrCheckScreen()),
      );
      await tester.enterText(find.byType(TextField), sensitiveInput);
      await tester.tap(find.text('Inspect QR content'));
      await tester.pumpAndSettle();

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getKeys(), isEmpty);
    });

    testWidgets('does not persist submitted message text or embedded tokens',
        (tester) async {
      const sensitiveInput =
          'Your OTP private-otp-marker is 123456. Visit https://example.test';

      await tester.pumpWidget(
        const MaterialApp(home: MessageCheckScreen()),
      );
      await tester.enterText(find.byType(TextField), sensitiveInput);
      await tester.tap(find.text('Inspect message'));
      await tester.pumpAndSettle();

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getKeys(), isEmpty);
    });
  });
}
