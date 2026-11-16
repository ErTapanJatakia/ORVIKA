import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final code in ['ar']) {
    testWidgets(
      '$code publishes RTL direction and the selected semantics locale through the app tree',
      (tester) async {
        final semantics = tester.ensureSemantics();
        SharedPreferences.setMockInitialValues({
          'appearance.language': code,
          'onboarding.completed.v1': true,
        });

        await tester.pumpWidget(const OrvikaApp());
        await tester.pumpAndSettle();

        final visibleText = find.byType(Text).first;
        final context = tester.element(visibleText);
        expect(
          Directionality.of(context),
          TextDirection.rtl,
          reason: '$code must use right-to-left layout direction',
        );

        final locale = tester.getSemantics(visibleText).getSemanticsData().locale;
        expect(locale?.languageCode, code);
        expect(locale?.scriptCode, isNull);
        expect(find.byType(FocusTraversalGroup), findsWidgets);
        semantics.dispose();
      },
    );
  }

  test('Urdu remains classified as right-to-left while its draft pack is gated', () {
    expect(OrvikaLanguage.fromCode('ur').isRightToLeft, isTrue);
  });

  testWidgets('switching to a left-to-right locale does not retain RTL direction',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'appearance.language': 'en',
      'onboarding.completed.v1': true,
    });

    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Text).first);
    expect(Directionality.of(context), TextDirection.ltr);
  });
}
