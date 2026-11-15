import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';

void main() {
  group('Localization release governance', () {
    test('the unified picker exposes 192 unique selectable languages', () {
      final languages = OrvikaLanguage.allValues;
      final codes = languages.map((language) => language.code).toList();

      expect(languages, hasLength(192));
      expect(codes.toSet(), hasLength(codes.length));
      expect(codes, isNot(contains('ba')));
      expect(codes, isNot(contains('tt')));
    });

    test('only explicitly reviewed locales are marked reviewed', () {
      final reviewed = OrvikaLanguage.allValues
          .where((language) => language.hasReviewedTranslation)
          .map((language) => language.code)
          .toSet();

      expect(reviewed, {'en', 'ru', 'ar', 'pt-PT'});
      for (final code in ['hi', 'de', 'fr', 'it', 'es', 'pt', 'pa', 'ur', 'mr', 'gu', 'sa', 'zh']) {
        expect(
          OrvikaLanguage.fromCode(code).hasReviewedTranslation,
          isFalse,
          reason: '$code must remain draft until its review gates are met',
        );
      }
    });

    test('RTL metadata is independent of translation approval', () {
      expect(OrvikaLanguage.fromCode('ar').isRightToLeft, isTrue);
      expect(OrvikaLanguage.fromCode('ur').isRightToLeft, isTrue);
      expect(OrvikaLanguage.fromCode('ur').hasReviewedTranslation, isFalse);
    });
  });
}
