import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(title),
        actions: actions,
        backgroundColor: backgroundColor,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
