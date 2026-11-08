import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/analytics/orvika_analytics.dart';

void main() {
  group('OrvikaAnalytics allowlist', () {
    test('accepts only known module labels', () {
      expect(OrvikaAnalytics.supportsModule('Link Check'), isTrue);
      expect(OrvikaAnalytics.supportsModule('Academy'), isTrue);
      expect(OrvikaAnalytics.supportsModule('https://example.com'), isFalse);
      expect(OrvikaAnalytics.supportsModule('user@example.com'), isFalse);
    });
  });
}
