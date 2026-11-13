import 'package:flutter_test/flutter_test.dart';

import 'package:orvika/core/localization/orvika_language.dart';

void main() {
  group('OrvikaLanguage locale registry', () {
    test('every selectable language exposes a non-empty BCP 47 tag', () {
      final languages = OrvikaLanguage.allValues;

      expect(languages, isNotEmpty);
      for (final language in languages) {
        expect(language.localeTag, isNotEmpty, reason: language.name);
        expect(language.localeTag, isNot(contains('_')), reason: language.name);
      }
      expect(languages.map((language) => language.code).toSet().length,
          languages.length);
    });

    test('regional and script-specific catalogue entries use canonical tags', () {
      expect(OrvikaLanguage.fromCode('zh').localeTag, 'zh-Hans-CN');
      expect(OrvikaLanguage.fromCode('pt').localeTag, 'pt-BR');
      expect(OrvikaLanguage.fromCode('pt-PT').localeTag, 'pt-PT');
      expect(OrvikaLanguage.fromCode('sr').localeTag, 'sr-Cyrl-RS');
      expect(OrvikaLanguage.fromCode('pa').localeTag, 'pa-Guru-IN');
    });

    test('locale tags resolve to their stable catalogue entries', () {
      for (final language in OrvikaLanguage.allValues) {
        expect(
          OrvikaLanguage.fromLocaleTag(language.localeTag).code,
          language.code,
          reason: language.localeTag,
        );
      }
      expect(OrvikaLanguage.fromLocaleTag('zh-CN').code, 'zh');
      expect(OrvikaLanguage.fromLocaleTag('zh-Hans-CN').code, 'zh');
      expect(OrvikaLanguage.fromLocaleTag('pt-BR').code, 'pt');
      expect(OrvikaLanguage.fromLocaleTag('pt-PT').code, 'pt-PT');
    });

    test('deferred languages remain excluded from the selectable registry', () {
      final codes = OrvikaLanguage.allValues.map((language) => language.code);
      expect(codes, isNot(contains('ba')));
      expect(codes, isNot(contains('tt')));
    });
  });
}
