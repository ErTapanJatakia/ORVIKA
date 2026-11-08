import '../../link_check/domain/url_analyzer.dart';

enum QrPayloadKind {
  webLink,
  wifiCredentials,
  contactCard,
  calendarEvent,
  paymentRequest,
  phoneAction,
  emailAction,
  messageAction,
  location,
  applicationLink,
  plainText,
  invalid,
}

class QrPayloadAnalysis {
  const QrPayloadAnalysis({
    required this.kind,
    required this.title,
    required this.detail,
    required this.severity,
    this.normalizedUrl,
    this.linkFindings = const [],
    this.isValid = true,
  });

  final QrPayloadKind kind;
  final String title;
  final String detail;
  final FindingSeverity severity;
  final String? normalizedUrl;
  final List<LinkFinding> linkFindings;
  final bool isValid;
}

/// Classifies QR payloads locally. It never opens links or triggers actions.
class QrPayloadAnalyzer {
  const QrPayloadAnalyzer();

  static final RegExp _schemePattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*:');
  static final RegExp _domainLike = RegExp(
    r'^(?:www\.)?[^\s/]+\.[^\s/]+(?:/[^\s]*)?$',
    caseSensitive: false,
  );

  QrPayloadAnalysis analyze(String rawPayload) {
    final payload = rawPayload.trim();
    if (payload.isEmpty) {
      return _invalid('No QR content was provided.');
    }
    if (payload.length > 8192) {
      return _invalid('The QR content exceeds the supported 8,192 characters.');
    }

    final upper = payload.toUpperCase();
    if (upper.startsWith('WIFI:')) {
      return const QrPayloadAnalysis(
        kind: QrPayloadKind.wifiCredentials,
        title: 'Wi-Fi configuration',
        detail: 'This QR payload may contain a network name, security type, and Wi-Fi password. Verify the network before joining; ORVIKA will not connect automatically.',
        severity: FindingSeverity.caution,
      );
    }
    if (upper.startsWith('BEGIN:VCARD')) {
      return const QrPayloadAnalysis(
        kind: QrPayloadKind.contactCard,
        title: 'Contact card',
        detail: 'This payload contains contact information. Review names, phone numbers, email addresses, and organisation details before saving.',
        severity: FindingSeverity.info,
      );
    }
    if (upper.startsWith('BEGIN:VEVENT')) {
      return const QrPayloadAnalysis(
        kind: QrPayloadKind.calendarEvent,
        title: 'Calendar event',
        detail: 'This payload describes a calendar event. Check its title, location, timing, and any embedded links before importing it.',
        severity: FindingSeverity.caution,
      );
    }

    final uri = Uri.tryParse(payload);
    final hasScheme = _schemePattern.hasMatch(payload);
    if (hasScheme && uri != null) {
      switch (uri.scheme.toLowerCase()) {
        case 'http':
        case 'https':
          return _analyseWebLink(payload);
        case 'upi':
          if (uri.host.toLowerCase() != 'pay' ||
              (uri.queryParameters['pa'] ?? '').trim().isEmpty) {
            return _invalid('The UPI payment payload is incomplete or has no payee address. Verify the QR source independently.');
          }
          return const QrPayloadAnalysis(
            kind: QrPayloadKind.paymentRequest,
            title: 'UPI payment request',
            detail: 'This QR payload may initiate a payment in a UPI app. Independently verify the recipient UPI ID, payee name, and amount. ORVIKA will not initiate or approve a payment.',
            severity: FindingSeverity.warning,
          );
        case 'tel':
          if (uri.path.trim().isEmpty) {
            return _invalid('The telephone action does not contain a phone number.');
          }
          return const QrPayloadAnalysis(
            kind: QrPayloadKind.phoneAction,
            title: 'Phone call action',
            detail: 'This payload contains a telephone action. Verify the number independently; ORVIKA will not place a call.',
            severity: FindingSeverity.caution,
          );
        case 'mailto':
          if (uri.path.trim().isEmpty) {
            return _invalid('The email action does not contain a recipient.');
          }
          return const QrPayloadAnalysis(
            kind: QrPayloadKind.emailAction,
            title: 'Email action',
            detail: 'This payload may pre-fill an email recipient or message. Verify all fields before sending; ORVIKA will not open an email app.',
            severity: FindingSeverity.caution,
          );
        case 'sms':
          if (uri.path.trim().isEmpty) {
            return _invalid('The text-message action does not contain a recipient.');
          }
          return const QrPayloadAnalysis(
            kind: QrPayloadKind.messageAction,
            title: 'Text-message action',
            detail: 'This payload may pre-fill a recipient or message. Verify the number and message before sending; ORVIKA will not send an SMS.',
            severity: FindingSeverity.caution,
          );
        case 'geo':
          return const QrPayloadAnalysis(
            kind: QrPayloadKind.location,
            title: 'Location coordinates',
            detail: 'This payload contains a location reference. Verify the coordinates and context before using them; ORVIKA will not open a map.',
            severity: FindingSeverity.info,
          );
        default:
          return QrPayloadAnalysis(
            kind: QrPayloadKind.applicationLink,
            title: 'Application-specific link',
            detail: 'This payload uses the "${uri.scheme}:" scheme rather than a standard web URL. It may launch an app or trigger an action. Do not open it unless you independently trust its source.',
            severity: FindingSeverity.warning,
          );
      }
    }

    if (_domainLike.hasMatch(payload)) {
      return _analyseWebLink(payload);
    }

    return const QrPayloadAnalysis(
      kind: QrPayloadKind.plainText,
      title: 'Plain text',
      detail: 'This QR payload contains text rather than a recognised web address or action. Review it carefully; text can still contain misleading instructions or sensitive information.',
      severity: FindingSeverity.info,
    );
  }

  QrPayloadAnalysis _analyseWebLink(String payload) {
    final result = const UrlAnalyzer().analyze(payload);
    if (!result.isValid) {
      return QrPayloadAnalysis(
        kind: QrPayloadKind.invalid,
        title: 'Unrecognised web address',
        detail: result.findings.map((finding) => finding.detail).join(' '),
        severity: FindingSeverity.warning,
        isValid: false,
      );
    }
    final hasWarning = result.findings.any(
      (finding) => finding.severity == FindingSeverity.warning,
    );
    final hasCaution = result.findings.any(
      (finding) => finding.severity == FindingSeverity.caution,
    );
    return QrPayloadAnalysis(
      kind: QrPayloadKind.webLink,
      title: 'Web address',
      detail: 'A web destination was found. Review the structural findings below before deciding what to do. The destination has not been opened or contacted.',
      severity: hasWarning
          ? FindingSeverity.warning
          : hasCaution
              ? FindingSeverity.caution
              : FindingSeverity.info,
      normalizedUrl: result.normalizedUrl,
      linkFindings: result.findings,
    );
  }

  QrPayloadAnalysis _invalid(String message) {
    return QrPayloadAnalysis(
      kind: QrPayloadKind.invalid,
      title: 'QR content not analysed',
      detail: message,
      severity: FindingSeverity.warning,
      isValid: false,
    );
  }
}
