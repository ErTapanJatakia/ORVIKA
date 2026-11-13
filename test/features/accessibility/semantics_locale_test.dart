import 'dart:ui' show Locale;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ORVIKA semantics locale mapping', () {
    test('maps canonical BCP 47 tags to structured Flutter locales', () {
      final cases = <(OrvikaLanguage, Locale)>[
        (OrvikaLanguage.english, const Locale('en')),
        (OrvikaLanguage.russian, const Locale('ru', 'RU')),
        (const OrvikaLanguage('hi', 'Hindi', 'हिन्दी'),
            const Locale('hi', 'IN')),
        (OrvikaLanguage.portugalPortuguese, const Locale('pt', 'PT')),
        (const OrvikaLanguage('pt', 'Portuguese (Brazil)', 'Português (Brasil)'),
            const Locale('pt', 'BR')),
        (const OrvikaLanguage('zh', 'Chinese (Simplified)', '中文（简体）'),
            const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hans',
              countryCode: 'CN',
            )),
        (const OrvikaLanguage('pa', 'Punjabi', 'ਪੰਜਾਬੀ'),
            const Locale.fromSubtags(
              languageCode: 'pa',
              scriptCode: 'Guru',
              countryCode: 'IN',
            )),
        (const OrvikaLanguage('ur', 'Urdu', 'اردو'),
            const Locale('ur', 'PK')),
        (const OrvikaLanguage('sr', 'Serbian', 'Српски'),
            const Locale.fromSubtags(
              languageCode: 'sr',
              scriptCode: 'Cyrl',
              countryCode: 'RS',
            )),
      ];

      for (final (language, expected) in cases) {
        expect(
          language.semanticsLocale,
          expected,
          reason: '${language.code} should use ${language.localeTag}',
        );
      }
    });

    testWidgets('publishes the selected language to the app semantics tree',
        (tester) async {
      final semantics = tester.ensureSemantics();
      SharedPreferences.setMockInitialValues({
        'appearance.language': 'ru',
        'onboarding.completed.v1': true,
      });

      await tester.pumpWidget(const OrvikaApp());
      await tester.pumpAndSettle();

      final firstText = find.byType(Text).first;
      expect(
        tester.getSemantics(firstText).getSemanticsData().locale,
        const Locale('ru', 'RU'),
      );

      semantics.dispose();
    });
  });
}
