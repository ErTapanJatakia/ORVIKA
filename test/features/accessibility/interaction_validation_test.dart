import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orvika/helpers/dashboard_test_helpers.dart';

double _contrastRatio(Color foreground, Color background) {
  final first = foreground.computeLuminance();
  final second = background.computeLuminance();
  final lighter = first > second ? first : second;
  final darker = first > second ? second : first;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  test('all palette status accents meet 4.5:1 contrast on app surfaces', () {
    for (final theme in OrvikaTheme.values) {
      final palette = theme.palette;
      final accents = <String, Color>{
        'primary': palette.primary,
        'secondary': palette.secondary,
        'success': palette.success,
        'warning': palette.warning,
        'danger': palette.danger,
      };

      for (final entry in accents.entries) {
        for (final surface in <String, Color>{
          'background': palette.background,
          'surface': palette.surface,
        }.entries) {
          expect(
            _contrastRatio(entry.value, surface.value),
            greaterThanOrEqualTo(4.5),
            reason: '${theme.label} ${entry.key} on ${surface.key} must meet 4.5:1',
          );
        }
      }
    }
  });

  testWidgets('dashboard icon actions retain 48 logical-pixel touch targets',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    for (final tooltip in ['Change language', 'Appearance and accessibility settings']) {
      final button = find.ancestor(
        of: find.byTooltip(tooltip),
        matching: find.byType(IconButton),
      );
      expect(button, findsOneWidget, reason: tooltip);
      final size = tester.getSize(button);
      expect(size.width, greaterThanOrEqualTo(48), reason: tooltip);
      expect(size.height, greaterThanOrEqualTo(48), reason: tooltip);
    }
  });

  testWidgets('dashboard keyboard traversal supports Tab, Shift+Tab and Enter',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await revealDashboardContent(tester);
    final linkCardTitle = find.text('Link Check');
    await tester.ensureVisible(linkCardTitle);
    await tester.pumpAndSettle();

    var reachedLinkCard = false;
    for (var attempt = 0; attempt < 50; attempt++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      if (Focus.of(tester.element(linkCardTitle)).hasFocus) {
        reachedLinkCard = true;
        break;
      }
    }
    expect(reachedLinkCard, isTrue, reason: 'Tab must reach the Link Check card');

    final linkFocus = FocusManager.instance.primaryFocus;
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();

    expect(FocusManager.instance.primaryFocus, isNotNull);
    expect(
      FocusManager.instance.primaryFocus,
      isNot(same(linkFocus)),
      reason: 'Shift+Tab must move focus to the preceding control',
    );

    reachedLinkCard = false;
    for (var attempt = 0; attempt < 50; attempt++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      if (Focus.of(tester.element(linkCardTitle)).hasFocus) {
        reachedLinkCard = true;
        break;
      }
    }
    expect(reachedLinkCard, isTrue, reason: 'Forward traversal must remain available');

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Inspect before you connect.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
