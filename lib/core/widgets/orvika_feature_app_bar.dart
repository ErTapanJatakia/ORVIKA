import 'package:flutter/material.dart';
import '../localization/orvika_localizations.dart';

/// Consistent app-bar shell for ORVIKA feature screens.
///
/// Feature-specific actions remain supplied by the owning screen; navigation
/// and content stay decoupled from shared visual chrome.
class OrvikaFeatureAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const OrvikaFeatureAppBar({
    required this.title,
    this.actions,
    this.backgroundColor,
    super.key,
  });

  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;

  String _localizedTitle(BuildContext context) {
    final key = switch (title) {
      'Link Check' => 'module.link',
      'QR Check' => 'module.qr',
      'Message Check' => 'module.message',
      'Intelligence' => 'module.intelligence',
      'Privacy' => 'module.privacy',
      'Academy' => 'module.academy',
      'Response' => 'module.response',
      _ => null,
    };
    return key == null
        ? title
        : OrvikaLocalizations.of(context).text(key, title);
  }

  @override
  Widget build(BuildContext context) => AppBar(
        title: Semantics(
          header: true,
          child: Text(_localizedTitle(context)),
        ),
        actions: actions,
        backgroundColor: backgroundColor,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
