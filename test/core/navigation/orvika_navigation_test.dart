import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/navigation/orvika_navigation.dart';
import 'package:orvika/features/academy/presentation/academy_screen.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';
import 'package:orvika/features/response/presentation/response_screen.dart';

void main() {
  group('OrvikaNavigation.screenForModule', () {
    test('maps every available dashboard module to its screen', () {
      expect(OrvikaNavigation.screenForModule('Link Check'),
          isA<LinkCheckScreen>());
      expect(OrvikaNavigation.screenForModule('QR Check'),
          isA<QrCheckScreen>());
      expect(OrvikaNavigation.screenForModule('Message Check'),
          isA<MessageCheckScreen>());
      expect(OrvikaNavigation.screenForModule('Intelligence'),
          isA<IntelligenceScreen>());
      expect(OrvikaNavigation.screenForModule('Privacy'),
          isA<PrivacyScreen>());
      expect(OrvikaNavigation.screenForModule('Academy'),
          isA<AcademyScreen>());
      expect(OrvikaNavigation.screenForModule('Response'),
          isA<ResponseScreen>());
    });

    test('keeps informational and unknown modules non-navigable', () {
      expect(OrvikaNavigation.screenForModule('Sentinel'), isNull);
      expect(OrvikaNavigation.screenForModule('Unknown module'), isNull);
    });
  });
}
