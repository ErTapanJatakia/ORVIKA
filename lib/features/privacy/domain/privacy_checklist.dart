enum PrivacyCategory { accounts, device, apps, browsing }

class PrivacyPractice {
  const PrivacyPractice({
    required this.id,
    required this.title,
    required this.category,
    required this.why,
    required this.action,
    required this.limit,
  });

  final String id;
  final String title;
  final PrivacyCategory category;
  final String why;
  final String action;
  final String limit;
}

/// A user-guided privacy self-audit. It does not inspect device settings.
class PrivacyChecklist {
  const PrivacyChecklist();

  static const practices = <PrivacyPractice>[
    PrivacyPractice(
      id: 'account-unique-passwords',
      title: 'Use unique passwords for important accounts',
      category: PrivacyCategory.accounts,
      why: 'Reusing a password lets a breach at one service put other accounts at risk.',
      action: 'Use a reputable password manager to create a different, long password for each important account. Secure the manager with a strong master password and available recovery options.',
      limit: 'A password manager cannot protect an account if its master password or recovery channel is compromised.',
    ),
    PrivacyPractice(
      id: 'account-mfa',
      title: 'Enable multi-factor authentication',
      category: PrivacyCategory.accounts,
      why: 'A second factor can reduce the impact of a stolen password.',
      action: 'Enable MFA on email, financial, cloud and social accounts. Prefer passkeys or security keys where supported; protect authenticator backups.',
      limit: 'MFA methods differ in strength. SMS codes can be exposed to SIM-swap and number-porting attacks.',
    ),
    PrivacyPractice(
      id: 'account-recovery',
      title: 'Review account recovery options',
      category: PrivacyCategory.accounts,
      why: 'An outdated recovery email or phone number can block legitimate recovery or expose an account to takeover.',
      action: 'Check recovery addresses, phone numbers, backup codes and trusted devices from each service’s official security settings.',
      limit: 'Recovery settings are service-specific; ORVIKA cannot verify that a provider has applied your changes.',
    ),
    PrivacyPractice(
      id: 'device-updates',
      title: 'Keep operating systems and apps updated',
      category: PrivacyCategory.device,
      why: 'Updates often fix security flaws that attackers may otherwise exploit.',
      action: 'Enable automatic security updates where practical. Install updates from the device’s built-in updater or the official app store.',
      limit: 'An update reduces known exposure but does not guarantee a device is free of compromise.',
    ),
    PrivacyPractice(
      id: 'device-lock',
      title: 'Protect the device with a strong screen lock',
      category: PrivacyCategory.device,
      why: 'A lost or unattended unlocked device can expose messages, accounts and stored data.',
      action: 'Use a long PIN or password, set a short automatic lock interval and configure biometrics only as a convenient additional unlock method.',
      limit: 'Biometrics and lock-screen options vary by device; a screen lock does not encrypt every external backup.',
    ),
    PrivacyPractice(
      id: 'device-backups',
      title: 'Check backup and device-finding settings',
      category: PrivacyCategory.device,
      why: 'Backups help recovery, while device-finding features can help locate or remotely secure a lost device.',
      action: 'Review what is backed up, who can access the backup account, whether backup encryption is available, and whether device-finding and remote-lock features are enabled.',
      limit: 'Availability and encryption defaults vary by operating system and provider. Confirm the provider’s current documentation.',
    ),
    PrivacyPractice(
      id: 'apps-permissions',
      title: 'Review app permissions',
      category: PrivacyCategory.apps,
      why: 'Apps may retain access to location, contacts, camera, microphone, photos or nearby devices beyond what they need.',
      action: 'Open the operating system’s privacy or app-permissions settings. Remove unnecessary access and prefer one-time or while-in-use access where available.',
      limit: 'Permission labels and controls differ by operating system and version. ORVIKA does not read or change these permissions.',
    ),
    PrivacyPractice(
      id: 'apps-unused',
      title: 'Remove apps you no longer use',
      category: PrivacyCategory.apps,
      why: 'Unused apps can remain signed in, retain data or continue receiving updates and permissions.',
      action: 'Uninstall apps you no longer need. Before removing an app, export information you need and revoke connected-account access if appropriate.',
      limit: 'Uninstalling an app may not delete data already held by its provider.',
    ),
    PrivacyPractice(
      id: 'apps-sources',
      title: 'Install apps from trusted sources',
      category: PrivacyCategory.apps,
      why: 'Unverified installers and modified apps can contain unwanted code or request excessive access.',
      action: 'Use official stores or the verified publisher’s distribution channel. Check the developer, requested permissions and update history before installing.',
      limit: 'An official store listing is not a guarantee that an app is safe or privacy-respecting.',
    ),
    PrivacyPractice(
      id: 'browsing-tracking',
      title: 'Review browser privacy and tracking controls',
      category: PrivacyCategory.browsing,
      why: 'Cookies, site permissions and cross-site tracking can reveal browsing behaviour.',
      action: 'Review tracking protection, third-party cookie controls, saved site permissions and extensions. Remove extensions you do not recognise or need.',
      limit: 'Blocking trackers can affect website functionality and does not make browsing anonymous.',
    ),
    PrivacyPractice(
      id: 'browsing-sharing',
      title: 'Limit personal information shared publicly',
      category: PrivacyCategory.browsing,
      why: 'Public posts and profile details can be combined to support impersonation, targeted scams or account recovery attacks.',
      action: 'Review public profile fields, audience settings, location sharing and old posts. Avoid publishing identity documents, travel plans or account-recovery clues.',
      limit: 'Content can be copied or archived before privacy settings are changed.',
    ),
    PrivacyPractice(
      id: 'browsing-network',
      title: 'Use secure connections and verify network prompts',
      category: PrivacyCategory.browsing,
      why: 'Lookalike Wi-Fi portals and unprotected connections can expose activity or redirect you to deceptive pages.',
      action: 'Prefer trusted networks, verify the network name with its owner, avoid sensitive activity on unknown networks and use HTTPS sites. Disable automatic joining of unfamiliar hotspots.',
      limit: 'HTTPS protects data in transit to a site but does not prove the site is legitimate or make an untrusted network safe.',
    ),
  ];

  List<PrivacyPractice> byCategory(PrivacyCategory category) =>
      List.unmodifiable(practices.where((practice) => practice.category == category));
}
