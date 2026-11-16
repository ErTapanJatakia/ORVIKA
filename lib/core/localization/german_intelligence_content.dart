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
    'url-shortener': {'title': 'Verkürztes oder verschleiertes Ziel', 'signal': 'Ein Link verwendet einen URL-Kürzungsdienst oder verbirgt das endgültige Ziel hinter einer Weiterleitung.', 'meaning': 'Die sichtbare Adresse zeigt nicht die Website, die Sie letztlich erreichen. Weiterleitungsketten können ein unerwartetes Ziel verschleiern.', 'action': 'Verlassen Sie sich nicht auf den verkürzten Text. Verwenden Sie eine vertrauenswürdige Vorschau oder rufen Sie die Organisation unabhängig auf; öffnen Sie keine unaufgefordert zugesandten Kurzlinks.', 'limit': 'URL-Kürzungsdienste werden häufig auch für legitime Kampagnen und Dienste verwendet.'},
    'url-lookalike': {'title': 'Ähnlich geschriebene Domain', 'signal': 'Eine Domain ersetzt, ergänzt oder entfernt Zeichen, um einer bekannten Organisation zu ähneln.', 'meaning': 'Kleine Schreibunterschiede, zusätzliche Wörter oder vertauschte Zeichen können eine von Angreifern kontrollierte Domain vertraut erscheinen lassen.', 'action': 'Vergleiche die vollständige registrierbare Domain Zeichen für Zeichen mit einer unabhängig bezogenen Adresse.', 'limit': 'Ein ähnlich aussehender Name ist ein Anlass zur Prüfung, kein Beweis für bösartige Inhaberschaft.'},
    'url-download': {'title': 'Unerwarteter Dateidownload', 'signal': 'Eine Website oder Nachricht fordert unerwartet zum Herunterladen einer ausführbaren Datei, eines Skripts, Archivs oder mobilen App-Pakets auf.', 'meaning': 'Eine heruntergeladene Datei kann Software installieren, übermäßige Berechtigungen anfordern oder eine verwundbare Anwendung ausnutzen.', 'action': 'Führen Sie unerwartete Dateien nicht aus. Beziehen Sie Software über den vertrauenswürdigen Store der Plattform oder die unabhängig verifizierte Website des Herausgebers.', 'limit': 'Legitime Software wird ebenfalls als Datei verteilt; prüfen Sie Herausgeber, Quelle und Integrität.'},
    'url-certificate': {'title': 'HTTPS-Zertifikatswarnung', 'signal': 'Der Browser meldet ein ungültiges, abgelaufenes, nicht passendes oder nicht vertrauenswürdiges Website-Zertifikat.', 'meaning': 'Der Browser kann für diesen Hostnamen keine erwartete authentifizierte verschlüsselte Verbindung herstellen.', 'action': 'Brechen Sie ab und umgehen Sie die Warnung nicht, um Zugangsdaten oder Zahlungsdaten einzugeben. Prüfen Sie die Adresse und versuchen Sie es später erneut.', 'limit': 'Zertifikatsfehler können durch Fehlkonfiguration oder eine falsche Geräteuhr entstehen; sie zeigen nicht die Ursache.'},
    'url-permission': {'title': 'Unerwartete Browser-Berechtigungsanfrage', 'signal': 'Eine Website fordert unerwartet Zugriff auf Benachrichtigungen, Kamera, Mikrofon, Standort oder Dateien an.', 'meaning': 'Eine Berechtigung kann sensible Gerätefunktionen offenlegen oder dauerhaft unerwünschte Benachrichtigungen ermöglichen.', 'action': 'Lehnen Sie für die Aufgabe unnötige Berechtigungen ab. Prüfen und widerrufen Sie Website-Berechtigungen in den Browsereinstellungen.', 'limit': 'Einige legitime Dienste benötigen Berechtigungen für bestimmte Funktionen; prüfen Sie Zweck und Herkunft.'},
    'message-secrecy': {'title': 'Aufforderung zu Geheimhaltung oder Isolation', 'signal': 'Ein Absender fordert Sie auf, eine Anfrage nicht mit Familie, Kollegen, Ihrer Bank oder der betroffenen Organisation zu besprechen.', 'meaning': 'Isolation kann eine zweite Meinung verhindern und Identitätsmissbrauch oder Zahlungsdruck wirksamer machen.', 'action': 'Halten Sie inne und prüfen Sie die Anfrage unabhängig. Ein legitimer Vorgang sollte einer angemessenen Überprüfung standhalten.', 'limit': 'Vertraulichkeitsbitten können in manchen Situationen legitim sein; Dringlichkeit und Handlung sind entscheidend.'},
    'message-remote-access': {'title': 'Aufforderung zu Fernzugriff oder Bildschirmfreigabe', 'signal': 'Ein Absender fordert Sie auf, Fernwartungssoftware zu installieren, den Bildschirm freizugeben oder Gerätesteuerung zu erlauben.', 'meaning': 'Fernzugriff kann Nachrichten, Banking-Sitzungen, Authentifizierungscodes und Dateien offenlegen oder Handlungen in Ihrem Namen ermöglichen.', 'action': 'Installieren oder gewähren Sie auf unaufgeforderte Bitte keinen Zugriff. Kontaktieren Sie die Organisation über einen separat verifizierten Kanal.', 'limit': 'Fernwartung ist legitim, wenn Sie den Support eines vertrauenswürdigen Anbieters selbst anfordern.'},
    'message-gift-card': {'title': 'Zahlung mit Geschenkkarten oder Kryptowährung', 'signal': 'Eine Nachricht verlangt Geschenkkartencodes, Kryptowährung, Gutscheine oder eine andere schwer rückgängig zu machende Zahlung.', 'meaning': 'Diese Zahlungsmethoden lassen sich nach einer Übertragung nur schwer oder gar nicht zurückholen.', 'action': 'Kaufen oder übertragen Sie unter Druck keine Codes oder Kryptowährungen. Prüfen Sie die Anfrage über einen bekannten Kanal beim angeblichen Absender.', 'limit': 'Diese Zahlungsmethoden haben legitime Verwendungszwecke; bedenklich sind die unaufgeforderte Forderung und der Kontext.'},
    'message-secrets': {'title': 'Anfrage nach sensiblen Identitäts- oder Bankdaten', 'signal': 'Eine Nachricht verlangt den Kartenprüfcode, eine vollständige Ausweisnummer, Kontozugangsdaten oder Ausweiskopien.', 'meaning': 'Solche Angaben können Kontoübernahmen, Identitätsmissbrauch oder nicht autorisierte Transaktionen ermöglichen.', 'action': 'Senden Sie sensible Angaben nicht als Antwort oder im Chat. Nutzen Sie nur einen verifizierten offiziellen Prozess, den Sie selbst begonnen haben.', 'limit': 'Manche regulierten Vorgänge erfordern Identitätsprüfungen; prüfen Sie Kanal und Notwendigkeit vor der Weitergabe.'},
    'qr-wifi': {'title': 'QR-Code mit WLAN-Zugangsdaten', 'signal': 'Ein dekodierter QR-Inhalt enthält einen WLAN-Netzwerknamen und ein Passwort.', 'meaning': 'Beim Verbinden kann Ihr Gerät einem Netzwerk beitreten, das von einer anderen Person kontrolliert wird; die Risiken hängen von dessen Konfiguration ab.', 'action': 'Verbinden Sie sich nur mit vertrauenswürdigen Netzwerken. Vermeiden Sie sensible Aktivitäten in unbekannten Netzen und nutzen Sie die Sicherheitsfunktionen Ihres Geräts.', 'limit': 'WLAN-QR-Codes sind eine übliche Komfortfunktion und nicht grundsätzlich bösartig.'},
    'qr-contact': {'title': 'QR-Code mit Kontakt- oder Nachrichtenaktion', 'signal': 'Ein QR-Inhalt enthält eine vCard, Telefonnummer, E-Mail-Adresse oder vorausgefüllte SMS.', 'meaning': 'Beim Importieren oder Aktivieren können Kontakte hinzugefügt oder Nachrichten an ein nicht geprüftes Ziel vorbereitet werden.', 'action': 'Prüfen Sie angezeigten Namen, Nummer, Adresse und Nachricht, bevor Sie etwas speichern oder senden.', 'limit': 'Kontakt-QR-Codes werden häufig legitim genutzt; prüfen Sie die Angaben vor einer Aktion.'},
    'account-recovery': {'title': 'Unerwartete Kontowiederherstellung', 'signal': 'Sie erhalten unerwartet eine Passwortzurücksetzung, eine Anfrage nach Wiederherstellungscodes oder eine Meldung über geänderte Wiederherstellungsdaten.', 'meaning': 'Jemand versucht möglicherweise, auf ein Konto zuzugreifen oder es zu übernehmen; die Meldung kann auch unerwünschter Spam sein.', 'action': 'Geben Sie keine Wiederherstellungscodes weiter. Öffnen Sie den Dienst über die offizielle App oder ein vertrauenswürdiges Lesezeichen, prüfen Sie Aktivitäten und sichern Sie Wiederherstellungswege.', 'limit': 'Eine Benachrichtigung allein bestätigt keine erfolgreiche Kontoübernahme.'},
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
