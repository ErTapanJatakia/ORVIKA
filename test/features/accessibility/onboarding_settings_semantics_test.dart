import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('language selection exposes a heading and labelled search field',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(MaterialApp(
      home: LanguageSelectionScreen(
        selectedLanguage: OrvikaLanguage.english,
        selectedCatalogue: 'russia',
        onLanguageChanged: (_) {},
        onCatalogueChanged: (_) {},
      ),
    ));
    await tester.pumpAndSettle();

    final heading = tester.getSemantics(find.text('Choose your language'));
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(find.bySemanticsLabel('Search languages'), findsOneWidget);

    semantics.dispose();
  });

  testWidgets('language search result count is announced as a live update',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(MaterialApp(
      home: LanguageSelectionScreen(
        selectedLanguage: OrvikaLanguage.english,
        selectedCatalogue: 'russia',
        onLanguageChanged: (_) {},
        onCatalogueChanged: (_) {},
      ),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      'orvika-no-language-matches-this-query',
    );
    await tester.pumpAndSettle();

    final announcement = find.bySemanticsLabel(
      'Languages listed: 0. Available to select: 0',
    );
    expect(announcement, findsOneWidget);
    expect(
      tester.getSemantics(announcement).flagsCollection.isLiveRegion,
      isTrue,
    );
    expect(find.text('No matching language'), findsOneWidget);

    semantics.dispose();
  });

  testWidgets('onboarding exposes the current page heading and progress',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(MaterialApp(
      home: OrvikaOnboardingScreen(
        onCompleted: () {},
        language: OrvikaLanguage.english,
        selectedCatalogue: 'russia',
        onCatalogueChanged: (_) {},
      ),
    ));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.text('Check before you trust.'))
          .flagsCollection.isHeader,
      isTrue,
    );
    final firstProgress = find.bySemanticsLabel('Onboarding page 1 of 3');
    expect(firstProgress, findsOneWidget);
    expect(tester.getSemantics(firstProgress).flagsCollection.isLiveRegion,
        isTrue);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.text('Understand the risk.'))
          .flagsCollection.isHeader,
      isTrue,
    );
    expect(find.bySemanticsLabel('Onboarding page 2 of 3'), findsOneWidget);

    semantics.dispose();
  });

  testWidgets('appearance settings sections are exposed as headings',
      (tester) async {
    final semantics = tester.ensureSemantics();
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.tap(
      find.byTooltip('Appearance and accessibility settings'),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.text('Language')).flagsCollection.isHeader,
      isTrue,
    );
    expect(
      tester
          .getSemantics(find.text('Choose your visual environment'))
          .flagsCollection
          .isHeader,
      isTrue,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.text('Accessibility'))
          .flagsCollection.isHeader,
      isTrue,
    );

    semantics.dispose();
  });
}
