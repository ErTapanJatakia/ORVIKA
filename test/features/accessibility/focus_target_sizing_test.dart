import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
  });

  testWidgets('dashboard icon actions expose a 48 logical-pixel target', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    // Use a stable dashboard anchor; do not assume the first-run language
    // picker is present when onboarding is already complete.
    final dashboardHeading = find.text('Your safety toolkit');
    expect(dashboardHeading, findsOneWidget);

    final context = tester.element(dashboardHeading);
    final iconStyle = Theme.of(context).iconButtonTheme.style;
    expect(iconStyle, isNotNull);
    final minimumSize = iconStyle!.minimumSize!.resolve(const <WidgetState>{})!;
    expect(minimumSize.width, greaterThanOrEqualTo(48));
    expect(minimumSize.height, greaterThanOrEqualTo(48));
    expect(iconStyle.tapTargetSize, MaterialTapTargetSize.padded);

    final settingsAction = find.byTooltip('Appearance and accessibility settings');
    expect(settingsAction, findsOneWidget);
    final renderedSize = tester.getSize(settingsAction);
    expect(renderedSize.width, greaterThanOrEqualTo(48));
    expect(renderedSize.height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard focus gives dashboard cards a visible high-contrast outline', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

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

    expect(
      reachedLinkCard,
      isTrue,
      reason: 'Keyboard traversal must reach the Link Check card.',
    );

    final focusedCard = tester.widget<Container>(
      find.byKey(const ValueKey('dashboard-module-card-Link Check')),
    );
    final decoration = focusedCard.decoration! as BoxDecoration;
    expect(decoration.border, isA<Border>());
    final border = decoration.border! as Border;
    expect(border.top.width, greaterThanOrEqualTo(2.5));
    expect(
      border.top.color,
      Theme.of(tester.element(linkCardTitle)).colorScheme.primary,
      reason: 'The focused card outline must use the active theme primary colour.',
    );
    expect(tester.takeException(), isNull);
  });
}
