import '../../features/link_check/domain/url_analyzer.dart';
import '../../features/qr_check/domain/qr_payload_analyzer.dart';

/// German wording for deterministic checker findings. Matching is by stable
/// finding titles so the analyzer remains language-neutral and testable.
class GermanCheckerContent {
  GermanCheckerContent._();

  static const Map<String, ({String title, String detail})> _findings = {
    'Unicode hostname': (title: 'Unicode-Hostname', detail: 'Der Hostname enthält Nicht-ASCII-Zeichen. Prüfe die internationalisierte Domain sorgfältig auf optisch ähnliche Zeichen und bestätige die genaue Schreibweise.'),
    'Unencrypted connection': (title: 'Unverschlüsselte Verbindung', detail: 'Diese Adresse verwendet HTTP. Ausgetauschte Daten sind bei der Übertragung möglicherweise nicht geschützt.'),
    'Embedded sign-in information': (title: 'Eingebettete Anmeldeinformationen', detail: 'Die Adresse enthält Benutzerinformationen vor dem Host. Dadurch kann das angezeigte Ziel irreführend wirken.'),
    'Internationalised domain encoding': (title: 'Kodierte internationalisierte Domain', detail: 'Der Hostname enthält Punycode. Prüfe die angezeigte Domain sorgfältig auf ähnlich aussehende Zeichen.'),
    'IP-address destination': (title: 'IP-Adressen-Ziel', detail: 'Die Adresse verweist direkt auf eine IPv4-Adresse statt auf eine benannte Domain. Das ist nicht grundsätzlich schädlich, sollte aber überprüft werden.'),
    'Malformed IPv4-looking hostname': (title: 'Fehlerhaft wirkender IPv4-Hostname', detail: 'Der Hostname ähnelt einer IPv4-Adresse mit Punkten, enthält aber ein Oktett außerhalb des zulässigen Bereichs. Gehe nicht davon aus, dass er zum beabsichtigten Ziel führt.'),
    'Unusual numeric hostname': (title: 'Ungewöhnlicher numerischer Hostname', detail: 'Der Hostname ist numerisch, entspricht aber keiner üblichen IPv4-Adresse mit vier Oktetten. Manche Clients können ungewöhnliche numerische Formen unterschiedlich interpretieren.'),
    'Long subdomain chain': (title: 'Lange Subdomain-Kette', detail: 'Der Hostname enthält mehrere Subdomain-Ebenen. Prüfe die registrierbare Domain sorgfältig; ein vertrauter Markenname in einer Subdomain belegt nicht, wer das Ziel kontrolliert.'),
    'Non-standard port': (title: 'Nicht standardmäßiger Port', detail: 'Die Adresse verwendet Port {port} statt des üblichen HTTP- oder HTTPS-Ports.'),
    'Fragment present': (title: 'URL-Fragment vorhanden', detail: 'Die Adresse enthält ein Fragment. Es gehört zur angegebenen URL und kann die Seite oder das clientseitige Routing beeinflussen.'),
    'No structural warning detected': (title: 'Keine strukturelle Warnung erkannt', detail: 'Die Adresse hat diese grundlegenden lokalen Prüfungen bestanden. Das belegt nicht, dass die Website vertrauenswürdig oder sicher ist.'),
    'Address not analysed': (title: 'Adresse nicht analysiert', detail: 'Die Webadresse konnte nicht analysiert werden. Prüfe die Eingabe und versuche es erneut.'),
    'Urgency or pressure language': (title: 'Dringliche oder druckausübende Formulierungen', detail: 'Die Nachricht verwendet Zeitdruck oder fordert sofortiges Handeln. Halte inne und prüfe die Anfrage über einen separaten, vertrauenswürdigen Kanal.'),
    'Credential or sign-in request': (title: 'Anfrage nach Zugangsdaten oder Anmeldung', detail: 'Der Text scheint ein Passwort, eine Anmeldung oder eine Kontoverifizierung anzufordern. Gib keine Zugangsdaten über einen Nachrichtenlink ein.'),
    'OTP or authentication-code reference': (title: 'Hinweis auf OTP oder Authentifizierungscode', detail: 'Ein Einmalpasswort oder Authentifizierungscode wird erwähnt. Gib niemals OTPs, Wiederherstellungscodes oder Bestätigungsaufforderungen an andere Personen weiter.'),
    'Payment or financial action': (title: 'Zahlung oder finanzielle Handlung', detail: 'Die Nachricht bezieht sich auf eine Zahlung, Überweisung, Rückerstattung, Gebühr oder andere finanzielle Handlung. Bestätige Empfänger und Betrag unabhängig, bevor du fortfährst.'),
    'Prize or unexpected reward': (title: 'Gewinn oder unerwartete Belohnung', detail: 'Ein unerwarteter Gewinn oder eine Belohnung wird erwähnt. Sei vorsichtig bei Forderungen nach Gebühren oder persönlichen Daten zur Einlösung.'),
    'Threat or consequence language': (title: 'Drohung oder angedrohte Konsequenz', detail: 'Die Nachricht droht mit einer Strafe, rechtlichen Schritten, Festnahme oder Zugriffsverlust. Prüfe solche Behauptungen über unabhängig ermittelte Kontaktdaten der genannten Organisation.'),
    'Obfuscated web address detected': (title: 'Verschleierte Webadresse erkannt', detail: 'Die Nachricht enthält einen Link mit einem ersetzten Schema wie hxxp oder hxxps. Behandle ihn als Adresse, die manuell geprüft werden muss; er wurde weder normalisiert noch geöffnet.'),
    'Link or web address detected': (title: 'Link oder Webadresse erkannt', detail: '{count} Webadresse(n) gefunden. Ein sichtbarer Link kann ein anderes Ziel verbergen. Prüfe jede Adresse einzeln, bevor du sie öffnest.'),
    'No listed social-engineering cues detected': (title: 'Keine aufgeführten Social-Engineering-Merkmale erkannt', detail: 'Der Text entsprach keinen der begrenzten Muster dieser Version. Schädliche Nachrichten können trotzdem gewöhnlich wirken oder Formulierungen verwenden, die hier nicht erfasst werden.'),
    'Message not analysed': (title: 'Nachricht nicht analysiert', detail: 'Die Nachricht konnte nicht analysiert werden. Prüfe die Eingabe und versuche es erneut.'),
  };

