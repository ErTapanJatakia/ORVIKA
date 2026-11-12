import '../../features/response/domain/response_playbooks.dart';

/// Italian incident-response guidance keyed by stable playbook IDs.
class ItalianResponseContent {
  ItalianResponseContent._();

  static const Map<String, Map<String, Object>> _playbooks = {
    'account-compromise': {
      'title': 'Un account potrebbe essere stato compromesso',
      'summary': 'Noti accessi sconosciuti, dati di recupero modificati, messaggi che non hai inviato o richieste di autenticazione inattese.',
      'firstAction': 'Usa un dispositivo separato e affidabile e raggiungi il servizio tramite l’app o l’indirizzo ufficiale.',
      'steps': [
        'Se potrebbe essere coinvolto, proteggi prima l’account e-mail principale: spesso controlla il ripristino delle password degli altri servizi.',
        'Cambia la password interessata con una password univoca e attiva un metodo MFA robusto, se disponibile.',
        'Controlla indirizzi e-mail e numeri di telefono di recupero, passkey e metodi di autenticazione. Rimuovi quelli sconosciuti.',
        'Disconnetti le sessioni sconosciute e revoca le app collegate o i token di accesso non riconosciuti, se il servizio lo consente.',
        'Controlla regole di inoltro, filtri della casella, messaggi inviati e modifiche recenti all’account.',
        'Se è coinvolto un account di lavoro o scolastico, avvisa tempestivamente il team IT o di sicurezza dell’organizzazione.',
      ],
      'preserve': [
        'Registra e-mail di avviso, orari degli accessi, dettagli di dispositivi e sessioni e notifiche pertinenti dell’account.',
        'Conserva, se disponibili, i messaggi originali e le intestazioni. Annota cosa hai modificato e quando.',
      ],
      'avoid': [
        'Non condividere password, OTP, codici di recupero o link di sessione con chiunque offra aiuto.',
        'Non usare link di recupero o numeri di telefono forniti in un messaggio inatteso.',
        'Non eliminare avvisi potenzialmente pertinenti prima di averne registrato i dettagli.',
      ],
      'limit': 'ORVIKA non può verificare l’accesso a un account, revocare sessioni o recuperare un account. Segui la procedura ufficiale del servizio; passaggi e denominazioni possono variare.',
    },
    'payment-fraud': {
      'title': 'Pagamento sospetto o non autorizzato',
      'summary': 'Hai inviato denaro sotto pressione, approvato un pagamento inatteso, condiviso credenziali di pagamento o rilevato una transazione che non riconosci.',
      'firstAction': 'Contatta immediatamente la banca o il fornitore di pagamento tramite l’app ufficiale, il numero riportato sulla carta o un sito verificato in modo indipendente.',
      'steps': [
        'Chiedi al fornitore di proteggere l’account, la carta, il portafoglio o lo strumento di pagamento interessato e di spiegare le procedure di contestazione o richiamo disponibili.',
        'Segnala la transazione come non autorizzata o indotta da una truffa; fornisci riferimento, importo, data e dati del beneficiario.',
        'Cambia le credenziali bancarie o e-mail esposte da un dispositivo affidabile e controlla sessioni attive e mandati di pagamento.',
        'Se le credenziali o la SIM potrebbero essere compromesse, informa la banca e il relativo operatore mobile.',
        'Usa il canale ufficiale di segnalazione delle autorità competenti nella tua giurisdizione e conserva la ricevuta o il numero del caso.',
      ],
      'preserve': [
        'Conserva ID delle transazioni, notifiche bancarie, ricevute, dati del beneficiario, registri delle chiamate e conversazioni.',
        'Annota quando hai notato il problema e quando hai contattato il fornitore.',
      ],
      'avoid': [
        'Non pagare chi promette il recupero garantito dei fondi persi o richiede una commissione anticipata.',
        'Non approvare ulteriori richieste di pagamento, mandati o sessioni di accesso remoto.',
        'Non usare i recapiti inviati dal presunto truffatore.',
      ],
      'limit': 'Un pagamento potrebbe non essere reversibile. ORVIKA non può bloccare account, tracciare fondi o inviare segnalazioni. Contatta subito il fornitore; canali e scadenze variano.',
    },
    'lost-device': {
      'title': 'Un telefono, computer o altro dispositivo è stato smarrito',
      'summary': 'Un dispositivo è scomparso, è stato rubato o potrebbe essere accessibile a un’altra persona.',
      'firstAction': 'Da un altro dispositivo affidabile, usa il servizio ufficiale del produttore o della piattaforma per la sicurezza dell’account e la localizzazione del dispositivo.',
      'steps': [
        'Se disponibile, contrassegna il dispositivo come smarrito o bloccalo da remoto. Valuta la cancellazione remota in base alla sensibilità dei dati e alle possibilità di recupero.',
        'Contatta l’operatore mobile per sospendere una SIM o eSIM mancante e chiedi come proteggere il numero.',
        'Cambia le password degli account e-mail principali, finanziari e d’identità se il dispositivo potrebbe essere stato sbloccato o contenere credenziali salvate.',
        'Revoca le sessioni dei dispositivi attendibili e controlla i metodi di recupero da un dispositivo separato e affidabile.',
        'Segnala il sospetto furto all’autorità locale competente e segui la procedura aziendale prevista per i dispositivi gestiti.',
      ],
      'preserve': [
        'Conserva il numero di serie, l’IMEI se applicabile, la prova d’acquisto e gli avvisi ufficiali di localizzazione o sicurezza.',
        'Annota quando e dove è stato visto l’ultima volta e quali azioni di blocco o segnalazione hai intrapreso.',
      ],
      'avoid': [
        'Non affrontare né incontrare chi afferma di avere il dispositivo; rivolgiti alle autorità competenti.',
        'Non seguire messaggi che chiedono di disattivare la protezione del dispositivo o rivelare credenziali.',
        'Non presumere che una stima di posizione sia esatta o che agire personalmente sia sicuro.',
      ],
      'limit': 'Localizzazione, blocco e cancellazione remoti dipendono dalla configurazione precedente, dalla connettività e dal supporto della piattaforma. La cancellazione può compromettere prove o possibilità di recupero: valuta la situazione prima di procedere.',
    },
    'suspected-malware': {
      'title': 'Un dispositivo potrebbe contenere malware',
      'summary': 'Visualizzi finestre pop-up inattese, avvisi di sicurezza, app sconosciute, attività insolite dell’account o comportamenti anomali dopo aver aperto un file sospetto.',
      'firstAction': 'Smetti di inserire password o dati di pagamento sul dispositivo interessato. Se sospetti una compromissione attiva, scollegalo dalle reti quando è pratico farlo.',
      'steps': [
        'Usa un dispositivo separato e affidabile per modifiche sensibili agli account e contatta il team di sicurezza dell’organizzazione se il dispositivo è gestito.',
        'Non riaprire il file sospetto e non installare strumenti consigliati da un pop-up o da un chiamante non richiesto.',
        'Usa strumenti di sicurezza integrati o affidabili ottenuti da fonti ufficiali e segui le relative istruzioni documentate.',
        'Aggiorna sistema operativo e applicazioni dopo aver compreso la situazione immediata e quando il dispositivo può essere usato in sicurezza.',
        'Se le credenziali potrebbero essere state esposte, cambiale da un dispositivo separato e affidabile e revoca le sessioni attive.',
        'Per un dispositivo di lavoro o un incidente grave, conserva lo stato del dispositivo e richiedi assistenza qualificata di incident response prima di cancellare o reinstallare.',
      ],
      'preserve': [
        'Registra il testo degli avvisi, i nomi dei file, la fonte di download, gli orari e gli eventuali risultati degli strumenti di sicurezza.',
        'Conserva e-mail, URL e schermate pertinenti; non caricare file sensibili su servizi pubblici di analisi.',
      ],
      'avoid': [
        'Non eseguire script di pulizia casuali, correzioni del registro o download antivirus sconosciuti.',
        'Non ripristinare il dispositivo alle impostazioni di fabbrica né eliminare file prima di valutare le esigenze di prova e recupero.',
        'Non collegare inutilmente unità di backup o altri dispositivi mentre si sospetta una compromissione.',
      ],
      'limit': 'Questi segnali non dimostrano la presenza di malware. ORVIKA non analizza file, processi o dispositivi e non li ripulisce. Gli incidenti gravi o con impatto aziendale richiedono un’analisi qualificata.',
    },
    'identity-exposure': {
      'title': 'Sono stati esposti dati personali o identificativi',
      'summary': 'Documenti d’identità, dati personali, credenziali o registrazioni private potrebbero essere stati divulgati a una persona o a un servizio non affidabile.',
      'firstAction': 'Identifica esattamente quali informazioni sono state esposte e proteggi gli account o i servizi che dipendono da esse.',
      'steps': [
        'Cambia le password esposte e quelle riutilizzate da un dispositivo affidabile; attiva la MFA dove disponibile.',
        'Contatta l’organizzazione emittente tramite un canale verificato in modo indipendente se sono stati esposti documenti d’identità, dati finanziari o credenziali ufficiali.',
        'Chiedi agli istituti finanziari interessati informazioni su monitoraggio, sostituzione, restrizioni dell’account o altre misure di protezione.',
        'Controlla le impostazioni di recupero degli account e presta attenzione agli avvisi di reimpostazione password, credito, transazioni o verifica dell’identità.',
        'Segnala l’esposizione tramite il canale ufficiale per la privacy, l’autorità di controllo o le forze dell’ordine competente nella tua giurisdizione.',
      ],
      'preserve': [
        'Conserva la comunicazione originale sull’esposizione, la corrispondenza pertinente, le date, le categorie di dati coinvolte e i riferimenti del caso.',
        'Registra chi è stato informato e quali indicazioni o misure di protezione ha fornito.',
      ],
      'avoid': [
        'Non pubblicare il documento esposto né identificativi personali completi quando chiedi aiuto.',
        'Non inviare altri documenti d’identità a un servizio di recupero non verificato.',
        'Non presumere che eliminare un post o un messaggio rimuova le copie già ottenute da altri.',
      ],
      'limit': 'Le opzioni di protezione dell’identità e di segnalazione dipendono dal tipo di dati e dalla giurisdizione. ORVIKA non può determinare se le informazioni siano state copiate o utilizzate in modo improprio.',
    },
  };

  static ResponsePlaybook localize(ResponsePlaybook playbook, String languageCode) {
    if (languageCode != 'it') return playbook;
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
