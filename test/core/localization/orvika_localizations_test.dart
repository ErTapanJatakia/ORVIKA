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

    test('Devanagari locales use the bundled script font', () {
      for (final code in ['hi', 'mr', 'ne', 'sa', 'mai', 'doi', 'kok', 'brx', 'bho']) {
        expect(OrvikaLanguage.fromCode(code).usesDevanagariScript, isTrue,
            reason: '$code should use Devanagari typography');
      }
      expect(OrvikaLanguage.fromCode('gu').usesDevanagariScript, isFalse);
      expect(OrvikaLanguage.fromCode('ur').usesDevanagariScript, isFalse);
    });

    test('Hindi draft covers the reviewed source key baseline', () {
      final hindi = OrvikaLocalizations(OrvikaLanguage.fromCode('hi'));
      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(hindi.hasTranslation(key), isTrue, reason: 'Hindi is missing $key');
      }
    });

    test('only complete reviewed language packs are eligible for selection', () {
      for (final language in OrvikaLanguage.allValues) {
        expect(
          language.hasReviewedTranslation,
          ['en', 'ru'].contains(language.code),
          reason: '${language.code} must remain unavailable until its full app translation is reviewed',
        );
      }
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

    test('Russian and Hindi packs cover the first checker interface batch', () {
      const checkerKeys = [
        'checker.link.heading',
        'checker.link.description',
        'checker.link.input',
        'checker.link.action',
        'checker.link.result',
        'checker.link.notice',
        'checker.qr.heading',
        'checker.qr.description',
        'checker.qr.input',
        'checker.qr.hint',
        'checker.qr.action',
        'checker.qr.result',
        'checker.qr.destination',
        'checker.qr.notice',
        'checker.message.heading',
        'checker.message.description',
        'checker.message.input',
        'checker.message.hint',
        'checker.message.action',
        'checker.message.result',
        'checker.message.links',
        'checker.message.notice',
        'checker.severity.info',
        'checker.severity.caution',
        'checker.severity.warning',
      ];
      for (final code in ['ru', 'hi']) {
        final localization =
            OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in checkerKeys) {
          expect(
            localization.hasTranslation(key),
            isTrue,
            reason: '$code is missing checker UI key $key',
          );
          expect(localization.text(key), isNot(key));
        }
      }
    });


    test('Russian and Hindi packs cover Intelligence and Privacy interface keys', () {
      const keys = [
        'intelligence.heading',
        'intelligence.description',
        'intelligence.search',
        'intelligence.searchHint',
        'intelligence.clear',
        'intelligence.filter.all',
        'intelligence.category.links',
        'intelligence.category.messages',
        'intelligence.category.qr',
        'intelligence.category.accounts',
        'intelligence.count',
        'intelligence.offline',
        'intelligence.empty',
        'intelligence.detail.notice',
        'intelligence.detail.meaning',
        'intelligence.detail.next',
        'intelligence.detail.limit',
        'intelligence.notice',
        'privacy.category.accounts',
        'privacy.category.device',
        'privacy.category.apps',
        'privacy.category.browsing',
        'privacy.reset.tooltip',
        'privacy.heading',
        'privacy.description',
        'privacy.progress',
        'privacy.progressSemantics',
        'privacy.progressUpdate',
        'privacy.progressNote',
        'privacy.detail.why',
        'privacy.detail.action',
        'privacy.detail.limit',
        'privacy.reviewed',
      ];
      for (final code in ['ru', 'hi']) {
        final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in keys) {
          expect(localization.hasTranslation(key), isTrue,
              reason: '$code is missing interface key $key');
          expect(localization.text(key), isNot(key));
        }
      }
    });


    test('Russian and Hindi packs cover Academy and Response interface keys', () {
      const keys = [
        'academy.heading', 'academy.description', 'academy.category.accounts',
        'academy.category.social', 'academy.category.device', 'academy.category.payments',
        'academy.progress', 'academy.progressSemantics', 'academy.progressUpdate',
        'academy.progressNote', 'academy.reset', 'academy.keyPoints',
        'academy.knowledgeCheck', 'academy.correct', 'academy.tryAgain',
        'academy.completed', 'academy.notice', 'response.heading',
        'response.description', 'response.urgent', 'response.category.accounts',
        'response.category.payments', 'response.category.device',
        'response.category.identity', 'response.firstPriority', 'response.steps',
        'response.preserve', 'response.avoid', 'response.limit', 'response.notice',
      ];
      for (final code in ['ru', 'hi']) {
        final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in keys) {
          expect(localization.hasTranslation(key), isTrue,
              reason: '$code is missing feature key $key');
          expect(localization.text(key), isNot(key));
        }
      }
    });

    test('Marathi and Sanskrit draft packs cover the extended interface controls', () {
      const keys = [
        'intelligence.heading', 'intelligence.description', 'intelligence.search',
        'intelligence.searchHint', 'intelligence.clear', 'intelligence.filter.all',
        'intelligence.category.links', 'intelligence.category.messages',
        'intelligence.category.qr', 'intelligence.category.accounts',
        'intelligence.count', 'intelligence.offline', 'intelligence.empty',
        'intelligence.detail.notice', 'intelligence.detail.meaning',
        'intelligence.detail.next', 'intelligence.detail.limit',
        'privacy.category.accounts', 'privacy.category.device', 'privacy.category.apps',
        'privacy.category.browsing', 'privacy.reset.tooltip', 'privacy.heading',
        'privacy.description', 'privacy.progress', 'privacy.progressSemantics',
        'privacy.progressUpdate', 'privacy.detail.why', 'privacy.detail.action',
        'privacy.detail.limit', 'privacy.reviewed',
        'academy.heading', 'academy.description', 'academy.category.accounts',
        'academy.category.social', 'academy.category.device',
        'academy.category.payments', 'academy.progress',
        'academy.progressSemantics', 'academy.progressUpdate', 'academy.reset',
        'academy.keyPoints', 'academy.knowledgeCheck', 'academy.correct',
        'academy.tryAgain', 'academy.completed', 'response.heading',
        'response.description', 'response.category.accounts',
        'response.category.payments', 'response.category.device',
        'response.category.identity', 'response.firstPriority', 'response.steps',
        'response.preserve', 'response.avoid', 'response.limit',
      ];
      for (final code in ['mr', 'sa']) {
        final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in keys) {
          expect(localization.hasTranslation(key), isTrue,
              reason: '$code is missing interface key $key');
          expect(localization.text(key), isNot(key));
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
