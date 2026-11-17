import 'package:flutter/material.dart';

/// Displays the official W3C WCAG 2.2 Level AA blue conformance artwork.
///
/// The image is loaded from W3C's published asset URL, at the dimensions
/// specified by W3C. If the device is offline or W3C is unreachable, no
/// substitute artwork is drawn.
class Wcag22AaBadge extends StatelessWidget {
  const Wcag22AaBadge({super.key});

  static const imageUrl =
      'https://www.w3.org/WAI/WCAG22/wcag2.2AA-blue.png';

  @override
  Widget build(BuildContext context) => Semantics(
        image: true,
        label:
            'Level AA conformance, W3C Web Content Accessibility Guidelines 2.2. '
            'Publisher claim; not W3C certification.',
        child: Image.network(
          imageUrl,
          key: key,
          width: 88,
          height: 31,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
          errorBuilder: (context, error, stackTrace) =>
              const SizedBox(width: 88, height: 31),
        ),
      );
}
