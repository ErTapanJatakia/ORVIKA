import 'package:flutter/material.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';

import '../domain/response_playbooks.dart';

class ResponseScreen extends StatelessWidget {
  const ResponseScreen({super.key});

  String _sectionLabel(ResponseScenario scenario) => switch (scenario) {
        ResponseScenario.accountCompromise => 'ACCOUNT SECURITY',
        ResponseScenario.paymentFraud => 'PAYMENTS AND FRAUD',
        ResponseScenario.lostDevice => 'DEVICE SECURITY',
        ResponseScenario.suspectedMalware => 'DEVICE SECURITY',
        ResponseScenario.identityExposure => 'PRIVACY AND IDENTITY',
      };

  IconData _icon(ResponseScenario scenario) => switch (scenario) {
        ResponseScenario.accountCompromise => Icons.manage_accounts_outlined,
        ResponseScenario.paymentFraud => Icons.account_balance_wallet_outlined,
        ResponseScenario.lostDevice => Icons.phonelink_erase_outlined,
        ResponseScenario.suspectedMalware => Icons.biotech_outlined,
        ResponseScenario.identityExposure => Icons.badge_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const OrvikaFeatureAppBar(title: 'Response'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Text(
            'Know your next step.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Practical, ordered guidance for common digital incidents. Choose the situation that best matches what happened.',
            style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.priority_high_rounded, color: scheme.error, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'If someone is in immediate physical danger, contact local emergency services. For financial loss or suspected account takeover, contact the relevant provider promptly through an official channel.',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final playbook in ResponsePlaybooks.playbooks)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                key: PageStorageKey<String>('response-${playbook.id}'),
                leading: Icon(_icon(playbook.scenario), color: scheme.primary),
                title: Text(
                  playbook.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(_sectionLabel(playbook.scenario)),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(playbook.summary,
                      style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45)),
                  const SizedBox(height: 14),
                  _ResponseSection(
                    label: 'FIRST PRIORITY',
                    child: Text(
                      playbook.firstAction,
                      style: TextStyle(
                        color: scheme.onSurface,
                        height: 1.45,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _ResponseSection(
                    label: 'STEP-BY-STEP',
                    child: _BulletList(items: playbook.steps),
                  ),
                  _ResponseSection(
                    label: 'PRESERVE USEFUL INFORMATION',
                    child: _BulletList(items: playbook.preserve),
                  ),
                  _ResponseSection(
                    label: 'AVOID',
                    child: _BulletList(items: playbook.avoid),
                  ),
                  _ResponseSection(
                    label: 'IMPORTANT LIMIT',
                    child: Text(
                      playbook.limit,
                      style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'ORVIKA Response is general educational guidance, not emergency assistance, legal advice, financial advice or a substitute for qualified incident response. It does not detect incidents, contact providers or authorities, change account settings, or submit reports. Reporting channels and procedures vary by jurisdiction; use independently verified official sources.',
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ResponseSection extends StatelessWidget {
  const _ResponseSection({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: scheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_right_rounded, color: scheme.primary, size: 20),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
