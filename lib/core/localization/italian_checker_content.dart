import '../../features/link_check/domain/url_analyzer.dart';
import '../../features/qr_check/domain/qr_payload_analyzer.dart';

/// Italian wording for deterministic checker findings. Analyzer identifiers
/// remain canonical English so detection logic is language-neutral.
class ItalianCheckerContent {
  ItalianCheckerContent._();

  static const Map<String, ({String title, String detail})> _findings = {
    'Unicode hostname': (title: 'Nome host Unicode', detail: 'Il nome host contiene caratteri non ASCII. Controlla attentamente il dominio internazionalizzato per individuare caratteri visivamente simili e verificarne l’esatta grafia.'),
    'Unencrypted connection': (title: 'Connessione non crittografata', detail: 'Questo indirizzo usa HTTP. I dati scambiati potrebbero non essere protetti durante la trasmissione.'),
    'Embedded sign-in information': (title: 'Credenziali incorporate nell’indirizzo', detail: 'L’indirizzo contiene informazioni utente prima del nome host. Questo può rendere fuorviante la destinazione visualizzata.'),
    'Internationalised domain encoding': (title: 'Dominio internazionalizzato codificato', detail: 'Il nome host contiene Punycode. Controlla attentamente il dominio visualizzato per individuare caratteri simili.'),
    'IP-address destination': (title: 'Destinazione con indirizzo IP', detail: 'L’indirizzo punta direttamente a un indirizzo IPv4 anziché a un dominio denominato. Non è necessariamente dannoso, ma va verificato.'),
    'Malformed IPv4-looking hostname': (title: 'Nome host simile a un IPv4 non valido', detail: 'Il nome host assomiglia a un indirizzo IPv4 separato da punti, ma contiene un ottetto fuori dall’intervallo consentito. Non presumere che conduca alla destinazione prevista.'),
    'Unusual numeric hostname': (title: 'Nome host numerico insolito', detail: 'Il nome host è numerico, ma non corrisponde a un normale indirizzo IPv4 composto da quattro ottetti. Alcuni client possono interpretare in modo diverso le forme numeriche insolite.'),
    'Long subdomain chain': (title: 'Catena di sottodomini lunga', detail: 'Il nome host contiene più livelli di sottodomini. Controlla attentamente il dominio registrabile: la presenza di un marchio noto in un sottodominio non dimostra chi controlli la destinazione.'),
    'Non-standard port': (title: 'Porta non standard', detail: 'L’indirizzo usa la porta {port} anziché la porta HTTP o HTTPS abituale.'),
    'Fragment present': (title: 'Frammento URL presente', detail: 'L’indirizzo contiene un frammento. Fa parte dell’URL fornito e può influire sulla pagina o sul routing lato client.'),
    'No structural warning detected': (title: 'Nessun avviso strutturale rilevato', detail: 'L’indirizzo ha superato questi controlli locali di base. Ciò non dimostra che il sito sia affidabile o sicuro.'),
    'Address not analysed': (title: 'Indirizzo non analizzato', detail: 'Non è stato possibile analizzare l’indirizzo web. Controlla il valore inserito e riprova.'),
    'Urgency or pressure language': (title: 'Linguaggio urgente o pressante', detail: 'Il messaggio crea urgenza o richiede un’azione immediata. Fermati e verifica la richiesta tramite un canale separato e affidabile.'),
    'Credential or sign-in request': (title: 'Richiesta di credenziali o accesso', detail: 'Il testo sembra richiedere una password, l’accesso o la verifica di un account. Non inserire le credenziali tramite un link ricevuto in un messaggio.'),
    'OTP or authentication-code reference': (title: 'Riferimento a OTP o codice di autenticazione', detail: 'Viene menzionata una password monouso o un codice di autenticazione. Non condividere mai OTP, codici di recupero o richieste di approvazione con altre persone.'),
    'Payment or financial action': (title: 'Pagamento o operazione finanziaria', detail: 'Il messaggio riguarda un pagamento, un trasferimento, un rimborso, una commissione o un’altra operazione finanziaria. Verifica in modo indipendente il destinatario e l’importo prima di procedere.'),
    'Prize or unexpected reward': (title: 'Premio o ricompensa inattesa', detail: 'Viene menzionato un premio o una ricompensa inattesa. Diffida delle richieste di commissioni o dati personali per riscuoterla.'),
    'Threat or consequence language': (title: 'Minacce o conseguenze annunciate', detail: 'Il messaggio minaccia una sanzione, un’azione legale, un arresto o la perdita dell’accesso. Verifica tali affermazioni usando recapiti dell’organizzazione ottenuti in modo indipendente.'),
    'Obfuscated web address detected': (title: 'Indirizzo web offuscato rilevato', detail: 'Il messaggio contiene un link con uno schema sostituito, ad esempio hxxp o hxxps. Trattalo come un indirizzo da verificare manualmente: non è stato normalizzato né aperto.'),
    'Link or web address detected': (title: 'Link o indirizzo web rilevato', detail: 'Sono stati trovati {count} indirizzi web. Un link visibile può nascondere una destinazione diversa. Controlla ogni indirizzo separatamente prima di aprirlo.'),
    'No listed social-engineering cues detected': (title: 'Nessun indicatore di ingegneria sociale elencato rilevato', detail: 'Il testo non corrispondeva agli schemi limitati di questa versione. I messaggi dannosi possono comunque sembrare normali o usare formulazioni non rilevate da questi controlli.'),
    'Message not analysed': (title: 'Messaggio non analizzato', detail: 'Non è stato possibile analizzare il messaggio. Controlla il testo inserito e riprova.'),
  };

