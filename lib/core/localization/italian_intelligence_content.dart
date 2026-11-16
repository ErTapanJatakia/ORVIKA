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
    'url-shortener': {'title': 'Destinazione abbreviata o nascosta', 'signal': 'Un collegamento usa un servizio di abbreviazione URL o nasconde la destinazione finale dietro un reindirizzamento.', 'meaning': 'L’indirizzo visibile non mostra il sito che raggiungerai. Le catene di reindirizzamento possono nascondere una destinazione imprevista.', 'action': 'Non fidarti del testo abbreviato. Usa un’anteprima affidabile o raggiungi autonomamente il sito dell’organizzazione; evita i link abbreviati non richiesti.', 'limit': 'I servizi di abbreviazione URL sono ampiamente usati anche per campagne e servizi legittimi.'},
    'url-lookalike': {'title': 'Ortografia di dominio simile', 'signal': 'Un dominio sostituisce, aggiunge o rimuove caratteri per assomigliare a un’organizzazione conosciuta.', 'meaning': 'Piccole differenze ortografiche, parole aggiuntive o caratteri scambiati possono far sembrare familiare un dominio controllato da un aggressore.', 'action': 'Confronta carattere per carattere l’intero dominio registrabile con un indirizzo ottenuto in modo indipendente.', 'limit': 'Un nome simile è un motivo per verificare, non una prova di proprietà malevola.'},
    'url-download': {'title': 'Download di file imprevisto', 'signal': 'Un sito o un messaggio richiede inaspettatamente di scaricare un eseguibile, uno script, un archivio o un pacchetto di un’app mobile.', 'meaning': 'Un file scaricato può installare software, richiedere autorizzazioni eccessive o sfruttare un’applicazione vulnerabile.', 'action': 'Non eseguire file inattesi. Ottieni il software dallo store affidabile della piattaforma o dal sito dell’editore verificato in modo indipendente.', 'limit': 'Anche i software legittimi sono distribuiti come file scaricabili; verifica editore, fonte e integrità.'},
    'url-certificate': {'title': 'Avviso sul certificato HTTPS', 'signal': 'Il browser segnala un certificato del sito non valido, scaduto, non corrispondente o non attendibile.', 'meaning': 'Il browser non riesce a stabilire la connessione crittografata e autenticata prevista con quel nome host.', 'action': 'Fermati e non ignorare l’avviso per inserire credenziali o dati di pagamento. Controlla l’indirizzo e riprova più tardi.', 'limit': 'Gli errori del certificato possono dipendere da configurazione errata o dall’orologio del dispositivo; non ne identificano la causa.'},
    'url-permission': {'title': 'Richiesta inattesa di autorizzazione del browser', 'signal': 'Un sito chiede inaspettatamente accesso a notifiche, fotocamera, microfono, posizione o file.', 'meaning': 'Un’autorizzazione può esporre funzionalità sensibili del dispositivo o attivare notifiche persistenti indesiderate.', 'action': 'Nega le autorizzazioni non necessarie per l’attività. Controlla e revoca le autorizzazioni del sito nelle impostazioni del browser.', 'limit': 'Alcuni servizi legittimi richiedono autorizzazioni per funzioni specifiche; valuta scopo e origine.'},
    'message-secrecy': {'title': 'Richiesta di segretezza o isolamento', 'signal': 'Un mittente ti dice di non parlare della richiesta con familiari, colleghi, banca o organizzazione interessata.', 'meaning': 'L’isolamento può impedire un secondo parere e rendere più efficaci l’impersonificazione o la pressione per un pagamento.', 'action': 'Fermati e verifica la richiesta in modo indipendente. Una procedura legittima dovrebbe tollerare una verifica ragionevole.', 'limit': 'Le richieste di riservatezza possono essere legittime in alcuni contesti; contano urgenza e azione richiesta.'},
    'message-remote-access': {'title': 'Esca per accesso remoto o condivisione schermo', 'signal': 'Un mittente chiede di installare software di assistenza remota, condividere lo schermo o consentire il controllo del dispositivo.', 'meaning': 'L’accesso remoto può esporre messaggi, sessioni bancarie, codici di autenticazione e file, oppure consentire azioni per tuo conto.', 'action': 'Non installare software né concedere accesso in seguito a richieste non sollecitate. Contatta l’organizzazione tramite un canale verificato separatamente.', 'limit': 'Gli strumenti di assistenza remota hanno usi legittimi quando avvii autonomamente il supporto con un fornitore fidato.'},
    'message-gift-card': {'title': 'Pagamento con carte regalo o criptovaluta', 'signal': 'Un messaggio richiede codici di carte regalo, criptovaluta, voucher o un altro pagamento difficile da annullare.', 'meaning': 'Questi metodi di pagamento possono essere difficili o impossibili da recuperare dopo il trasferimento.', 'action': 'Non acquistare né trasferire codici o criptovalute sotto pressione. Verifica la richiesta con il presunto mittente tramite un canale noto.', 'limit': 'Questi metodi hanno usi legittimi; il problema è la richiesta non sollecitata e il contesto.'},
    'message-secrets': {'title': 'Richiesta di dati bancari o identificativi sensibili', 'signal': 'Un messaggio chiede il codice di sicurezza della carta, un numero identificativo completo, credenziali dell’account o copie di documenti d’identità.', 'meaning': 'Queste informazioni possono consentire la presa di controllo di account, l’uso improprio dell’identità o transazioni non autorizzate.', 'action': 'Non inviare dati sensibili in risposta o in chat. Usa solo una procedura ufficiale verificata che hai avviato tu.', 'limit': 'Alcune procedure regolamentate richiedono verifiche d’identità; verifica canale e necessità prima di condividere.'},
    'qr-wifi': {'title': 'Codice QR con credenziali Wi-Fi', 'signal': 'Il contenuto decodificato di un QR include il nome di una rete Wi-Fi e la password.', 'meaning': 'La connessione può collegare il dispositivo a una rete controllata da altri; i rischi dipendono dalla configurazione.', 'action': 'Connettiti solo a reti fidate. Evita attività sensibili su reti sconosciute e usa le protezioni del dispositivo.', 'limit': 'I QR Wi-Fi sono una comodità comune e non sono intrinsecamente dannosi.'},
    'qr-contact': {'title': 'Codice QR con azione di contatto o messaggio', 'signal': 'Un payload QR contiene una vCard, un numero di telefono, un indirizzo email o un SMS precompilato.', 'meaning': 'L’importazione o l’attivazione può aggiungere un contatto o preparare una comunicazione verso una destinazione non verificata.', 'action': 'Controlla nome, numero, indirizzo e messaggio visualizzati prima di salvare o inviare qualsiasi cosa.', 'limit': 'I QR per i contatti sono usati comunemente per condivisioni legittime; verifica i dettagli prima di agire.'},
    'account-recovery': {'title': 'Attività inattesa di recupero account', 'signal': 'Ricevi senza averlo richiesto un avviso di reimpostazione password, una richiesta di codice di recupero o una notifica di modifica dei dati di recupero.', 'meaning': 'Qualcuno potrebbe tentare di accedere a un account o prenderne il controllo; la notifica potrebbe anche essere spam.', 'action': 'Non condividere codici di recupero. Apri il servizio tramite l’app ufficiale o un segnalibro fidato, controlla l’attività e proteggi i metodi di recupero.', 'limit': 'Una notifica da sola non conferma che l’account sia stato compromesso.'},
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
