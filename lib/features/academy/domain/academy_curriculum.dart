enum AcademyCategory { accountSafety, socialEngineering, deviceSafety, payments }

class AcademyLesson {
  const AcademyLesson({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.keyPoints,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String title;
  final AcademyCategory category;
  final String summary;
  final List<String> keyPoints;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class AcademyCurriculum {
  const AcademyCurriculum();

  static const lessons = <AcademyLesson>[
    AcademyLesson(
      id: 'verify_sender',
      title: 'Verify the sender, not the display name',
      category: AcademyCategory.accountSafety,
      summary: 'Names, logos and profile photos are easy to copy. Check the actual address, number or account handle before trusting a request.',
      keyPoints: [
        'Open the sender details and inspect the complete email address or account identifier.',
        'For an unexpected request, contact the person or organisation using a channel you already trust.',
        'A familiar name or logo is not proof of identity.',
      ],
      question: 'A message appears to come from your bank and asks you to act urgently. What is the safest first step?',
      options: [
        'Reply and ask the sender to confirm',
        'Use the bank app or a known official contact route independently',
        'Trust it because the logo looks correct',
      ],
      correctIndex: 1,
      explanation: 'Use a contact route you obtain independently. Do not rely on links or phone numbers supplied in the unexpected message.',
    ),
    AcademyLesson(
      id: 'phishing_links',
      title: 'Read links before opening them',
      category: AcademyCategory.socialEngineering,
      summary: 'A link can imitate a trusted brand while sending you to an unrelated or misleading domain.',
      keyPoints: [
        'Identify the registered domain from right to left; extra subdomains can disguise the destination.',
        'Watch for misspellings, lookalike characters, unexpected URL shorteners and misleading text.',
        'When in doubt, navigate using a saved bookmark or type the known address yourself.',
      ],
      question: 'A message says “example.com” but the actual link points to example-login.security-check.invalid. What should you do?',
      options: [
        'Open it because the visible text looks familiar',
        'Avoid it and reach the service through its known official route',
        'Open it in a private browser window',
      ],
      correctIndex: 1,
      explanation: 'Visible link text can differ from the destination. Private browsing does not make a malicious destination safe.',
    ),
    AcademyLesson(
      id: 'otp_secrecy',
      title: 'Keep OTPs and recovery codes private',
      category: AcademyCategory.accountSafety,
      summary: 'One-time passwords, login approval prompts and recovery codes can let someone access your account.',
      keyPoints: [
        'Never disclose an OTP or recovery code to a caller, chat contact or support impersonator.',
        'Do not approve a login prompt you did not initiate.',
        'If you shared a code, use the official service to secure the account immediately.',
      ],
      question: 'Someone claiming to be support asks you to read out an OTP to cancel a transaction. What should you do?',
      options: [
        'Share it if they know your name',
        'Share only the first half',
        'Do not share it; end contact and use the official service channel',
      ],
      correctIndex: 2,
      explanation: 'An OTP is an authentication secret. A legitimate support interaction should not require you to disclose it.',
    ),
    AcademyLesson(
      id: 'mfa_fatigue',
      title: 'Recognise unexpected MFA prompts',
      category: AcademyCategory.accountSafety,
      summary: 'Repeated or unexpected approval prompts may indicate someone is attempting to sign in with your credentials.',
      keyPoints: [
        'Deny prompts you did not initiate.',
        'Do not approve a prompt simply to make repeated notifications stop.',
        'Change your password through the official service and review active sessions if you suspect compromise.',
      ],
      question: 'Your phone receives several sign-in approval prompts while you are not logging in. What is the safe response?',
      options: [
        'Deny them and investigate the account through its official settings',
        'Approve one to stop the alerts',
        'Ignore all future account alerts',
      ],
      correctIndex: 0,
      explanation: 'Unexpected prompts should be denied. Then investigate from a trusted device and official account route.',
    ),
    AcademyLesson(
      id: 'payment_pressure',
      title: 'Pause before urgent payments',
      category: AcademyCategory.payments,
      summary: 'Scammers use urgency, secrecy and authority to pressure people into transfers, gift cards or payment approvals.',
      keyPoints: [
        'Treat last-minute bank-detail changes and urgent transfer requests as high risk.',
        'Verify payment instructions with the recipient using a previously known number.',
        'Never let a caller rush you past normal approval controls.',
      ],
      question: 'A supplier emails new bank details and says payment must be made in the next 10 minutes. What should you do?',
      options: [
        'Pay immediately to avoid a late fee',
        'Verify the change using a previously known contact number',
        'Reply to the email asking if it is genuine',
      ],
      correctIndex: 1,
      explanation: 'Independently verify payment changes. A reply to the same potentially compromised email thread is not independent verification.',
    ),
    AcademyLesson(
      id: 'qr_safety',
      title: 'Treat QR codes as links',
      category: AcademyCategory.payments,
      summary: 'A QR code can encode a website, payment request, contact action or other payload. Scanning does not make it trustworthy.',
      keyPoints: [
        'Preview the decoded destination or payment details before proceeding.',
        'Check recipient and amount carefully before authorising a payment.',
        'Be cautious when a QR sticker appears placed over an expected code.',
      ],
      question: 'A QR code opens a payment screen. What should you verify before approving anything?',
      options: [
        'Only whether the QR image looks professional',
        'The recipient, amount and purpose using a trusted source',
        'Whether the code scans quickly',
      ],
      correctIndex: 1,
      explanation: 'A QR code is just a convenient way to carry data. Verify the actual transaction details before authorising it.',
    ),
    AcademyLesson(
      id: 'device_updates',
      title: 'Keep devices and apps maintained',
      category: AcademyCategory.deviceSafety,
      summary: 'Security updates address known weaknesses. Delaying updates can leave devices exposed to issues that already have fixes.',
      keyPoints: [
        'Install operating-system and app updates from official update mechanisms.',
        'Remove apps you no longer use and review permissions periodically.',
        'Keep a recovery-ready backup and protect the device with a screen lock.',
      ],
      question: 'An app update is available through your device’s official app store. What is the safer practice?',
      options: [
        'Install updates in a timely manner after checking the source',
        'Download a random “faster update” package from an advert',
        'Disable updates permanently',
      ],
      correctIndex: 0,
      explanation: 'Use the platform’s official update mechanism and keep software reasonably current.',
    ),
    AcademyLesson(
      id: 'incident_first_steps',
      title: 'Act quickly if an account may be compromised',
      category: AcademyCategory.accountSafety,
      summary: 'A calm, ordered response can limit further access and preserve useful information.',
      keyPoints: [
        'From a trusted device, secure the affected account using the official service.',
        'Change reused passwords, revoke unfamiliar sessions and enable MFA where available.',
        'Preserve relevant messages and transaction records; contact your bank promptly if money is involved.',
      ],
      question: 'You suspect your email account has been taken over. Which action is the best starting point?',
      options: [
        'Delete every suspicious message immediately',
        'Use a trusted device and official recovery route to secure the account',
        'Post your recovery codes publicly to ask for help',
      ],
      correctIndex: 1,
      explanation: 'Secure the account through the official recovery process, review sessions and preserve evidence that may help the investigation.',
    ),
  ];

  List<AcademyLesson> byCategory(AcademyCategory category) =>
      lessons.where((lesson) => lesson.category == category).toList(growable: false);
}
