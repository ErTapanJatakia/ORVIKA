import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';

void main() {
  testWidgets('launch overlay remains visible for five seconds before fading', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OrvikaLaunchOverlay(
          child: Scaffold(body: Center(child: Text('Dashboard'))),
        ),
      ),
    );

    expect(find.text('ORVIKA'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4, milliseconds: 999));
    expect(find.text('ORVIKA'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1));
    final opacity = tester.widget<AnimatedOpacity>(
      find.descendant(
        of: find.byType(OrvikaLaunchOverlay),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(opacity.opacity, 0);

    await tester.pump(const Duration(milliseconds: 650));
    expect(find.text('ORVIKA'), findsNothing);
    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('tapping anywhere on launch overlay dismisses it immediately', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OrvikaLaunchOverlay(
          child: Scaffold(body: Center(child: Text('Dashboard'))),
        ),
      ),
    );

    expect(find.text('ORVIKA'), findsOneWidget);
    await tester.tapAt(const Offset(20, 20));
    await tester.pump();

    final opacity = tester.widget<AnimatedOpacity>(
      find.descendant(
        of: find.byType(OrvikaLaunchOverlay),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(opacity.opacity, 0);

    // Repeated taps during the fade must not schedule duplicate transitions.
    await tester.tapAt(const Offset(20, 20));
    await tester.pump(const Duration(milliseconds: 650));
    expect(find.text('ORVIKA'), findsNothing);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
