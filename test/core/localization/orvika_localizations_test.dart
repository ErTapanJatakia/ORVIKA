import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';

void main() {
  group('ORVIKA language catalogue', () {
    test('unified picker contains unique stable language codes', () {
      final codes = OrvikaLanguage.allValues.map((language) => language.code).toList();
      expect(codes.length, 191);
      expect(codes.toSet().length, codes.length);
      expect(codes, isNot(contains('tt')));
      expect(codes, isNot(contains('ba')));
    });

    test('Tatar and Bashkir are excluded from selectable language catalogues', () {
      for (final catalogue in ['russia', 'india']) {
        final codes = OrvikaLanguage.valuesForCatalogue(catalogue)
            .map((language) => language.code)
            .toSet();
        expect(codes, isNot(contains('tt')));
        expect(codes, isNot(contains('ba')));
      }
      expect(OrvikaLanguage.valuesForCatalogue('russia'), hasLength(98));
      expect(OrvikaLanguage.valuesForCatalogue('india'), hasLength(100));
      expect(OrvikaLanguage.fromCode('tt').code, 'en');
      expect(OrvikaLanguage.fromCode('ba').code, 'en');
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

    test('all authored language packs cover every feature app-bar title', () {
      const featureTitleKeys = [
        'module.link',
        'module.qr',
        'module.message',
        'module.intelligence',
        'module.privacy',
        'module.academy',
        'module.response',
      ];
      for (final code in OrvikaLocalizations.translatedLanguageCodes) {
        final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in featureTitleKeys) {
          expect(
            localization.hasTranslation(key),
            isTrue,
            reason: '$code is missing the feature title key $key',
          );
          expect(
            localization.text(key),
            isNot(key),
            reason: '$code resolves $key to its untranslated key',
          );
        }
      }
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
