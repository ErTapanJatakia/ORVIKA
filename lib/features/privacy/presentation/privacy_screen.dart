import 'package:flutter/material.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';
import '../../../core/localization/orvika_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/privacy_checklist.dart';
import '../../../core/localization/german_privacy_content.dart';
import '../../../core/localization/italian_privacy_content.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  static const _progressKey = 'privacy.reviewed.v1';
  final _checklist = const PrivacyChecklist();
  Set<String> _reviewedIds = <String>{};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = preferences.getStringList(_progressKey) ?? <String>[];
      if (!mounted) return;
      setState(() {
        _reviewedIds = saved.toSet().intersection(
          PrivacyChecklist.practices.map((practice) => practice.id).toSet(),
        );
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _setReviewed(String id, bool reviewed) async {
    final updated = Set<String>.from(_reviewedIds);
    if (reviewed) {
      updated.add(id);
    } else {
      updated.remove(id);
    }
    setState(() => _reviewedIds = updated);
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setStringList(_progressKey, updated.toList()..sort());
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(OrvikaLocalizations.of(context).text('privacy.error.save', 'Could not save this review on the device.'))),
        );
      }
    }
  }

  Future<void> _resetProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(OrvikaLocalizations.of(context).text('privacy.reset.title', 'Reset review progress?')),
        content: Text(OrvikaLocalizations.of(context).text('privacy.reset.description', 'This clears only the checklist marks stored on this device. It does not change any device or account settings.')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(OrvikaLocalizations.of(context).text('common.cancel', 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(OrvikaLocalizations.of(context).text('privacy.reset.action', 'Reset progress')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _reviewedIds = <String>{});
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(_progressKey);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(OrvikaLocalizations.of(context).text('privacy.error.clear', 'Could not clear saved review progress.'))),
        );
      }
    }
  }

  String _categoryLabel(PrivacyCategory category) => switch (category) {
        PrivacyCategory.accounts => OrvikaLocalizations.of(context).text('privacy.category.accounts', 'Accounts'),
        PrivacyCategory.device => OrvikaLocalizations.of(context).text('privacy.category.device', 'Device'),
        PrivacyCategory.apps => OrvikaLocalizations.of(context).text('privacy.category.apps', 'Apps and permissions'),
        PrivacyCategory.browsing => OrvikaLocalizations.of(context).text('privacy.category.browsing', 'Browsing and sharing'),
      };

  IconData _categoryIcon(PrivacyCategory category) => switch (category) {
        PrivacyCategory.accounts => Icons.manage_accounts_outlined,
        PrivacyCategory.device => Icons.phonelink_lock_outlined,
        PrivacyCategory.apps => Icons.app_settings_alt_outlined,
        PrivacyCategory.browsing => Icons.travel_explore_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = OrvikaLocalizations.of(context);
    final total = PrivacyChecklist.practices.length;
    final reviewed = _reviewedIds.length;
    return Scaffold(
      appBar: OrvikaFeatureAppBar(
        title: 'Privacy',
        actions: [
          if (!_isLoading && reviewed > 0)
            IconButton(
              tooltip: l10n.text('privacy.reset.tooltip', 'Reset review progress'),
              onPressed: _resetProgress,
              icon: const Icon(Icons.restart_alt_rounded),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.text('privacy.heading', 'Take control of your privacy.'),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.text('privacy.description', 'A practical self-audit for the accounts, devices, apps and everyday habits that shape your digital privacy.'),
                  style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
                ),
                const SizedBox(height: 18),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.textWithParameters('privacy.progress', fallback: '{reviewed} of {total} practices reviewed', parameters: {'reviewed': reviewed, 'total': total}),
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                            Text(
                              '${(reviewed / total * 100).round()}%',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: reviewed / total,
                          semanticsLabel: l10n.textWithParameters('privacy.progressSemantics', fallback: 'Privacy review progress: {reviewed} of {total} practices reviewed', parameters: {'reviewed': reviewed, 'total': total}),
                          semanticsValue: '${reviewed / total}',
                        ),
                        Semantics(
                          container: true,
                          liveRegion: true,
                          label: l10n.textWithParameters('privacy.progressUpdate', fallback: 'Privacy progress update: {reviewed} of {total} practices reviewed', parameters: {'reviewed': reviewed, 'total': total}),
                          child: const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.text('privacy.progressNote', 'Your progress is saved locally on this device. A checkmark means you reviewed the guidance—not that ORVIKA verified or changed a setting.'),
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (final category in PrivacyCategory.values) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 8),
                    child: Row(
                      children: [
                        Icon(_categoryIcon(category), color: scheme.primary, size: 20),
                        const SizedBox(width: 9),
                        Text(
                          _categoryLabel(category),
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  for (final practice in _checklist.byCategory(category).map((item) => l10n.language.code == 'it' ? ItalianPrivacyContent.localize(item, l10n.language.code) : GermanPrivacyContent.localize(item, l10n.language.code)))
                    Card(
                      margin: const EdgeInsets.only(bottom: 9),
                      child: ExpansionTile(
                        key: PageStorageKey<String>('privacy-${practice.id}'),
                        leading: Icon(
                          _reviewedIds.contains(practice.id)
                              ? Icons.check_circle_rounded
                              : Icons.shield_outlined,
                          color: _reviewedIds.contains(practice.id)
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                        title: Text(
                          practice.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _GuidanceSection(label: l10n.text('privacy.detail.why', 'WHY IT MATTERS'), value: practice.why),
                          _GuidanceSection(label: l10n.text('privacy.detail.action', 'WHAT YOU CAN DO'), value: practice.action),
                          _GuidanceSection(label: l10n.text('privacy.detail.limit', 'IMPORTANT LIMIT'), value: practice.limit),
                          const SizedBox(height: 8),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: _reviewedIds.contains(practice.id),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              l10n.text('privacy.reviewed', 'I have reviewed this practice'),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            onChanged: (value) {
                              _setReviewed(practice.id, value ?? false);
                            },
                          ),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 12),
                Text(
                  l10n.text('privacy.analytics.notice', 'Website analytics: ORVIKA uses Vercel Web Analytics for aggregated page views and basic device, browser, referrer and approximate location metrics. On the Vercel Hobby plan, custom feature-usage events are not available. ORVIKA does not send pasted URLs, message text, decoded QR content, credentials or security-analysis findings as analytics data. Website analytics is separate from on-device security analysis. Vercel states that Web Analytics does not use cookies and that visitor hashes expire after 24 hours.'),
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.text('privacy.device.notice', 'ORVIKA does not scan your device, inspect installed apps, read account data or change permissions. Settings and labels vary by platform. Use each operating system or service’s official settings and documentation.'),
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _GuidanceSection extends StatelessWidget {
  const _GuidanceSection({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
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
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45)),
        ],
      ),
    );
  }
}
