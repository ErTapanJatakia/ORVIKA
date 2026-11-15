import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../core/platform/accessibility_contact_launcher.dart';

class OrvikaAccessibilityStatementScreen extends StatelessWidget {
  const OrvikaAccessibilityStatementScreen({super.key});

  static const sections = <(String, String)>[
    ('Accessibility commitment', 'ORVIKA uses WCAG 2.2 Level AA as its web accessibility design and testing target. Implemented work includes keyboard navigation and visible focus, semantic labels and headings, form-control semantics, text scaling, responsive layouts, reduced-motion support, and contrast-aware themes.'),
    ('Current evaluation status', 'The project owner reports manually validating the A11Y-01 to A11Y-10 implementation set. Automated Flutter tests cover selected semantics, headings, form labels, keyboard navigation, responsive layouts, and text scaling. This project validation is not an independent third-party audit.'),
    ('Conformance status and limitations', 'ORVIKA does not claim full WCAG 2.2 Level AA conformance and does not display a WCAG conformance logo or certification badge. Automated tests and project-owner validation do not establish that every applicable success criterion is met across every page, state, browser, assistive technology, and user configuration.'),
    ('Platform coverage', 'This statement covers the hosted web experience. The Android application requires separate native evaluation, including TalkBack, Switch Access, and Android display scaling. Web validation must not be treated as evidence of Android conformance.'),
    ('How to report an accessibility barrier', 'When reporting a barrier, include the affected page or feature, the action you attempted, the result you expected, and concise reproduction steps. Browser and assistive-technology details are optional. Do not include passwords, one-time codes, or unrelated sensitive personal information.'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('ORVIKA Accessibility Statement')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Text('Last reviewed: 15 November 2026', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
              const SizedBox(height: 12),
              for (final section in sections) ...[
                Semantics(header: true, child: Text(section.$1, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
                const SizedBox(height: 6),
                SelectableText(section.$2, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
                const SizedBox(height: 18),
              ],
              if (kIsWeb) ...[
                FilledButton.icon(
                  onPressed: openAccessibilityContact,
                  icon: const Icon(Icons.verified_user_outlined),
                  label: const Text('Open protected accessibility contact'),
                ),
                const SizedBox(height: 8),
                Text('Contact addresses are disclosed only after successful server-side Turnstile verification.', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
              ] else
                Text('The protected accessibility contact flow is available through the hosted ORVIKA web application.', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
