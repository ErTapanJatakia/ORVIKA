import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/core/localization/russian_academy_content.dart';
import 'package:orvika/core/localization/russian_privacy_content.dart';
import 'package:orvika/core/localization/russian_response_content.dart';
import 'package:orvika/core/localization/russian_intelligence_content.dart';
import 'package:orvika/core/localization/russian_checker_content.dart';
import 'package:orvika/features/academy/domain/academy_curriculum.dart';
import 'package:orvika/features/privacy/domain/privacy_checklist.dart';
import 'package:orvika/features/response/domain/response_playbooks.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/message_check/domain/message_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';

void main() {
  group('Russian feature localization completeness', () {
    const code = 'ru';
    final l10n = OrvikaLocalizations(OrvikaLanguage.fromCode(code));

    test('covers all reviewed core interface keys', () {
      expect(OrvikaLocalizations.requiredTranslationKeys, hasLength(146));
      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(l10n.hasTranslation(key), isTrue, reason: 'Missing Russian key: $key');
        expect(l10n.text(key), isNot(key), reason: 'Unresolved Russian key: $key');
      }
    });

    test('interpolates all Russian progress and count placeholders', () {
      expect(
        l10n.textWithParameters(
          'intelligence.count',
          parameters: const {'count': 10},
        ),
        'Справочных материалов: 10',
      );
      expect(
        l10n.textWithParameters(
          'privacy.progress',
          parameters: const {'reviewed': 7, 'total': 12},
        ),
        'Проверено практик: 7 из 12',
      );
      expect(
        l10n.textWithParameters(
          'privacy.progressSemantics',
          parameters: const {'reviewed': 7, 'total': 12},
        ),
        contains('7 из 12'),
      );
      expect(
        l10n.textWithParameters(
          'privacy.progressUpdate',
          parameters: const {'reviewed': 7, 'total': 12},
        ),
        contains('7 из 12'),
      );
      expect(
        l10n.textWithParameters(
          'academy.progress',
          parameters: const {'completed': 3, 'total': 8},
        ),
        'Завершено уроков: 3 из 8',
      );
      expect(
        l10n.textWithParameters(
          'academy.progressSemantics',
          parameters: const {'completed': 3, 'total': 8},
        ),
        contains('3 из 8'),
      );
      expect(
        l10n.textWithParameters(
          'academy.progressUpdate',
          parameters: const {'completed': 3, 'total': 8},
        ),
        contains('3 из 8'),
      );
      expect(
        l10n.textWithParameters('privacy.progress'),
        contains('{reviewed}'),
      );
    });

    test('localizes every Academy lesson and preserves assessment logic', () {
      expect(AcademyCurriculum.lessons, hasLength(8));
      for (final source in AcademyCurriculum.lessons) {
        final item = RussianAcademyContent.localize(source, code);
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.summary, isNot(source.summary));
        expect(item.keyPoints, hasLength(source.keyPoints.length));
        for (var i = 0; i < source.keyPoints.length; i++) {
          expect(item.keyPoints[i], isNot(source.keyPoints[i]),
              reason: 'Untranslated Academy key point in ${source.id} at index $i');
        }
        expect(item.question, isNot(source.question));
        expect(item.options, hasLength(source.options.length));
        for (var i = 0; i < source.options.length; i++) {
          expect(item.options[i], isNot(source.options[i]),
              reason: 'Untranslated Academy option in ${source.id} at index $i');
        }
        expect(item.correctIndex, source.correctIndex);
        expect(item.explanation, isNot(source.explanation));
      }
    });

    test('localizes all twelve Privacy practices', () {
      expect(PrivacyChecklist.practices, hasLength(12));
      for (final source in PrivacyChecklist.practices) {
        final item = RussianPrivacyContent.localize(source, code);
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.why, isNot(source.why));
        expect(item.action, isNot(source.action));
        expect(item.limit, isNot(source.limit));
      }
    });

    test('localizes all five Response playbooks and preserves list counts', () {
      expect(ResponsePlaybooks.playbooks, hasLength(5));
      for (final source in ResponsePlaybooks.playbooks) {
        final item = RussianResponseContent.localize(source, code);
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.summary, isNot(source.summary));
        expect(item.firstAction, isNot(source.firstAction));
        expect(item.steps, hasLength(source.steps.length));
        for (var i = 0; i < source.steps.length; i++) {
          expect(item.steps[i], isNot(source.steps[i]),
              reason: 'Untranslated Response step in ${source.id} at index $i');
        }
        expect(item.preserve, hasLength(source.preserve.length));
        for (var i = 0; i < source.preserve.length; i++) {
          expect(item.preserve[i], isNot(source.preserve[i]),
              reason: 'Untranslated evidence item in ${source.id} at index $i');
        }
        expect(item.avoid, hasLength(source.avoid.length));
        for (var i = 0; i < source.avoid.length; i++) {
          expect(item.avoid[i], isNot(source.avoid[i]),
              reason: 'Untranslated caution item in ${source.id} at index $i');
        }
        expect(item.limit, isNot(source.limit));
      }
    });

    test('localizes all ten Intelligence references', () {
      expect(IntelligenceLibrary.entries, hasLength(10));
      for (final source in IntelligenceLibrary.entries) {
        final item = RussianIntelligenceContent.localize(source, code);
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.signal, isNot(source.signal));
        expect(item.meaning, isNot(source.meaning));
        expect(item.action, isNot(source.action));
        expect(item.limit, isNot(source.limit));
      }
    });

    test('localizes checker findings without changing severity', () {
      const source = LinkFinding(
        title: 'Unencrypted connection',
        detail: 'This address uses HTTP.',
        severity: FindingSeverity.warning,
      );
      final item = RussianCheckerContent.localizeFinding(source, code);
      expect(item.title, 'Незашифрованное соединение');
      expect(item.detail, isNot(source.detail));
      expect(item.severity, source.severity);
      expect(RussianCheckerContent.localizeMessageNotice(code), contains('эвристические'));
      expect(RussianCheckerContent.localizeLinkNotice('No network request was made.', code),
          'Сетевые запросы не выполнялись.');
    });

    test('localizes every URL and message analyzer finding title', () {
      const urlInputs = [
        'http://example.com',
        'https://user:secret@example.com',
        'https://192.0.2.1',
        'https://999.1.1.1',
        'https://123.456',
        'https://a.b.c.example.com',
        'https://example.com:8443/path#section',
        'https://example.com',
        '',
      ];
      for (final input in urlInputs) {
        final result = const UrlAnalyzer().analyze(input);
        for (final finding in result.findings) {
          final localized = RussianCheckerContent.localizeFinding(finding, code);
          expect(localized.title, isNot(finding.title),
              reason: 'Untranslated URL finding: ${finding.title} for $input');
          expect(localized.severity, finding.severity);
        }
      }

      const messageInputs = [
        'Urgent: act now or your account will be suspended.',
        'Verify your password and sign in.',
        'Your OTP verification code is 123456.',
        'Please pay now using this bank transfer.',
        'You have won a prize; claim your prize.',
        'Police case: legal action and penalty.',
        'Visit hxxps://example.invalid now.',
        'Visit https://example.com now.',
        'A routine note with no matching indicators.',
        '',
      ];
      for (final input in messageInputs) {
        final result = const MessageAnalyzer().analyze(input);
        for (final finding in result.findings) {
          final localized = RussianCheckerContent.localizeFinding(finding, code);
          expect(localized.title, isNot(finding.title),
              reason: 'Untranslated message finding: ${finding.title} for $input');
          expect(localized.severity, finding.severity);
        }
      }
    });

    test('preserves dynamic values and uses natural Russian QR labels', () {
      final port = RussianCheckerContent.localizeFinding(
        const LinkFinding(
          title: 'Non-standard port',
          detail: 'The address uses port 8443, rather than the usual HTTP or HTTPS port.',
          severity: FindingSeverity.caution,
        ),
        code,
      );
      expect(port.detail, contains('8443'));

      final links = RussianCheckerContent.localizeFinding(
        const LinkFinding(
          title: 'Link or web address detected',
          detail: '2 web address(es) found. A visible link can conceal a different destination.',
          severity: FindingSeverity.caution,
        ),
        code,
      );
      expect(links.detail, contains('2'));
      expect(links.detail, contains('Количество обнаруженных веб-адресов'));

      final qr = const QrPayloadAnalyzer().analyze('tel:+10000000000');
      final localizedQr = RussianCheckerContent.localizeQr(qr, code);
      expect(localizedQr.title, 'Телефонный вызов');
      expect(localizedQr.detail, contains('номер'));
      expect(localizedQr.severity, qr.severity);
      expect(localizedQr.kind, qr.kind);

      final appLink = const QrPayloadAnalyzer().analyze('orvika-demo://open');
      final localizedAppLink = RussianCheckerContent.localizeQr(appLink, code);
      expect(localizedAppLink.detail, contains('orvika-demo'));
      expect(localizedAppLink.severity, appLink.severity);
      expect(localizedAppLink.kind, appLink.kind);
    });

    test('localizes every QR payload class without changing analysis metadata', () {
      final cases = <({String payload, QrPayloadKind kind, String title})>[
        (payload: 'WIFI:T:WPA;S:Example;P:secret;;', kind: QrPayloadKind.wifiCredentials, title: 'Настройки Wi-Fi'),
        (payload: 'BEGIN:VCARD\\nFN:Example\\nEND:VCARD', kind: QrPayloadKind.contactCard, title: 'Контактная карточка'),
        (payload: 'BEGIN:VEVENT\\nSUMMARY:Example\\nEND:VEVENT', kind: QrPayloadKind.calendarEvent, title: 'Событие календаря'),
        (payload: 'upi://pay?pa=merchant@example&pn=Merchant&am=10', kind: QrPayloadKind.paymentRequest, title: 'Запрос платежа UPI'),
        (payload: 'tel:+10000000000', kind: QrPayloadKind.phoneAction, title: 'Телефонный вызов'),
        (payload: 'mailto:help@example.com', kind: QrPayloadKind.emailAction, title: 'Действие электронной почты'),
        (payload: 'sms:+10000000000', kind: QrPayloadKind.messageAction, title: 'Действие SMS'),
        (payload: 'geo:55.75,37.61', kind: QrPayloadKind.location, title: 'Координаты местоположения'),
        (payload: 'orvika-demo://open', kind: QrPayloadKind.applicationLink, title: 'Ссылка для приложения'),
        (payload: 'Пример обычного текста', kind: QrPayloadKind.plainText, title: 'Обычный текст'),
        (payload: 'https://example.com', kind: QrPayloadKind.webLink, title: 'Веб-адрес'),
        (payload: '', kind: QrPayloadKind.invalid, title: 'Содержимое QR-кода не проанализировано'),
      ];

      for (final testCase in cases) {
        final source = const QrPayloadAnalyzer().analyze(testCase.payload);
        final localized = RussianCheckerContent.localizeQr(source, code);
        expect(source.kind, testCase.kind, reason: testCase.payload);
        expect(localized.title, testCase.title, reason: testCase.payload);
        expect(localized.kind, source.kind, reason: testCase.payload);
        expect(localized.severity, source.severity, reason: testCase.payload);
        expect(localized.isValid, source.isValid, reason: testCase.payload);
        expect(localized.normalizedUrl, source.normalizedUrl, reason: testCase.payload);
      }
    });

    test('covers scanner controls, errors and privacy disclosures', () {
      const keys = [
        'checker.camera.title', 'checker.camera.close', 'checker.camera.notice.title',
        'checker.camera.notice.body', 'checker.camera.permissionDenied',
        'checker.camera.unavailable', 'checker.camera.previewError',
        'checker.camera.requesting', 'checker.camera.allow', 'checker.camera.stop',
        'checker.camera.formats', 'checker.image.title', 'checker.image.close',
        'checker.image.instruction', 'checker.image.error.selection',
        'checker.image.error.empty', 'checker.image.error.tooLarge',
        'checker.image.error.noCode', 'checker.image.error.decode',
        'checker.image.privacyNotice', 'checker.image.choose',
        'checker.image.chooseAnother', 'checker.image.previewUnavailable',
        'checker.image.selected', 'checker.image.scanning', 'checker.image.detect',
        'checker.image.clear', 'checker.image.selectResult',
      ];
      for (final key in keys) {
        expect(l10n.hasTranslation(key), isTrue, reason: 'Missing Russian scanner key: $key');
        expect(l10n.text(key), isNot(key), reason: 'Untranslated Russian scanner key: $key');
      }
      expect(l10n.text('checker.camera.previewError'), contains('{error}'));
      expect(l10n.text('checker.qr.detectedFormat'), contains('{format}'));
      expect(l10n.text('privacy.analytics.notice'), contains('Vercel Web Analytics'));
      expect(l10n.text('privacy.device.notice'), contains('ORVIKA'));
    });
  });
}