  static LinkFinding localizeFinding(LinkFinding finding, String languageCode) {
    if (languageCode != 'it') return finding;
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
    if (languageCode != 'it') return notice;
    if (notice == 'No network request was made.') {
      return 'Non è stata effettuata alcuna richiesta di rete.';
    }
    return 'Sono stati eseguiti esclusivamente controlli strutturali locali. Non è stata effettuata alcuna richiesta di rete né alcuna verifica della reputazione.';
  }

  static String localizeMessageNotice(String languageCode) => languageCode == 'it'
      ? 'Solo controlli euristici sul testo. Il messaggio non è stato caricato, nessun link è stato aperto e non sono state verificate né l’identità né le intenzioni del mittente.'
      : 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.';

  static QrPayloadAnalysis localizeQr(QrPayloadAnalysis result, String languageCode) {
    if (languageCode != 'it') return result;
    const titles = <String, String>{
      'Wi-Fi configuration': 'Configurazione Wi-Fi',
      'Contact card': 'Scheda contatto',
      'Calendar event': 'Evento del calendario',
      'UPI payment request': 'Richiesta di pagamento UPI',
      'Phone call action': 'Azione di chiamata',
      'Email action': 'Azione e-mail',
      'Text-message action': 'Azione SMS',
      'Location coordinates': 'Coordinate della posizione',
      'Application-specific link': 'Link specifico per un’applicazione',
      'Plain text': 'Testo semplice',
      'Web address': 'Indirizzo web',
      'Unrecognised web address': 'Indirizzo web non riconosciuto',
      'QR content not analysed': 'Contenuto QR non analizzato',
    };
    const details = <String, String>{
      'Wi-Fi configuration': 'Questo contenuto QR può includere il nome della rete, il tipo di sicurezza e la password Wi-Fi. Verifica la rete prima di connetterti: ORVIKA non si connette automaticamente.',
      'Contact card': 'Questo contenuto include dati di contatto. Verifica nomi, numeri di telefono, indirizzi e-mail e dettagli dell’organizzazione prima di salvarli.',
      'Calendar event': 'Questo contenuto descrive un evento del calendario. Controlla titolo, luogo, orari e link incorporati prima di importarlo.',
      'UPI payment request': 'Questo contenuto QR può predisporre un pagamento in un’app UPI. Verifica in modo indipendente l’ID UPI, il nome del destinatario e l’importo. ORVIKA non avvia né autorizza pagamenti.',
      'Phone call action': 'Questo contenuto include un’azione di chiamata. Verifica il numero in modo indipendente: ORVIKA non effettua chiamate.',
      'Email action': 'Questo contenuto può precompilare un destinatario o il testo di un’e-mail. Controlla tutti i campi prima dell’invio: ORVIKA non apre un’app e-mail.',
      'Text-message action': 'Questo contenuto può precompilare il destinatario o il messaggio. Verifica il numero e il testo prima dell’invio: ORVIKA non invia SMS.',
      'Location coordinates': 'Questo contenuto include un riferimento a una posizione. Verifica le coordinate e il contesto prima di usarlo: ORVIKA non apre mappe.',
      'Application-specific link': 'Questo contenuto usa lo schema “{scheme}:” anziché un normale URL web. Potrebbe avviare un’app o un’azione. Aprilo solo se ti fidi della fonte dopo una verifica indipendente.',
      'Plain text': 'Questo contenuto QR contiene testo anziché un indirizzo web o un’azione riconosciuta. Esaminalo attentamente: anche il testo può contenere istruzioni fuorvianti o informazioni riservate.',
      'Web address': 'È stata rilevata una destinazione web. Verifica il dominio e il percorso prima di aprire il link.',
      'Unrecognised web address': 'Il contenuto sembra un indirizzo web, ma non è stato possibile interpretarlo in modo affidabile. Non aprirlo finché non ne hai verificato la destinazione.',
      'QR content not analysed': 'Non è stato possibile analizzare il contenuto QR. Controlla il codice o l’immagine e riprova.',
    };
    final title = titles[result.title] ?? result.title;
    var detail = details[result.title] ?? result.detail;
    final scheme = RegExp(r'([a-zA-Z][a-zA-Z0-9+.-]*):').firstMatch(result.detail);
    if (scheme != null) detail = detail.replaceAll('{scheme}', scheme.group(1)!);
    return QrPayloadAnalysis(
      title: title,
      detail: detail,
      severity: result.severity,
      kind: result.kind,
      normalizedUrl: result.normalizedUrl,
      linkFindings: result.linkFindings,
      isValid: result.isValid,
    );
  }
}
