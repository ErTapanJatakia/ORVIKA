import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/main.dart';

void main() {
  testWidgets('fresh installs start at 50 percent text size', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Appearance and accessibility settings'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.value, 0.5);
    expect(find.text('50% · 50%–200%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('text-size slider spans 50 to 200 percent in 5-point steps',
      (tester) async {
    var selected = 0.5;
    await tester.pumpWidget(MaterialApp(
      home: AppearanceSettingsScreen(
        selectedTheme: OrvikaTheme.obsidian,
        onThemeChanged: (_) {},
        selectedLanguage: OrvikaLanguage.english,
        selectedCatalogue: 'russia',
        onLanguageChanged: (_) {},
        onCatalogueChanged: (_) {},
        textScale: 0.5,
        onTextScaleChanged: (value) => selected = value,
        boldText: false,
        onBoldTextChanged: (_) {},
        reduceMotion: false,
        onReduceMotionChanged: (_) {},
      ),
    ));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Text size'));
    await tester.pumpAndSettle();

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.min, 0.5);
    expect(slider.max, 2.0);
    expect(slider.divisions, 30);
    expect(slider.value, 0.5);
    expect(selected, 0.5);
  });

  test('accessibility text-size labels exist in every implemented language pack',
      () {
    const codes = [
      'en', 'ru', 'pt', 'es', 'hi', 'de', 'fr', 'it',
      'pa', 'ur', 'ar', 'mr', 'gu', 'sa',
    ];
    const keys = [
      'settings.accessibility.title',
      'settings.accessibility.help',
      'settings.textSize',
      'settings.textSize.range',
      'settings.boldText',
      'settings.boldText.help',
      'settings.reduceMotion',
      'settings.reduceMotion.help',
    ];

    for (final code in codes) {
      final l10n = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
      for (final key in keys) {
        expect(l10n.text(key), isNot(key), reason: '$code is missing $key');
      }
    }
  });
}
