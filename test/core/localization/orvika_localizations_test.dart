import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';

void main() {
  group('ORVIKA language catalogue', () {
    test('unified picker contains unique stable language codes', () {
      final codes = OrvikaLanguage.allValues.map((language) => language.code).toList();
      expect(codes.length, 193);
      expect(codes.toSet().length, codes.length);
    });

    test('translation coverage is explicit and is not inferred from picker membership', () {
      for (final language in OrvikaLanguage.allValues) {
        final localization = OrvikaLocalizations(language);
        final hasPack = OrvikaLocalizations.translatedLanguageCodes.contains(language.code);
        expect(
          localization.hasTranslation('skip'),
          hasPack && language.code != 'en',
          reason: 'Unexpected authored-pack status for ${language.code}',
        );
      }
      expect(OrvikaLanguage.fromCode('ce').hasDraftTranslation, isFalse);
      expect(OrvikaLanguage.fromCode('ce').hasReviewedTranslation, isFalse);
    });

    test('missing translations use explicit English fallback', () {
      final localization = OrvikaLocalizations(OrvikaLanguage.fromCode('ce'));
      expect(localization.text('feature.title', 'Feature title'), 'Feature title');
      expect(localization.hasTranslation('feature.title'), isFalse);
    });

    test('named parameters are interpolated', () {
      final localization = OrvikaLocalizations(OrvikaLanguage.fromCode('ce'));
      expect(
        localization.textWithParameters(
          'custom.message',
          fallback: 'Found {count} indicators',
          parameters: const {'count': 3},
        ),
        'Found 3 indicators',
      );
    });

    test('missing interpolation values remain visible', () {
      final localization = OrvikaLocalizations(OrvikaLanguage.fromCode('ce'));
      expect(
        localization.textWithParameters('custom.message', fallback: 'Found {count} indicators'),
        'Found {count} indicators',
      );
    });

    test('RTL direction is independent from translation coverage', () {
      for (final code in ['ar', 'ur', 'he', 'fa', 'ps']) {
        expect(OrvikaLanguage.fromCode(code).isRightToLeft, isTrue);
      }
      expect(OrvikaLanguage.fromCode('de').isRightToLeft, isFalse);
      expect(OrvikaLanguage.fromCode('he').hasDraftTranslation, isFalse);
    });
  });
}
