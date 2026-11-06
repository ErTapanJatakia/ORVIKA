import '../../link_check/domain/url_analyzer.dart';

class MessageAnalysisResult {
  const MessageAnalysisResult({
    required this.input,
    required this.findings,
    required this.detectedLinks,
    required this.isValid,
    required this.notice,
  });

  final String input;
  final List<LinkFinding> findings;
  final List<String> detectedLinks;
  final bool isValid;
  final String notice;
}

/// Deterministic, on-device heuristic checks for common social-engineering cues.
/// This is a triage aid, not a classifier or proof of malicious intent.
class MessageAnalyzer {
  const MessageAnalyzer();

  static final RegExp _urlPattern = RegExp(
    r'(?:(?:https?://)|(?:www\.))[A-Za-z0-9\-._~:/?#\[\]@!$&()*+,;=%]+',
    caseSensitive: false,
  );

  static final List<({String title, String detail, RegExp pattern})> _signals = [
    (
      title: 'Urgency or pressure language',
      detail: 'The message uses time pressure or immediate-action language. Pause and verify the request through a separate, trusted channel.',
      pattern: RegExp(r'\b(urgent|immediately|act now|right away|final notice|within \d+ hours?|expires today|limited time|account.{0,20}(?:suspend|block|close))\b', caseSensitive: false),
    ),
    (
      title: 'Credential or sign-in request',
      detail: 'The text appears to request a password, sign-in, or account verification. Do not enter credentials through a message link.',
      pattern: RegExp(r'\b(password|passcode|sign[ -]?in|log[ -]?in|verify.{0,20}(?:account|identity)|account.{0,20}verification|credentials)\b', caseSensitive: false),
    ),
    (
      title: 'OTP or authentication-code reference',
      detail: 'A one-time password or authentication code is mentioned. Never share an OTP, recovery code, or approval prompt with another person.',
      pattern: RegExp(r'\b(otp|one[ -]?time password|verification code|authentication code|security code)\b', caseSensitive: false),
    ),
    (
      title: 'Payment or financial action',
      detail: 'The message refers to a payment, transfer, refund, fee, or financial action. Independently confirm the beneficiary and amount before proceeding.',
      pattern: RegExp(r'\b(payment|pay now|transfer|bank account|refund|invoice|wire|upi|wallet|processing fee|prize money)\b', caseSensitive: false),
    ),
    (
      title: 'Prize or unexpected reward',
      detail: 'An unexpected prize, reward, or winning is mentioned. Be cautious of requests for fees or personal information to claim it.',
      pattern: RegExp(r'\b(you have won|winner|won a prize|claim your prize|lottery|giveaway|reward awaits)\b', caseSensitive: false),
    ),
    (
      title: 'Threat or consequence language',
      detail: 'The message threatens a penalty, legal action, arrest, or loss of access. Verify claims with the named organisation using independently sourced contact details.',
      pattern: RegExp(r'\b(arrest|legal action|police case|penalty|fine|prosecution|service will be disconnected|account will be blocked)\b', caseSensitive: false),
    ),
  ];

  MessageAnalysisResult analyze(String rawInput) {
    if (rawInput.trim().isEmpty) {
      return _invalid(rawInput, 'Paste a message to inspect.');
    }
    if (rawInput.length > 10000) {
      return _invalid(rawInput, 'The message exceeds the 10,000-character limit.');
    }

    final findings = <LinkFinding>[];
    for (final signal in _signals) {
      if (signal.pattern.hasMatch(rawInput)) {
        findings.add(LinkFinding(
          title: signal.title,
          detail: signal.detail,
          severity: signal.title == 'OTP or authentication-code reference' ||
                  signal.title == 'Credential or sign-in request'
              ? FindingSeverity.warning
              : FindingSeverity.caution,
        ));
      }
    }

    final links = _urlPattern
        .allMatches(rawInput)
        .map((match) => match.group(0)!.replaceAll(RegExp(r'[.,!?;:]+$'), ''))
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList(growable: false);

    if (links.isNotEmpty) {
      findings.add(LinkFinding(
        title: 'Link or web address detected',
        detail: '${links.length} web address(es) found. A visible link can conceal a different destination; inspect each address separately before opening it.',
        severity: FindingSeverity.caution,
      ));
    }

    if (findings.isEmpty) {
      findings.add(const LinkFinding(
        title: 'No listed social-engineering cues detected',
        detail: 'The text did not match the limited patterns in this version. Harmful messages can still appear ordinary or use wording not covered here.',
        severity: FindingSeverity.info,
      ));
    }

    return MessageAnalysisResult(
      input: rawInput,
      findings: List.unmodifiable(findings),
      detectedLinks: links,
      isValid: true,
      notice: 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.',
    );
  }

  MessageAnalysisResult _invalid(String input, String detail) => MessageAnalysisResult(
    input: input,
    findings: [LinkFinding(
      title: 'Message not analysed',
      detail: detail,
      severity: FindingSeverity.warning,
    )],
    detectedLinks: const [],
    isValid: false,
    notice: 'No network request was made.',
  );
}
