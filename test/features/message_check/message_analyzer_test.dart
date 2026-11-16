import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/message_check/domain/message_analyzer.dart';

void main() {
  const analyzer = MessageAnalyzer();

  test('flags credential and OTP requests with warning severity', () {
    final result = analyzer.analyze(
      'Your account sign-in is blocked. Share your OTP and password immediately.',
    );

    expect(result.isValid, isTrue);
    expect(result.findings.map((finding) => finding.title),
        containsAll(['Credential or sign-in request', 'OTP or authentication-code reference']));
    expect(result.findings.where((finding) =>
        finding.severity == FindingSeverity.warning), isNotEmpty);
  });

  test('detects urgency, payment language and web addresses', () {
    final result = analyzer.analyze(
      'URGENT: pay now to claim your refund at https://example.test/claim',
    );

    expect(result.findings.map((finding) => finding.title),
        containsAll(['Urgency or pressure language', 'Payment or financial action', 'Link or web address detected']));
    expect(result.detectedLinks, ['https://example.test/claim']);
  });

  test('does not label ordinary unmatched text as malicious', () {
    final result = analyzer.analyze('The team meeting starts at 10 tomorrow.');

    expect(result.isValid, isTrue);
    expect(result.findings.single.severity, FindingSeverity.info);
    expect(result.findings.single.title, 'No listed social-engineering cues detected');
  });

  test('rejects empty and oversized input', () {
    expect(analyzer.analyze(' ').isValid, isFalse);
    expect(analyzer.analyze(List.filled(10001, 'x').join()).isValid, isFalse);
  });

  test('detects Hindi and Russian urgency and authentication wording', () {
    final hindi = analyzer.analyze('तुरंत अपना ओटीपी साझा करें');
    final russian = analyzer.analyze('Срочно сообщите одноразовый пароль и код подтверждения');

    expect(hindi.findings.map((f) => f.title), contains('Urgency or pressure language'));
    expect(hindi.findings.map((f) => f.title), contains('OTP or authentication-code reference'));
    expect(russian.findings.map((f) => f.title), contains('Urgency or pressure language'));
    expect(russian.findings.map((f) => f.title), contains('OTP or authentication-code reference'));
  });

  test('detects internationalised URLs and obfuscated hxxps links', () {
    final result = analyzer.analyze(
      'Проверьте https://раypal.example и hxxps://example.test/login',
    );

    expect(result.findings.map((f) => f.title), contains('Link or web address detected'));
    expect(result.findings.map((f) => f.title), contains('Obfuscated web address detected'));
    expect(result.detectedLinks, contains('https://раypal.example'));
  });

  test('detects impersonation, secrecy and remote-access lures', () {
    final result = analyzer.analyze(
      'URGENT: Bank security team says keep this secret. Install AnyDesk for remote access.',
    );

    expect(result.findings.map((f) => f.title), containsAll([
      'Urgency or pressure language',
      'Impersonation or authority claim',
      'Secrecy or isolation request',
      'Remote-access or app-installation request',
    ]));
  });

  test('detects sensitive information and hard-to-reverse payment methods', () {
    final result = analyzer.analyze(
      'Send your Aadhaar and CVV, then pay with a gift card or Bitcoin.',
    );

    expect(result.findings.map((f) => f.title), containsAll([
      'Sensitive personal information request',
      'Unusual or hard-to-reverse payment method',
    ]));
  });

  test('extracts email addresses and phone numbers without contacting them', () {
    final result = analyzer.analyze(
      'Contact support@example.test or call +91 98765 43210.',
    );

    expect(result.detectedContacts, contains('support@example.test'));
    expect(result.detectedContacts, contains('+91 98765 43210'));
    expect(result.findings.map((f) => f.title), contains('Contact details detected'));
    expect(result.notice, contains('No message was uploaded'));
  });

  test('keeps obfuscated links un-opened and reports them separately', () {
    final result = analyzer.analyze('Use hxxps://example.test/login');

    expect(result.findings.map((f) => f.title), contains('Obfuscated web address detected'));
    expect(result.detectedLinks, isEmpty);
    expect(result.notice, contains('no link was opened'));
  });
  test('preserves balanced URL brackets and trims unmatched closing punctuation', () {
    final result = analyzer.analyze(
      'See https://example.test/path_(campaign) and https://example.test/other_(x)).',
    );

    expect(result.detectedLinks, [
      'https://example.test/path_(campaign)',
      'https://example.test/other_(x)',
    ]);
  });

  test('deduplicates repeated links', () {
    final result = analyzer.analyze(
      'Review https://example.test and https://example.test before continuing.',
    );

    expect(result.detectedLinks, ['https://example.test']);
  });
}
