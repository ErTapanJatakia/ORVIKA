import '../../features/academy/domain/academy_curriculum.dart';

/// Italian lesson copy keyed by stable curriculum IDs.
class ItalianAcademyContent {
  ItalianAcademyContent._();

  static const Map<String, Map<String, Object>> _lessons = {
    'verify_sender': {
      'title': 'Verifica il mittente, non il nome visualizzato',
      'summary': 'Nomi, loghi e foto profilo si copiano facilmente. Controlla l’indirizzo, il numero o l’identificativo effettivo dell’account prima di fidarti di una richiesta.',
      'keyPoints': [
        'Apri i dettagli del mittente e controlla l’indirizzo e-mail completo o l’identificativo dell’account.',
        'Per una richiesta inattesa, contatta la persona o l’organizzazione tramite un canale che già consideri affidabile.',
        'Un nome o un logo familiare non dimostra l’identità.',
      ],
      'question': 'Un messaggio sembra provenire dalla tua banca e ti chiede di agire con urgenza. Qual è il primo passo più sicuro?',
      'options': [
        'Rispondere e chiedere al mittente una conferma',
        'Usare autonomamente l’app della banca o un recapito ufficiale già noto',
        'Fidarsi perché il logo sembra corretto',
      ],
      'explanation': 'Usa un recapito ottenuto in modo indipendente. Non affidarti ai link o ai numeri di telefono contenuti nel messaggio inatteso.',
    },
    'phishing_links': {
      'title': 'Leggi i link prima di aprirli',
      'summary': 'Un link può imitare un marchio affidabile e condurti comunque a un dominio estraneo o ingannevole.',
      'keyPoints': [
        'Individua il dominio registrato leggendo da destra verso sinistra: i sottodomini aggiuntivi possono mascherare la destinazione.',
        'Fai attenzione a errori di ortografia, caratteri simili, URL abbreviati inattesi e testo del link fuorviante.',
        'In caso di dubbio, usa un segnalibro salvato o digita personalmente l’indirizzo noto.',
      ],
      'question': 'Un messaggio mostra “example.com”, ma il link effettivo punta a example-login.security-check.invalid. Cosa dovresti fare?',
      'options': [
        'Aprirlo perché il testo visibile sembra familiare',
        'Evitarlo e raggiungere il servizio tramite il suo canale ufficiale noto',
        'Aprirlo in una finestra di navigazione privata',
      ],
      'explanation': 'Il testo visibile di un link può essere diverso dalla destinazione. La navigazione privata non rende sicura una destinazione dannosa.',
    },
    'otp_secrecy': {
      'title': 'Mantieni riservati OTP e codici di recupero',
      'summary': 'Le password monouso, le richieste di approvazione dell’accesso e i codici di recupero possono consentire ad altri di accedere al tuo account.',
      'keyPoints': [
        'Non comunicare mai OTP o codici di recupero a chiamanti, contatti in chat o falsi operatori di assistenza.',
        'Non approvare una richiesta di accesso che non hai avviato tu.',
        'Se hai condiviso un codice, proteggi subito l’account tramite il servizio ufficiale.',
      ],
      'question': 'Una persona che si presenta come addetto all’assistenza ti chiede un OTP per annullare una transazione. Cosa dovresti fare?',
      'options': [
        'Condividerlo se conosce il tuo nome',
        'Condividere soltanto la prima metà',
        'Non condividerlo, interrompere il contatto e usare il canale ufficiale del servizio',
      ],
      'explanation': 'Un OTP è un segreto di autenticazione. Una legittima procedura di assistenza non dovrebbe chiederti di rivelarlo.',
    },
    'mfa_fatigue': {
      'title': 'Riconosci le richieste MFA inattese',
      'summary': 'Richieste di approvazione ripetute o inattese possono indicare che qualcuno sta tentando di accedere usando le tue credenziali.',
      'keyPoints': [
        'Rifiuta le richieste che non hai avviato.',
        'Non approvare una richiesta soltanto per far cessare le notifiche ripetute.',
        'Se sospetti una compromissione, cambia la password tramite il servizio ufficiale e controlla le sessioni attive.',
      ],
      'question': 'Il telefono riceve diverse richieste di approvazione dell’accesso mentre non stai effettuando il login. Qual è la risposta sicura?',
      'options': [
        'Rifiutarle e verificare l’account tramite le impostazioni ufficiali',
        'Approvarne una per interrompere gli avvisi',
        'Ignorare tutti i futuri avvisi dell’account',
      ],
      'explanation': 'Le richieste inattese vanno rifiutate. Verifica poi l’account da un dispositivo affidabile e tramite il canale ufficiale.',
    },
    'payment_pressure': {
      'title': 'Fermati prima di effettuare pagamenti urgenti',
      'summary': 'I truffatori sfruttano urgenza, segretezza e autorità per spingere le persone a effettuare bonifici, acquistare carte regalo o approvare pagamenti.',
      'keyPoints': [
        'Considera ad alto rischio le modifiche dell’ultimo minuto alle coordinate bancarie e le richieste urgenti di trasferimento.',
        'Verifica le istruzioni di pagamento con il destinatario usando un numero già noto.',
        'Non lasciare che un chiamante ti metta fretta o ti induca a saltare i normali controlli di autorizzazione.',
      ],
      'question': 'Un fornitore invia nuove coordinate bancarie via e-mail e chiede il pagamento entro dieci minuti. Cosa dovresti fare?',
      'options': [
        'Pagare subito per evitare una penale',
        'Verificare la modifica usando un recapito già noto',
        'Rispondere alla stessa e-mail chiedendo se è autentica',
      ],
      'explanation': 'Verifica in modo indipendente le modifiche ai pagamenti. Rispondere allo stesso scambio e-mail potenzialmente compromesso non costituisce una verifica indipendente.',
    },
    'qr_safety': {
      'title': 'Tratta i codici QR come link',
      'summary': 'Un codice QR può contenere un sito web, una richiesta di pagamento, un’azione relativa a un contatto o altri dati. La scansione non lo rende affidabile.',
      'keyPoints': [
        'Visualizza in anteprima la destinazione decodificata o i dettagli del pagamento prima di procedere.',
        'Controlla attentamente destinatario e importo prima di autorizzare un pagamento.',
        'Fai attenzione agli adesivi QR applicati sopra un codice che ti aspettavi di trovare.',
      ],
      'question': 'Un codice QR apre una schermata di pagamento. Cosa dovresti verificare prima di approvare?',
      'options': [
        'Soltanto se l’immagine QR sembra professionale',
        'Destinatario, importo e causale tramite una fonte affidabile',
        'Se il codice viene scansionato rapidamente',
      ],
      'explanation': 'Un codice QR è soltanto un modo pratico per trasportare dati. Verifica i dettagli effettivi della transazione prima di autorizzarla.',
    },
    'device_updates': {
      'title': 'Mantieni aggiornati dispositivi e app',
      'summary': 'Gli aggiornamenti di sicurezza correggono vulnerabilità note. Rimandarli può lasciare i dispositivi esposti a problemi per i quali esistono già correzioni.',
      'keyPoints': [
        'Installa gli aggiornamenti del sistema operativo e delle app tramite i meccanismi ufficiali.',
        'Rimuovi le app che non usi più e controlla periodicamente le autorizzazioni.',
        'Mantieni un backup ripristinabile e proteggi il dispositivo con un blocco schermo.',
      ],
      'question': 'Un aggiornamento di un’app è disponibile nello store ufficiale del dispositivo. Qual è la pratica più sicura?',
      'options': [
        'Installare tempestivamente l’aggiornamento dopo averne verificato la fonte',
        'Scaricare da una pubblicità un pacchetto casuale per un “aggiornamento più veloce”',
        'Disattivare definitivamente gli aggiornamenti',
      ],
      'explanation': 'Usa il meccanismo di aggiornamento ufficiale della piattaforma e mantieni il software ragionevolmente aggiornato.',
    },
    'incident_first_steps': {
      'title': 'Agisci rapidamente se un account potrebbe essere compromesso',
      'summary': 'Una risposta calma e ordinata può limitare ulteriori accessi e preservare informazioni utili.',
      'keyPoints': [
        'Da un dispositivo affidabile, proteggi l’account interessato usando il servizio ufficiale.',
        'Cambia le password riutilizzate, revoca le sessioni sconosciute e attiva la MFA se disponibile.',
        'Conserva i messaggi e le registrazioni delle transazioni pertinenti; se sono coinvolti fondi, contatta subito la banca.',
      ],
      'question': 'Sospetti che il tuo account e-mail sia stato preso di mira e compromesso. Qual è il miglior punto di partenza?',
      'options': [
        'Eliminare immediatamente ogni messaggio sospetto',
        'Proteggere l’account da un dispositivo affidabile tramite la procedura ufficiale di recupero',
        'Pubblicare online i codici di recupero per chiedere aiuto',
      ],
      'explanation': 'Proteggi l’account tramite la procedura ufficiale di recupero, controlla le sessioni e conserva le prove che possono aiutare l’indagine.',
    },
  };

  static AcademyLesson localize(AcademyLesson lesson, String languageCode) {
    if (languageCode != 'it') return lesson;
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
