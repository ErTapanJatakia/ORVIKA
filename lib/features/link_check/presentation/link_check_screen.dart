import 'package:flutter/material.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';
import '../../../core/localization/orvika_localizations.dart';

import '../domain/url_analyzer.dart';

class LinkCheckScreen extends StatefulWidget {
  const LinkCheckScreen({super.key});

  @override
  State<LinkCheckScreen> createState() => _LinkCheckScreenState();
}

class _LinkCheckScreenState extends State<LinkCheckScreen> {
  final _controller = TextEditingController();
  final _analyzer = const UrlAnalyzer();
  LinkAnalysisResult? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyse() {
    FocusScope.of(context).unfocus();
    setState(() => _result = _analyzer.analyze(_controller.text));
  }

  Color _severityColor(FindingSeverity severity, ColorScheme scheme) {
    return switch (severity) {
      FindingSeverity.info => scheme.primary,
      FindingSeverity.caution => Colors.amber,
      FindingSeverity.warning => scheme.error,
    };
  }

  String _severityLabel(FindingSeverity severity) {
    return switch (severity) {
      FindingSeverity.info => OrvikaLocalizations.of(context).text('checker.severity.info', 'INFO'),
      FindingSeverity.caution => OrvikaLocalizations.of(context).text('checker.severity.caution', 'CAUTION'),
      FindingSeverity.warning => OrvikaLocalizations.of(context).text('checker.severity.warning', 'WARNING'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = OrvikaLocalizations.of(context);
    return Scaffold(
      appBar: const OrvikaFeatureAppBar(
        title: 'Link Check',
        backgroundColor: Colors.transparent,
      ),
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
                    l10n.text('checker.link.heading', 'Inspect before you connect.'),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.text('checker.link.description', 'Paste a URL to review its structure for common warning signs. Analysis happens on this device.'),
                  style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
                ),
                const SizedBox(height: 22),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.done,
                  maxLength: 2048,
                  onSubmitted: (_) => _analyse(),
                  decoration: InputDecoration(
                    labelText: l10n.text('checker.link.input', 'Website address'),
                    hintText: 'https://example.com',
                    prefixIcon: Icon(Icons.link_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _analyse,
                  icon: const Icon(Icons.manage_search_rounded),
                  label: Text(l10n.text('checker.link.action', 'Analyse address')),
                ),
                if (_result case final result?) ...[
                  Semantics(
                    container: true,
                    liveRegion: true,
                    label: 'Link analysis complete. ${result.findings.length} findings.',
                    child: const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                result.isValid
                                    ? Icons.fact_check_outlined
                                    : Icons.warning_amber_rounded,
                                color: result.isValid ? scheme.primary : scheme.error,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  l10n.text('checker.link.result', 'Analysis findings'),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (result.normalizedUrl != null) ...[
                            const SizedBox(height: 12),
                            SelectableText(
                              result.normalizedUrl!,
                              style: TextStyle(color: scheme.primary, fontSize: 13),
                            ),
                          ],
                          const SizedBox(height: 14),
                          for (final finding in result.findings)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 9,
                                    color: _severityColor(finding.severity, scheme),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                finding.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              _severityLabel(finding.severity),
                                              style: TextStyle(
                                                color: _severityColor(
                                                  finding.severity,
                                                  scheme,
                                                ),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          finding.detail,
                                          style: TextStyle(
                                            color: scheme.onSurfaceVariant,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(),
                          Text(
                            result.notice,
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
                ],
                const SizedBox(height: 16),
                Text(
                  l10n.text('checker.link.notice', 'Important: a clean structural check is not a safety certificate. ORVIKA does not open the URL, contact the destination, or verify its reputation in this version.'),
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
