import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/accessibility/presentation/accessibility_statement_screen.dart';

void main() {
  testWidgets('statement presents the AA claim, auditor contacts and paired badges', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: OrvikaAccessibilityStatementScreen()));
    expect(find.text('Accessibility Statement'), findsOneWidget);
    expect(find.text('WCAG 2.2 AA'), findsNWidgets(2));
    expect(find.textContaining('WCAG 2.2 Level AA conformance claim'), findsNothing);
    expect(find.textContaining('publisher makes a WCAG 2.2 Level AA conformance claim'), findsOneWidget);
    expect(find.textContaining('native Android application'), findsOneWidget);
    final auditor = find.textContaining('cyber.litigation.advisor@gmail.com');
    await tester.scrollUntilVisible(auditor, 220, scrollable: find.byType(Scrollable).first);
    expect(auditor, findsOneWidget);
    expect(find.textContaining('+91 9664332984'), findsOneWidget);
    expect(find.textContaining('https://linktr.ee/ertapanjatakia'), findsOneWidget);
    expect(find.textContaining('A11Y-01'), findsNothing);
    expect(find.textContaining('They may receive spam'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
