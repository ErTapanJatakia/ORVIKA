import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true}));

  testWidgets('first launch presents branded onboarding and enters dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('Check before you trust.'), findsOneWidget);
    expect(find.byType(OrvikaOwlMark), findsWidgets);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Understand the risk.'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your data stays yours.'), findsOneWidget);

    await tester.tap(find.text('Enter ORVIKA'));
    await tester.pumpAndSettle();
    expect(find.text('Your safety toolkit'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('onboarding.completed.v1'), isTrue);
  });

  testWidgets('completed onboarding is not shown on the next launch', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('Your safety toolkit'), findsOneWidget);
    expect(find.text('Check before you trust.'), findsNothing);
  });

  testWidgets('Skip completes onboarding without requiring all slides', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Your safety toolkit'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('onboarding.completed.v1'), isTrue);
  });

  testWidgets('ORVIKA dashboard presents its visual identity and core modules', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('ORVIKA'), findsOneWidget);
    expect(find.text('Check before\nyou trust.'), findsOneWidget);
    expect(find.byType(OrvikaOwlMark), findsWidgets);
    expect(find.text('Sentinel'), findsOneWidget);
    expect(find.text('Link Check'), findsOneWidget);
    expect(find.text('QR Check'), findsOneWidget);
    expect(find.text('Message Check'), findsOneWidget);
    expect(find.text('Intelligence'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);
    expect(find.text('Academy'), findsOneWidget);
    expect(find.text('Response'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.textContaining('ORVIKA is an early prototype'), findsOneWidget);
  });

  testWidgets('theme selector switches to the Daylight palette', (tester) async {
    await tester.pumpWidget(const OrvikaApp());

    await tester.tap(find.byTooltip('Choose visual theme'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Daylight').last);
    await tester.pumpAndSettle();

    expect(find.text('Daylight'), findsOneWidget);
    expect(Theme.of(tester.element(find.text('Your safety toolkit'))).brightness, Brightness.light);
  });


  testWidgets('appearance settings saves and restores the selected theme', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.tap(find.byTooltip('Appearance and accessibility settings'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your visual environment'), findsOneWidget);
    await tester.tap(find.text('Daylight'));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('appearance.theme'), 'daylight');

    await tester.pumpWidget(const OrvikaApp(key: ValueKey('restarted-app')));
    await tester.pumpAndSettle();
    expect(find.text('Daylight'), findsOneWidget);
    expect(Theme.of(tester.element(find.text('Your safety toolkit'))).brightness,
      Brightness.light);
  });

  testWidgets('QR Check opens and inspects a payment payload without initiating it', (tester) async {
    await tester.pumpWidget(const OrvikaApp());

    await tester.ensureVisible(find.text('QR Check'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('QR Check'));
    await tester.pumpAndSettle();

    expect(find.text('Inspect QR content'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'upi://pay?pa=merchant@example&pn=Merchant',
    );
    await tester.tap(find.text('Inspect QR content'));
    await tester.pumpAndSettle();

    expect(find.text('UPI payment request'), findsOneWidget);
    expect(find.textContaining('will not initiate or approve a payment'), findsOneWidget);
  });
}
