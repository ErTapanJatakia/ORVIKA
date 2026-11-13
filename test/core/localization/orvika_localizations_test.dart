import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/core/localization/orvika_feature_translations.dart';

void main() {
  group('ORVIKA language catalogue', () {
    test('unified picker contains unique stable language codes', () {
      final codes = OrvikaLanguage.allValues.map((language) => language.code).toList();
      expect(codes.length, 192);
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

    test('Simplified Chinese is registered as a draft and exposes initial UI translations', () {
      final chinese = OrvikaLanguage.fromCode('zh');
      expect(chinese.nativeName, '中文（简体）');
      expect(chinese.localeTag, 'zh-Hans-CN');
      expect(chinese.hasDraftTranslation, isTrue);
      expect(chinese.hasReviewedTranslation, isFalse);
      expect(OrvikaLocalizations.translatedLanguageCodes.contains('zh'), isFalse);

      final localization = OrvikaLocalizations(chinese);
      // Audit every reviewed Russian baseline key, not just representative samples.
      // Draft text must resolve for development without counting as reviewed coverage.
      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(localization.hasTranslation(key), isFalse,
            reason: 'Simplified Chinese draft must not claim reviewed coverage for $key');
        expect(localization.text(key), isNot(key),
            reason: 'Simplified Chinese draft is missing authored UI text for $key');
      }
    });

    test('Simplified Chinese checker, camera, image and privacy notices preserve placeholders', () {
      final chinese = OrvikaFeatureTranslations.forCode('zh');
      final russian = OrvikaFeatureTranslations.forCode('ru');
      final requiredKeys = [
        'checker.qr.detectedFormat',
        'checker.camera.previewError',
        'checker.image.error.tooLarge',
        'checker.image.privacyNotice',
        'privacy.analytics.notice',
        'privacy.device.notice',
      ];
      Set<String> placeholders(String value) => RegExp(r'\\{([a-zA-Z][a-zA-Z0-9_]*)\\}')
          .allMatches(value).map((match) => match.group(1)!).toSet();

      for (final key in requiredKeys) {
        expect(chinese.containsKey(key), isTrue,
            reason: 'Simplified Chinese feature pack is missing $key');
        expect(chinese[key], isNot(key));
        expect(placeholders(chinese[key]!), placeholders(russian[key]!),
            reason: 'Simplified Chinese must preserve placeholders for $key');
      }
    });

    test('Simplified Chinese draft covers every required shared UI key', () {
      final localization = OrvikaLocalizations(OrvikaLanguage.fromCode('zh'));
      expect(OrvikaLocalizations.translatedLanguageCodes.contains('zh'), isFalse);
      expect(OrvikaLanguage.fromCode('zh').hasReviewedTranslation, isFalse);
      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(localization.text(key), isNot(key),
            reason: 'Simplified Chinese draft is missing shared UI key $key');
        expect(localization.text(key), isNotEmpty,
            reason: 'Simplified Chinese shared UI key $key is empty');
        expect(localization.hasTranslation(key), isFalse,
            reason: 'Draft Chinese key $key must not count as reviewed coverage');
      }
    });

    test('Portugal Portuguese is a distinct selectable locale, not Brazilian Portuguese', () {
      final brazil = OrvikaLanguage.fromCode('pt');
      final portugal = OrvikaLanguage.fromCode('pt-PT');
      expect(brazil.code, 'pt');
      expect(brazil.name, 'Portuguese (Brazil)');
      expect(brazil.nativeName, 'Português (Brasil)');
      expect(portugal.code, 'pt-PT');
      expect(portugal.name, 'Portuguese (Portugal)');
      expect(portugal.nativeName, 'Português (Portugal)');
      expect(OrvikaLanguage.allValues.where((language) => language.code == 'pt-PT'),
          hasLength(1));
      expect(portugal.hasDraftTranslation, isFalse);
      expect(portugal.hasReviewedTranslation, isTrue);
      expect(OrvikaLocalizations.translatedLanguageCodes.contains('pt-PT'), isTrue);
      expect(OrvikaLocalizations(portugal).text('hero.title'), 'Verifique antes de confiar.');
      expect(OrvikaLocalizations(portugal).text('settings.textSize'), 'Tamanho do texto');
      expect(portugal.hasReviewedTranslation, isTrue);
    });

    test('Portugal Portuguese covers accessibility, camera, image and analytics strings', () {
      final localization = OrvikaLocalizations(OrvikaLanguage.fromCode('pt-PT'));
      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(localization.hasTranslation(key), isTrue, reason: 'pt-PT is missing $key');
      }
      expect(localization.text('settings.textSize.range'), '50%–200%');
      expect(localization.text('settings.boldText'), isNot('Bold text'));
      expect(localization.text('settings.reduceMotion'), isNot('Reduce motion'));
      final featurePack = OrvikaFeatureTranslations.forCode('pt-PT');
      for (final key in [
        'checker.camera.title',
        'checker.camera.permissionDenied',
        'checker.image.error.tooLarge',
        'checker.image.privacyNotice',
        'privacy.analytics.notice',
        'privacy.device.notice',
      ]) {
        expect(featurePack.containsKey(key), isTrue, reason: 'pt-PT feature pack is missing $key');
        expect(featurePack[key], isNot(key));
      }
      expect(
        localization.textWithParameters(
          'privacy.progressUpdate',
          parameters: const {'reviewed': 3, 'total': 12},
        ),
        contains('3'),
      );
      expect(localization.textWithParameters('privacy.progressUpdate',
          parameters: const {'reviewed': 3, 'total': 12}), contains('12'));
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

    test('Gujarati and Urdu use bundled script-specific font families', () {
      final gujarati = OrvikaLanguage.fromCode('gu');
      expect(gujarati.usesGujaratiScript, isTrue);
      expect(gujarati.preferredFontFamily, 'NotoSansGujarati');
      final urdu = OrvikaLanguage.fromCode('ur');
      expect(urdu.usesUrduScript, isTrue);
      expect(urdu.preferredFontFamily, 'NotoNastaliqUrdu');
      expect(OrvikaLanguage.fromCode('ar').usesUrduScript, isFalse);
      expect(OrvikaLanguage.fromCode('hi').preferredFontFamily, 'NotoSansDevanagari');
      expect(OrvikaLanguage.fromCode('en').preferredFontFamily, 'Inter');
    });

    test('all declared RTL locales expose RTL layout metadata', () {
      for (final code in ['ar', 'ur', 'he', 'fa', 'ps']) {
        expect(OrvikaLanguage.fromCode(code).isRightToLeft, isTrue);
      }
      expect(OrvikaLanguage.fromCode('gu').isRightToLeft, isFalse);
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
          ['en', 'ru', 'ar'].contains(language.code),
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
        'privacy.category.browsing', 'privacy.reset.tooltip', 'privacy.reset.title',
        'privacy.reset.description', 'privacy.reset.action', 'privacy.error.save',
        'privacy.error.clear', 'privacy.heading',
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
      final source = OrvikaLocalizations(OrvikaLanguage.fromCode('ru'));
      Set<String> placeholders(String value) => RegExp(
            r'\{([a-zA-Z][a-zA-Z0-9_]*)\}',
          ).allMatches(value).map((match) => match.group(1)!).toSet();

      for (final code in ['mr', 'sa']) {
        final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in keys) {
          expect(localization.hasTranslation(key), isTrue,
              reason: '$code is missing interface key $key');
          expect(localization.text(key), isNot(key));
          expect(
            placeholders(localization.text(key)),
            placeholders(source.text(key)),
            reason: '$code must preserve interpolation placeholders for $key',
          );
        }

        final privacyProgress = localization.textWithParameters(
          'privacy.progress',
          parameters: const {'reviewed': 3, 'total': 8},
        );
        final academyProgress = localization.textWithParameters(
          'academy.progress',
          parameters: const {'completed': 3, 'total': 8},
        );
        if (code == 'mr') {
          expect(privacyProgress, 'तपासलेल्या बाबी: 8 पैकी 3');
          expect(academyProgress, 'पूर्ण झालेले धडे: 8 पैकी 3');
        } else {
          expect(privacyProgress, 'परीक्षिताः विषयाः: 3/8');
          expect(academyProgress, 'पूर्णाः पाठाः: 3/8');
        }
      }
    });

    test('Marathi and Sanskrit cover the full baseline except approved safety notices', () {
      const fallbackOnlyKeys = {
        'intelligence.notice',
        'privacy.progressNote',
        'academy.progressNote',
        'academy.notice',
        'response.urgent',
        'response.notice',
      };
      final source = OrvikaLocalizations(OrvikaLanguage.fromCode('ru'));
      Set<String> placeholders(String value) => RegExp(
            r'\{([a-zA-Z][a-zA-Z0-9_]*)\}',
          ).allMatches(value).map((match) => match.group(1)!).toSet();

      for (final code in ['mr', 'sa']) {
        final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in OrvikaLocalizations.requiredTranslationKeys) {
          if (fallbackOnlyKeys.contains(key)) {
            expect(localization.hasTranslation(key), isFalse,
                reason: '$code must retain the approved fallback for $key');
            continue;
          }
          expect(localization.hasTranslation(key), isTrue,
              reason: '$code is missing baseline key $key');
          expect(localization.text(key), isNot(key));
          expect(
            placeholders(localization.text(key)),
            placeholders(source.text(key)),
            reason: '$code must preserve placeholders for $key',
          );
        }
      }
    });

    test('Gujarati and Urdu cover the extended checker interface', () {
      const keys = [
        'checker.link.description',
        'checker.link.result',
        'checker.link.notice',
        'checker.qr.description',
        'checker.qr.hint',
        'checker.qr.result',
        'checker.qr.destination',
        'checker.qr.notice',
        'checker.message.description',
        'checker.message.hint',
        'checker.message.result',
        'checker.message.links',
        'checker.message.notice',
      ];
      for (final code in ['gu', 'ur']) {
        final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in keys) {
          expect(localization.hasTranslation(key), isTrue,
              reason: '$code is missing checker interface key $key');
          expect(localization.text(key), isNot(key));
        }
      }
    });

    test('Gujarati and Urdu checker translations preserve placeholders and script direction', () {
      const keys = [
        'checker.link.description',
        'checker.link.result',
        'checker.link.notice',
        'checker.qr.description',
        'checker.qr.hint',
        'checker.qr.result',
        'checker.qr.destination',
        'checker.qr.notice',
        'checker.message.description',
        'checker.message.hint',
        'checker.message.result',
        'checker.message.links',
        'checker.message.notice',
      ];
      final source = OrvikaLocalizations(OrvikaLanguage.fromCode('ru'));
      Set<String> placeholders(String value) => RegExp(
            r'\{([a-zA-Z][a-zA-Z0-9_]*)\}',
          ).allMatches(value).map((match) => match.group(1)!).toSet();

      for (final code in ['gu', 'ur']) {
        final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in keys) {
          expect(
            placeholders(localization.text(key)),
            placeholders(source.text(key)),
            reason: '$code must preserve placeholders for $key',
          );
        }
      }
      expect(OrvikaLanguage.fromCode('ur').isRightToLeft, isTrue);
      expect(OrvikaLanguage.fromCode('gu').isRightToLeft, isFalse);
    });


    test('Gujarati and Urdu cover the complete baseline with safety notices', () {
      final source = OrvikaLocalizations(OrvikaLanguage.fromCode('ru'));
      Set<String> placeholders(String value) => RegExp(
            r'\{([a-zA-Z][a-zA-Z0-9_]*)\}',
          ).allMatches(value).map((match) => match.group(1)!).toSet();

      for (final code in ['gu', 'ur']) {
        final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
        for (final key in OrvikaLocalizations.requiredTranslationKeys) {
          expect(localization.hasTranslation(key), isTrue,
              reason: '$code is missing baseline key $key');
          expect(localization.text(key), isNot(key));
          expect(
            placeholders(localization.text(key)),
            placeholders(source.text(key)),
            reason: '$code must preserve placeholders for $key',
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

    test('Arabic shared and feature interfaces cover the Russian baseline', () {
      final arabic = OrvikaLocalizations(OrvikaLanguage.fromCode('ar'));
      final russian = OrvikaLocalizations(OrvikaLanguage.fromCode('ru'));
      Set<String> placeholders(String value) => RegExp(
            r'\{([a-zA-Z][a-zA-Z0-9_]*)\}',
          ).allMatches(value).map((match) => match.group(1)!).toSet();

      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(arabic.hasTranslation(key), isTrue,
            reason: 'Arabic is missing shared key $key');
        expect(arabic.text(key), isNot(key),
            reason: 'Arabic falls back to the key for $key');
        expect(placeholders(arabic.text(key)), placeholders(russian.text(key)),
            reason: 'Arabic must preserve placeholders for $key');
      }

      final arabicFeatures = OrvikaFeatureTranslations.forCode('ar');
      final russianFeatures = OrvikaFeatureTranslations.forCode('ru');
      for (final key in russianFeatures.keys) {
        expect(arabicFeatures.containsKey(key), isTrue,
            reason: 'Arabic feature interface is missing $key');
        expect(arabicFeatures[key], isNot(key));
        expect(placeholders(arabicFeatures[key]!), placeholders(russianFeatures[key]!),
            reason: 'Arabic feature string must preserve placeholders for $key');
      }
      expect(OrvikaLanguage.fromCode('ar').isRightToLeft, isTrue);
      expect(OrvikaLanguage.fromCode('ar').hasDraftTranslation, isFalse);
      expect(OrvikaLanguage.fromCode('ar').hasReviewedTranslation, isTrue);
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
