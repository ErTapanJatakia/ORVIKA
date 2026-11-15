import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';

void main() {
  testWidgets('Link Check provides a one-action input and result clear control',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LinkCheckScreen()));
    final input = find.byType(TextField);

    await tester.enterText(input, 'https://example.com');
    await tester.pump();
    expect(find.text('Clear input and findings'), findsOneWidget);

    await tester.tap(find.text('Analyse address'));
    await tester.pumpAndSettle();
    expect(find.text('Analysis findings'), findsOneWidget);

    await tester.tap(find.text('Clear input and findings'));
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(input).controller!.text, isEmpty);
    expect(find.text('Analysis findings'), findsNothing);
    expect(find.text('Clear input and findings'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('QR Check clears decoded content, findings and detected format',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: QrCheckScreen()));
    final input = find.byType(TextField);

    await tester.enterText(input, 'https://example.com');
    await tester.pump();
    expect(find.text('Clear input and findings'), findsOneWidget);

    await tester.tap(find.text('Inspect QR content'));
    await tester.pumpAndSettle();
    expect(find.text('Inspection result'), findsOneWidget);

    await tester.tap(find.text('Clear input and findings'));
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(input).controller!.text, isEmpty);
    expect(find.text('Inspection result'), findsNothing);
    expect(find.text('Clear input and findings'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
