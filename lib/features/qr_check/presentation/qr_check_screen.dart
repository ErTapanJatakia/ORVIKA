import 'package:flutter/material.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';

import '../../link_check/domain/url_analyzer.dart';
import '../domain/qr_payload_analyzer.dart';

class QrCheckScreen extends StatefulWidget {
  const QrCheckScreen({super.key});

  @override
  State<QrCheckScreen> createState() => _QrCheckScreenState();
}

class _QrCheckScreenState extends State<QrCheckScreen> {
  final _controller = TextEditingController();
  final _analyzer = const QrPayloadAnalyzer();
  QrPayloadAnalysis? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _inspect() {
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
      FindingSeverity.info => 'INFO',
      FindingSeverity.caution => 'CAUTION',
      FindingSeverity.warning => 'WARNING',
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final result = _result;
    return Scaffold(
      appBar: const OrvikaFeatureAppBar(
        title: 'QR Check',
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
              child: const Text(
                'Look before you scan.',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inspect decoded QR content before opening a link, joining a network, saving a contact, or making a payment.',
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
            ),
            const SizedBox(height: 22),
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 7,
              keyboardType: TextInputType.multiline,
              maxLength: 8192,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Decoded QR content',
                hintText: 'Paste the text or destination decoded from a QR code',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.qr_code_2_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _inspect,
              icon: const Icon(Icons.policy_outlined),
              label: const Text('Inspect QR content'),
            ),
            if (result != null) ...[
              Semantics(
                container: true,
                liveRegion: true,
                label: 'QR inspection complete. ${result.title}. Severity ${_severityLabel(result.severity)}. ${result.linkFindings.length} link findings.',
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
                          const Expanded(
                            child: Text(
                              'Inspection result',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            _severityLabel(result.severity),
                            style: TextStyle(
                              color: _severityColor(result.severity, scheme),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(result.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        result.detail,
                        style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
                      ),
                      if (result.normalizedUrl != null) ...[
                        const SizedBox(height: 14),
                        const Text('Detected destination', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 5),
                        SelectableText(
                          result.normalizedUrl!,
                          style: TextStyle(color: scheme.primary, fontSize: 13),
                        ),
                      ],
                      for (final finding in result.linkFindings) ...[
                        const SizedBox(height: 14),
                        const Divider(),
                        Row(
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
                                  Text(finding.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text(
                                    finding.detail,
                                    style: TextStyle(color: scheme.onSurfaceVariant, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'This first version inspects pasted, decoded content. It does not activate your camera, open destinations, connect to Wi-Fi, save contacts, send messages, or initiate payments. All analysis stays on this device.',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, height: 1.45),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
