import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/core/localization/hindi_checker_content.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';

void main() {
  group('Hindi checker result localization', () {
    test('localizes live-result announcements and interpolates every count', () {
      const l10n = OrvikaLocalizations(OrvikaLanguage('hi', 'Hindi', 'हिन्दी'));

      expect(
        l10n.textWithParameters(
          'checker.link.complete',
          fallback: 'Link analysis complete. {count} findings.',
          parameters: {'count': 4},
        ),
        'लिंक विश्लेषण पूरा हुआ। 4 निष्कर्ष मिले।',
      );
      expect(
        l10n.textWithParameters(
          'checker.message.complete',
          fallback: 'Message inspection complete. {findings} findings. {links} web addresses detected.',
          parameters: {'findings': 3, 'links': 2},
        ),
        'संदेश की जाँच पूरी हुई। 3 निष्कर्ष मिले। 2 वेब पते मिले।',
      );
      expect(
        l10n.textWithParameters(
          'checker.qr.complete',
          fallback: 'QR inspection complete. {title}. Severity {severity}. {count} link findings.',
          parameters: {
            'title': 'वेब पता',
            'severity': 'चेतावनी',
            'count': 1,
          },
        ),
        'QR जाँच पूरी हुई। वेब पता। गंभीरता: चेतावनी। 1 लिंक संबंधी निष्कर्ष।',
      );
    });

    test('localizes every URL and message finding while preserving severity', () {
      const titles = [
        'Unicode hostname',
        'Unencrypted connection',
        'Embedded sign-in information',
        'Internationalised domain encoding',
        'IP-address destination',
        'Malformed IPv4-looking hostname',
        'Unusual numeric hostname',
        'Long subdomain chain',
        'Non-standard port',
        'Fragment present',
        'No structural warning detected',
        'Address not analysed',
        'Urgency or pressure language',
        'Credential or sign-in request',
        'OTP or authentication-code reference',
        'Payment or financial action',
        'Prize or unexpected reward',
        'Threat or consequence language',
        'Obfuscated web address detected',
        'Link or web address detected',
        'No listed social-engineering cues detected',
        'Message not analysed',
      ];

      for (final title in titles) {
        final source = LinkFinding(
          title: title,
          detail: switch (title) {
            'Non-standard port' => 'The address uses port 8443 instead of the usual HTTP or HTTPS port.',
            'Link or web address detected' => '2 web addresses found. A visible link may conceal a different destination.',
            _ => 'Source detail for $title.',
          },
          severity: FindingSeverity.warning,
        );
        final localized = HindiCheckerContent.localizeFinding(source, 'hi');
        expect(localized.title, isNot(source.title), reason: title);
        expect(localized.detail, isNot(source.detail), reason: title);
        expect(localized.severity, source.severity, reason: title);
      }
    });

    test('interpolates port and detected web-address count', () {
      final port = HindiCheckerContent.localizeFinding(
        const LinkFinding(
          title: 'Non-standard port',
          detail: 'The address uses port 8443 instead of the usual HTTP or HTTPS port.',
          severity: FindingSeverity.caution,
        ),
        'hi',
      );
      expect(port.detail, contains('8443'));

      final count = HindiCheckerContent.localizeFinding(
        const LinkFinding(
          title: 'Link or web address detected',
          detail: '3 web addresses found. A visible link may conceal a different destination.',
          severity: FindingSeverity.info,
        ),
        'hi',
      );
      expect(count.detail, contains('3'));
      expect(count.detail, isNot(contains('{count}')));
    });

    test('preserves English findings for non-Hindi languages', () {
      const source = LinkFinding(
        title: 'Unencrypted connection',
        detail: 'This address uses HTTP.',
        severity: FindingSeverity.warning,
      );
      expect(HindiCheckerContent.localizeFinding(source, 'mr'), same(source));
      expect(HindiCheckerContent.localizeLinkNotice('No network request was made.', 'mr'),
          'No network request was made.');
    });

    test('localizes all QR payload classes without changing analysis semantics', () {
      const titles = [
        'Wi-Fi configuration',
        'Contact card',
        'Calendar event',
        'UPI payment request',
        'Phone call action',
        'Email action',
        'Text-message action',
        'Location coordinates',
        'Application-specific link',
        'Plain text',
        'Web address',
        'Unrecognised web address',
        'QR content not analysed',
      ];

      for (final title in titles) {
        final source = QrPayloadAnalysis(
          kind: QrPayloadKind.plainText,
          title: title,
          detail: title == 'Application-specific link'
              ? 'This payload uses the "customapp:" scheme instead of a normal web URL.'
              : 'Source QR detail for $title.',
          severity: FindingSeverity.caution,
          normalizedUrl: 'https://example.com/path',
          linkFindings: const [
            LinkFinding(
              title: 'Unencrypted connection',
              detail: 'This address uses HTTP.',
              severity: FindingSeverity.warning,
            ),
          ],
          isValid: false,
        );
        final localized = HindiCheckerContent.localizeQr(source, 'hi');
        expect(localized.title, isNot(source.title), reason: title);
        expect(localized.detail, isNot(source.detail), reason: title);
        expect(localized.kind, source.kind, reason: title);
        expect(localized.severity, source.severity, reason: title);
        expect(localized.normalizedUrl, source.normalizedUrl, reason: title);
        expect(localized.isValid, source.isValid, reason: title);
        expect(localized.linkFindings, hasLength(source.linkFindings.length));
        expect(localized.linkFindings.single.title, 'एन्क्रिप्शन रहित कनेक्शन');
      }
    });

    test('preserves application URI scheme in localized QR detail', () {
      final localized = HindiCheckerContent.localizeQr(
        const QrPayloadAnalysis(
          kind: QrPayloadKind.applicationLink,
          title: 'Application-specific link',
          detail: 'This payload uses the "customapp:" scheme instead of a normal web URL.',
          severity: FindingSeverity.warning,
        ),
        'hi',
      );
      expect(localized.detail, contains('customapp:'));
      expect(localized.detail, isNot(contains('{scheme}')));
    });

    test('localizes notices and keeps non-Hindi fallback unchanged', () {
      expect(
        HindiCheckerContent.localizeLinkNotice('No network request was made.', 'hi'),
        'कोई नेटवर्क अनुरोध नहीं किया गया।',
      );
      expect(HindiCheckerContent.localizeMessageNotice('hi'), contains('अपलोड'));
      expect(
        HindiCheckerContent.localizeMessageNotice('en'),
        'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.',
      );
    });
  });
}
