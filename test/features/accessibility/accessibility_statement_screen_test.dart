import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/accessibility/presentation/accessibility_statement_screen.dart';

void main() {
  testWidgets('accessibility statement discloses evaluation limits', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrvikaAccessibilityStatementScreen()),
    );

    expect(find.text('ORVIKA Accessibility Statement'), findsOneWidget);
    expect(find.textContaining('does not claim full WCAG 2.2 Level AA conformance'), findsOneWidget);
    expect(find.textContaining('not an independent third-party audit'), findsOneWidget);
    expect(find.textContaining('Android application requires separate native evaluation'), findsOneWidget);
  });
}
