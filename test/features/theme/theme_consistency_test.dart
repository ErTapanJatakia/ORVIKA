import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

double _contrastRatio(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  test('all theme text and signal colours meet 4.5:1 against their surface', () {
    for (final theme in OrvikaTheme.values) {
      final palette = theme.palette;
      final signals = [
        palette.primary,
        palette.secondary,
        palette.success,
        palette.warning,
        palette.danger,
      ];

      expect(
        _contrastRatio(
          palette.isDark ? const Color(0xFFF3F7FC) : const Color(0xFF172536),
          palette.surface,
        ),
        greaterThanOrEqualTo(4.5),
        reason: '${theme.label} primary text must remain readable.',
      );
      for (final signal in signals) {
        expect(
          _contrastRatio(signal, palette.surface),
          greaterThanOrEqualTo(4.5),
          reason: '${theme.label} signal colour $signal must remain readable on its surface.',
        );
      }
    }
  });

  testWidgets('each theme applies immediately and survives app restart',
      (tester) async {
    for (final theme in OrvikaTheme.values) {
      SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true, 'appearance.language': 'en', 'appearance.theme': theme == OrvikaTheme.obsidian ? OrvikaTheme.daylight.name : OrvikaTheme.obsidian.name});
      await tester.pumpWidget(OrvikaApp(key: ValueKey('theme-${theme.name}')));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Appearance and accessibility settings'));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      await tester.tap(find.text(theme.label).last);
      await tester.pumpAndSettle();

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString('appearance.theme'), theme.name);

      var app = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(app.theme!.scaffoldBackgroundColor, theme.palette.background);
      expect(app.theme!.colorScheme.primary, theme.palette.primary);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(OrvikaApp(key: ValueKey('restored-${theme.name}')));
      await tester.pumpAndSettle();

      app = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(app.theme!.scaffoldBackgroundColor, theme.palette.background);
      expect(app.theme!.colorScheme.primary, theme.palette.primary);
    }
  });
}
