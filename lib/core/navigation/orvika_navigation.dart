import 'package:flutter/material.dart';

import '../../features/academy/presentation/academy_screen.dart';
import '../../features/intelligence/presentation/intelligence_screen.dart';
import '../../features/link_check/presentation/link_check_screen.dart';
import '../../features/message_check/presentation/message_check_screen.dart';
import '../../features/privacy/presentation/privacy_screen.dart';
import '../../features/qr_check/presentation/qr_check_screen.dart';
import '../../features/response/presentation/response_screen.dart';

/// Central registry for dashboard destinations.
///
/// Keep route ownership here so dashboard widgets do not need to know the
/// concrete presentation class for each feature. A null result means the
/// module is intentionally informational and has no destination yet.
abstract final class OrvikaNavigation {
  static Widget? screenForModule(String title) => switch (title) {
        'Link Check' => const LinkCheckScreen(),
        'QR Check' => const QrCheckScreen(),
        'Message Check' => const MessageCheckScreen(),
        'Intelligence' => const IntelligenceScreen(),
        'Privacy' => const PrivacyScreen(),
        'Academy' => const AcademyScreen(),
        'Response' => const ResponseScreen(),
        _ => null,
      };
}
