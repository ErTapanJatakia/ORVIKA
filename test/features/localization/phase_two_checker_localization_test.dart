import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';

void main() {
  const languageCodes = [
    'ru', 'hi', 'de', 'fr', 'it', 'pa', 'ur', 'ar', 'mr', 'gu', 'sa',
  ];
  const phaseTwoKeys = [
    'checker.link.heading',
    'checker.link.input',
    'checker.link.action',
    'checker.qr.heading',
    'checker.qr.input',
    'checker.qr.action',
    'checker.qr.scanCamera',
    'checker.qr.scanImage',
    'checker.message.heading',
    'checker.message.input',
    'checker.message.action',
    'checker.severity.info',
    'checker.severity.caution',
    'checker.severity.warning',
  ];

  test('all authored draft/reviewed packs cover the phase-two checker controls', () {
    for (final code in languageCodes) {
      final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
      for (final key in phaseTwoKeys) {
        expect(localization.hasTranslation(key), isTrue,
            reason: '$code is missing $key');
        expect(localization.text(key), isNotEmpty);
        expect(localization.text(key), isNot(key));
      }
    }
  });

  test('languages outside authored packs retain explicit English fallback', () {
    final localization = OrvikaLocalizations(OrvikaLanguage.fromCode('ce'));
    expect(localization.hasTranslation('checker.qr.scanCamera'), isFalse);
    expect(
      localization.text(
        'checker.qr.scanCamera',
        'Scan QR / barcode with camera',
      ),
      'Scan QR / barcode with camera',
    );
  });

  test('RTL writing direction remains independent from draft translation coverage', () {
    for (final code in ['ar', 'ur']) {
      final language = OrvikaLanguage.fromCode(code);
      final localization = OrvikaLocalizations(language);
      expect(language.isRightToLeft, isTrue);
      expect(localization.usesRightToLeftLayout, isTrue);
      expect(localization.hasTranslation('checker.qr.scanCamera'), isTrue);
    }
    expect(OrvikaLanguage.fromCode('de').isRightToLeft, isFalse);
  });

  testWidgets('QR scan actions render in French', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: OrvikaLanguageScope(
        language: OrvikaLanguage.fromCode('fr'),
        child: const QrCheckScreen(),
      ),
    ));
    expect(find.text('Scanner un QR code ou un code-barres avec la caméra'),
        findsOneWidget);
    expect(find.text('Scanner un QR code ou un code-barres depuis une image'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('QR scan actions render in Arabic', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: OrvikaLanguageScope(
        language: OrvikaLanguage.fromCode('ar'),
        child: const QrCheckScreen(),
      ),
    ));
    expect(find.text('امسح رمز QR أو الرمز الشريطي بالكاميرا'), findsOneWidget);
    expect(find.text('امسح رمز QR أو الرمز الشريطي من صورة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
