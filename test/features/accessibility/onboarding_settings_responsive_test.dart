import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/main.dart';

void main() {
  testWidgets('language selection remains usable across phone, tablet and desktop widths',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [
      280.0, 320.0, 360.0, 390.0, 430.0, 600.0, 760.0, 1024.0, 1920.0,
    ]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(MaterialApp(
        key: ValueKey('language-$width'),
        home: LanguageSelectionScreen(
          selectedLanguage: OrvikaLanguage.english,
          selectedCatalogue: 'russia',
          onLanguageChanged: (_) {},
          onCatalogueChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Search languages'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Language selection overflow at width $width');
    }
  });

  testWidgets('onboarding remains navigable across phone, tablet and desktop widths',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [
      280.0, 320.0, 360.0, 390.0, 430.0, 600.0, 760.0, 1024.0, 1920.0,
    ]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(MaterialApp(
        key: ValueKey('onboarding-$width'),
        home: OrvikaOnboardingScreen(
          onCompleted: () {},
          language: OrvikaLanguage.english,
          selectedCatalogue: 'russia',
          onCatalogueChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Check before you trust.'), findsOneWidget);
      expect(find.bySemanticsLabel('Onboarding page 1 of 3'), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Onboarding overflow at width $width');

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Understand the risk.'), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Onboarding navigation overflow at width $width');
    }
  });

  testWidgets('appearance settings use a readable content width at all viewports',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [
      280.0, 320.0, 360.0, 390.0, 430.0, 600.0, 760.0, 1024.0, 1920.0,
    ]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(MaterialApp(
        key: ValueKey('settings-$width'),
        home: AppearanceSettingsScreen(
          selectedTheme: OrvikaTheme.obsidian,
          onThemeChanged: (_) {},
          selectedLanguage: OrvikaLanguage.english,
          selectedCatalogue: 'russia',
          onLanguageChanged: (_) {},
          onCatalogueChanged: (_) {},
          textScale: 1,
          onTextScaleChanged: (_) {},
          boldText: false,
          onBoldTextChanged: (_) {},
          reduceMotion: false,
          onReduceMotionChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Accessibility'), findsOneWidget);
      expect(tester.getSize(find.byType(ListView)).width, lessThanOrEqualTo(760));
      expect(tester.takeException(), isNull,
          reason: 'Appearance settings overflow at width $width');
    }
  });

  testWidgets('onboarding and settings remain usable with RTL and 200 percent text',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: OrvikaOnboardingScreen(
            onCompleted: _noop,
            language: OrvikaLanguage.english,
            selectedCatalogue: 'russia',
            onCatalogueChanged: _ignoreCatalogue,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    final heading = find.text('Check before you trust.');
    expect(Directionality.of(tester.element(heading)), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(tester.element(heading)).scale(10), 20);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AppearanceSettingsScreen(
            selectedTheme: OrvikaTheme.obsidian,
            onThemeChanged: _ignoreTheme,
            selectedLanguage: OrvikaLanguage.english,
            selectedCatalogue: 'russia',
            onLanguageChanged: _ignoreLanguage,
            onCatalogueChanged: _ignoreCatalogue,
            textScale: 2,
            onTextScaleChanged: _ignoreScale,
            boldText: false,
            onBoldTextChanged: _ignoreBool,
            reduceMotion: false,
            onReduceMotionChanged: _ignoreBool,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    final settingsHeading = find.text('Accessibility');
    expect(Directionality.of(tester.element(settingsHeading)), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}
void _ignoreCatalogue(String value) {}
void _ignoreLanguage(OrvikaLanguage value) {}
void _ignoreTheme(OrvikaTheme value) {}
void _ignoreScale(double value) {}
void _ignoreBool(bool value) {}
