import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../core/platform/accessibility_contact_launcher.dart';

class OrvikaAccessibilityStatementScreen extends StatelessWidget {
  const OrvikaAccessibilityStatementScreen({super.key});

  static const sections = <(String, String)>[
    ('Accessibility commitment', 'ORVIKA uses WCAG 2.2 Level AA as its web accessibility design and testing target. Implemented work includes keyboard navigation and visible focus, semantic labels and headings, form-control semantics, text scaling, responsive layouts, reduced-motion support, and contrast-aware themes.'),
    ('Current evaluation status', 'The project owner reports manually validating the A11Y-01 to A11Y-10 implementation set. Automated Flutter tests cover selected semantics, headings, form labels, keyboard navigation, responsive layouts, and text scaling. This project validation is not an independent third-party audit.'),
    ('Conformance status and limitations', 'ORVIKA does not claim full WCAG 2.2 Level AA conformance. Automated tests and project-owner validation do not establish that every applicable success criterion is met across every page, state, browser, assistive technology, and user configuration. The Accessibility badge identifies this statement and feedback route only; it is not a conformance or certification badge.'),
    ('Platform coverage', 'This statement covers the hosted web experience. The Android application requires separate native evaluation, including TalkBack, Switch Access, and Android display scaling. Web validation must not be treated as evidence of Android conformance.'),
    ('How to report an accessibility barrier', 'When reporting a barrier, include the affected page or feature, the action you attempted, the result you expected, and concise reproduction steps. Browser and assistive-technology details are optional. Do not include passwords, one-time codes, or unrelated sensitive personal information. No CAPTCHA, account, or verification challenge is required.'),
  ];

  static const contactEmails = <String>[
    'ertapanjatakia@yandex.com',
    'tapan_ditu_17.20@outlook.com',
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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Semantics(
                  label: 'Accessibility information badge',
                  child: const Chip(
                    avatar: const Icon(Icons.accessibility_new_rounded, size: 18),
                    label: const Text('Accessibility information'),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              Text('Last reviewed: 15 November 2026', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
              const SizedBox(height: 12),
              for (final section in sections) ...[
                Semantics(header: true, child: Text(section.$1, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
                const SizedBox(height: 6),
                SelectableText(section.$2, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
                const SizedBox(height: 18),
              ],
              Semantics(
                header: true,
                child: Text('Accessibility feedback and contact', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 6),
              const SelectableText('No CAPTCHA or verification is required. Contact us directly:'),
              const SizedBox(height: 8),
              for (final email in contactEmails)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SelectableText(email, style: TextStyle(color: scheme.primary, decoration: TextDecoration.underline)),
                ),
              if (kIsWeb) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: openAccessibilityContact,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Open web accessibility statement and contact'),
                ),
              ],
              const SizedBox(height: 8),
              Text('Email addresses are public so that accessibility feedback remains available without a CAPTCHA. They may receive spam.', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
