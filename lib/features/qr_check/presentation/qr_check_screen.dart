import 'package:flutter/material.dart';
import '../../../core/localization/arabic_checker_content.dart';

import 'qr_camera_scanner_screen.dart';
import 'qr_image_scanner_screen.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';
import '../../../core/localization/orvika_localizations.dart';

import '../../link_check/domain/url_analyzer.dart';
import '../domain/qr_payload_analyzer.dart';
import '../../../core/localization/german_checker_content.dart';
import '../../../core/localization/italian_checker_content.dart';
import '../../../core/localization/french_checker_content.dart';
import '../../../core/localization/spanish_checker_content.dart';
import '../../../core/localization/portuguese_checker_content.dart';
import '../../../core/localization/russian_checker_content.dart';
import '../../../core/localization/mandarin_checker_content.dart';
import '../../../core/localization/hindi_checker_content.dart';

class QrCheckScreen extends StatefulWidget {
  const QrCheckScreen({super.key});

  @override
  State<QrCheckScreen> createState() => _QrCheckScreenState();
}

class _QrCheckScreenState extends State<QrCheckScreen> {
  final _controller = TextEditingController();
  final _analyzer = const QrPayloadAnalyzer();
  QrPayloadAnalysis? _result;
  String? _detectedCodeFormat;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _inspect() {
    FocusScope.of(context).unfocus();
    setState(() {
      _result = _analyzer.analyze(_controller.text);
      _detectedCodeFormat = null;
    });
  }

  Future<void> _scanWithCamera() async {
    final scanned = await Navigator.of(context).push<({String value, String format})>(
      MaterialPageRoute(
        builder: (_) => const QrCameraScannerScreen(),
        fullscreenDialog: true,
      ),
    );
    if (!mounted || scanned == null) return;
    _controller.text = scanned.value;
    FocusScope.of(context).unfocus();
    setState(() {
      _detectedCodeFormat = scanned.format;
      _result = _analyzer.analyze(scanned.value);
    });
  }

  Future<void> _scanFromImage() async {
    final scanned = await Navigator.of(context).push<({String value, String format})>(
      MaterialPageRoute(
        builder: (_) => const QrImageScannerScreen(),
        fullscreenDialog: true,
      ),
    );
    if (!mounted || scanned == null) return;
    _controller.text = scanned.value;
    FocusScope.of(context).unfocus();
    setState(() {
      _detectedCodeFormat = scanned.format;
      _result = _analyzer.analyze(scanned.value);
    });
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
    final result = _result == null ? null : l10n.language.code == 'hi' ? HindiCheckerContent.localizeQr(_result!, l10n.language.code) : (l10n.language.code == 'pt' || l10n.language.code == 'pt-PT') ? PortugueseCheckerContent.localizeQr(_result!, l10n.language.code) : l10n.language.code == 'es' ? SpanishCheckerContent.localizeQr(_result!, l10n.language.code) : l10n.language.code == 'fr' ? FrenchCheckerContent.localizeQr(_result!, l10n.language.code) : l10n.language.code == 'it' ? ItalianCheckerContent.localizeQr(_result!, l10n.language.code) : l10n.language.code == 'zh' ? MandarinCheckerContent.localizeQr(_result!, l10n.language.code) : l10n.language.code == 'ru' ? RussianCheckerContent.localizeQr(_result!, l10n.language.code) : l10n.language.code == 'ar' ? ArabicCheckerContent.localizeQr(_result!, l10n.language.code) : GermanCheckerContent.localizeQr(_result!, l10n.language.code);
    return Scaffold(
      appBar: OrvikaFeatureAppBar(
        title: l10n.text('module.qr', 'QR Check'),
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
                l10n.text('checker.qr.heading', 'Look before you scan.'),
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.text('checker.qr.description', 'Inspect decoded QR content before opening a link, joining a network, saving a contact, or making a payment.'),
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: _scanWithCamera,
              icon: const Icon(Icons.document_scanner_outlined),
              label: Text(l10n.text('checker.qr.scanCamera', 'Scan QR / barcode with camera')),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _scanFromImage,
              icon: const Icon(Icons.image_search_outlined),
              label: Text(l10n.text('checker.qr.scanImage', 'Scan QR / barcode from image')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 7,
              keyboardType: TextInputType.multiline,
              maxLength: 8192,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l10n.text('checker.qr.input', 'Decoded QR content'),
                hintText: l10n.text('checker.qr.hint', 'Paste the text or destination decoded from a QR code'),
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.qr_code_2_rounded),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _inspect,
              icon: const Icon(Icons.policy_outlined),
              label: Text(l10n.text('checker.qr.action', 'Inspect QR content')),
            ),
            if (result != null) ...[
              Semantics(
                container: true,
                liveRegion: true,
                label: l10n.textWithParameters('checker.qr.complete', fallback: 'QR inspection complete. {title}. Severity {severity}. {count} link findings.', parameters: {'title': result.title, 'severity': _severityLabel(result.severity), 'count': result.linkFindings.length}),
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
                              l10n.text('checker.qr.result', 'Inspection result'),
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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
                      if (_detectedCodeFormat != null) ...[
                        const SizedBox(height: 10),
                        Text(l10n.textWithParameters('checker.qr.detectedFormat', fallback: 'Detected code format: {format}', parameters: {'format': _detectedCodeFormat!.toUpperCase()}),
                            style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)),
                      ],
                      const SizedBox(height: 14),
                      Text(result.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        result.detail,
                        style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
                      ),
                      if (result.normalizedUrl != null) ...[
                        const SizedBox(height: 14),
                        Text(l10n.text('checker.qr.destination', 'Detected destination'), style: const TextStyle(fontWeight: FontWeight.w700)),
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
              l10n.text('checker.qr.notice', 'Camera scanning starts only after you explicitly choose Scan and then Allow camera for this scan. The camera stops when a code is captured or you leave the scanner. Decoded content is analysed on this device; ORVIKA does not open destinations, connect to Wi-Fi, save contacts, send messages, or initiate payments. Browser and operating-system permission settings remain under your control.'),
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
