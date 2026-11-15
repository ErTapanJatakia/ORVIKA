import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orvika/main.dart';

void main() {
  testWidgets('shared Material button themes provide 48px minimum targets', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Your safety toolkit'));
    final theme = Theme.of(context);
    final buttonStyles = <ButtonStyle?>[
      theme.iconButtonTheme.style,
      theme.elevatedButtonTheme.style,
      theme.outlinedButtonTheme.style,
      theme.textButtonTheme.style,
    ];

    for (final style in buttonStyles) {
      expect(style, isNotNull);
      expect(
        style!.minimumSize!.resolve(const <WidgetState>{}),
        const Size(48, 48),
      );
      expect(
        style.tapTargetSize!.resolve(const <WidgetState>{}),
        MaterialTapTargetSize.padded,
      );
    }

    expect(theme.focusColor.a, greaterThan(0.30));
    expect(tester.takeException(), isNull);
  });
}
