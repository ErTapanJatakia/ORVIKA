import '../../features/response/domain/response_playbooks.dart';

/// German incident-response guidance keyed by stable playbook IDs.
class GermanResponseContent {
  GermanResponseContent._();

  static const Map<String, Map<String, Object>> _playbooks = {
    'account-compromise': {
      'title': 'Ein Konto könnte kompromittiert sein',
      'summary': 'Du bemerkst unbekannte Anmeldungen, geänderte Wiederherstellungsdaten, Nachrichten, die du nicht gesendet hast, oder unerwartete Authentifizierungsaufforderungen.',
      'firstAction': 'Nutze ein separates, vertrauenswürdiges Gerät und rufe den Dienst über seine offizielle App oder Adresse auf.',
      'steps': [
        'Sichere zuerst das primäre E-Mail-Konto, falls es betroffen sein könnte; darüber werden häufig Passwörter anderer Dienste zurückgesetzt.',
        'Ändere das betroffene Passwort in ein einzigartiges Passwort und aktiviere eine verfügbare starke MFA-Methode.',
        'Prüfe Wiederherstellungsadressen, Telefonnummern, Passkeys und Authentifizierungsmethoden. Entferne unbekannte Einträge.',
        'Melde unbekannte Sitzungen ab und widerrufe unbekannte verbundene Apps oder Zugriffstoken, sofern der Dienst dies ermöglicht.',
        'Prüfe Weiterleitungsregeln, Postfachfilter, gesendete Nachrichten und kürzliche Kontoänderungen.',
        'Informiere bei einem Arbeits- oder Schulkonto umgehend das IT- oder Sicherheitsteam der Organisation.',
      ],
      'preserve': [
        'Dokumentiere Warn-E-Mails, Anmeldezeitpunkte, Geräte- und Sitzungsdetails sowie relevante Kontobenachrichtigungen.',
        'Bewahre Originalnachrichten und Header auf, sofern verfügbar. Notiere, was du wann geändert hast.',
      ],
      'avoid': [
        'Gib Passwörter, OTPs, Wiederherstellungscodes oder Sitzungslinks niemals an Personen weiter, die Hilfe anbieten.',
        'Nutze keine Wiederherstellungslinks oder Telefonnummern aus einer unerwarteten Nachricht.',
        'Lösche möglicherweise relevante Warnungen nicht, bevor du ihre Details dokumentiert hast.',
      ],
      'limit': 'ORVIKA kann keinen Kontozugriff überprüfen, Sitzungen widerrufen oder ein Konto wiederherstellen. Folge dem offiziellen Wiederherstellungsprozess des Dienstes; Schritte und Bezeichnungen unterscheiden sich.',
    },
    'payment-fraud': {
      'title': 'Verdächtige oder nicht autorisierte Zahlung',
      'summary': 'Du hast unter Druck Geld überwiesen, eine unerwartete Zahlung bestätigt, Zahlungsdaten weitergegeben oder entdeckst eine unbekannte Transaktion.',
      'firstAction': 'Kontaktiere umgehend deine Bank oder deinen Zahlungsanbieter über die offizielle App, die Kartennummer oder eine unabhängig bestätigte Website.',
      'steps': [
        'Bitte den Anbieter, das betroffene Konto, die Karte, das Wallet oder Zahlungsmittel zu sichern und erläutere das verfügbare Streitbeilegungs- oder Rückrufverfahren.',
        'Melde die Transaktion als nicht autorisiert oder durch Betrug veranlasst. Nenne Referenz, Betrag, Datum und Empfängerdaten.',
        'Ändere offengelegte Bank- oder E-Mail-Zugangsdaten von einem vertrauenswürdigen Gerät aus und prüfe aktive Sitzungen sowie Zahlungsvollmachten.',
        'Informiere die Bank und den Mobilfunkanbieter, wenn Zugangsdaten oder eine SIM-Karte kompromittiert sein könnten.',
        'Nutze den offiziellen Meldeweg der zuständigen Behörden in deinem Land und bewahre die Bestätigung oder das Aktenzeichen auf.',
      ],
      'preserve': [
        'Sichere Transaktions-IDs, Bankbenachrichtigungen, Belege, Empfängerdaten, Anrufprotokolle und Nachrichtenverläufe.',
        'Notiere, wann du das Problem bemerkt und wann du den Anbieter kontaktiert hast.',
      ],
      'avoid': [
        'Zahle niemandem, der eine garantierte Rückholung verlorener Gelder verspricht oder eine Vorausgebühr verlangt.',
        'Bestätige keine weiteren Zahlungsanforderungen, Zahlungsvollmachten oder Fernzugriffssitzungen.',
        'Verlasse dich nicht auf Kontaktdaten, die dir der mutmaßliche Betrüger geschickt hat.',
      ],
      'limit': 'Eine Zahlung lässt sich möglicherweise nicht rückgängig machen. ORVIKA kann keine Konten sperren, Geld verfolgen oder Meldungen einreichen. Kontaktiere den Anbieter unverzüglich; Meldewege und Fristen unterscheiden sich.',
    },
    'lost-device': {
      'title': 'Ein Telefon, Laptop oder anderes Gerät ist verloren',
      'summary': 'Ein Gerät wird vermisst, wurde gestohlen oder könnte für andere Personen zugänglich sein.',
      'firstAction': 'Nutze von einem anderen vertrauenswürdigen Gerät aus den offiziellen Kontosicherheits- und Ortungsdienst des Herstellers oder der Plattform.',
      'steps': [
        'Markiere das Gerät, falls möglich, als verloren oder sperre es aus der Ferne. Erwäge eine Fernlöschung abhängig von Datensensibilität und Wiederherstellungschancen.',
        'Kontaktiere deinen Mobilfunkanbieter, um eine fehlende SIM- oder eSIM-Karte sperren zu lassen und die Rufnummer zu schützen.',
        'Ändere Passwörter für primäre E-Mail-, Finanz- und Identitätskonten, falls das Gerät entsperrt gewesen sein könnte oder Zugangsdaten gespeichert waren.',
        'Widerrufe vertrauenswürdige Gerätesitzungen und prüfe Wiederherstellungsoptionen von einem separaten vertrauenswürdigen Gerät.',
        'Melde einen vermuteten Diebstahl der zuständigen örtlichen Behörde und beachte bei verwalteten Geräten die Meldewege deines Arbeitgebers.',
      ],
      'preserve': [
        'Bewahre Seriennummer, gegebenenfalls IMEI, Kaufbeleg und offizielle Ortungs- oder Sicherheitsmeldungen auf.',
        'Notiere, wann und wo das Gerät zuletzt gesehen wurde und welche Sperr- oder Meldeschritte du unternommen hast.',
      ],
      'avoid': [
        'Konfrontiere oder treffe keine Person, die behauptet, das Gerät zu besitzen. Nutze die zuständigen Behörden.',
        'Befolge keine Nachrichten, die dich auffordern, den Geräteschutz zu deaktivieren oder Zugangsdaten offenzulegen.',
        'Gehe nicht davon aus, dass ein Standort ungefährer Ortung exakt ist oder ein eigenes Eingreifen sicher macht.',
      ],
      'limit': 'Fernortung, Sperrung und Löschung hängen von vorherigen Einstellungen, Verbindung und Plattformunterstützung ab. Eine Löschung kann spätere Beweise oder Wiederherstellung beeinträchtigen; prüfe die Situation sorgfältig.',
    },
    'suspected-malware': {
      'title': 'Ein Gerät könnte Schadsoftware enthalten',
      'summary': 'Du siehst unerwartete Pop-ups, Sicherheitswarnungen, unbekannte Apps, ungewöhnliche Kontoaktivitäten oder Auffälligkeiten nach dem Öffnen einer verdächtigen Datei.',
      'firstAction': 'Gib auf dem betroffenen Gerät keine Passwörter oder Zahlungsdaten mehr ein. Trenne es bei vermuteter aktiver Kompromittierung nach Möglichkeit vom Netzwerk.',
      'steps': [
        'Nutze für sensible Kontoänderungen ein separates vertrauenswürdiges Gerät und informiere bei einem verwalteten Gerät das Sicherheitsteam deiner Organisation.',
        'Öffne die verdächtige Datei nicht erneut und installiere keine Tools, die ein unerwünschtes Pop-up oder Anrufer empfiehlt.',
        'Nutze integrierte oder seriöse Sicherheitstools aus offiziellen Quellen und befolge deren dokumentierte Hinweise.',
        'Aktualisiere Betriebssystem und Anwendungen, sobald die unmittelbare Lage verstanden ist und das Gerät sicher verwendet werden kann.',
        'Ändere möglicherweise offengelegte Zugangsdaten von einem separaten vertrauenswürdigen Gerät aus und widerrufe aktive Sitzungen.',
        'Bewahre bei einem Arbeitsgerät oder einem schwerwiegenden Vorfall den Gerätezustand und hole qualifizierte Incident-Response-Unterstützung ein, bevor du löschst oder neu installierst.',
      ],
      'preserve': [
        'Dokumentiere Warntexte, Dateinamen, Downloadquelle, Zeitpunkte und Ergebnisse von Sicherheitstools.',
        'Bewahre relevante E-Mails, URLs und Screenshots auf. Lade keine sensiblen Dateien in öffentliche Analysedienste hoch.',
      ],
      'avoid': [
        'Führe keine zufälligen Bereinigungsskripte, Registry-Reparaturen oder unbekannten Antivirus-Downloads aus.',
        'Setze das Gerät nicht auf Werkseinstellungen zurück und lösche keine Dateien, bevor Beweis- und Wiederherstellungsbedarf geprüft wurde.',
        'Schließe bei vermuteter Kompromittierung nicht unnötig Backup-Laufwerke oder andere Geräte an.',
      ],
      'limit': 'Diese Anzeichen beweisen nicht, dass Schadsoftware vorhanden ist. ORVIKA scannt keine Dateien, untersucht keine Prozesse und bereinigt keine Geräte. Schwerwiegende oder geschäftskritische Vorfälle erfordern qualifizierte Analyse.',
    },
    'identity-exposure': {
      'title': 'Persönliche Daten oder Identitätsdaten wurden offengelegt',
      'summary': 'Ausweisdokumente, persönliche Angaben, Zugangsdaten oder vertrauliche Unterlagen könnten einer nicht vertrauenswürdigen Person oder einem Dienst bekannt geworden sein.',
      'firstAction': 'Stelle genau fest, welche Informationen offengelegt wurden, und sichere die davon abhängigen Konten oder Dienste.',
      'steps': [
        'Ändere offengelegte und wiederverwendete Passwörter von einem vertrauenswürdigen Gerät aus. Aktiviere MFA, sofern verfügbar.',
        'Kontaktiere die ausstellende Organisation über einen unabhängig bestätigten Kanal, wenn Ausweisdokumente, Finanzdaten oder amtliche Zugangsdaten betroffen sind.',
        'Frage relevante Finanzinstitute nach Überwachung, Ersatz, Kontobeschränkungen oder anderen Schutzmaßnahmen.',
        'Prüfe Kontowiederherstellungseinstellungen und achte auf Warnungen zu Passwortzurücksetzungen, Krediten, Transaktionen oder Identitätsprüfungen.',
        'Melde die Offenlegung über den zuständigen offiziellen Datenschutz-, Aufsichts- oder Strafverfolgungskanal.',
      ],
      'preserve': [
        'Bewahre die ursprüngliche Offenlegungsmitteilung, relevante Korrespondenz, Daten, betroffene Datenkategorien und Aktenzeichen auf.',
        'Notiere, wer informiert wurde und welche Hinweise oder Schutzmaßnahmen mitgeteilt wurden.',
      ],
      'avoid': [
        'Veröffentliche das offengelegte Dokument oder vollständige persönliche Kennungen nicht, wenn du um Hilfe bittest.',
        'Sende keine weiteren Identitätsdokumente an einen nicht verifizierten Wiederherstellungsdienst.',
        'Gehe nicht davon aus, dass das Löschen eines Beitrags oder einer Nachricht bereits angefertigte Kopien entfernt.',
      ],
      'limit': 'Verfügbare Schutz- und Meldeoptionen hängen von Datentyp und Rechtsordnung ab. ORVIKA kann nicht feststellen, ob Informationen kopiert oder missbraucht wurden.',
    },
  };

  static ResponsePlaybook localize(ResponsePlaybook playbook, String languageCode) {
    if (languageCode != 'de') return playbook;
    final values = _playbooks[playbook.id];
    if (values == null) return playbook;
    return ResponsePlaybook(
      id: playbook.id,
      title: values['title']! as String,
      scenario: playbook.scenario,
      summary: values['summary']! as String,
      firstAction: values['firstAction']! as String,
      steps: List<String>.unmodifiable(values['steps']! as List<String>),
      preserve: List<String>.unmodifiable(values['preserve']! as List<String>),
      avoid: List<String>.unmodifiable(values['avoid']! as List<String>),
      limit: values['limit']! as String,
    );
  }
}
