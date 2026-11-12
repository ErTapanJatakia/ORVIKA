import '../../features/privacy/domain/privacy_checklist.dart';

/// Italian privacy self-audit guidance keyed by stable practice IDs.
class ItalianPrivacyContent {
  ItalianPrivacyContent._();

  static const Map<String, Map<String, String>> _practices = {
    'account-unique-passwords': {
      'title': 'Usa password uniche per gli account importanti',
      'why': 'Riutilizzare una password fa sì che una violazione presso un servizio possa mettere a rischio anche gli altri account.',
      'action': 'Usa un gestore di password affidabile per creare una password lunga e diversa per ogni account importante. Proteggi il gestore con una password principale robusta e con le opzioni di recupero disponibili.',
      'limit': 'Un gestore di password non può proteggere un account se la password principale o il canale di recupero vengono compromessi.',
    },
    'account-mfa': {
      'title': 'Attiva l’autenticazione a più fattori',
      'why': 'Un secondo fattore può ridurre l’impatto di una password rubata.',
      'action': 'Attiva la MFA per account e-mail, finanziari, cloud e social. Quando supportati, preferisci passkey o chiavi di sicurezza e proteggi i backup dell’autenticatore.',
      'limit': 'I metodi MFA hanno livelli di sicurezza diversi. I codici SMS possono essere esposti ad attacchi di SIM swap e portabilità fraudolenta del numero.',
    },
    'account-recovery': {
      'title': 'Controlla le opzioni di recupero dell’account',
      'why': 'Un indirizzo e-mail o un numero di telefono di recupero non aggiornato può impedire un recupero legittimo o facilitare la presa di controllo dell’account.',
      'action': 'Controlla indirizzi di recupero, numeri di telefono, codici di backup e dispositivi attendibili nelle impostazioni di sicurezza ufficiali di ogni servizio.',
      'limit': 'Le impostazioni di recupero dipendono dal servizio. ORVIKA non può verificare che un fornitore abbia applicato le modifiche.',
    },
    'device-updates': {
      'title': 'Mantieni aggiornati sistemi operativi e app',
      'why': 'Gli aggiornamenti correggono spesso vulnerabilità che altrimenti potrebbero essere sfruttate dagli aggressori.',
      'action': 'Quando possibile, attiva gli aggiornamenti automatici di sicurezza. Installa gli aggiornamenti tramite lo strumento integrato del dispositivo o lo store ufficiale.',
      'limit': 'Un aggiornamento riduce i rischi noti, ma non garantisce che un dispositivo sia privo di compromissioni.',
    },
    'device-lock': {
      'title': 'Proteggi il dispositivo con un blocco schermo robusto',
      'why': 'Un dispositivo smarrito o lasciato incustodito e sbloccato può esporre messaggi, account e dati memorizzati.',
      'action': 'Usa un PIN o una password lunghi, imposta un intervallo breve per il blocco automatico e configura la biometria soltanto come metodo aggiuntivo e pratico di sblocco.',
      'limit': 'Le opzioni biometriche e di blocco variano in base al dispositivo. Il blocco schermo non cifra necessariamente tutti i backup esterni.',
    },
    'device-backups': {
      'title': 'Controlla le impostazioni di backup e localizzazione del dispositivo',
      'why': 'I backup facilitano il ripristino, mentre le funzioni di localizzazione possono aiutare a trovare o proteggere da remoto un dispositivo smarrito.',
      'action': 'Verifica quali dati vengono salvati, chi può accedere all’account di backup, se è disponibile la cifratura dei backup e se sono attive la localizzazione e il blocco remoto.',
      'limit': 'Disponibilità e impostazioni predefinite di cifratura variano in base al sistema operativo e al fornitore. Consulta la documentazione aggiornata del fornitore.',
    },
    'apps-permissions': {
      'title': 'Controlla le autorizzazioni delle app',
      'why': 'Le app possono mantenere l’accesso a posizione, contatti, fotocamera, microfono, foto o dispositivi vicini oltre quanto necessario.',
      'action': 'Apri le impostazioni di privacy o delle autorizzazioni delle app del sistema operativo. Rimuovi gli accessi non necessari e, se disponibile, preferisci l’accesso una tantum o limitato al periodo di utilizzo.',
      'limit': 'Le etichette e i controlli delle autorizzazioni variano in base al sistema operativo e alla versione. ORVIKA non legge né modifica queste autorizzazioni.',
    },
    'apps-unused': {
      'title': 'Rimuovi le app che non usi più',
      'why': 'Le app inutilizzate possono mantenere sessioni aperte, conservare dati o continuare a ricevere aggiornamenti e autorizzazioni.',
      'action': 'Disinstalla le app che non ti servono più. Prima di rimuoverle, esporta le informazioni necessarie e, se opportuno, revoca l’accesso agli account collegati.',
      'limit': 'La disinstallazione di un’app potrebbe non eliminare i dati già conservati dal relativo fornitore.',
    },
    'apps-sources': {
      'title': 'Installa app da fonti affidabili',
      'why': 'File di installazione non verificati e app modificate possono contenere codice indesiderato o richiedere accessi eccessivi.',
      'action': 'Usa gli store ufficiali o il canale di distribuzione verificato dell’editore. Prima dell’installazione, controlla sviluppatore, autorizzazioni richieste e cronologia degli aggiornamenti.',
      'limit': 'La presenza nello store ufficiale non garantisce che un’app sia sicura o rispetti la privacy.',
    },
    'browsing-tracking': {
      'title': 'Controlla le impostazioni di privacy e tracciamento del browser',
      'why': 'Cookie, autorizzazioni dei siti e tracciamento tra siti possono rivelare le abitudini di navigazione.',
      'action': 'Controlla la protezione dal tracciamento, i cookie di terze parti, le autorizzazioni dei siti salvate e le estensioni. Rimuovi le estensioni che non riconosci o non ti servono.',
      'limit': 'Il blocco dei tracker può compromettere alcune funzioni dei siti e non rende anonima la navigazione.',
    },
    'browsing-sharing': {
      'title': 'Limita le informazioni personali condivise pubblicamente',
      'why': 'Post pubblici e dettagli del profilo possono essere combinati per favorire furti d’identità, truffe mirate o attacchi alle procedure di recupero degli account.',
      'action': 'Controlla i campi pubblici del profilo, le impostazioni del pubblico, la condivisione della posizione e i vecchi post. Evita di pubblicare documenti d’identità, programmi di viaggio o indizi per il recupero degli account.',
      'limit': 'I contenuti possono essere copiati o archiviati prima che vengano modificate le impostazioni di privacy.',
    },
    'browsing-network': {
      'title': 'Usa connessioni sicure e verifica le richieste di rete',
      'why': 'Portali Wi-Fi contraffatti e connessioni non protette possono esporre le attività o reindirizzarti verso pagine ingannevoli.',
      'action': 'Preferisci reti affidabili, verifica il nome della rete con il gestore, evita attività sensibili su reti sconosciute e usa siti HTTPS. Disattiva la connessione automatica agli hotspot non familiari.',
      'limit': 'HTTPS protegge i dati durante il trasferimento verso un sito, ma non ne dimostra la legittimità e non rende sicura una rete non affidabile.',
    },
  };

  static PrivacyPractice localize(PrivacyPractice practice, String languageCode) {
    if (languageCode != 'it') return practice;
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
