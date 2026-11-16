import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shared Material controls use 48 logical-pixel minimum targets',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Your safety toolkit'));
    final theme = Theme.of(context);
    final styles = <String, ButtonStyle?>{
      'icon': theme.iconButtonTheme.style,
      'elevated': theme.elevatedButtonTheme.style,
      'outlined': theme.outlinedButtonTheme.style,
      'text': theme.textButtonTheme.style,
    };

    for (final entry in styles.entries) {
      expect(entry.value, isNotNull, reason: entry.key);
      final style = entry.value!;
      expect(
        style.minimumSize!.resolve(const <WidgetState>{}),
        const Size(48, 48),
        reason: '${entry.key} buttons must have a 48x48 logical-pixel minimum',
      );
      expect(
        style.tapTargetSize,
        MaterialTapTargetSize.padded,
        reason: entry.key,
      );
    }

    expect(theme.materialTapTargetSize, MaterialTapTargetSize.padded);
    expect(theme.visualDensity, VisualDensity.standard);
    expect(theme.focusColor.a, greaterThan(0.30));
    expect(tester.takeException(), isNull);
  });
}
