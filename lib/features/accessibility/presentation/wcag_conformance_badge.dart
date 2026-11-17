import 'package:flutter/material.dart';

/// Displays the official W3C WCAG 2.2 Level AA blue conformance artwork.
///
/// The badge is bundled with ORVIKA, so displaying it does not make a
/// third-party network request. The badge represents a publisher conformance
/// claim; it is not W3C certification or endorsement.
class Wcag22AaBadge extends StatelessWidget {
  const Wcag22AaBadge({super.key});

  static const assetPath = 'assets/images/wcag2.2AA-blue.png';

  @override
  Widget build(BuildContext context) => Semantics(
        image: true,
        label:
            'This badge identifies the publisher’s WCAG 2.2 Level AA conformance claim '
            'for the hosted ORVIKA Web application only. The native Android application '
            'is excluded. This is not W3C certification or endorsement.',
        child: Image.asset(
          assetPath,
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
