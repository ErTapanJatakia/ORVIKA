import 'package:flutter/material.dart';
import '../../../core/localization/arabic_checker_content.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';
import '../../../core/localization/orvika_localizations.dart';

import '../../link_check/domain/url_analyzer.dart';
import '../domain/message_analyzer.dart';
import '../../../core/localization/german_checker_content.dart';
import '../../../core/localization/italian_checker_content.dart';
import '../../../core/localization/french_checker_content.dart';
import '../../../core/localization/spanish_checker_content.dart';
import '../../../core/localization/portuguese_checker_content.dart';
import '../../../core/localization/russian_checker_content.dart';

class MessageCheckScreen extends StatefulWidget {
  const MessageCheckScreen({super.key});

  @override
  State<MessageCheckScreen> createState() => _MessageCheckScreenState();
}

class _MessageCheckScreenState extends State<MessageCheckScreen> {
  final _controller = TextEditingController();
  final _analyzer = const MessageAnalyzer();
  MessageAnalysisResult? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyse() {
    FocusScope.of(context).unfocus();
    setState(() => _result = _analyzer.analyze(_controller.text));
  }

  Color _severityColor(FindingSeverity severity, ColorScheme scheme) =>
      switch (severity) {
        FindingSeverity.info => scheme.primary,
        FindingSeverity.caution => Colors.amber,
        FindingSeverity.warning => scheme.error,
      };

  String _severityLabel(FindingSeverity severity) => switch (severity) {
        FindingSeverity.info => OrvikaLocalizations.of(context).text('checker.severity.info', 'INFO'),
        FindingSeverity.caution => OrvikaLocalizations.of(context).text('checker.severity.caution', 'CAUTION'),
        FindingSeverity.warning => OrvikaLocalizations.of(context).text('checker.severity.warning', 'WARNING'),
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = OrvikaLocalizations.of(context);
    final result = _result;
    return Scaffold(
      appBar: OrvikaFeatureAppBar(
        title: l10n.text('module.message', 'Message Check'),
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
                    l10n.text('checker.message.heading', 'Pause. Inspect. Then respond.'),
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.text('checker.message.description', 'Paste a suspicious SMS, email or chat message to review common social-engineering cues. Analysis stays on this device.'),
                  style:
                      TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _controller,
                  minLines: 5,
                  maxLines: 10,
                  maxLength: 10000,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: l10n.text('checker.message.input', 'Message text'),
                    hintText: l10n.text('checker.message.hint', 'Paste the message here. Avoid adding unrelated personal information.'),
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.message_outlined),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: _analyse,
                  icon: const Icon(Icons.manage_search_rounded),
                  label: Text(l10n.text('checker.message.action', 'Inspect message')),
                ),
                if (result != null) ...[
                  Semantics(
                    container: true,
                    liveRegion: true,
                    label: l10n.textWithParameters('checker.message.complete', fallback: 'Message inspection complete. {findings} findings. {links} web addresses detected.', parameters: {'findings': result.findings.length, 'links': result.detectedLinks.length}),
                    child: const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 22),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.text('checker.message.result', 'Review findings'),
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 14),
                          for (final finding in result.findings.map((item) => (l10n.language.code == 'pt' || l10n.language.code == 'pt-PT') ? PortugueseCheckerContent.localizeFinding(item, l10n.language.code) : l10n.language.code == 'es' ? SpanishCheckerContent.localizeFinding(item, l10n.language.code) : l10n.language.code == 'fr' ? FrenchCheckerContent.localizeFinding(item, l10n.language.code) : l10n.language.code == 'it' ? ItalianCheckerContent.localizeFinding(item, l10n.language.code) : l10n.language.code == 'ru' ? RussianCheckerContent.localizeFinding(item, l10n.language.code) : GermanCheckerContent.localizeFinding(item, l10n.language.code)))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.circle,
                                      size: 9,
                                      color: _severityColor(
                                          finding.severity, scheme)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(finding.title,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Text(_severityLabel(
                                                finding.severity),
                                                style: TextStyle(
                                                  color: _severityColor(
                                                      finding.severity,
                                                      scheme),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 1,
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(finding.detail,
                                            style: TextStyle(
                                                color: scheme.onSurfaceVariant,
                                                height: 1.4)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (result.detectedLinks.isNotEmpty) ...[
                            const Divider(),
                            Text(l10n.text('checker.message.links', 'Detected web addresses'),
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            for (final link in result.detectedLinks)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: SelectableText(link,
                                    style: TextStyle(
                                        color: scheme.primary, fontSize: 13)),
                              ),
                          ],
                          const Divider(),
                          Text((l10n.language.code == 'pt' || l10n.language.code == 'pt-PT') ? PortugueseCheckerContent.localizeMessageNotice(l10n.language.code) : l10n.language.code == 'es' ? SpanishCheckerContent.localizeMessageNotice(l10n.language.code) : l10n.language.code == 'fr' ? FrenchCheckerContent.localizeMessageNotice(l10n.language.code) : l10n.language.code == 'it' ? ItalianCheckerContent.localizeMessageNotice(l10n.language.code) : l10n.language.code == 'ru' ? RussianCheckerContent.localizeMessageNotice(l10n.language.code) : l10n.language.code == 'ar' ? ArabicCheckerContent.localizeMessageNotice(l10n.language.code) : GermanCheckerContent.localizeMessageNotice(l10n.language.code),
                              style: TextStyle(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 12,
                                  height: 1.4)),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  l10n.text('checker.message.notice', 'Important: this version uses a limited set of transparent text patterns. It does not determine whether a sender is genuine, prove fraud, inspect attachments, or verify a message against external threat intelligence. Do not share OTPs, passwords or recovery codes.'),
                  style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12,
                      height: 1.45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
