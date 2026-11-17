import 'package:flutter/material.dart';
import '../../../core/localization/arabic_privacy_content.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';
import '../../../core/localization/orvika_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/privacy_checklist.dart';
import '../../../core/localization/german_privacy_content.dart';
import '../../../core/localization/italian_privacy_content.dart';
import '../../../core/localization/french_privacy_content.dart';
import '../../../core/localization/spanish_privacy_content.dart';
import '../../../core/localization/portuguese_privacy_content.dart';
import '../../../core/localization/russian_privacy_content.dart';
import '../../../core/localization/mandarin_privacy_content.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  static const _progressKey = 'privacy.reviewed.v1';
  final _checklist = const PrivacyChecklist();
  Set<String> _reviewedIds = <String>{};
  final Map<String, PrivacyAssessmentStatus> _assessment = {};
  bool _isLoading = true;
  Future<void> _progressWriteQueue = Future<void>.value();

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

  Future<void> _persistReviewedProgress({required bool clear}) {
    final snapshot = _reviewedIds.toList()..sort();
    _progressWriteQueue = _progressWriteQueue.then((_) async {
      try {
        final preferences = await SharedPreferences.getInstance();
        if (clear) {
          await preferences.remove(_progressKey);
        } else {
          await preferences.setStringList(_progressKey, snapshot);
        }
      } catch (_) {
        if (mounted) {
          final message = clear
              ? OrvikaLocalizations.of(context).text('privacy.error.clear', 'Could not clear saved review progress.')
              : OrvikaLocalizations.of(context).text('privacy.error.save', 'Could not save this review on the device.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    });
    return _progressWriteQueue;
  }

  Future<void> _setReviewed(String id, bool reviewed) async {
    final updated = Set<String>.from(_reviewedIds);
    if (reviewed) {
      updated.add(id);
    } else {
      updated.remove(id);
    }
    setState(() => _reviewedIds = updated);
    await _persistReviewedProgress(clear: false);
  }

  void _setAssessment(String id, PrivacyAssessmentStatus? status) {
    setState(() {
      if (status == null) {
        _assessment.remove(id);
      } else {
        _assessment[id] = status;
      }
    });
  }

  String _priorityLabel(PrivacyPriority priority) => switch (priority) {
        PrivacyPriority.high => OrvikaLocalizations.of(context).text('privacy.priority.high', 'High priority'),
        PrivacyPriority.recommended => OrvikaLocalizations.of(context).text('privacy.priority.recommended', 'Recommended'),
        PrivacyPriority.routine => OrvikaLocalizations.of(context).text('privacy.priority.routine', 'Routine review'),
      };

  String _statusLabel(PrivacyAssessmentStatus status) => switch (status) {
        PrivacyAssessmentStatus.inPlace => OrvikaLocalizations.of(context).text('privacy.status.inPlace', 'Already in place'),
        PrivacyAssessmentStatus.needsAttention => OrvikaLocalizations.of(context).text('privacy.status.needsAttention', 'Needs attention'),
        PrivacyAssessmentStatus.unsure => OrvikaLocalizations.of(context).text('privacy.status.unsure', 'Not sure'),
      };

  Future<void> _resetProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(OrvikaLocalizations.of(context).text('privacy.reset.title', 'Reset review progress?')),
        content: Text(OrvikaLocalizations.of(context).text('privacy.reset.description', 'This clears checklist marks stored on this device and assessment answers in this screen session. It does not change any device or account settings.')),
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
    if (confirmed != true || !mounted) return;
    setState(() {
      _reviewedIds = <String>{};
      _assessment.clear();
    });
    await _persistReviewedProgress(clear: true);
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
        title: l10n.text('module.privacy', 'Privacy'),
        actions: [
          if (!_isLoading && (reviewed > 0 || _assessment.isNotEmpty))
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.text('privacy.assessment.title', 'Your privacy assessment'),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.text('privacy.assessment.description', 'For each practice, choose the answer that best describes your current setup. ORVIKA does not inspect or verify your settings.'),
                          style: TextStyle(color: scheme.onSurfaceVariant, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _AssessmentCount(
                              label: l10n.text('privacy.status.needsAttention', 'Needs attention'),
                              count: _assessment.values.where((value) => value == PrivacyAssessmentStatus.needsAttention).length,
                            ),
                            _AssessmentCount(
                              label: l10n.text('privacy.status.unsure', 'Not sure'),
                              count: _assessment.values.where((value) => value == PrivacyAssessmentStatus.unsure).length,
                            ),
                            _AssessmentCount(
                              label: l10n.text('privacy.status.inPlace', 'Already in place'),
                              count: _assessment.values.where((value) => value == PrivacyAssessmentStatus.inPlace).length,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.text('privacy.assessment.priorityNote', 'Start with items marked High priority, then work through recommended and routine practices. Priority is editorial guidance, not a personalised risk score.'),
                          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, height: 1.4),
                        ),
                        Text(
                          l10n.text('privacy.assessment.sessionNote', 'Your answers are kept only in this screen session. Only checklist review marks are saved locally on this device.'),
                          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, height: 1.4),
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
                  for (final practice in _checklist.byCategory(category).map((item) => (l10n.language.code == 'pt' || l10n.language.code == 'pt-PT') ? PortuguesePrivacyContent.localize(item, l10n.language.code) : l10n.language.code == 'es' ? SpanishPrivacyContent.localize(item, l10n.language.code) : l10n.language.code == 'fr' ? FrenchPrivacyContent.localize(item, l10n.language.code) : l10n.language.code == 'it' ? ItalianPrivacyContent.localize(item, l10n.language.code) : l10n.language.code == 'zh' ? MandarinPrivacyContent.localize(item, l10n.language.code) : l10n.language.code == 'ru' ? RussianPrivacyContent.localize(item, l10n.language.code) : l10n.language.code == 'ar' ? ArabicPrivacyContent.localize(item, l10n.language.code) : GermanPrivacyContent.localize(item, l10n.language.code)))
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
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag_outlined,
                                  size: 18,
                                  color: _checklist.priorityFor(practice) == PrivacyPriority.high
                                      ? scheme.error
                                      : scheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _priorityLabel(_checklist.priorityFor(practice)),
                                  style: TextStyle(
                                    color: _checklist.priorityFor(practice) == PrivacyPriority.high
                                        ? scheme.error
                                        : scheme.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _GuidanceSection(label: l10n.text('privacy.detail.why', 'WHY IT MATTERS'), value: practice.why),
                          _GuidanceSection(label: l10n.text('privacy.detail.action', 'WHAT YOU CAN DO'), value: practice.action),
                          _GuidanceSection(label: l10n.text('privacy.detail.limit', 'IMPORTANT LIMIT'), value: practice.limit),
                          const SizedBox(height: 12),
                          Text(
                            l10n.text('privacy.assessment.prompt', 'How does this practice apply to you?'),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: PrivacyAssessmentStatus.values.map((status) {
                              final selected = _assessment[practice.id] == status;
                              return ChoiceChip(
                                label: Text(_statusLabel(status)),
                                selected: selected,
                                onSelected: (_) => _setAssessment(
                                  practice.id,
                                  selected ? null : status,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          Semantics(
                            container: true,
                            label: l10n.text(
                              'privacy.reviewed',
                              'I have reviewed this practice',
                            ),
                            checked: _reviewedIds.contains(practice.id),
                            onTap: () => _setReviewed(
                              practice.id,
                              !_reviewedIds.contains(practice.id),
                            ),
                            child: ExcludeSemantics(
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: _reviewedIds.contains(practice.id),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(
                                  l10n.text(
                                    'privacy.reviewed',
                                    'I have reviewed this practice',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onChanged: (value) {
                                  _setReviewed(practice.id, value ?? false);
                                },
                              ),
                            ),
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

class _AssessmentCount extends StatelessWidget {
  const _AssessmentCount({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) => Chip(
        label: Text('$label: $count'),
        visualDensity: VisualDensity.compact,
      );
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
