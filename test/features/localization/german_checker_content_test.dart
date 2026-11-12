import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/german_checker_content.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/message_check/domain/message_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';

void main() {
  const urls = UrlAnalyzer();
  const messages = MessageAnalyzer();
  const qr = QrPayloadAnalyzer();

  test('German URL findings and notices are localized without changing severity', () {
    final result = urls.analyze('http://example.com');
    expect(result.findings, isNotEmpty);
    for (final finding in result.findings) {
      final translated = GermanCheckerContent.localizeFinding(finding, 'de');
      expect(translated.title, isNot(finding.title));
      expect(translated.detail, isNot(finding.detail));
      expect(translated.severity, finding.severity);
    }
    expect(
      GermanCheckerContent.localizeLinkNotice(result.notice, 'de'),
      isNot(result.notice),
    );
  });

  test('German message findings and disclosure are localized', () {
    final result = messages.analyze(
      'URGENT: verify your account password and OTP immediately. '
      'Pay now to claim your prize: https://example.com',
    );
    expect(result.findings, isNotEmpty);
    for (final finding in result.findings) {
      final translated = GermanCheckerContent.localizeFinding(finding, 'de');
      expect(translated.title, isNot(finding.title), reason: finding.title);
      expect(translated.detail, isNot(finding.detail), reason: finding.title);
      expect(translated.severity, finding.severity);
    }
    expect(GermanCheckerContent.localizeMessageNotice('de'), isNot(result.notice));
  });

  test('German QR result covers common action types and preserves payload metadata', () {
    for (final payload in [
      'WIFI:T:WPA;S:Example;P:secret;;',
      'BEGIN:VCARD\nFN:Example Person\nEND:VCARD',
      'BEGIN:VEVENT\nSUMMARY:Meeting\nEND:VEVENT',
      'upi://pay?pa=merchant@example&pn=Merchant&am=10',
      'tel:+49123456789',
      'mailto:help@example.com',
      'sms:+49123456789',
      'geo:52.5,13.4',
      'customscheme://open',
      'ordinary text',
      'https://example.com',
    ]) {
      final source = qr.analyze(payload);
      final translated = GermanCheckerContent.localizeQr(source, 'de');
      expect(translated.title, isNot(source.title), reason: source.title);
      expect(translated.detail, isNot(source.detail), reason: source.title);
      expect(translated.kind, source.kind);
      expect(translated.severity, source.severity);
      expect(translated.isValid, source.isValid);
    }
  });

  test('non-German checker results remain unchanged', () {
    final finding = urls.analyze('http://example.com').findings.first;
    final source = qr.analyze('https://example.com');
    expect(GermanCheckerContent.localizeFinding(finding, 'en'), same(finding));
    expect(GermanCheckerContent.localizeQr(source, 'en'), same(source));
  });
}
