import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_feature_translations.dart';

void main() {
  group('Six-priority QR feature translations', () {
    const localeCodes = ['de', 'fr', 'it', 'es', 'pt', 'ru'];
    const requiredKeys = [
      'checker.qr.detectedFormat',
      'checker.camera.notice.title',
      'checker.camera.notice.body',
      'checker.camera.permissionDenied',
      'checker.camera.unavailable',
      'checker.camera.previewError',
      'checker.camera.formats',
      'checker.image.privacyNotice',
    ];

    Set<String> placeholders(String value) => RegExp(
          r'\{([a-zA-Z][a-zA-Z0-9_]*)\}',
        ).allMatches(value).map((match) => match.group(1)!).toSet();

    test('every priority locale provides the QR and scanner safety notices', () {
      for (final locale in localeCodes) {
        final translations = OrvikaFeatureTranslations.forCode(locale);
        for (final key in requiredKeys) {
          expect(translations.containsKey(key), isTrue,
              reason: '$locale is missing $key');
          expect(translations[key], isNotEmpty,
              reason: '$locale has an empty value for $key');
          expect(translations[key], isNot(key),
              reason: '$locale is exposing the raw key $key');
        }
      }
    });

    test('dynamic QR format and camera error placeholders are preserved', () {
      final reference = OrvikaFeatureTranslations.forCode('ru');
      for (final locale in localeCodes) {
        final translations = OrvikaFeatureTranslations.forCode(locale);
        for (final key in [
          'checker.qr.detectedFormat',
          'checker.camera.previewError',
        ]) {
          expect(
            placeholders(translations[key]!),
            placeholders(reference[key]!),
            reason: '$locale changed the placeholder contract for $key',
          );
        }
      }
    });

    test('Portugal Portuguese adaptation retains the QR placeholder contract', () {
      final portugal = OrvikaFeatureTranslations.forCode('pt-PT');
      final brazil = OrvikaFeatureTranslations.forCode('pt');
      expect(portugal.containsKey('checker.qr.detectedFormat'), isTrue);
      expect(
        placeholders(portugal['checker.qr.detectedFormat']!),
        placeholders(brazil['checker.qr.detectedFormat']!),
      );
    });
  });
}
