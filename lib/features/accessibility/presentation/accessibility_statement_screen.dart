import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../core/localization/orvika_localizations.dart';
import '../../../core/platform/accessibility_contact_launcher.dart';

class OrvikaAccessibilityStatementScreen extends StatelessWidget {
  const OrvikaAccessibilityStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = OrvikaLocalizations.of(context);
    final sections = <(String, String)>[
      (
        l10n.text('a11y.statement.commitment.title', 'Accessibility commitment'),
        l10n.text('a11y.statement.commitment.body',
          'ORVIKA is committed to making its digital safety tools accessible. The web experience is evaluated against WCAG 2.2 Level AA.'),
      ),
      (
        l10n.text('a11y.statement.conformance.title', 'Conformance claim'),
        l10n.text('a11y.statement.publisherClaim.body',
          'The publisher makes a WCAG 2.2 Level AA conformance claim for the ORVIKA hosted web application at https://orvika-web.vercel.app/. The claim is dated 17 November 2026 and is assessed and declared by Er. Tapan Jatakia (C.Eng.), WCAG Auditor. Scope: the complete hosted web application and responsive page presentations. The claim excludes the native Android application and third-party content outside the publisher’s control. W3C does not review, validate, certify or endorse this claim.'),
      ),
      (
        l10n.text('a11y.statement.platform.title', 'Platform coverage'),
        l10n.text('a11y.statement.platform.body',
          'This conformance claim covers the hosted ORVIKA web application only. The native Android application is evaluated separately using applicable native accessibility guidance and assistive-technology testing; it is not included in this WCAG web conformance claim.'),
      ),
      (
        l10n.text('a11y.statement.report.title', 'How to report an accessibility barrier'),
        l10n.text('a11y.statement.report.body',
          'When reporting a barrier, include the affected page or feature, the action you attempted, the result you expected, and concise reproduction steps. Browser and assistive-technology details are optional. Do not include passwords, one-time codes, or unrelated sensitive personal information.'),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.text('a11y.statement.title', 'Accessibility Statement'))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            children: [
              const Center(child: _Wcag22AaBadge()),
              const SizedBox(height: 8),
              Text(l10n.text('a11y.statement.reviewed.current', 'Last reviewed: 17 November 2026'),
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
              const SizedBox(height: 14),
              for (final section in sections) ...[
                Semantics(header: true, child: Text(section.$1,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
                const SizedBox(height: 4),
                SelectableText(section.$2,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
                const SizedBox(height: 12),
              ],
              Semantics(header: true, child: Text(
                l10n.text('a11y.statement.contact.auditor', 'WCAG Auditor contact information:'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
              const SizedBox(height: 6),
              const SelectableText(
                'Name: Er. Tapan Jatakia (C.Eng.)\n'
                'Email: cyber.litigation.advisor@gmail.com\n'
                'Phone Number: +91 9664332984\n'
                'Website: https://linktr.ee/ertapanjatakia',
              ),
              if (kIsWeb) ...[
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: openAccessibilityContact,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(l10n.text('a11y.statement.contact.action',
                    'Open web accessibility statement and contact')),
                ),
              ],
              const SizedBox(height: 12),
              const Center(child: _Wcag22AaBadge()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Wcag22AaBadge extends StatelessWidget {
  const _Wcag22AaBadge();
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'WCAG 2.2 Level AA conformance claim',
    child: Container(
      key: const ValueKey('wcag-22-aa-statement-badge'),
      width: 112, height: 36, alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD166),
        border: Border.all(color: const Color(0xFF111827), width: 1.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text('WCAG 2.2 AA',
        style: TextStyle(color: Color(0xFF111827), fontSize: 13,
          fontWeight: FontWeight.w900, decoration: TextDecoration.none)),
    ),
  );
}
