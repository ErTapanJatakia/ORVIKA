import 'dart:ui' show SemanticsAction;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';
import 'package:orvika/features/response/presentation/response_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Privacy review control exposes and updates its checked state',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(home: PrivacyScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();

    final reviewLabel = find.text('I have reviewed this practice');
    expect(reviewLabel, findsOneWidget);
    final reviewControl = find.ancestor(
      of: reviewLabel,
      matching: find.byType(CheckboxListTile),
    );
    expect(reviewControl, findsOneWidget);

    var node = tester.getSemantics(reviewControl);
    expect(node.flagsCollection.isChecked, isFalse);
    expect(
      node.getSemanticsData().hasAction(SemanticsAction.tap),
      isTrue,
    );

    await tester.tap(reviewLabel);
    await tester.pumpAndSettle();

    node = tester.getSemantics(reviewControl);
    expect(node.flagsCollection.isChecked, isTrue);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('Intelligence category filters expose selected state',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(home: IntelligenceScreen()));
    await tester.pumpAndSettle();

    final linksLabel = find.text('Links');
    final linksChip = find.ancestor(
      of: linksLabel,
      matching: find.byType(ChoiceChip),
    );
    expect(linksChip, findsOneWidget);

    var node = tester.getSemantics(linksChip);
    expect(node.flagsCollection.isSelected, isFalse);
    expect(
      node.getSemanticsData().hasAction(SemanticsAction.tap),
      isTrue,
    );

    await tester.tap(linksLabel);
    await tester.pumpAndSettle();

    node = tester.getSemantics(linksChip);
    expect(node.flagsCollection.isSelected, isTrue);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('Response playbook section labels are semantic headings',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(home: ResponseScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();

    for (final heading in [
      'FIRST PRIORITY',
      'STEP-BY-STEP',
      'PRESERVE USEFUL INFORMATION',
      'AVOID',
      'IMPORTANT LIMIT',
    ]) {
      expect(find.text(heading), findsOneWidget);
      expect(
        tester.getSemantics(find.text(heading)).flagsCollection.isHeader,
        isTrue,
        reason: '$heading should be available in heading navigation',
      );
    }
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
