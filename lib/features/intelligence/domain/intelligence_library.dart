enum IntelligenceCategory { links, messages, qrCodes, accountSafety }

class IntelligenceEntry {
  const IntelligenceEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.signal,
    required this.meaning,
    required this.action,
    required this.limit,
  });

  final String id;
  final String title;
  final IntelligenceCategory category;
  final String signal;
  final String meaning;
  final String action;
  final String limit;
}

/// A small, curated, offline reference library — not a live threat feed.
class IntelligenceLibrary {
  const IntelligenceLibrary();

  static const entries = <IntelligenceEntry>[
    IntelligenceEntry(
      id: 'url-http',
      title: 'Unencrypted HTTP',
      category: IntelligenceCategory.links,
      signal: 'A website address begins with http:// rather than https://.',
      meaning: 'The connection does not use TLS to protect data in transit. Information exchanged may be exposed or altered on the network.',
      action: 'Avoid entering passwords or payment details. Navigate to the organisation using a trusted bookmark or independently verified address.',
      limit: 'HTTPS protects the connection; it does not prove that the website itself is legitimate.',
    ),
    IntelligenceEntry(
      id: 'url-userinfo',
      title: 'Misleading URL user information',
      category: IntelligenceCategory.links,
      signal: 'A URL contains text before the @ symbol, for example https://trusted.example@unknown.example/.',
      meaning: 'Browsers interpret the hostname after the @ symbol. The trusted-looking text before it may be intended to distract.',
      action: 'Read the actual hostname immediately after @ and verify the registered domain before visiting.',
      limit: 'User information in a URL is unusual but is not, by itself, proof of malicious intent.',
    ),
    IntelligenceEntry(
      id: 'url-punycode',
      title: 'Internationalised domain / Punycode',
      category: IntelligenceCategory.links,
      signal: 'A hostname contains an xn-- label or visually similar characters.',
      meaning: 'Internationalised domain names can use characters from different writing systems that resemble Latin letters.',
      action: 'Check the exact spelling and domain owner using a trusted source. Do not rely on a familiar-looking logo or display name.',
      limit: 'Many legitimate websites use internationalised domain names.',
    ),
    IntelligenceEntry(
      id: 'url-subdomains',
      title: 'Deep subdomain chain',
      category: IntelligenceCategory.links,
      signal: 'A hostname has many labels, such as login.account.example.invalid.',
      meaning: 'The registered domain is not necessarily the first familiar word in the address. Attackers can place brand names in subdomains they control.',
      action: 'Read the hostname from right to left and identify the registrable domain. Verify it independently.',
      limit: 'Long subdomain chains also have legitimate uses.',
    ),
    IntelligenceEntry(
      id: 'message-urgency',
      title: 'Urgency and pressure',
      category: IntelligenceCategory.messages,
      signal: 'A message demands immediate action, threatens account closure, or imposes an artificial deadline.',
      meaning: 'Pressure can discourage independent verification and make a recipient act before thinking.',
      action: 'Pause. Contact the organisation using a known official app, website or phone number—not contact details in the message.',
      limit: 'Urgent language can occur in legitimate communications; context matters.',
    ),
    IntelligenceEntry(
      id: 'message-credentials',
      title: 'Credential or OTP request',
      category: IntelligenceCategory.messages,
      signal: 'A sender asks for a password, OTP, recovery code or approval of an unexpected sign-in prompt.',
      meaning: 'These secrets or approvals can give another person access to an account or authorise a transaction.',
      action: 'Never disclose passwords or OTPs. Reject unexpected approval prompts and contact the service through its official channel.',
      limit: 'A keyword match only identifies a topic; it does not establish who sent the message or their intent.',
    ),
    IntelligenceEntry(
      id: 'message-payment',
      title: 'Unexpected payment or refund',
      category: IntelligenceCategory.messages,
      signal: 'A message requests a transfer, processing fee, refund action or payment to release a benefit.',
      meaning: 'Unexpected financial instructions can be used to redirect funds or collect payment details.',
      action: 'Verify the beneficiary, amount and reason through a separate trusted channel before taking action.',
      limit: 'Payment-related language is common in ordinary invoices and service notifications.',
    ),
    IntelligenceEntry(
      id: 'qr-payment',
      title: 'QR payment request',
      category: IntelligenceCategory.qrCodes,
      signal: 'A QR payload uses a payment scheme such as upi://pay.',
      meaning: 'Scanning may prefill a payment to a recipient. A QR code does not authenticate the payee or guarantee the amount is correct.',
      action: 'Check the payee name, UPI ID and amount in your payment app before authorising. Cancel if anything differs.',
      limit: 'A payment payload is not inherently fraudulent; verify the transaction details.',
    ),
    IntelligenceEntry(
      id: 'qr-action',
      title: 'QR code with an action link',
      category: IntelligenceCategory.qrCodes,
      signal: 'A QR payload contains a web, telephone, email, SMS or application-specific action.',
      meaning: 'The payload may open a destination or prefill an action when handled by another app.',
      action: 'Inspect the decoded content first. Do not open unfamiliar links or approve prefilled actions without verification.',
      limit: 'The payload type alone cannot establish whether its source is trustworthy.',
    ),
    IntelligenceEntry(
      id: 'account-mfa',
      title: 'Unexpected MFA approval',
      category: IntelligenceCategory.accountSafety,
      signal: 'You receive a sign-in approval prompt or one-time code that you did not request.',
      meaning: 'Someone may be attempting to sign in using your account identifier and password, or a code may have been triggered accidentally.',
      action: 'Deny the prompt, do not share the code, change the password from the official service if appropriate, and review active sessions.',
      limit: 'An unexpected prompt is a warning signal, not confirmation that an account was compromised.',
    ),
  ];

  List<IntelligenceEntry> search({
    String query = '',
    IntelligenceCategory? category,
  }) {
    final normalized = query.trim().toLowerCase();
    return List.unmodifiable(entries.where((entry) {
      final categoryMatches = category == null || entry.category == category;
      final textMatches = normalized.isEmpty ||
          <String>[
            entry.title,
            entry.signal,
            entry.meaning,
            entry.action,
            entry.limit,
          ].any((value) => value.toLowerCase().contains(normalized));
      return categoryMatches && textMatches;
    }));
  }
}
