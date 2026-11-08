import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/academy/presentation/academy_screen.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';
import 'package:orvika/features/response/presentation/response_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('feature screen titles are exposed as semantic headings',
      (tester) async {
    final semantics = tester.ensureSemantics();

    final cases = <(Widget, String)>[
      (const LinkCheckScreen(), 'Inspect before you connect.'),
      (const QrCheckScreen(), 'Look before you scan.'),
      (const MessageCheckScreen(), 'Pause. Inspect. Then respond.'),
      (const IntelligenceScreen(), 'Understand the signal.'),
      (const PrivacyScreen(), 'Take control of your privacy.'),
      (const AcademyScreen(), 'Build safer digital habits.'),
      (const ResponseScreen(), 'Know your next step.'),
    ];

    for (final (screen, heading) in cases) {
      if (screen is PrivacyScreen || screen is AcademyScreen) {
        SharedPreferences.setMockInitialValues({});
      }
      await tester.pumpWidget(MaterialApp(home: screen));
      await tester.pumpAndSettle();

      final headingSemantics = tester.getSemantics(find.text(heading));
      expect(
        headingSemantics.flagsCollection.isHeader,
        isTrue,
        reason: '$heading should be exposed as a heading',
      );
    }
    semantics.dispose();
  });

  testWidgets('Link Check announces newly available analysis results',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(home: LinkCheckScreen()));

    await tester.enterText(find.byType(TextField), 'http://example.com');
    await tester.tap(find.text('Analyse address'));
    await tester.pumpAndSettle();

    final announcement = find.bySemanticsLabel(
      RegExp(r'Link analysis complete\.'),
    );
    expect(announcement, findsOneWidget);
    expect(
      tester.getSemantics(announcement).flagsCollection.isLiveRegion,
      isTrue,
    );
    semantics.dispose();
  });

  testWidgets('QR Check announces inspection outcome and severity',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(home: QrCheckScreen()));

    await tester.enterText(find.byType(TextField), 'https://example.com');
    await tester.tap(find.text('Inspect QR content'));
    await tester.pumpAndSettle();

    final announcement = find.bySemanticsLabel(
      RegExp(r'QR inspection complete\.'),
    );
    expect(announcement, findsOneWidget);
    expect(
      tester.getSemantics(announcement).flagsCollection.isLiveRegion,
      isTrue,
    );
    semantics.dispose();
  });

  testWidgets('Message Check announces finding and detected-link counts',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(home: MessageCheckScreen()));

    await tester.enterText(
      find.byType(TextField),
      'URGENT: Your account is blocked. Share your OTP at https://example.test',
    );
    await tester.tap(find.text('Inspect message'));
    await tester.pumpAndSettle();

    final announcement = find.bySemanticsLabel(
      RegExp(r'Message inspection complete\.'),
    );
    expect(announcement, findsOneWidget);
    expect(
      tester.getSemantics(announcement).flagsCollection.isLiveRegion,
      isTrue,
    );
    semantics.dispose();
  });

  testWidgets('Intelligence announces updated reference-result count',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(home: IntelligenceScreen()));

    await tester.enterText(find.byType(TextField), 'Punycode');
    await tester.pumpAndSettle();

    final announcement = find.bySemanticsLabel('1 reference entries');
    expect(announcement, findsOneWidget);
    expect(
      tester.getSemantics(announcement).flagsCollection.isLiveRegion,
      isTrue,
    );
    semantics.dispose();
  });

  testWidgets('Privacy progress exposes a descriptive accessible value',
      (tester) async {
    final semantics = tester.ensureSemantics();
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MaterialApp(home: PrivacyScreen()));
    await tester.pumpAndSettle();

    final progress = find.byType(LinearProgressIndicator);
    expect(progress, findsOneWidget);
    final progressSemantics = tester.getSemantics(progress);
    expect(progressSemantics.label, contains('Privacy review progress: 0 of 12 practices reviewed'));
    expect(double.parse(progressSemantics.value), 0.0);
    final announcement = find.bySemanticsLabel(
      RegExp(r'Privacy progress update:'),
    );
    expect(announcement, findsOneWidget);
    expect(
      tester.getSemantics(announcement).flagsCollection.isLiveRegion,
      isTrue,
    );
    semantics.dispose();
  });

  testWidgets('Academy progress exposes a descriptive accessible value',
      (tester) async {
    final semantics = tester.ensureSemantics();
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MaterialApp(home: AcademyScreen()));
    await tester.pumpAndSettle();

    final progress = find.byType(LinearProgressIndicator);
    expect(progress, findsOneWidget);
    final progressSemantics = tester.getSemantics(progress);
    expect(progressSemantics.label, contains('Academy lesson completion: 0 of 8 lessons completed'));
    expect(double.parse(progressSemantics.value), 0.0);
    final announcement = find.bySemanticsLabel(
      RegExp(r'Academy progress:'),
    );
    expect(announcement, findsOneWidget);
    expect(
      tester.getSemantics(announcement).flagsCollection.isLiveRegion,
      isTrue,
    );
    semantics.dispose();
  });

  testWidgets('Academy answer feedback is announced as a live update',
      (tester) async {
    final semantics = tester.ensureSemantics();
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: AcademyScreen()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('Use the bank app or a known official contact route independently'),
    );
    await tester.pumpAndSettle();

    final feedback = find.bySemanticsLabel(RegExp(r'Correct\.'));
    expect(feedback, findsOneWidget);
    expect(
      tester.getSemantics(feedback).flagsCollection.isLiveRegion,
      isTrue,
    );
    semantics.dispose();
  });
}
