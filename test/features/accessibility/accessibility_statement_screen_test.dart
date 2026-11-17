import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/accessibility/presentation/accessibility_statement_screen.dart';
import 'package:orvika/features/accessibility/presentation/wcag_conformance_badge.dart';

void main() {
  testWidgets('statement presents the AA claim, auditor contacts and paired badges', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: OrvikaAccessibilityStatementScreen()));
    expect(find.text('Accessibility Statement'), findsOneWidget);
    expect(find.byType(Wcag22AaBadge), findsNWidgets(2));
    expect(find.byType(Image), findsNWidgets(2));
    expect(Wcag22AaBadge.imageUrl,
        'https://www.w3.org/WAI/WCAG22/wcag2.2AA-blue.png');
    final badgeSemantics = tester.widget<Semantics>(find.descendant(
      of: find.byType(Wcag22AaBadge).first,
      matching: find.byType(Semantics),
    ));
    expect(badgeSemantics.properties.label, contains('hosted ORVIKA Web application only'));
    expect(badgeSemantics.properties.label, contains('native Android application is excluded'));
    expect(
      find.byWidgetPredicate(
        (widget) => widget is SelectableText &&
            widget.data?.contains(
              'The publisher makes a WCAG 2.2 Level AA conformance claim',
            ) == true,
      ),
      findsOneWidget,
    );
    expect(find.textContaining('native Android application'), findsNWidgets(2));
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
