import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/french_checker_content.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/message_check/domain/message_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';

void main() {
  const urls = UrlAnalyzer();
  const messages = MessageAnalyzer();
  const qr = QrPayloadAnalyzer();

  test('French URL findings preserve severity and interpolate port and count values', () {
    final result = urls.analyze('http://example.com:8080');
    expect(result.findings, isNotEmpty);
    for (final finding in result.findings) {
      final translated = FrenchCheckerContent.localizeFinding(finding, 'fr');
      expect(translated.title, isNot(finding.title), reason: finding.title);
      expect(translated.detail, isNot(finding.detail), reason: finding.title);
      expect(translated.severity, finding.severity);
    }
    expect(FrenchCheckerContent.localizeLinkNotice(result.notice, 'fr'), isNot(result.notice));
  });

  test('French message findings and privacy disclosure are localized', () {
    final result = messages.analyze(
      'URGENT: verify your account password and OTP immediately. Pay now to claim your prize: https://example.com',
    );
    expect(result.findings, isNotEmpty);
    for (final finding in result.findings) {
      final translated = FrenchCheckerContent.localizeFinding(finding, 'fr');
      expect(translated.title, isNot(finding.title), reason: finding.title);
      expect(translated.detail, isNot(finding.detail), reason: finding.title);
      expect(translated.severity, finding.severity);
    }
    expect(FrenchCheckerContent.localizeMessageNotice('fr'), isNotEmpty);
  });

  test('French QR translations preserve analysis metadata and dynamic scheme', () {
    for (final payload in [
      'WIFI:T:WPA;S:Example;P:secret;;',
      'BEGIN:VCARD\nFN:Example Person\nEND:VCARD',
      'BEGIN:VEVENT\nSUMMARY:Meeting\nEND:VEVENT',
      'upi://pay?pa=merchant@example&pn=Merchant&am=10',
      'tel:+39123456789',
      'mailto:help@example.com',
      'sms:+39123456789',
      'geo:45.4,9.1',
      'customscheme://open',
      'ordinary text',
      'https://example.com',
    ]) {
      final source = qr.analyze(payload);
      final translated = FrenchCheckerContent.localizeQr(source, 'fr');
      expect(translated.title, isNot(source.title), reason: source.title);
      expect(translated.detail, isNot(source.detail), reason: source.title);
      expect(translated.kind, source.kind);
      expect(translated.severity, source.severity);
      expect(translated.isValid, source.isValid);
      expect(translated.normalizedUrl, source.normalizedUrl);
      expect(translated.linkFindings, source.linkFindings);
    }
  });

  test('non-French checker results remain unchanged', () {
    final finding = urls.analyze('http://example.com').findings.first;
    final source = qr.analyze('https://example.com');
    expect(FrenchCheckerContent.localizeFinding(finding, 'en'), same(finding));
    expect(FrenchCheckerContent.localizeQr(source, 'en'), same(source));
  });
}