  static LinkFinding localizeFinding(LinkFinding finding, String languageCode) {
    if (languageCode != 'de') return finding;
    final translated = _findings[finding.title];
    if (translated == null) return finding;
    var detail = translated.detail;
    final portMatch = RegExp(r'port (\d+)').firstMatch(finding.detail);
    final countMatch = RegExp(r'^(\d+) web address').firstMatch(finding.detail);
    if (portMatch != null) detail = detail.replaceAll('{port}', portMatch.group(1)!);
    if (countMatch != null) detail = detail.replaceAll('{count}', countMatch.group(1)!);
    return LinkFinding(title: translated.title, detail: detail, severity: finding.severity);
  }

  static String localizeLinkNotice(String notice, String languageCode) {
    if (languageCode != 'de') return notice;
    return notice == 'No network request was made.'
        ? 'Es wurde keine Netzwerkanfrage gestellt.'
        : 'Es wurden ausschließlich lokale Strukturprüfungen durchgeführt. Es erfolgte keine Netzwerkanfrage und keine Reputationsabfrage.';
  }

  static String localizeMessageNotice(String languageCode) => languageCode == 'de'
      ? 'Nur heuristische Textprüfungen. Es wurde keine Nachricht hochgeladen, kein Link geöffnet und weder die Identität des Absenders noch seine Absicht überprüft.'
      : 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.';

