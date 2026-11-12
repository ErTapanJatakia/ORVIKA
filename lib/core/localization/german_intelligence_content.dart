import '../../features/intelligence/domain/intelligence_library.dart';

/// Reviewed German wording for the curated offline intelligence reference.
/// Indicator identifiers and technical examples remain unchanged.
class GermanIntelligenceContent {
  GermanIntelligenceContent._();

  static const Map<String, Map<String, String>> _entries = {
    'url-http': {
      'title': 'Unverschlüsseltes HTTP',
      'signal': 'Eine Webadresse beginnt mit http:// statt mit https://.',
      'meaning': 'Die Verbindung verwendet keine TLS-Verschlüsselung zum Schutz der übertragenen Daten. Informationen können im Netzwerk offengelegt oder verändert werden.',
      'action': 'Gib keine Passwörter oder Zahlungsdaten ein. Öffne die Organisation über ein vertrauenswürdiges Lesezeichen oder eine unabhängig bestätigte Adresse.',
      'limit': 'HTTPS schützt die Verbindung; es beweist nicht, dass die Website selbst legitim ist.',
    },
    'url-userinfo': {
      'title': 'Irreführende Benutzerinformationen in einer URL',
      'signal': 'Eine URL enthält Text vor dem @-Zeichen, zum Beispiel https://trusted.example@unknown.example/.',
      'meaning': 'Browser interpretieren den Hostnamen hinter dem @-Zeichen. Der vertrauenswürdig wirkende Text davor kann ablenken sollen.',
      'action': 'Prüfe den tatsächlichen Hostnamen direkt nach dem @-Zeichen und bestätige die registrierte Domain, bevor du die Seite aufrufst.',
      'limit': 'Benutzerinformationen in einer URL sind ungewöhnlich, aber für sich allein kein Beweis für eine schädliche Absicht.',
    },
    'url-punycode': {
      'title': 'Internationalisierte Domain / Punycode',
      'signal': 'Ein Hostname enthält ein xn---Label oder optisch ähnliche Zeichen.',
      'meaning': 'Internationalisierte Domainnamen können Zeichen aus verschiedenen Schriftsystemen verwenden, die lateinischen Buchstaben ähneln.',
      'action': 'Prüfe die genaue Schreibweise und den Domaininhaber anhand einer vertrauenswürdigen Quelle. Verlasse dich nicht auf ein vertraut wirkendes Logo oder einen Anzeigenamen.',
      'limit': 'Viele legitime Websites verwenden internationalisierte Domainnamen.',
    },
    'url-subdomains': {
      'title': 'Lange Kette von Subdomains',
      'signal': 'Ein Hostname enthält mehrere Bestandteile, zum Beispiel login.account.example.invalid.',
      'meaning': 'Die registrierte Domain ist nicht unbedingt das erste vertraut wirkende Wort in der Adresse. Angreifer können Markennamen in Subdomains platzieren, die sie kontrollieren.',
      'action': 'Lies den Hostnamen von rechts nach links und identifiziere die registrierbare Domain. Bestätige sie unabhängig.',
      'limit': 'Lange Subdomain-Ketten haben auch legitime Anwendungsfälle.',
    },
    'message-urgency': {
      'title': 'Dringlichkeit und Druck',
      'signal': 'Eine Nachricht verlangt sofortiges Handeln, droht mit einer Kontosperrung oder setzt eine künstliche Frist.',
      'meaning': 'Zeitdruck kann eine unabhängige Prüfung verhindern und dazu führen, dass Empfänger vorschnell handeln.',
      'action': 'Halte inne. Kontaktiere die Organisation über eine bekannte offizielle App, Website oder Telefonnummer – nicht über die Kontaktdaten in der Nachricht.',
      'limit': 'Dringliche Formulierungen kommen auch in legitimer Kommunikation vor; der Kontext ist entscheidend.',
    },
    'message-credentials': {
      'title': 'Anfrage nach Zugangsdaten oder OTP',
      'signal': 'Ein Absender fragt nach einem Passwort, OTP, Wiederherstellungscode oder der Bestätigung einer unerwarteten Anmeldeaufforderung.',
      'meaning': 'Diese Geheimnisse oder Bestätigungen können einer anderen Person Zugriff auf ein Konto geben oder eine Transaktion autorisieren.',
      'action': 'Gib niemals Passwörter oder OTPs weiter. Lehne unerwartete Bestätigungsaufforderungen ab und kontaktiere den Dienst über seinen offiziellen Kanal.',
      'limit': 'Ein Schlüsselworttreffer erkennt lediglich ein Thema; er stellt weder die Identität des Absenders noch dessen Absicht fest.',
    },
    'message-payment': {
      'title': 'Unerwartete Zahlung oder Rückerstattung',
      'signal': 'Eine Nachricht fordert eine Überweisung, Bearbeitungsgebühr, Rückerstattung oder Zahlung zur Freigabe einer Leistung.',
      'meaning': 'Unerwartete Zahlungsanweisungen können dazu dienen, Geld umzuleiten oder Zahlungsdaten zu erfassen.',
      'action': 'Prüfe Zahlungsempfänger, Betrag und Grund über einen separaten vertrauenswürdigen Kanal, bevor du handelst.',
      'limit': 'Zahlungsbezogene Formulierungen sind auch in gewöhnlichen Rechnungen und Dienstbenachrichtigungen üblich.',
    },
    'qr-payment': {
      'title': 'QR-Zahlungsanforderung',
      'signal': 'Ein QR-Inhalt verwendet ein Zahlungsschema wie upi://pay.',
      'meaning': 'Beim Scannen kann eine Zahlung an einen Empfänger vorausgefüllt werden. Ein QR-Code authentifiziert weder den Zahlungsempfänger noch garantiert er die Richtigkeit des Betrags.',
      'action': 'Prüfe den Empfängernamen, die UPI-ID und den Betrag in deiner Zahlungs-App, bevor du autorisierst. Brich ab, wenn etwas nicht übereinstimmt.',
      'limit': 'Ein Zahlungsinhalt ist nicht automatisch betrügerisch; prüfe die Transaktionsdetails.',
    },
    'qr-action': {
      'title': 'QR-Code mit Aktionslink',
      'signal': 'Ein QR-Inhalt enthält eine Web-, Telefon-, E-Mail-, SMS- oder anwendungsspezifische Aktion.',
      'meaning': 'Der Inhalt kann ein Ziel öffnen oder eine Aktion in einer anderen App vorausfüllen.',
      'action': 'Prüfe zuerst den dekodierten Inhalt. Öffne keine unbekannten Links und bestätige keine vorausgefüllten Aktionen ohne Prüfung.',
      'limit': 'Der Inhaltstyp allein sagt nicht aus, ob die Quelle vertrauenswürdig ist.',
    },
    'account-mfa': {
      'title': 'Unerwartete MFA-Bestätigung',
      'signal': 'Du erhältst eine Anmeldebestätigung oder einen Einmalcode, den du nicht angefordert hast.',
      'meaning': 'Möglicherweise versucht jemand, sich mit deiner Konto-ID und deinem Passwort anzumelden; alternativ wurde der Code versehentlich ausgelöst.',
      'action': 'Lehne die Aufforderung ab, gib den Code nicht weiter, ändere bei Bedarf das Passwort über den offiziellen Dienst und prüfe aktive Sitzungen.',
      'limit': 'Eine unerwartete Aufforderung ist ein Warnsignal, aber keine Bestätigung dafür, dass ein Konto kompromittiert wurde.',
    },
  };

  static IntelligenceEntry localize(IntelligenceEntry entry, String languageCode) {
    if (languageCode != 'de') return entry;
    final values = _entries[entry.id];
    if (values == null) return entry;
    return IntelligenceEntry(
      id: entry.id,
      title: values['title']!,
      category: entry.category,
      signal: values['signal']!,
      meaning: values['meaning']!,
      action: values['action']!,
      limit: values['limit']!,
    );
  }
}
