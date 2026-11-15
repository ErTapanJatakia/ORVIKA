import '../../link_check/domain/url_analyzer.dart';

class MessageAnalysisResult {
  const MessageAnalysisResult({
    required this.input,
    required this.findings,
    required this.detectedLinks,
    required this.detectedContacts,
    required this.isValid,
    required this.notice,
  });

  final String input;
  final List<LinkFinding> findings;
  final List<String> detectedLinks;
  final List<String> detectedContacts;
  final bool isValid;
  final String notice;
}

/// Deterministic, on-device heuristic checks for common social-engineering cues.
/// This is a triage aid, not a classifier or proof of malicious intent.
class MessageAnalyzer {
  const MessageAnalyzer();

  static final RegExp _urlPattern = RegExp(
    r'''(?:(?:https?://)|(?:www\.))[^\s<>"']+''',
    caseSensitive: false,
  );

  static final RegExp _obfuscatedUrlPattern = RegExp(
    r'''\bhxxps?://[^\s<>"']+''',
    caseSensitive: false,
  );

  static final List<({String title, String detail, RegExp pattern})> _signals = [
    (
      title: 'Urgency or pressure language',
      detail: 'The message uses time pressure or immediate-action language. Pause and verify the request through a separate, trusted channel.',
      pattern: RegExp(
        r'\b(urgent|immediately|act now|right away|final notice|within \d+ hours?|expires today|limited time|account.{0,20}(?:suspend|block|close))\b|तुरंत|अभी|जल्दी|срочно|немедленно|сейчас',
        caseSensitive: false,
      ),
    ),
    (
      title: 'Credential or sign-in request',
      detail: 'The text appears to request a password, sign-in, or account verification. Do not enter credentials through a message link.',
      pattern: RegExp(
        r'\b(password|passcode|sign[ -]?in|log[ -]?in|verify.{0,20}(?:account|identity)|account.{0,20}verification|credentials)\b|पासवर्ड|खाता|लॉग.?इन|пароль|войти|учетн\w* запись',
        caseSensitive: false,
      ),
    ),
    (
      title: 'OTP or authentication-code reference',
      detail: 'A one-time password or authentication code is mentioned. Never share an OTP, recovery code, or approval prompt with another person.',
      pattern: RegExp(
        r'\b(otp|one[ -]?time password|verification code|authentication code|security code)\b|ओटीपी|एक.?बार.?का.?पासवर्ड|सत्यापन.?कोड|одноразовый пароль|код подтверждения|код аутентификации',
        caseSensitive: false,
      ),
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
    (
      title: 'Impersonation or authority claim',
      detail: 'The message appears to speak on behalf of a bank, government body, delivery company, employer or support team. Verify through contact details you obtain independently.',
      pattern: RegExp(r'\\b(bank|government|tax department|income tax|customs|police|court|courier|delivery|customer support|technical support|helpdesk|security team|hr department)\\b|बैंक|सरकार|आयकर|पुलिस|कूरियर|служба поддержки|банк|налогов\\w*', caseSensitive: false),
    ),
    (
      title: 'Secrecy or isolation request',
      detail: 'The message may be pressuring you not to consult anyone or to keep the request secret. Pause and verify with a trusted person or the organisation through a separate channel.',
      pattern: RegExp(r'\\b(keep (this|it) secret|do not tell anyone|don.t tell anyone|confidential (and )?urgent|act alone|do not discuss|don.t discuss)\\b|किसी को मत बताना|गुप्त रखें|никому не говорите|держите в секрете', caseSensitive: false),
    ),
    (
      title: 'Remote-access or app-installation request',
      detail: 'The message appears to request remote access, screen sharing, or installation of an application. Do not install tools or grant device access at the request of an unsolicited message.',
      pattern: RegExp(r'\\b(anydesk|teamviewer|remote access|screen sharing|share your screen|install (this|the) app|download (this|the) app|apk file|quick support|remote control)\\b|ऐप इंस्टॉल|स्क्रीन साझा|удаленный доступ|установите приложение', caseSensitive: false),
    ),
    (
      title: 'Sensitive personal information request',
      detail: 'The message may request identity, banking or personal details. Share sensitive information only through a verified official process that you initiated.',
      pattern: RegExp(r'\\b(aadhaar|pan card|social security|date of birth|mother.s maiden|card number|cvv|bank details|identity document|passport number|account number)\\b|आधार|पैन कार्ड|जन्म तिथि|паспорт|номер карты|личные данные', caseSensitive: false),
    ),
    (
      title: 'Unusual or hard-to-reverse payment method',
      detail: 'The message refers to gift cards, cryptocurrency, vouchers or an unusual payment route. These methods can be difficult to reverse; independently verify the request.',
      pattern: RegExp(r'\\b(gift card|crypto(currency)?|bitcoin|ethereum|usdt|voucher code|prepaid card|buy (an? )?gift card)\\b', caseSensitive: false),
    ),
  ];

  static final RegExp _contactPattern = RegExp(
    r'(?<![\\w.+-])[\\w.+-]+@[\\w.-]+\\.[A-Za-z]{2,}|(?<!\\w)(?:\\+?\\d[\\d .()\\-]{7,}\\d)(?!\\w)',
  );

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
        .map((match) => _trimTrailingPunctuation(match.group(0)!))
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList(growable: false);

    final contacts = _contactPattern
        .allMatches(rawInput)
        .map((match) => match.group(0)!.trim())
        .toSet()
        .toList(growable: false);
    if (contacts.isNotEmpty) {
      findings.add(LinkFinding(
        title: 'Contact details detected',
        detail: '${contacts.length} email address(es) or phone number(s) found. These are displayed for inspection only and have not been contacted or verified.',
        severity: FindingSeverity.caution,
      ));
    }

    if (_obfuscatedUrlPattern.hasMatch(rawInput)) {
      findings.add(const LinkFinding(
        title: 'Obfuscated web address detected',
        detail: 'The message contains a link using a substituted scheme such as hxxp or hxxps. Treat it as an address requiring manual inspection; it has not been normalised or opened.',
        severity: FindingSeverity.warning,
      ));
    }

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
      detectedContacts: List.unmodifiable(contacts),
      isValid: true,
      notice: 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.',
    );
  }

  String _trimTrailingPunctuation(String value) {
    var end = value.length;
    const trailingCharacters = '.,!?;:)\\]}>\u2019\u201d';
    while (end > 0 && trailingCharacters.contains(value[end - 1])) {
      end--;
    }
    return value.substring(0, end);
  }

  MessageAnalysisResult _invalid(String input, String detail) =>
      MessageAnalysisResult(
        input: input,
        findings: [
          LinkFinding(
            title: 'Message not analysed',
            detail: detail,
            severity: FindingSeverity.warning,
          ),
        ],
        detectedLinks: const [],
        detectedContacts: const [],
        isValid: false,
        notice: 'No network request was made.',
      );
}
