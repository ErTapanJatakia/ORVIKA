import 'package:flutter/material.dart';
import '../../../core/localization/arabic_intelligence_content.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';
import '../../../core/localization/orvika_localizations.dart';

import '../domain/intelligence_library.dart';
import '../../../core/localization/german_intelligence_content.dart';
import '../../../core/localization/italian_intelligence_content.dart';
import '../../../core/localization/french_intelligence_content.dart';
import '../../../core/localization/spanish_intelligence_content.dart';
import '../../../core/localization/portuguese_intelligence_content.dart';
import '../../../core/localization/russian_intelligence_content.dart';
import '../../../core/localization/mandarin_intelligence_content.dart';

class IntelligenceScreen extends StatefulWidget {
  const IntelligenceScreen({super.key});

  @override
  State<IntelligenceScreen> createState() => _IntelligenceScreenState();
}

class _IntelligenceScreenState extends State<IntelligenceScreen> {
  final _controller = TextEditingController();
  final _library = const IntelligenceLibrary();
  IntelligenceCategory? _category;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _categoryLabel(IntelligenceCategory category) => switch (category) {
        IntelligenceCategory.links => OrvikaLocalizations.of(context).text('intelligence.category.links', 'Links'),
        IntelligenceCategory.messages => OrvikaLocalizations.of(context).text('intelligence.category.messages', 'Messages'),
        IntelligenceCategory.qrCodes => OrvikaLocalizations.of(context).text('intelligence.category.qr', 'QR codes'),
        IntelligenceCategory.accountSafety => OrvikaLocalizations.of(context).text('intelligence.category.accounts', 'Account safety'),
      };

  IconData _categoryIcon(IntelligenceCategory category) => switch (category) {
        IntelligenceCategory.links => Icons.link_rounded,
        IntelligenceCategory.messages => Icons.mark_email_unread_outlined,
        IntelligenceCategory.qrCodes => Icons.qr_code_rounded,
        IntelligenceCategory.accountSafety => Icons.verified_user_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = OrvikaLocalizations.of(context);
    final normalizedQuery = _controller.text.trim().toLowerCase();
    final entries = (l10n.language.code == 'ru' || l10n.language.code == 'zh')
        ? _library.search(query: '', category: _category).where((sourceEntry) {
            final translated = l10n.language.code == 'zh' ? MandarinIntelligenceContent.localize(sourceEntry, 'zh') : RussianIntelligenceContent.localize(sourceEntry, 'ru');
            return normalizedQuery.isEmpty ||
                <String>[
                  sourceEntry.title, sourceEntry.signal, sourceEntry.meaning,
                  sourceEntry.action, sourceEntry.limit, translated.title,
                  translated.signal, translated.meaning, translated.action,
                  translated.limit,
                ].any((value) => value.toLowerCase().contains(normalizedQuery));
          }).toList(growable: false)
        : _library.search(query: _controller.text, category: _category);
    return Scaffold(
      appBar: OrvikaFeatureAppBar(title: l10n.text('module.intelligence', 'Intelligence')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.text('intelligence.heading', 'Understand the signal.'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.text('intelligence.description', 'A practical, on-device reference to common digital-risk indicators and safer next steps.'),
                style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l10n.text('intelligence.search', 'Search indicators'),
                  hintText: l10n.text('intelligence.searchHint', 'Try “OTP”, “Punycode” or “payment”'),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: l10n.text('intelligence.clear', 'Clear search'),
                          onPressed: () {
                            _controller.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.text('intelligence.filter.all', 'All')),
                    selected: _category == null,
                    onSelected: (_) => setState(() => _category = null),
                  ),
                  for (final category in IntelligenceCategory.values)
                    ChoiceChip(
                      label: Text(_categoryLabel(category)),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.textWithParameters('intelligence.count', fallback: '{count} reference entries', parameters: {'count': entries.length}),
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  l10n.text('intelligence.offline', 'OFFLINE REFERENCE'),
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Semantics(
              container: true,
              liveRegion: true,
              label: l10n.textWithParameters('intelligence.count', fallback: '{count} reference entries', parameters: {'count': entries.length}),
              child: const SizedBox.shrink(),
            ),
            if (entries.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(l10n.text('intelligence.empty', 'No matching indicators. Try another search term or category.'),
                ),
              ),
            ),
            for (final sourceEntry in entries)
              Builder(
                builder: (context) {
                  final entry = (l10n.language.code == 'pt' || l10n.language.code == 'pt-PT') ? PortugueseIntelligenceContent.localize(sourceEntry, l10n.language.code) : l10n.language.code == 'es' ? SpanishIntelligenceContent.localize(sourceEntry, l10n.language.code) : l10n.language.code == 'fr' ? FrenchIntelligenceContent.localize(sourceEntry, l10n.language.code) : l10n.language.code == 'it' ? ItalianIntelligenceContent.localize(sourceEntry, l10n.language.code) : l10n.language.code == 'ru' ? RussianIntelligenceContent.localize(sourceEntry, l10n.language.code) : l10n.language.code == 'ar' ? ArabicIntelligenceContent.localize(sourceEntry, l10n.language.code) : GermanIntelligenceContent.localize(sourceEntry, l10n.language.code);
                  return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  leading: Icon(_categoryIcon(entry.category), color: scheme.primary),
                  title: Text(
                    entry.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(_categoryLabel(entry.category)),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailSection(label: l10n.text('intelligence.detail.notice', 'WHAT TO NOTICE'), value: entry.signal),
                    _DetailSection(label: l10n.text('intelligence.detail.meaning', 'WHAT IT MEANS'), value: entry.meaning),
                    _DetailSection(label: l10n.text('intelligence.detail.next', 'SAFER NEXT STEP'), value: entry.action),
                    _DetailSection(label: l10n.text('intelligence.detail.limit', 'IMPORTANT LIMIT'), value: entry.limit),
                  ],
                ),
              );
                },
              ),
            const SizedBox(height: 8),
            Text(
              l10n.text('intelligence.notice', 'This is a curated educational reference, not a live threat-intelligence feed, reputation service or verdict about a person, message or website. Entries are general guidance and may not fit every situation.'),
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
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.label, required this.value});

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
          Text(value, style: TextStyle(height: 1.45, color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
