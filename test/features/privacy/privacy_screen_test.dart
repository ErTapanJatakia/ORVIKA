import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Privacy self-audit saves and restores reviewed practices locally', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrivacyScreen()));
    await tester.pumpAndSettle();

    expect(find.text('0 of 12 practices reviewed'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Accounts'), 300, scrollable: find.byType(ListView));
    expect(find.text('Accounts'), findsOneWidget);

    final firstPractice = find.text('Use unique passwords for important accounts');
    await tester.scrollUntilVisible(firstPractice, 300, scrollable: find.byType(ListView));
    await tester.tap(firstPractice);
    await tester.pumpAndSettle();

    expect(find.text('WHY IT MATTERS'), findsOneWidget);
    expect(find.text('WHAT YOU CAN DO'), findsOneWidget);
    expect(find.text('IMPORTANT LIMIT'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(CheckboxListTile).first);
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pumpAndSettle();

    // The progress summary is above the expanded card; return to it before
    // asserting because ListView lazily builds off-screen children.
    await tester.drag(find.byType(ListView), const Offset(0, 900));
    await tester.pumpAndSettle();
    expect(find.text('1 of 12 practices reviewed'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getStringList('privacy.reviewed.v1'),
      contains('account-unique-passwords'),
    );

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pumpWidget(const MaterialApp(home: PrivacyScreen()));
    await tester.pumpAndSettle();

    expect(find.text('1 of 12 practices reviewed'), findsOneWidget);
  });

  testWidgets('assessment answers update session summary without persistence', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrivacyScreen()));
    await tester.pumpAndSettle();

    final firstPractice = find.text('Use unique passwords for important accounts');
    await tester.scrollUntilVisible(firstPractice, 300, scrollable: find.byType(ListView));
    await tester.ensureVisible(firstPractice);
    await tester.tap(firstPractice);
    await tester.pumpAndSettle();

    final needsAttention = find.widgetWithText(ChoiceChip, 'Needs attention');
    await tester.ensureVisible(needsAttention);
    await tester.tap(needsAttention);
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, 900));
    await tester.pumpAndSettle();
    expect(find.text('Needs attention: 1'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getKeys(), isEmpty,
        reason: 'Assessment answers must remain in active screen memory');
  });

  testWidgets('Privacy reset requires confirmation and clears saved review progress', (tester) async {
    SharedPreferences.setMockInitialValues({
      'privacy.reviewed.v1': <String>['account-unique-passwords'],
    });
    await tester.pumpWidget(const MaterialApp(home: PrivacyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('1 of 12 practices reviewed'), findsOneWidget);

    await tester.tap(find.byTooltip('Reset review progress'));
    await tester.pumpAndSettle();
    expect(find.text('Reset review progress?'), findsOneWidget);
    expect(find.text('1 of 12 practices reviewed'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Reset progress'));
    await tester.pumpAndSettle();
    expect(find.text('0 of 12 practices reviewed'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getStringList('privacy.reviewed.v1'), isNull);
  });

  testWidgets('Privacy screen clearly explains its self-audit boundary', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrivacyScreen()));
    await tester.pumpAndSettle();

    final boundaryText = find.textContaining('ORVIKA does not scan your device');
    await tester.scrollUntilVisible(
      boundaryText,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(boundaryText, findsOneWidget);
  });
}
