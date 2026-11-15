import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';

void main() {
  testWidgets('Link Check input exposes its visible accessible name',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(home: LinkCheckScreen()),
    );

    expect(find.bySemanticsLabel('Website address'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('QR Check input exposes its visible accessible name',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(home: QrCheckScreen()),
    );

    expect(find.bySemanticsLabel('Decoded QR content'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('Message Check input exposes its visible accessible name',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(home: MessageCheckScreen()),
    );

    expect(find.bySemanticsLabel('Message text'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('Intelligence search exposes its visible accessible name',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(home: IntelligenceScreen()),
    );

    expect(find.bySemanticsLabel('Search indicators'), findsOneWidget);
    semantics.dispose();
  });
}
