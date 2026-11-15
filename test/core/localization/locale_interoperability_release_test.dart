import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';

void main() {
  group('Locale interoperability release coverage', () {
    test('every selectable catalogue entry round-trips through its BCP 47 tag', () {
      final languages = OrvikaLanguage.allValues;
      expect(languages, hasLength(192));

      for (final language in languages) {
        final resolved = OrvikaLanguage.fromLocaleTag(language.localeTag);
        expect(
          resolved.code,
          language.code,
          reason: '${language.code} must round-trip through ${language.localeTag}',
        );
        expect(language.semanticsLocale.languageCode, isNotEmpty);
        expect(language.semanticsLocale.languageCode, isNot('und'));
      }
    });

    test('Portuguese region tags resolve to the intentionally distinct entries', () {
      expect(OrvikaLanguage.fromLocaleTag('pt-PT').code, 'pt-PT');
      expect(OrvikaLanguage.fromLocaleTag('pt_pt').code, 'pt-PT');
      expect(OrvikaLanguage.fromLocaleTag('pt-BR').code, 'pt');
      expect(OrvikaLanguage.fromLocaleTag('pt_br').code, 'pt');
      expect(OrvikaLanguage.fromLocaleTag('PT-pt').code, 'pt-PT');
    });

    test('unknown and temporarily withheld locale tags fail safely to English', () {
      for (final tag in [null, '', '   ', 'tt-RU', 'ba-RU', 'zz-ZZ']) {
        expect(
          OrvikaLanguage.fromLocaleTag(tag).code,
          'en',
          reason: 'Unsupported locale tag $tag must use the safe default',
        );
      }
    });

    test('reviewed status remains a strict allowlist independent of picker size', () {
      final reviewed = OrvikaLanguage.allValues
          .where((language) => language.hasReviewedTranslation)
          .map((language) => language.code)
          .toSet();
      expect(reviewed, {'en', 'ru', 'ar', 'pt-PT'});

      for (final language in OrvikaLanguage.allValues) {
        expect(
          language.hasReviewedTranslation,
          const {'en', 'ru', 'ar', 'pt-PT'}.contains(language.code),
          reason: '${language.code} review status must not be inferred from authored draft strings',
        );
      }
    });
  });
}
