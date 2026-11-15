import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';

void main() {
  group('Localization release governance', () {
    test('keeps the selectable catalogue unique and excludes deferred locales', () {
      final codes = OrvikaLanguage.allValues.map((language) => language.code).toList();

      expect(codes, hasLength(192));
      expect(codes.toSet(), hasLength(codes.length));
      expect(codes, isNot(contains('ba')));
      expect(codes, isNot(contains('tt')));
      expect(codes, contains('pt-PT'));
    });

    test('keeps reviewed status separate from authored translation availability', () {
      const reviewed = {'en', 'ru', 'ar', 'pt-PT'};
      final actualReviewed = OrvikaLanguage.allValues
          .where((language) => language.hasReviewedTranslation)
          .map((language) => language.code)
          .toSet();

      expect(actualReviewed, reviewed);
      expect(OrvikaLocalizations.translatedLanguageCodes, containsAll(reviewed.where((code) => code != 'en')));
      expect(OrvikaLocalizations.translatedLanguageCodes, isNot(contains('zh')));
      expect(OrvikaLanguage.fromCode('zh').hasReviewedTranslation, isFalse);
      expect(OrvikaLanguage.fromCode('hi').hasReviewedTranslation, isFalse);
    });

    test('keeps Arabic and Urdu direction metadata independent of review status', () {
      expect(OrvikaLanguage.fromCode('ar').isRightToLeft, isTrue);
      expect(OrvikaLanguage.fromCode('ur').isRightToLeft, isTrue);
      expect(OrvikaLanguage.fromCode('ur').hasReviewedTranslation, isFalse);
    });

    test('keeps regional Portuguese locale identities distinct', () {
      expect(OrvikaLanguage.fromLocaleTag('pt-BR').code, 'pt');
      expect(OrvikaLanguage.fromLocaleTag('pt-PT').code, 'pt-PT');
      expect(OrvikaLanguage.fromLocaleTag('pt_PT').code, 'pt-PT');
    });
  });
}
