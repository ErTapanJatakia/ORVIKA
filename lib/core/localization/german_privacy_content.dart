import '../../features/privacy/domain/privacy_checklist.dart';

/// German privacy self-audit guidance keyed by stable practice IDs.
class GermanPrivacyContent {
  GermanPrivacyContent._();

  static const Map<String, Map<String, String>> _practices = {
    'account-unique-passwords': {
      'title': 'Verwende einzigartige Passwörter für wichtige Konten',
      'why': 'Wird ein Passwort wiederverwendet, kann ein Datenleck bei einem Dienst auch andere Konten gefährden.',
      'action': 'Nutze einen seriösen Passwortmanager, um für jedes wichtige Konto ein eigenes, langes Passwort zu erstellen. Schütze den Manager mit einem starken Masterpasswort und verfügbaren Wiederherstellungsoptionen.',
      'limit': 'Ein Passwortmanager kann ein Konto nicht schützen, wenn sein Masterpasswort oder Wiederherstellungskanal kompromittiert ist.',
    },
    'account-mfa': {
      'title': 'Aktiviere Mehr-Faktor-Authentifizierung',
      'why': 'Ein zweiter Faktor kann die Folgen eines gestohlenen Passworts begrenzen.',
      'action': 'Aktiviere MFA für E-Mail-, Finanz-, Cloud- und Social-Media-Konten. Bevorzuge unterstützte Passkeys oder Sicherheitsschlüssel und schütze Authenticator-Backups.',
      'limit': 'MFA-Methoden unterscheiden sich in ihrer Stärke. SMS-Codes können SIM-Swap- und Rufnummernportierungsangriffen ausgesetzt sein.',
    },
    'account-recovery': {
      'title': 'Prüfe die Kontowiederherstellungsoptionen',
      'why': 'Eine veraltete Wiederherstellungs-E-Mail-Adresse oder Telefonnummer kann eine legitime Wiederherstellung verhindern oder eine Kontoübernahme erleichtern.',
      'action': 'Prüfe Wiederherstellungsadressen, Telefonnummern, Backup-Codes und vertrauenswürdige Geräte in den offiziellen Sicherheitseinstellungen jedes Dienstes.',
      'limit': 'Wiederherstellungseinstellungen unterscheiden sich je nach Dienst. ORVIKA kann nicht überprüfen, ob ein Anbieter deine Änderungen übernommen hat.',
    },
    'device-updates': {
      'title': 'Halte Betriebssysteme und Apps aktuell',
      'why': 'Updates beheben häufig Sicherheitslücken, die Angreifer andernfalls ausnutzen könnten.',
      'action': 'Aktiviere nach Möglichkeit automatische Sicherheitsupdates. Installiere Aktualisierungen über den integrierten Updater des Geräts oder den offiziellen App-Store.',
      'limit': 'Ein Update verringert bekannte Risiken, garantiert aber nicht, dass ein Gerät frei von Kompromittierung ist.',
    },
    'device-lock': {
      'title': 'Schütze das Gerät mit einer starken Bildschirmsperre',
      'why': 'Ein verlorenes oder unbeaufsichtigtes, entsperrtes Gerät kann Nachrichten, Konten und gespeicherte Daten offenlegen.',
      'action': 'Verwende eine lange PIN oder ein Passwort, stelle eine kurze automatische Sperrzeit ein und nutze Biometrie nur als zusätzliche bequeme Entsperrmethode.',
      'limit': 'Biometrie- und Sperroptionen unterscheiden sich je nach Gerät. Eine Bildschirmsperre verschlüsselt nicht jedes externe Backup.',
    },
    'device-backups': {
      'title': 'Prüfe Backup- und Geräteortungseinstellungen',
      'why': 'Backups erleichtern die Wiederherstellung. Geräteortungsfunktionen können helfen, ein verlorenes Gerät zu finden oder aus der Ferne zu sichern.',
      'action': 'Prüfe, welche Daten gesichert werden, wer auf das Backup-Konto zugreifen kann, ob Backup-Verschlüsselung verfügbar ist und ob Geräteortung sowie Fernsperre aktiviert sind.',
      'limit': 'Verfügbarkeit und Verschlüsselungsstandard hängen von Betriebssystem und Anbieter ab. Prüfe die aktuelle Dokumentation des Anbieters.',
    },
    'apps-permissions': {
      'title': 'Prüfe App-Berechtigungen',
      'why': 'Apps können weiterhin auf Standort, Kontakte, Kamera, Mikrofon, Fotos oder Geräte in der Nähe zugreifen, obwohl sie diese Daten nicht benötigen.',
      'action': 'Öffne die Datenschutz- oder App-Berechtigungseinstellungen des Betriebssystems. Entferne unnötige Zugriffe und bevorzuge einmalige oder auf die Nutzung beschränkte Freigaben, sofern verfügbar.',
      'limit': 'Bezeichnungen und Steuerungsmöglichkeiten unterscheiden sich je nach Betriebssystem und Version. ORVIKA liest oder ändert diese Berechtigungen nicht.',
    },
    'apps-unused': {
      'title': 'Entferne nicht mehr verwendete Apps',
      'why': 'Nicht verwendete Apps können angemeldet bleiben, Daten speichern oder weiterhin Berechtigungen und Updates erhalten.',
      'action': 'Deinstalliere Apps, die du nicht mehr benötigst. Exportiere benötigte Informationen vorher und widerrufe bei Bedarf den Zugriff auf verbundene Konten.',
      'limit': 'Die Deinstallation einer App löscht möglicherweise keine Daten, die bereits beim Anbieter gespeichert sind.',
    },
    'apps-sources': {
      'title': 'Installiere Apps aus vertrauenswürdigen Quellen',
      'why': 'Nicht verifizierte Installationsdateien und veränderte Apps können unerwünschten Code enthalten oder übermäßige Zugriffe verlangen.',
      'action': 'Nutze offizielle Stores oder den verifizierten Vertriebskanal des Herausgebers. Prüfe Entwickler, angeforderte Berechtigungen und Update-Verlauf vor der Installation.',
      'limit': 'Ein Eintrag in einem offiziellen Store garantiert nicht, dass eine App sicher ist oder die Privatsphäre respektiert.',
    },
    'browsing-tracking': {
      'title': 'Prüfe Datenschutz- und Tracking-Einstellungen des Browsers',
      'why': 'Cookies, Website-Berechtigungen und seitenübergreifendes Tracking können das Surfverhalten offenlegen.',
      'action': 'Prüfe Tracking-Schutz, Drittanbieter-Cookies, gespeicherte Website-Berechtigungen und Erweiterungen. Entferne Erweiterungen, die du nicht kennst oder benötigst.',
      'limit': 'Das Blockieren von Trackern kann die Funktion von Websites beeinträchtigen und macht das Surfen nicht anonym.',
    },
    'browsing-sharing': {
      'title': 'Begrenze öffentlich geteilte persönliche Informationen',
      'why': 'Öffentliche Beiträge und Profildetails können kombiniert werden, um Identitätsbetrug, gezielte Betrugsversuche oder Angriffe auf die Kontowiederherstellung zu unterstützen.',
      'action': 'Prüfe öffentliche Profilfelder, Zielgruppeneinstellungen, Standortfreigaben und ältere Beiträge. Veröffentliche keine Ausweisdokumente, Reisepläne oder Hinweise zur Kontowiederherstellung.',
      'limit': 'Inhalte können kopiert oder archiviert werden, bevor Datenschutzeinstellungen geändert werden.',
    },
    'browsing-network': {
      'title': 'Nutze sichere Verbindungen und prüfe Netzwerkanfragen',
      'why': 'Gefälschte WLAN-Portale und ungeschützte Verbindungen können Aktivitäten offenlegen oder auf täuschende Seiten umleiten.',
      'action': 'Bevorzuge vertrauenswürdige Netzwerke, bestätige den Netzwerknamen beim Betreiber, vermeide sensible Aktivitäten in unbekannten Netzwerken und nutze HTTPS-Websites. Deaktiviere die automatische Verbindung mit unbekannten Hotspots.',
      'limit': 'HTTPS schützt Daten auf dem Weg zu einer Website, beweist aber nicht deren Echtheit und macht ein nicht vertrauenswürdiges Netzwerk nicht sicher.',
    },
  };

  static PrivacyPractice localize(PrivacyPractice practice, String languageCode) {
    if (languageCode != 'de') return practice;
    final values = _practices[practice.id];
    if (values == null) return practice;
    return PrivacyPractice(
      id: practice.id,
      title: values['title']!,
      category: practice.category,
      why: values['why']!,
      action: values['action']!,
      limit: values['limit']!,
    );
  }
}
