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

  test('extended scanner and privacy controls have explicit English fallbacks', () {
    final localization = OrvikaLocalizations(OrvikaLanguage.fromCode('ce'));
    const fallbacks = {
      'checker.camera.title': 'Scan a code',
      'checker.camera.allow': 'Allow camera for this scan',
      'checker.camera.stop': 'Stop camera',
      'checker.image.title': 'Scan from image',
      'checker.image.choose': 'Choose image',
      'checker.image.clear': 'Clear selected image',
      'privacy.reset.title': 'Reset review progress?',
      'privacy.reset.action': 'Reset progress',
      'privacy.error.save': 'Could not save this review on the device.',
      'checker.link.complete': 'Link analysis complete. {count} findings.',
      'checker.message.complete': 'Message inspection complete. {findings} findings. {links} web addresses detected.',
      'checker.qr.complete': 'QR inspection complete. {title}. Severity {severity}. {count} link findings.',
      'checker.qr.detectedFormat': 'Detected code format: {format}',
    };
    for (final entry in fallbacks.entries) {
      expect(localization.hasTranslation(entry.key), isFalse);
      expect(localization.text(entry.key, entry.value), entry.value);
    }
  });

  test('checker and scanner UI copy has authored translations or explicit English fallbacks', () {
    const fallbacks = {
      'checker.link.description': 'Paste a URL to review its structure for common warning signs. Analysis happens on this device.',
      'checker.link.result': 'Analysis findings',
      'checker.link.notice': 'Important: a clean structural check is not a safety certificate. ORVIKA does not open the URL, contact the destination, or verify its reputation in this version.',
      'checker.message.description': 'Paste a suspicious SMS, email or chat message to review common social-engineering cues. Analysis stays on this device.',
      'checker.message.hint': 'Paste the message here. Avoid adding unrelated personal information.',
      'checker.message.result': 'Review findings',
      'checker.message.links': 'Detected web addresses',
      'checker.message.notice': 'Important: this version uses a limited set of transparent text patterns. It does not determine whether a sender is genuine, prove fraud, inspect attachments, or verify a message against external threat intelligence. Do not share OTPs, passwords or recovery codes.',
      'checker.qr.description': 'Inspect decoded QR content before opening a link, joining a network, saving a contact, or making a payment.',
      'checker.qr.hint': 'Paste the text or destination decoded from a QR code',
      'checker.qr.result': 'Inspection result',
      'checker.qr.destination': 'Detected destination',
      'checker.qr.notice': 'Camera scanning starts only after you explicitly choose Scan and then Allow camera for this scan. The camera stops when a code is captured or you leave the scanner. Decoded content is analysed on this device; ORVIKA does not open destinations, connect to Wi-Fi, save contacts, send messages, or initiate payments. Browser and operating-system permission settings remain under your control.',
      'checker.camera.close': 'Close scanner',
      'checker.image.close': 'Close image scanner',
      'checker.image.instruction': 'Choose an image containing a QR code or barcode.',
      'checker.image.error.empty': 'The selected image is empty or could not be read.',
      'checker.image.error.tooLarge': 'Please choose an image smaller than 20 MB.',
      'checker.image.error.selection': 'The image could not be selected. Check the file and try again.',
      'checker.image.error.noCode': 'No supported QR code or barcode was detected. Try a clearer image with the code fully visible.',
      'checker.image.error.decode': 'This image could not be decoded on this device or browser.',
    };
    for (final code in languageCodes) {
      final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(code));
      for (final entry in fallbacks.entries) {
        final resolved = localization.text(entry.key, entry.value);
        expect(resolved, isNotEmpty, reason: '$code has empty copy for ${entry.key}');
        expect(resolved, isNot(entry.key), reason: '$code exposes raw key ${entry.key}');
      }
    }
  });

  test('parameterized checker fallbacks interpolate every supplied value', () {
    final localization = OrvikaLocalizations(OrvikaLanguage.fromCode('ce'));
    expect(
      localization.textWithParameters(
        'checker.image.detectedMany',
        fallback: 'Detected {count} codes',
        parameters: {'count': 3},
      ),
      'Detected 3 codes',
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
