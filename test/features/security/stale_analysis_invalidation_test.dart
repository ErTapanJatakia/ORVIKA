import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';

void main() {
  testWidgets('Link Check removes old findings as soon as the URL is edited',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LinkCheckScreen()));
    await tester.enterText(find.byType(TextField), 'https://example.com');
    await tester.tap(find.text('Analyse address'));
    await tester.pumpAndSettle();

    expect(find.text('Analysis findings'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'https://different.example');
    await tester.pump();

    expect(find.text('Analysis findings'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('QR Check removes old findings and detected context while editing',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: QrCheckScreen()));
    await tester.enterText(find.byType(TextField), 'https://example.com');
    await tester.tap(find.text('Inspect QR content'));
    await tester.pumpAndSettle();

    expect(find.text('Inspection result'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'plain replacement text');
    await tester.pump();

    expect(find.text('Inspection result'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
