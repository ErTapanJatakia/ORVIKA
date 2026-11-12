import '../../features/academy/domain/academy_curriculum.dart';

/// German lesson copy keyed by stable curriculum IDs.
class GermanAcademyContent {
  GermanAcademyContent._();

  static const Map<String, Map<String, Object>> _lessons = {
    'verify_sender': {
      'title': 'Prüfe den Absender, nicht den Anzeigenamen',
      'summary': 'Namen, Logos und Profilbilder lassen sich leicht kopieren. Prüfe die tatsächliche Adresse, Telefonnummer oder Konto-ID, bevor du einer Anfrage vertraust.',
      'keyPoints': [
        'Öffne die Absenderdetails und prüfe die vollständige E-Mail-Adresse oder Konto-ID.',
        'Kontaktiere die Person oder Organisation bei unerwarteten Anfragen über einen bereits bekannten, vertrauenswürdigen Kanal.',
        'Ein vertrauter Name oder ein Logo ist kein Identitätsnachweis.',
      ],
      'question': 'Eine Nachricht scheint von deiner Bank zu stammen und fordert dich zu sofortigem Handeln auf. Was ist der sicherste erste Schritt?',
      'options': [
        'Antworte und bitte den Absender um Bestätigung',
        'Nutze unabhängig die Banking-App oder einen bekannten offiziellen Kontaktweg',
        'Vertraue der Nachricht, weil das Logo korrekt aussieht',
      ],
      'explanation': 'Nutze einen Kontaktweg, den du unabhängig ermittelst. Verlasse dich nicht auf Links oder Telefonnummern aus der unerwarteten Nachricht.',
    },
    'phishing_links': {
      'title': 'Prüfe Links vor dem Öffnen',
      'summary': 'Ein Link kann eine vertrauenswürdige Marke imitieren und dich trotzdem auf eine fremde oder irreführende Domain führen.',
      'keyPoints': [
        'Ermittle die registrierte Domain von rechts nach links; zusätzliche Subdomains können das Ziel verschleiern.',
        'Achte auf Tippfehler, ähnlich aussehende Zeichen, unerwartete Kurzlinks und irreführenden Linktext.',
        'Nutze im Zweifel ein gespeichertes Lesezeichen oder gib die bekannte Adresse selbst ein.',
      ],
      'question': 'Eine Nachricht zeigt „example.com“, der tatsächliche Link führt aber zu example-login.security-check.invalid. Was solltest du tun?',
      'options': [
        'Öffne den Link, weil der sichtbare Text vertraut wirkt',
        'Meide den Link und rufe den Dienst über seinen bekannten offiziellen Weg auf',
        'Öffne ihn in einem privaten Browserfenster',
      ],
      'explanation': 'Der sichtbare Linktext kann vom tatsächlichen Ziel abweichen. Privates Surfen macht ein schädliches Ziel nicht sicher.',
    },
    'otp_secrecy': {
      'title': 'Halte OTPs und Wiederherstellungscodes geheim',
      'summary': 'Einmalpasswörter, Anmeldebestätigungen und Wiederherstellungscodes können anderen Zugriff auf dein Konto ermöglichen.',
      'keyPoints': [
        'Gib OTPs oder Wiederherstellungscodes niemals an Anrufer, Chatkontakte oder vermeintliche Supportmitarbeiter weiter.',
        'Bestätige keine Anmeldeaufforderung, die du nicht selbst ausgelöst hast.',
        'Wenn du einen Code weitergegeben hast, sichere das Konto umgehend über den offiziellen Dienst.',
      ],
      'question': 'Jemand gibt sich als Support aus und verlangt ein OTP, um eine Transaktion zu stornieren. Was solltest du tun?',
      'options': [
        'Teile es mit, wenn die Person deinen Namen kennt',
        'Teile nur die erste Hälfte',
        'Gib es nicht weiter, beende den Kontakt und nutze den offiziellen Dienstkanal',
      ],
      'explanation': 'Ein OTP ist ein Authentifizierungsgeheimnis. Ein legitimer Supportkontakt sollte nicht verlangen, dass du es offenlegst.',
    },
    'mfa_fatigue': {
      'title': 'Erkenne unerwartete MFA-Aufforderungen',
      'summary': 'Wiederholte oder unerwartete Bestätigungsaufforderungen können darauf hindeuten, dass jemand versucht, sich mit deinen Zugangsdaten anzumelden.',
      'keyPoints': [
        'Lehne Aufforderungen ab, die du nicht selbst ausgelöst hast.',
        'Bestätige keine Aufforderung nur, damit wiederholte Benachrichtigungen aufhören.',
        'Ändere bei Verdacht dein Passwort über den offiziellen Dienst und prüfe aktive Sitzungen.',
      ],
      'question': 'Dein Telefon erhält mehrere Anmeldebestätigungen, obwohl du dich nicht anmeldest. Wie reagierst du sicher?',
      'options': [
        'Lehne sie ab und prüfe das Konto über die offiziellen Einstellungen',
        'Bestätige eine Aufforderung, damit die Meldungen aufhören',
        'Ignoriere künftig alle Kontowarnungen',
      ],
      'explanation': 'Unerwartete Aufforderungen müssen abgelehnt werden. Prüfe das Konto anschließend von einem vertrauenswürdigen Gerät und über den offiziellen Zugang.',
    },
    'payment_pressure': {
      'title': 'Halte vor dringenden Zahlungen inne',
      'summary': 'Betrüger nutzen Zeitdruck, Geheimhaltung und Autorität, um Menschen zu Überweisungen, Geschenkkarten oder Zahlungsfreigaben zu drängen.',
      'keyPoints': [
        'Behandle kurzfristige Änderungen von Bankdaten und dringende Überweisungsanfragen als hohes Risiko.',
        'Bestätige Zahlungsanweisungen beim Empfänger über eine zuvor bekannte Telefonnummer.',
        'Lass dich von Anrufern nicht dazu drängen, normale Freigabekontrollen zu umgehen.',
      ],
      'question': 'Ein Lieferant sendet neue Bankdaten per E-Mail und verlangt die Zahlung innerhalb von zehn Minuten. Was solltest du tun?',
      'options': [
        'Sofort zahlen, um eine Verspätungsgebühr zu vermeiden',
        'Die Änderung über eine zuvor bekannte Kontaktnummer bestätigen',
        'Auf dieselbe E-Mail antworten und fragen, ob sie echt ist',
      ],
      'explanation': 'Bestätige Änderungen bei Zahlungen unabhängig. Eine Antwort auf denselben möglicherweise kompromittierten E-Mail-Verlauf ist keine unabhängige Prüfung.',
    },
    'qr_safety': {
      'title': 'Behandle QR-Codes wie Links',
      'summary': 'Ein QR-Code kann eine Website, Zahlungsanforderung, Kontaktaktion oder andere Daten enthalten. Das Scannen macht ihn nicht vertrauenswürdig.',
      'keyPoints': [
        'Zeige das dekodierte Ziel oder die Zahlungsdetails an, bevor du fortfährst.',
        'Prüfe Empfänger und Betrag sorgfältig, bevor du eine Zahlung autorisierst.',
        'Sei vorsichtig, wenn ein QR-Aufkleber über einem erwarteten Code angebracht wurde.',
      ],
      'question': 'Ein QR-Code öffnet eine Zahlungsmaske. Was solltest du vor einer Freigabe prüfen?',
      'options': [
        'Nur, ob das QR-Bild professionell aussieht',
        'Empfänger, Betrag und Zweck anhand einer vertrauenswürdigen Quelle',
        'Ob der Code schnell gescannt wurde',
      ],
      'explanation': 'Ein QR-Code ist lediglich eine praktische Möglichkeit, Daten zu übertragen. Prüfe die tatsächlichen Transaktionsdetails vor der Freigabe.',
    },
    'device_updates': {
      'title': 'Halte Geräte und Apps aktuell',
      'summary': 'Sicherheitsupdates beheben bekannte Schwachstellen. Verzögerungen können Geräte Risiken aussetzen, für die bereits Korrekturen verfügbar sind.',
      'keyPoints': [
        'Installiere Betriebssystem- und App-Updates über die offiziellen Aktualisierungsmechanismen.',
        'Entferne nicht mehr verwendete Apps und prüfe Berechtigungen regelmäßig.',
        'Halte ein wiederherstellbares Backup bereit und schütze das Gerät mit einer Bildschirmsperre.',
      ],
      'question': 'Ein App-Update ist im offiziellen App-Store deines Geräts verfügbar. Was ist die sicherere Vorgehensweise?',
      'options': [
        'Installiere Updates zeitnah, nachdem du die Quelle geprüft hast',
        'Lade ein zufälliges Paket für ein „schnelleres Update“ aus einer Anzeige herunter',
        'Deaktiviere Updates dauerhaft',
      ],
      'explanation': 'Nutze den offiziellen Aktualisierungsmechanismus der Plattform und halte Software angemessen aktuell.',
    },
    'incident_first_steps': {
      'title': 'Handle schnell bei möglicher Kontoübernahme',
      'summary': 'Eine ruhige, geordnete Reaktion kann weiteren Zugriff begrenzen und wichtige Informationen erhalten.',
      'keyPoints': [
        'Sichere das betroffene Konto von einem vertrauenswürdigen Gerät aus über den offiziellen Dienst.',
        'Ändere wiederverwendete Passwörter, widerrufe unbekannte Sitzungen und aktiviere MFA, sofern verfügbar.',
        'Bewahre relevante Nachrichten und Transaktionsbelege auf. Kontaktiere bei Geldverlust umgehend deine Bank.',
      ],
      'question': 'Du vermutest, dass dein E-Mail-Konto übernommen wurde. Welche Maßnahme ist ein guter erster Schritt?',
      'options': [
        'Lösche sofort jede verdächtige Nachricht',
        'Sichere das Konto über ein vertrauenswürdiges Gerät und den offiziellen Wiederherstellungsweg',
        'Veröffentliche deine Wiederherstellungscodes, um Hilfe zu erhalten',
      ],
      'explanation': 'Sichere das Konto über den offiziellen Wiederherstellungsprozess, prüfe Sitzungen und bewahre Beweise auf, die bei der Untersuchung helfen können.',
    },
  };

  static AcademyLesson localize(AcademyLesson lesson, String languageCode) {
    if (languageCode != 'de') return lesson;
    final values = _lessons[lesson.id];
    if (values == null) return lesson;
    return AcademyLesson(
      id: lesson.id,
      title: values['title']! as String,
      category: lesson.category,
      summary: values['summary']! as String,
      keyPoints: List<String>.unmodifiable(values['keyPoints']! as List<String>),
      question: values['question']! as String,
      options: List<String>.unmodifiable(values['options']! as List<String>),
      correctIndex: lesson.correctIndex,
      explanation: values['explanation']! as String,
    );
  }
}
