import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';
import 'package:orvika/features/message_check/domain/message_analyzer.dart';

void main() {
  group('URL parser resilience corpus', () {
    const analyzer = UrlAnalyzer();
    final corpus = <String>[
      '',
      ' ',
      'https://example.test',
      'HTTPS://EXAMPLE.TEST/path?token=private#section',
      'http://user:pass@example.test:8080/path',
      'https://[::1',
      'https://example.test:99999/path',
      'https://example.test/%zz',
      'https://192.0.2.999/path',
      'https://123.456/path',
      'https://xn--pple-43d.com/',
      'https://раypal.example/account',
      'https://example.test/שלום/مرحبا/नमस्ते',
      'https://example.test/\u202Etxt.exe',
      'https://example.test/\u200Bhidden',
      'https://example.test/\u0000control',
      'https://example.test\\@attacker.test/path',
      'javascript:alert(1)',
      'file:///etc/passwd',
      'https://example.test:443/path',
      'https://example.test:8443/path',
    ];

    test('returns deterministic results and never throws for adversarial input corpus', () {
      for (final input in corpus) {
        final first = analyzer.analyze(input);
        final second = analyzer.analyze(input);
        expect(first.isValid, second.isValid, reason: 'Input: $input');
        expect(first.input, second.input, reason: 'Input: $input');
        expect(first.normalizedUrl, second.normalizedUrl, reason: 'Input: $input');
        expect(first.notice, second.notice, reason: 'Input: $input');
        expect(
          first.findings.map((f) => (f.title, f.detail, f.severity)).toList(),
          second.findings.map((f) => (f.title, f.detail, f.severity)).toList(),
          reason: 'Input: $input',
        );
      }
    });

    test('rejects control characters and preserves the raw input for diagnosis', () {
      for (final input in ['https://example.test/\u0000', 'https://example.test/\u007F']) {
        final result = analyzer.analyze(input);
        expect(result.isValid, isFalse);
        expect(result.normalizedUrl, isNull);
        expect(result.input, input);
      }
    });

    test('does not upgrade non-web schemes into valid web destinations', () {
      for (final input in ['javascript:alert(1)', 'file:///etc/passwd', 'data:text/html,hello']) {
        final result = analyzer.analyze(input);
        expect(result.isValid, isFalse, reason: input);
        expect(result.normalizedUrl, isNull, reason: input);
      }
    });
  });

  group('QR parser resilience and sensitive-payload boundaries', () {
    const analyzer = QrPayloadAnalyzer();
    final corpus = <String>[
      '',
      'WIFI:T:WPA;S:Office;P:private-secret;;',
      'BEGIN:VCARD\\nFN:Example\\nEND:VCARD',
      'BEGIN:VEVENT\\nSUMMARY:Meeting\\nEND:VEVENT',
      'upi://pay?pa=private-payee%40example.test&pn=Private%20Merchant&am=98765.43',
      'upi://pay?pa=%09%20&pn=Merchant',
      'TEL:+911234567890',
      'MAILTO:security@example.test',
      'sms:+911234567890?body=private-message',
      'geo:19.0760,72.8777',
      'bankapp://trusted.example/transfer',
      'https://раypal.example/account',
      'https://example.test/%zz',
      'https://example.test/\u202Etxt.exe',
      'plain text with emoji 🔐 and RTL مرحبا',
    ];

    test('returns deterministic classifications for malformed and unusual payloads', () {
      for (final payload in corpus) {
        final first = analyzer.analyze(payload);
        final second = analyzer.analyze(payload);
        expect(first.kind, second.kind, reason: 'Payload: $payload');
        expect(first.title, second.title, reason: 'Payload: $payload');
        expect(first.detail, second.detail, reason: 'Payload: $payload');
        expect(first.severity, second.severity, reason: 'Payload: $payload');
        expect(first.normalizedUrl, second.normalizedUrl, reason: 'Payload: $payload');
        expect(first.isValid, second.isValid, reason: 'Payload: $payload');
      }
    });

    test('does not echo Wi-Fi credentials or payment recipient and amount', () {
      const password = 'private-secret-credential';
      const recipient = 'private-payee@example.test';
      const amount = '98765.43';
      final wifi = analyzer.analyze('WIFI:T:WPA;S:Office;P:$password;;');
      final payment = analyzer.analyze(
        'upi://pay?pa=$recipient&pn=Private%20Merchant&am=$amount',
      );

      expect(wifi.detail, isNot(contains(password)));
      expect(payment.detail, isNot(contains(recipient)));
      expect(payment.detail, isNot(contains(amount)));
    });

    test('keeps custom application schemes classified as untrusted actions', () {
      for (final payload in [
        'bankapp://trusted.example/transfer',
        'intent://trusted.example/#Intent;scheme=bankapp;end',
        'custom+secure://trusted.example/action',
      ]) {
        final result = analyzer.analyze(payload);
        expect(result.kind, QrPayloadKind.applicationLink, reason: payload);
        expect(result.severity, FindingSeverity.warning, reason: payload);
      }
    });
  });

  group('Message parser resilience corpus', () {
    const analyzer = MessageAnalyzer();
    final corpus = <String>[
      '',
      'Ordinary message with no action.',
      'URGENT: verify your account immediately.',
      'Your OTP is 123456. Never share it.',
      'Review https://example.test/login?next=home.',
      '<a href="https://login.example.test/session">Review account</a>',
      'hxxps://hidden.example.test/login',
      'https://раypal.example/account',
      'https://example.test/\u202Etxt.exe',
      'Zero-width\u200Bseparator and bidi\u2066markers\u2069.',
      'مرحبا नमस्ते Привет 🔐',
      'A malformed URL https://example.test/%zz and unmatched <tag',
      'https://example.test/path?token=private-token https://example.test/path?token=private-token',
    ];

    test('returns deterministic results and never throws for adversarial message corpus', () {
      for (final input in corpus) {
        final first = analyzer.analyze(input);
        final second = analyzer.analyze(input);
        expect(first.isValid, second.isValid, reason: 'Input: $input');
        expect(first.input, second.input, reason: 'Input: $input');
        expect(first.detectedLinks, second.detectedLinks, reason: 'Input: $input');
        expect(first.notice, second.notice, reason: 'Input: $input');
        expect(
          first.findings.map((f) => (f.title, f.detail, f.severity)).toList(),
          second.findings.map((f) => (f.title, f.detail, f.severity)).toList(),
          reason: 'Input: $input',
        );
      }
    });

    test('keeps obfuscated schemes separate from extracted web links', () {
      final result = analyzer.analyze(
        'hxxp://first.example hxxps://second.example https://third.example',
      );
      expect(result.detectedLinks, ['https://third.example']);
      expect(
        result.findings.map((finding) => finding.title),
        contains('Obfuscated web address detected'),
      );
    });
  });
}
