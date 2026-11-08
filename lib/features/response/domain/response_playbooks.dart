enum ResponseScenario {
  accountCompromise,
  paymentFraud,
  lostDevice,
  suspectedMalware,
  identityExposure,
}

class ResponsePlaybook {
  const ResponsePlaybook({
    required this.id,
    required this.title,
    required this.scenario,
    required this.summary,
    required this.firstAction,
    required this.steps,
    required this.preserve,
    required this.avoid,
    required this.limit,
  });

  final String id;
  final String title;
  final ResponseScenario scenario;
  final String summary;
  final String firstAction;
  final List<String> steps;
  final List<String> preserve;
  final List<String> avoid;
  final String limit;
}

/// General, offline-first incident guidance. This is not incident detection
/// and does not contact providers, banks, authorities or emergency services.
class ResponsePlaybooks {
  const ResponsePlaybooks();

  static const playbooks = <ResponsePlaybook>[
    ResponsePlaybook(
      id: 'account-compromise',
      title: 'An account may be compromised',
      scenario: ResponseScenario.accountCompromise,
      summary: 'You notice unfamiliar sign-ins, changed recovery details, messages you did not send or unexpected authentication prompts.',
      firstAction: 'Use a separate, trusted device and reach the service through its official app or address.',
      steps: [
        'Secure the primary email account first if it may be affected; it often controls password resets for other services.',
        'Change the affected password to a unique one and enable a strong available MFA method.',
        'Review recovery email addresses, phone numbers, passkeys and authentication methods; remove unfamiliar entries.',
        'Sign out unfamiliar sessions and revoke unknown connected apps or access tokens where the service provides that option.',
        'Check forwarding rules, mailbox filters, sent messages and recent account changes.',
        'If a work or school account is involved, notify the organisation’s IT or security team promptly.',
      ],
      preserve: [
        'Record alert emails, sign-in timestamps, device/session details and relevant account notifications.',
        'Keep original messages and headers where available; note what you changed and when.',
      ],
      avoid: [
        'Do not share passwords, OTPs, recovery codes or session links with anyone offering help.',
        'Do not use recovery links or phone numbers supplied in an unexpected message.',
        'Do not delete potentially relevant alerts before recording their details.',
      ],
      limit: 'ORVIKA cannot verify account access, revoke sessions or recover an account. Follow the service’s official recovery process; steps and labels vary.',
    ),
    ResponsePlaybook(
      id: 'payment-fraud',
      title: 'A suspicious or unauthorised payment',
      scenario: ResponseScenario.paymentFraud,
      summary: 'You sent money under pressure, approved an unexpected payment, shared payment credentials or see a transaction you do not recognise.',
      firstAction: 'Contact your bank or payment provider immediately using its official app, card number or independently verified website.',
      steps: [
        'Ask the provider to secure the affected account, card, wallet or payment instrument and explain the available dispute or recall process.',
        'Report the transaction as unauthorised or scam-induced; provide the transaction reference, amount, date and recipient details.',
        'Change exposed banking or email credentials from a trusted device and review active sessions and payment mandates.',
        'If credentials or a SIM may be compromised, tell the bank and relevant mobile provider.',
        'Use the official government or law-enforcement reporting channel for your jurisdiction and retain the acknowledgement or case reference.',
      ],
      preserve: [
        'Save transaction IDs, bank notifications, receipts, beneficiary details, call logs and message conversations.',
        'Record the time you noticed the issue and the time you contacted the provider.',
      ],
      avoid: [
        'Do not pay anyone promising guaranteed recovery of lost funds or demanding an advance fee.',
        'Do not approve further collect requests, payment mandates or remote-access sessions.',
        'Do not rely on contact details sent by the suspected fraudster.',
      ],
      limit: 'A payment may not be reversible. ORVIKA cannot freeze accounts, trace funds or submit reports. Contact the provider without delay; reporting routes and deadlines vary.',
    ),
    ResponsePlaybook(
      id: 'lost-device',
      title: 'A phone, laptop or device is lost',
      scenario: ResponseScenario.lostDevice,
      summary: 'A device is missing, stolen or may be accessible to someone else.',
      firstAction: 'From another trusted device, use the manufacturer’s or platform’s official account-security and device-location service.',
      steps: [
        'If available, mark the device as lost or remotely lock it; consider remote erase based on the sensitivity of the data and recovery prospects.',
        'Contact your mobile carrier to suspend a missing SIM or eSIM and ask about protecting the number.',
        'Change passwords for primary email, financial and identity accounts if the device may have been unlocked or credentials were saved.',
        'Revoke trusted-device sessions and review account recovery methods from a separate trusted device.',
        'Report suspected theft to the appropriate local authority and follow any workplace reporting process for managed devices.',
      ],
      preserve: [
        'Keep the device serial number, IMEI where applicable, purchase record and official location/security alerts.',
        'Record when and where it was last seen and the steps taken to lock or report it.',
      ],
      avoid: [
        'Do not confront or meet a person claiming to have the device; use appropriate authorities.',
        'Do not follow messages asking you to disable device protection or reveal account credentials.',
        'Do not assume a location estimate is exact or safe to act on yourself.',
      ],
      limit: 'Remote location, lock and erase depend on prior configuration, connectivity and platform support. Erasing may affect later evidence or recovery; consider the situation before proceeding.',
    ),
    ResponsePlaybook(
      id: 'suspected-malware',
      title: 'A device may have malware',
      scenario: ResponseScenario.suspectedMalware,
      summary: 'You see unexpected pop-ups, security warnings, unknown apps, unusual account activity or behaviour after opening a suspicious file.',
      firstAction: 'Stop entering passwords or payment details on the affected device. If active compromise is suspected, disconnect it from networks when practical.',
      steps: [
        'Use a separate trusted device for sensitive account changes and contact your organisation’s security team if it is a managed device.',
        'Do not open the suspicious file again or install tools recommended by an unsolicited pop-up or caller.',
        'Use built-in or reputable security tools obtained from official sources; follow their documented guidance.',
        'Update the operating system and applications after the immediate situation is understood and the device is safe to use.',
        'If credentials may have been exposed, change them from a separate trusted device and revoke active sessions.',
        'For a work device or a serious incident, preserve the device state and seek qualified incident-response support before wiping or reinstalling.',
      ],
      preserve: [
        'Record warning text, file names, download source, timestamps and any security-tool findings.',
        'Keep relevant emails, URLs and screenshots; do not upload sensitive files to public analysis services.',
      ],
      avoid: [
        'Do not run random cleanup scripts, registry fixes or unknown antivirus downloads.',
        'Do not factory-reset or delete files before considering evidence and recovery needs.',
        'Do not connect backup drives or other devices unnecessarily while compromise is suspected.',
      ],
      limit: 'These signs do not prove malware is present. ORVIKA does not scan files, inspect processes or clean devices. Serious or business-impacting incidents need qualified analysis.',
    ),
    ResponsePlaybook(
      id: 'identity-exposure',
      title: 'Personal or identity information was exposed',
      scenario: ResponseScenario.identityExposure,
      summary: 'Identity documents, personal details, credentials or private records may have been disclosed to an untrusted person or service.',
      firstAction: 'Identify exactly what information was exposed and secure the accounts or services that depend on it.',
      steps: [
        'Change any exposed passwords and any reused passwords from a trusted device; enable MFA where available.',
        'Contact the issuing organisation through an independently verified channel if identity documents, financial details or official credentials were exposed.',
        'Ask relevant financial institutions about monitoring, replacement, account restrictions or other protective options.',
        'Review account recovery settings and watch for password-reset, credit, transaction or identity-verification alerts.',
        'Report the exposure through the official privacy, regulator or law-enforcement channel applicable to your jurisdiction.',
      ],
      preserve: [
        'Keep the original exposure notice, relevant correspondence, dates, affected data categories and case references.',
        'Record who was notified and any advice or protective action they provided.',
      ],
      avoid: [
        'Do not publish the exposed document or full personal identifiers when asking for help.',
        'Do not send additional identity documents to an unverified recovery agent.',
        'Do not assume deleting a post or message removes copies already obtained by others.',
      ],
      limit: 'Available identity-protection and reporting options depend on the data type and jurisdiction. ORVIKA cannot determine whether information was copied or misused.',
    ),
  ];

  static ResponsePlaybook? byId(String id) {
    for (final playbook in playbooks) {
      if (playbook.id == id) return playbook;
    }
    return null;
  }
}
