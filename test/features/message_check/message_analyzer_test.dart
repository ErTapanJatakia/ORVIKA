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

  test('deduplicates repeated links', () {
    final result = analyzer.analyze(
      'Review https://example.test and https://example.test before continuing.',
    );

    expect(result.detectedLinks, ['https://example.test']);
  });
}