  static QrPayloadAnalysis localizeQr(QrPayloadAnalysis result, String languageCode) {
    if (languageCode != 'de') return result;
    const titles = <String, String>{
      'Wi-Fi configuration': 'WLAN-Konfiguration',
      'Contact card': 'Kontaktkarte',
      'Calendar event': 'Kalenderereignis',
      'UPI payment request': 'UPI-Zahlungsanforderung',
      'Phone call action': 'Telefonaktion',
      'Email action': 'E-Mail-Aktion',
      'Text-message action': 'SMS-Aktion',
      'Location coordinates': 'Standortkoordinaten',
      'Application-specific link': 'Anwendungsspezifischer Link',
      'Plain text': 'Klartext',
      'Web address': 'Webadresse',
      'Unrecognised web address': 'Nicht erkannte Webadresse',
      'QR content not analysed': 'QR-Inhalt nicht analysiert',
    };
    const details = <String, String>{
      'Wi-Fi configuration': 'Dieser QR-Inhalt kann einen Netzwerknamen, Sicherheitstyp und ein WLAN-Passwort enthalten. Prüfe das Netzwerk vor dem Beitritt; ORVIKA verbindet sich nicht automatisch.',
      'Contact card': 'Dieser Inhalt enthält Kontaktdaten. Prüfe Namen, Telefonnummern, E-Mail-Adressen und Organisationsangaben, bevor du sie speicherst.',
      'Calendar event': 'Dieser Inhalt beschreibt einen Kalendereintrag. Prüfe Titel, Ort, Zeitangaben und eingebettete Links, bevor du ihn importierst.',
      'UPI payment request': 'Dieser QR-Inhalt kann eine Zahlung in einer UPI-App vorbereiten. Prüfe UPI-ID, Empfängername und Betrag unabhängig. ORVIKA leitet keine Zahlung ein und autorisiert sie nicht.',
      'Phone call action': 'Dieser Inhalt enthält eine Telefonaktion. Prüfe die Nummer unabhängig; ORVIKA tätigt keinen Anruf.',
      'Email action': 'Dieser Inhalt kann einen E-Mail-Empfänger oder Nachrichtentext vorausfüllen. Prüfe alle Felder vor dem Senden; ORVIKA öffnet keine E-Mail-App.',
      'Text-message action': 'Dieser Inhalt kann Empfänger oder Nachricht vorausfüllen. Prüfe Nummer und Text vor dem Senden; ORVIKA versendet keine SMS.',
      'Location coordinates': 'Dieser Inhalt enthält einen Standortverweis. Prüfe Koordinaten und Kontext vor der Verwendung; ORVIKA öffnet keine Karte.',
      'Application-specific link': 'Dieser Inhalt verwendet das Schema „{scheme}:“ statt einer üblichen Web-URL. Er kann eine App starten oder eine Aktion auslösen. Öffne ihn nur, wenn du der Quelle unabhängig vertraust.',
      'Plain text': 'Dieser QR-Inhalt enthält Text statt einer erkannten Webadresse oder Aktion. Prüfe ihn sorgfältig; auch Text kann irreführende Anweisungen oder vertrauliche Informationen enthalten.',
      'Web address': 'Ein Webziel wurde erkannt. Prüfe die strukturellen Hinweise unten, bevor du entscheidest, was zu tun ist. Das Ziel wurde weder geöffnet noch kontaktiert.',
      'Unrecognised web address': 'Die Webadresse wurde nicht erkannt. Prüfe die enthaltenen Hinweise, bevor du fortfährst.',
      'QR content not analysed': 'Der QR-Inhalt wurde nicht analysiert. Prüfe die Eingabe und versuche es erneut.',
    };
    var detail = details[result.title] ?? result.detail;
    final schemeMatch = RegExp(r'"([^"]+):"').firstMatch(result.detail);
    if (schemeMatch != null) detail = detail.replaceAll('{scheme}', schemeMatch.group(1)!);
    return QrPayloadAnalysis(
      kind: result.kind,
      title: titles[result.title] ?? result.title,
      detail: detail,
      severity: result.severity,
      normalizedUrl: result.normalizedUrl,
      linkFindings: result.linkFindings.map((finding) => localizeFinding(finding, languageCode)).toList(growable: false),
      isValid: result.isValid,
    );
  }
}
