import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({
        'onboarding.completed.v1': true,
      }));

  testWidgets('Message Check opens and explains social-engineering signals',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Message Check'));
    await tester.tap(find.text('Message Check'));
    await tester.pumpAndSettle();

    expect(find.text('Pause. Inspect. Then respond.'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'URGENT: Your account sign-in is blocked. Share your OTP immediately at https://example.test',
    );
    await tester.tap(find.text('Inspect message'));
    await tester.pumpAndSettle();

    expect(find.text('OTP or authentication-code reference'), findsOneWidget);
    expect(find.text('Urgency or pressure language'), findsOneWidget);
    expect(find.text('Link or web address detected'), findsOneWidget);
    expect(find.textContaining('No message was uploaded'), findsOneWidget);
  });
}
