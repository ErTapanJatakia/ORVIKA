import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';

void main() {
  const analyzer = QrPayloadAnalyzer();

  group('QrPayloadAnalyzer', () {
    test('rejects empty content', () {
      final result = analyzer.analyze('  ');
      expect(result.isValid, isFalse);
      expect(result.kind, QrPayloadKind.invalid);
    });

    test('rejects oversized content', () {
      final result = analyzer.analyze('a' * 8193);
      expect(result.isValid, isFalse);
    });

    test('recognises and inspects HTTPS destinations', () {
      final result = analyzer.analyze('https://example.com');
      expect(result.kind, QrPayloadKind.webLink);
      expect(result.normalizedUrl, 'https://example.com');
      expect(result.detail, contains('has not been opened'));
    });

    test('recognises Wi-Fi configuration without connecting', () {
      final result = analyzer.analyze(r'WIFI:T:WPA;S:Office;P:secret;;');
      expect(result.kind, QrPayloadKind.wifiCredentials);
      expect(result.detail, contains('will not connect automatically'));
    });

    test('recognises UPI payment requests without initiating payment', () {
      final result = analyzer.analyze('upi://pay?pa=merchant@example&pn=Merchant');
      expect(result.kind, QrPayloadKind.paymentRequest);
      expect(result.severity, FindingSeverity.warning);
      expect(result.detail, contains('will not initiate'));
    });

    test('treats application-specific schemes as untrusted actions', () {
      final result = analyzer.analyze('intent://scan/#Intent;scheme=zxing;end');
      expect(result.kind, QrPayloadKind.applicationLink);
      expect(result.severity, FindingSeverity.warning);
    });

    test('recognises contact cards', () {
      final result = analyzer.analyze('BEGIN:VCARD\nVERSION:3.0\nFN:Example\nEND:VCARD');
      expect(result.kind, QrPayloadKind.contactCard);
    });

    test('recognises phone actions without calling', () {
      final result = analyzer.analyze('tel:+911234567890');
      expect(result.kind, QrPayloadKind.phoneAction);
      expect(result.detail, contains('will not place a call'));
    });

    test('treats ordinary text as text, not a trusted destination', () {
      final result = analyzer.analyze('Pay this invoice immediately');
      expect(result.kind, QrPayloadKind.plainText);
      expect(result.severity, FindingSeverity.info);
    });
  });
}
