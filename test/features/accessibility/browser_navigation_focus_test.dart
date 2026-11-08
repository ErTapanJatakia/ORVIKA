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

  testWidgets('Space activates a focused dashboard destination', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    final linkCardTitle = find.text('Link Check');
    await tester.ensureVisible(linkCardTitle);
    await tester.pumpAndSettle();

    var focused = false;
    for (var attempt = 0; attempt < 50; attempt++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      if (Focus.of(tester.element(linkCardTitle)).hasFocus) {
        focused = true;
        break;
      }
    }
    expect(focused, isTrue, reason: 'Tab must reach the Link Check destination');

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(find.text('Inspect before you connect.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('returning from a feature restores focus to its dashboard card',
      (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    final linkCardTitle = find.text('Link Check');
    await tester.ensureVisible(linkCardTitle);
    await tester.pumpAndSettle();

    var focused = false;
    for (var attempt = 0; attempt < 50; attempt++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      if (Focus.of(tester.element(linkCardTitle)).hasFocus) {
        focused = true;
        break;
      }
    }
    expect(focused, isTrue, reason: 'Tab must reach the Link Check destination');
    final invokingFocus = FocusManager.instance.primaryFocus;

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Inspect before you connect.'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(linkCardTitle, findsOneWidget);
    expect(
      FocusManager.instance.primaryFocus,
      same(invokingFocus),
      reason: 'Popping the feature route should restore focus to its invoker',
    );
    expect(Focus.of(tester.element(linkCardTitle)).hasFocus, isTrue);
    expect(tester.takeException(), isNull);
  });
}
