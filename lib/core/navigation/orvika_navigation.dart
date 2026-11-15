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
  static String? routeNameForModule(String title) => switch (title) {
        'Link Check' => '/link-check',
        'QR Check' => '/qr-check',
        'Message Check' => '/message-check',
        'Intelligence' => '/intelligence',
        'Privacy' => '/privacy',
        'Academy' => '/academy',
        'Response' => '/response',
        _ => null,
      };

  static bool hasDestination(String title) => routeNameForModule(title) != null;

  /// Push a known module using a stable internal route identifier.
  /// Returns false for informational cards without a destination.
  static bool openModule(BuildContext context, String title) {
    final screen = screenForModule(title);
    final routeName = routeNameForModule(title);
    if (screen == null || routeName == null) return false;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (_) => screen,
      ),
    );
    return true;
  }

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
