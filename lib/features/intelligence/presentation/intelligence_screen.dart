import 'package:flutter/material.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';

import '../domain/intelligence_library.dart';

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
        IntelligenceCategory.links => 'Links',
        IntelligenceCategory.messages => 'Messages',
        IntelligenceCategory.qrCodes => 'QR codes',
        IntelligenceCategory.accountSafety => 'Account safety',
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
    final entries = _library.search(query: _controller.text, category: _category);
    return Scaffold(
      appBar: const OrvikaFeatureAppBar(title: 'Intelligence'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
              Text(
                'Understand the signal.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'A practical, on-device reference to common digital-risk indicators and safer next steps.',
                style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Search indicators',
                  hintText: 'Try “OTP”, “Punycode” or “payment”',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
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
                    label: const Text('All'),
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
                    '${entries.length} reference entries',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Text(
                  'OFFLINE REFERENCE',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (entries.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('No matching indicators. Try another search term or category.'),
                ),
              ),
            for (final entry in entries)
              Card(
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
                    _DetailSection(label: 'WHAT TO NOTICE', value: entry.signal),
                    _DetailSection(label: 'WHAT IT MEANS', value: entry.meaning),
                    _DetailSection(label: 'SAFER NEXT STEP', value: entry.action),
                    _DetailSection(label: 'IMPORTANT LIMIT', value: entry.limit),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'This is a curated educational reference, not a live threat-intelligence feed, reputation service or verdict about a person, message or website. Entries are general guidance and may not fit every situation.',
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
