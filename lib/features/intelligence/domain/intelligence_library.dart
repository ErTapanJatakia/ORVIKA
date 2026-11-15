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

    IntelligenceEntry(
      id: 'url-shortener',
      title: 'Shortened or obscured destination',
      category: IntelligenceCategory.links,
      signal: 'A link uses a URL shortener or hides the final destination behind a redirect.',
      meaning: 'The visible address does not show the website you will ultimately reach. Redirect chains can conceal an unexpected destination.',
      action: 'Do not rely on the shortened text. Use a trusted preview or independently navigate to the organisation; avoid opening unsolicited shortened links.',
      limit: 'URL shorteners are widely used for legitimate campaigns and services.',
    ),
    IntelligenceEntry(
      id: 'url-lookalike',
      title: 'Lookalike domain spelling',
      category: IntelligenceCategory.links,
      signal: 'A domain substitutes, adds or removes characters to resemble a known organisation.',
      meaning: 'Small spelling differences, extra words or swapped characters can make an attacker-controlled domain appear familiar.',
      action: 'Compare the complete registered domain character by character with an address obtained independently.',
      limit: 'A similar-looking name is a reason to verify, not proof of malicious ownership.',
    ),
    IntelligenceEntry(
      id: 'url-download',
      title: 'Unexpected file download',
      category: IntelligenceCategory.links,
      signal: 'A website or message unexpectedly prompts you to download an executable, script, archive or mobile application package.',
      meaning: 'A downloaded file may install software, request excessive permissions or exploit a vulnerable application.',
      action: 'Do not run unexpected files. Obtain software from the device platform’s trusted store or the publisher’s independently verified website.',
      limit: 'Legitimate software is also distributed as downloadable files; verify publisher, source and integrity.',
    ),
    IntelligenceEntry(
      id: 'url-certificate',
      title: 'HTTPS certificate warning',
      category: IntelligenceCategory.links,
      signal: 'The browser reports an invalid, expired, mismatched or untrusted site certificate.',
      meaning: 'The browser cannot establish the expected authenticated encrypted connection to that hostname.',
      action: 'Stop and do not bypass the warning to enter credentials or payment information. Check the address and try again later.',
      limit: 'Certificate errors can result from misconfiguration or device clock problems; they do not identify the cause.',
    ),
    IntelligenceEntry(
      id: 'url-permission',
      title: 'Unexpected browser permission request',
      category: IntelligenceCategory.links,
      signal: 'A site unexpectedly asks for notification, camera, microphone, location or file access.',
      meaning: 'A permission can expose sensitive device capabilities or enable persistent unwanted notifications.',
      action: 'Deny permissions that are not necessary for the task. Review and revoke site permissions in browser settings.',
      limit: 'Some legitimate services require permissions for specific features; assess the purpose and origin.',
    ),
    IntelligenceEntry(
      id: 'message-secrecy',
      title: 'Secrecy or isolation request',
      category: IntelligenceCategory.messages,
      signal: 'A sender tells you not to discuss a request with family, colleagues, your bank or the organisation concerned.',
      meaning: 'Isolation can prevent a second opinion and make impersonation or payment pressure more effective.',
      action: 'Pause and independently verify the request. A legitimate process should withstand reasonable verification.',
      limit: 'Confidentiality requests can be legitimate in some contexts; urgency and the requested action matter.',
    ),
    IntelligenceEntry(
      id: 'message-remote-access',
      title: 'Remote-access or screen-sharing lure',
      category: IntelligenceCategory.messages,
      signal: 'A sender asks you to install remote-support software, share your screen or grant device control.',
      meaning: 'Remote access can expose messages, banking sessions, authentication codes and files, or allow actions on your behalf.',
      action: 'Do not install or grant access at an unsolicited request. Contact the organisation through a separately verified channel.',
      limit: 'Remote-support tools have legitimate uses when you independently initiate support with a trusted provider.',
    ),
    IntelligenceEntry(
      id: 'message-gift-card',
      title: 'Gift-card or cryptocurrency payment',
      category: IntelligenceCategory.messages,
      signal: 'A message asks for gift-card codes, cryptocurrency, vouchers or another difficult-to-reverse payment.',
      meaning: 'These payment methods can be difficult or impossible to recover once transferred.',
      action: 'Do not buy or transfer codes or cryptocurrency under pressure. Verify the request with the supposed sender using a known channel.',
      limit: 'These payment methods have legitimate uses; the unsolicited demand and context are the concern.',
    ),
    IntelligenceEntry(
      id: 'message-secrets',
      title: 'Request for sensitive identity or banking data',
      category: IntelligenceCategory.messages,
      signal: 'A message asks for a card security code, full identity number, account credentials or copies of identity documents.',
      meaning: 'Such information can enable account takeover, identity misuse or unauthorised transactions.',
      action: 'Do not send sensitive details in a reply or chat. Use only a verified official process that you initiated.',
      limit: 'Some regulated processes require identity checks; verify the channel and necessity before sharing.',
    ),
    IntelligenceEntry(
      id: 'qr-wifi',
      title: 'QR code containing Wi-Fi credentials',
      category: IntelligenceCategory.qrCodes,
      signal: 'A decoded QR payload contains a Wi-Fi network name and password.',
      meaning: 'Joining may connect your device to a network controlled by someone else, where network-level risks depend on its configuration.',
      action: 'Join only networks you trust. Avoid sensitive activity on unknown networks and use your device’s security protections.',
      limit: 'Wi-Fi QR codes are a common convenience feature and are not inherently malicious.',
    ),
    IntelligenceEntry(
      id: 'qr-contact',
      title: 'QR code with contact or message action',
      category: IntelligenceCategory.qrCodes,
      signal: 'A QR payload contains a vCard, telephone number, email address or prefilled SMS message.',
      meaning: 'Importing or activating the payload may add a contact or prepare a communication to a destination you have not verified.',
      action: 'Review the displayed name, number, address and message before saving or sending anything.',
      limit: 'Contact QR codes are commonly used for legitimate sharing; verify the details before acting.',
    ),
    IntelligenceEntry(
      id: 'account-recovery',
      title: 'Unexpected account recovery activity',
      category: IntelligenceCategory.accountSafety,
      signal: 'You receive an unsolicited password-reset notice, recovery-code request or alert that recovery details changed.',
      meaning: 'Someone may be attempting to access or take control of an account, or the notification may be unsolicited spam.',
      action: 'Do not share recovery codes. Open the service using its official app or a trusted bookmark, review account activity and secure recovery methods.',
      limit: 'A notification alone does not confirm a successful account takeover.',
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
