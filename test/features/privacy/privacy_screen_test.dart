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
    expect(find.text('Accounts'), findsOneWidget);

    await tester.tap(find.text('Use unique passwords for important accounts'));
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
