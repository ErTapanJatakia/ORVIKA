import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';

void main() {
  const analyzer = UrlAnalyzer();

  group('UrlAnalyzer', () {
    test('rejects an empty address', () {
      final result = analyzer.analyze('  ');
      expect(result.isValid, isFalse);
      expect(result.normalizedUrl, isNull);
    });

    test('adds HTTPS when a scheme is omitted', () {
      final result = analyzer.analyze('example.com/path');
      expect(result.isValid, isTrue);
      expect(result.normalizedUrl, 'https://example.com/path');
    });

    test('flags unencrypted HTTP', () {
      final result = analyzer.analyze('http://example.com');
      expect(result.findings.any((f) => f.title == 'Unencrypted connection'), isTrue);
    });

    test('flags embedded user information', () {
      final result = analyzer.analyze('https://user@example.com/login');
      expect(result.findings.any((f) => f.title == 'Embedded sign-in information'), isTrue);
    });

    test('flags Punycode hostnames for careful review', () {
      final result = analyzer.analyze('https://xn--e1afmkfd.example');
      expect(result.findings.any((f) => f.title == 'Internationalised domain encoding'), isTrue);
    });

    test('rejects unsupported schemes', () {
      final result = analyzer.analyze('javascript:alert(1)');
      expect(result.isValid, isFalse);
    });

    test('rejects whitespace and control characters', () {
      expect(analyzer.analyze('https://exa mple.com').isValid, isFalse);
      expect(analyzer.analyze('https://example.com\n').isValid, isFalse);
    });

    test('flags Unicode hostnames for careful visual verification', () {
      final result = analyzer.analyze('https://раypal.example');
      expect(result.isValid, isTrue);
      expect(result.findings.any((f) => f.title == 'Unicode hostname'), isTrue);
    });

    test('flags out-of-range dotted IPv4-looking hosts', () {
      final result = analyzer.analyze('https://999.999.999.999');
      expect(result.isValid, isTrue);
      expect(result.findings.any((f) => f.title == 'Malformed IPv4-looking hostname'), isTrue);
    });

    test('flags deeper subdomain chains without claiming maliciousness', () {
      final result = analyzer.analyze('https://paypal.com.attacker.example');
      expect(result.isValid, isTrue);
      expect(result.findings.any((f) => f.title == 'Long subdomain chain'), isTrue);
    });

    test('does not label a structurally ordinary HTTPS URL as safe', () {
      final result = analyzer.analyze('https://example.com');
      expect(result.isValid, isTrue);
      expect(result.findings.single.title, 'No structural warning detected');
      expect(result.notice, contains('No network request'));
      expect(result.findings.single.detail, contains('does not establish'));
    });
  });
}
