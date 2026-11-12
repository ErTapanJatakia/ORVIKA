import '../../features/intelligence/domain/intelligence_library.dart';

/// Italian wording for the curated offline intelligence reference.
class ItalianIntelligenceContent {
  ItalianIntelligenceContent._();

  static const Map<String, Map<String, String>> _entries = {
    'url-http': {
      'title': 'HTTP non crittografato',
      'signal': 'Un indirizzo web inizia con http:// anziché https://.',
      'meaning': 'La connessione non usa TLS per proteggere i dati in transito. Le informazioni scambiate potrebbero essere esposte o modificate sulla rete.',
      'action': 'Evita di inserire password o dati di pagamento. Raggiungi l’organizzazione tramite un segnalibro affidabile o un indirizzo verificato in modo indipendente.',
      'limit': 'HTTPS protegge la connessione; non dimostra che il sito web sia legittimo.',
    },
    'url-userinfo': {
      'title': 'Informazioni utente fuorvianti nell’URL',
      'signal': 'Un URL contiene testo prima del simbolo @, ad esempio https://trusted.example@unknown.example/.',
      'meaning': 'I browser interpretano come nome host il testo dopo il simbolo @. Il testo apparentemente affidabile che lo precede può essere usato per distrarre.',
      'action': 'Leggi il nome host effettivo subito dopo @ e verifica il dominio registrato prima di visitare il sito.',
      'limit': 'Le informazioni utente in un URL sono insolite, ma da sole non dimostrano un intento dannoso.',
    },
    'url-punycode': {
      'title': 'Dominio internazionalizzato / Punycode',
      'signal': 'Un nome host contiene un’etichetta xn-- o caratteri visivamente simili.',
      'meaning': 'I nomi di dominio internazionalizzati possono usare caratteri di sistemi di scrittura diversi che assomigliano alle lettere latine.',
      'action': 'Controlla la grafia esatta e il titolare del dominio tramite una fonte affidabile. Non basarti su un logo o un nome visualizzato familiare.',
      'limit': 'Molti siti legittimi usano nomi di dominio internazionalizzati.',
    },
    'url-subdomains': {
      'title': 'Catena profonda di sottodomini',
      'signal': 'Un nome host contiene molte etichette, ad esempio login.account.example.invalid.',
      'meaning': 'Il dominio registrato non è necessariamente la prima parola familiare nell’indirizzo. Gli aggressori possono inserire nomi di marchi in sottodomini sotto il loro controllo.',
      'action': 'Leggi il nome host da destra verso sinistra e identifica il dominio registrabile. Verificalo in modo indipendente.',
      'limit': 'Le catene lunghe di sottodomini hanno anche usi legittimi.',
    },
    'message-urgency': {
      'title': 'Urgenza e pressione',
      'signal': 'Un messaggio pretende un’azione immediata, minaccia la chiusura dell’account o impone una scadenza artificiale.',
      'meaning': 'La pressione può scoraggiare verifiche indipendenti e spingere il destinatario ad agire senza riflettere.',
      'action': 'Fermati. Contatta l’organizzazione tramite un’app, un sito o un numero ufficiale già noto, non usando i recapiti contenuti nel messaggio.',
      'limit': 'Un linguaggio urgente può comparire anche in comunicazioni legittime: il contesto è importante.',
    },
    'message-credentials': {
      'title': 'Richiesta di credenziali o OTP',
      'signal': 'Un mittente chiede una password, un OTP, un codice di recupero o l’approvazione di una richiesta di accesso inattesa.',
      'meaning': 'Questi segreti o approvazioni possono dare a un’altra persona accesso a un account o autorizzare una transazione.',
      'action': 'Non comunicare mai password o OTP. Rifiuta le richieste di approvazione inattese e contatta il servizio tramite il suo canale ufficiale.',
      'limit': 'Una corrispondenza con parole chiave identifica soltanto un argomento: non stabilisce chi abbia inviato il messaggio né le sue intenzioni.',
    },
    'message-payment': {
      'title': 'Pagamento o rimborso inatteso',
      'signal': 'Un messaggio richiede un trasferimento, una commissione di gestione, un’azione di rimborso o un pagamento per sbloccare un vantaggio.',
      'meaning': 'Istruzioni finanziarie inattese possono essere usate per dirottare fondi o raccogliere dati di pagamento.',
      'action': 'Verifica beneficiario, importo e motivo tramite un canale separato e affidabile prima di agire.',
      'limit': 'Il linguaggio relativo ai pagamenti è comune anche in normali fatture e notifiche di servizio.',
    },
    'qr-payment': {
      'title': 'Richiesta di pagamento tramite QR',
      'signal': 'Un payload QR usa uno schema di pagamento come upi://pay.',
      'meaning': 'La scansione può precompilare un pagamento a favore di un destinatario. Un codice QR non autentica il beneficiario né garantisce che l’importo sia corretto.',
      'action': 'Controlla nome del beneficiario, ID UPI e importo nell’app di pagamento prima di autorizzare. Annulla se qualcosa non coincide.',
      'limit': 'Un payload di pagamento non è intrinsecamente fraudolento: verifica i dettagli della transazione.',
    },
    'qr-action': {
      'title': 'Codice QR con link ad azione',
      'signal': 'Un payload QR contiene un’azione web, telefonica, e-mail, SMS o specifica di un’applicazione.',
      'meaning': 'Il payload può aprire una destinazione o precompilare un’azione quando viene gestito da un’altra app.',
      'action': 'Esamina prima il contenuto decodificato. Non aprire link sconosciuti né approvare azioni precompilate senza verificarle.',
      'limit': 'Il solo tipo di payload non permette di stabilire se la fonte sia affidabile.',
    },
    'account-mfa': {
      'title': 'Approvazione MFA inattesa',
      'signal': 'Ricevi una richiesta di approvazione dell’accesso o un codice monouso che non hai richiesto.',
      'meaning': 'Qualcuno potrebbe tentare di accedere usando l’identificativo e la password del tuo account, oppure il codice potrebbe essere stato generato per errore.',
      'action': 'Rifiuta la richiesta, non condividere il codice, se opportuno cambia la password tramite il servizio ufficiale e controlla le sessioni attive.',
      'limit': 'Una richiesta inattesa è un segnale di allarme, non la conferma che un account sia stato compromesso.',
    },
  };

  static IntelligenceEntry localize(IntelligenceEntry entry, String languageCode) {
    if (languageCode != 'it') return entry;
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
