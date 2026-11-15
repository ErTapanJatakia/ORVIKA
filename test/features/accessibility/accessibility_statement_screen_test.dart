import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/accessibility/presentation/accessibility_statement_screen.dart';

void main() {
  testWidgets('accessibility statement shows its badge, contact route and evaluation limits', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: OrvikaAccessibilityStatementScreen()),
    );

    expect(find.text('ORVIKA Accessibility Statement'), findsOneWidget);
    expect(find.text('Accessibility information'), findsOneWidget);
    expect(find.textContaining('does not claim full WCAG 2.2 Level AA conformance'), findsOneWidget);
    expect(find.textContaining('not an independent third-party audit'), findsOneWidget);
    final platformCoverage = find.textContaining('Android application requires separate native evaluation');
    await tester.scrollUntilVisible(platformCoverage, 250, scrollable: find.byType(Scrollable));
    expect(platformCoverage, findsOneWidget);

    final contactAddress = find.text('ertapanjatakia@yandex.com');
    await tester.scrollUntilVisible(contactAddress, 250, scrollable: find.byType(ListView));
    expect(contactAddress, findsOneWidget);
    expect(find.text('tapan_ditu_17.20@outlook.com'), findsOneWidget);
    expect(find.textContaining('No CAPTCHA or verification is required'), findsOneWidget);
  });
}
