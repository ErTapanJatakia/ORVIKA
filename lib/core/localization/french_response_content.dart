import '../../features/response/domain/response_playbooks.dart';

/// French incident-response guidance keyed by stable playbook IDs.
class FrenchResponseContent {
  FrenchResponseContent._();

  static const Map<String, Map<String, Object>> _playbooks = {
    'account-compromise': {
      'title': 'Un compte pourrait être compromis',
      'summary': 'Vous constatez des connexions inconnues, des données de récupération modifiées, des messages que vous n’avez pas envoyés ou des demandes d’authentification inattendues.',
      'firstAction': 'Utilisez un autre appareil de confiance et accédez au service par son application ou son adresse officielle.',
      'steps': [
        'Si nécessaire, sécurisez d’abord votre compte de messagerie principal : il contrôle souvent la réinitialisation des mots de passe d’autres services.',
        'Changez le mot de passe concerné pour un mot de passe unique et activez une méthode MFA robuste si elle est disponible.',
        'Vérifiez les adresses e-mail et numéros de récupération, les clés d’accès et les méthodes d’authentification. Supprimez ceux que vous ne reconnaissez pas.',
        'Déconnectez les sessions inconnues et révoquez les applications connectées ou jetons d’accès non reconnus si le service le permet.',
        'Vérifiez les règles de transfert, filtres de boîte de réception, messages envoyés et modifications récentes du compte.',
        'Si un compte professionnel ou scolaire est concerné, informez rapidement l’équipe informatique ou sécurité de l’organisation.',
      ],
      'preserve': [
        'Notez les e-mails d’alerte, heures de connexion, détails des appareils et sessions ainsi que les notifications pertinentes du compte.',
        'Conservez les messages originaux et leurs en-têtes si possible. Notez ce que vous avez modifié et à quel moment.',
      ],
      'avoid': [
        'Ne communiquez pas vos mots de passe, OTP, codes de récupération ou liens de session à quiconque propose son aide.',
        'N’utilisez pas les liens de récupération ou numéros de téléphone fournis dans un message inattendu.',
        'Ne supprimez pas les alertes potentiellement pertinentes avant d’en avoir enregistré les détails.',
      ],
      'limit': 'ORVIKA ne peut pas vérifier l’accès à un compte, révoquer des sessions ni récupérer un compte. Suivez la procédure officielle du service ; les étapes et intitulés peuvent varier.',
    },
    'payment-fraud': {
      'title': 'Paiement suspect ou non autorisé',
      'summary': 'Vous avez envoyé de l’argent sous pression, approuvé un paiement inattendu, partagé des identifiants de paiement ou repéré une transaction inconnue.',
      'firstAction': 'Contactez immédiatement votre banque ou prestataire de paiement via son application officielle, le numéro figurant sur votre carte ou un site vérifié indépendamment.',
      'steps': [
        'Demandez au prestataire de sécuriser le compte, la carte, le portefeuille ou le moyen de paiement concerné et d’expliquer les procédures de contestation ou de rappel disponibles.',
        'Signalez la transaction comme non autorisée ou liée à une escroquerie ; fournissez la référence, le montant, la date et les informations du bénéficiaire.',
        'Changez les identifiants bancaires ou e-mail exposés depuis un appareil de confiance et vérifiez les sessions actives et mandats de paiement.',
        'Si vos identifiants ou votre carte SIM peuvent être compromis, informez la banque et l’opérateur mobile concerné.',
        'Utilisez le canal officiel de signalement des autorités compétentes dans votre juridiction et conservez le reçu ou numéro de dossier.',
      ],
      'preserve': [
        'Conservez les identifiants de transaction, alertes bancaires, reçus, informations du bénéficiaire, journaux d’appels et conversations.',
        'Notez quand vous avez découvert le problème et quand vous avez contacté le prestataire.',
      ],
      'avoid': [
        'Ne payez pas une personne qui promet de récupérer à coup sûr les fonds perdus ou exige des frais initiaux.',
        'N’approuvez aucune autre demande de paiement, mandat ou session d’accès à distance.',
        'N’utilisez pas les coordonnées fournies par le prétendu fraudeur.',
      ],
      'limit': 'Un paiement peut être irréversible. ORVIKA ne peut pas bloquer des comptes, tracer des fonds ni déposer des signalements. Contactez rapidement le prestataire ; les canaux et délais varient.',
    },
    'lost-device': {
      'title': 'Un téléphone, ordinateur ou autre appareil est perdu',
      'summary': 'Un appareil a disparu, a été volé ou pourrait être accessible à une autre personne.',
      'firstAction': 'Depuis un autre appareil de confiance, utilisez le service officiel du fabricant ou de la plateforme pour sécuriser le compte et localiser l’appareil.',
      'steps': [
        'Si l’option existe, marquez l’appareil comme perdu ou verrouillez-le à distance. Évaluez l’effacement à distance selon la sensibilité des données et les possibilités de récupération.',
        'Contactez l’opérateur mobile pour suspendre une carte SIM ou eSIM manquante et demandez comment protéger le numéro.',
        'Changez les mots de passe des comptes de messagerie, financiers et d’identité principaux si l’appareil a pu être déverrouillé ou contenir des identifiants enregistrés.',
        'Révoquez les sessions des appareils de confiance et vérifiez les méthodes de récupération depuis un autre appareil fiable.',
        'Signalez le vol présumé aux autorités locales compétentes et suivez la procédure de votre organisation pour les appareils gérés.',
      ],
      'preserve': [
        'Conservez le numéro de série, l’IMEI le cas échéant, la preuve d’achat et les alertes officielles de localisation ou de sécurité.',
        'Notez où et quand l’appareil a été vu pour la dernière fois ainsi que les actions de verrouillage ou de signalement effectuées.',
      ],
      'avoid': [
        'Ne confrontez pas et ne rencontrez pas une personne qui prétend détenir l’appareil ; contactez les autorités compétentes.',
        'Ne suivez pas les messages vous demandant de désactiver la protection de l’appareil ou de révéler vos identifiants.',
        'Ne supposez pas qu’une estimation de localisation est exacte ni qu’une intervention personnelle est sans danger.',
      ],
      'limit': 'La localisation, le verrouillage et l’effacement à distance dépendent de la configuration préalable, de la connectivité et du support de la plateforme. L’effacement peut nuire aux preuves ou aux chances de récupération : évaluez la situation avant d’agir.',
    },
    'suspected-malware': {
      'title': 'Un appareil pourrait être infecté par un logiciel malveillant',
      'summary': 'Vous voyez des fenêtres intempestives, des alertes de sécurité, des applications inconnues, une activité inhabituelle sur vos comptes ou un comportement anormal après l’ouverture d’un fichier suspect.',
      'firstAction': 'Cessez de saisir des mots de passe ou des informations de paiement sur l’appareil concerné. Si une compromission active est suspectée, déconnectez-le du réseau lorsque cela est possible.',
      'steps': [
        'Utilisez un autre appareil de confiance pour les modifications sensibles des comptes et contactez l’équipe de sécurité si l’appareil est géré par une organisation.',
        'Ne rouvrez pas le fichier suspect et n’installez pas d’outils recommandés par une fenêtre intempestive ou un appelant non sollicité.',
        'Utilisez des outils de sécurité intégrés ou fiables provenant de sources officielles et suivez leur documentation.',
        'Mettez à jour le système et les applications après avoir évalué la situation immédiate et lorsque l’appareil peut être utilisé sans risque.',
        'Si des identifiants ont pu être exposés, changez-les depuis un autre appareil de confiance et révoquez les sessions actives.',
        'Pour un appareil professionnel ou un incident grave, préservez son état et demandez une assistance qualifiée en réponse aux incidents avant tout effacement ou réinstallation.',
      ],
      'preserve': [
        'Notez le texte des alertes, les noms de fichiers, la source de téléchargement, les heures et les résultats éventuels des outils de sécurité.',
        'Conservez les e-mails, URL et captures d’écran pertinents ; ne téléversez pas de fichiers sensibles vers des services publics d’analyse.',
      ],
      'avoid': [
        'N’exécutez pas de scripts de nettoyage aléatoires, de modifications de registre ou de téléchargements antivirus inconnus.',
        'Ne réinitialisez pas l’appareil aux paramètres d’usine et ne supprimez pas de fichiers avant d’avoir évalué les besoins en preuves et en récupération.',
        'Ne connectez pas inutilement des supports de sauvegarde ou d’autres appareils pendant une suspicion de compromission.',
      ],
      'limit': 'Ces signes ne prouvent pas la présence d’un logiciel malveillant. ORVIKA n’analyse ni fichiers, ni processus, ni appareils et ne les nettoie pas. Les incidents graves ou touchant une organisation nécessitent une analyse qualifiée.',
    },
    'identity-exposure': {
      'title': 'Des données personnelles ou d’identité ont été exposées',
      'summary': 'Des pièces d’identité, informations personnelles, identifiants ou documents privés pourraient avoir été divulgués à une personne ou à un service non fiable.',
      'firstAction': 'Déterminez précisément quelles informations ont été exposées et sécurisez les comptes ou services qui en dépendent.',
      'steps': [
        'Changez les mots de passe exposés et réutilisés depuis un appareil de confiance ; activez la MFA lorsque c’est possible.',
        'Contactez l’organisme émetteur par un canal vérifié indépendamment si des pièces d’identité, données financières ou identifiants officiels ont été exposés.',
        'Demandez aux institutions financières concernées quelles mesures de surveillance, de remplacement ou de restriction de compte sont disponibles.',
        'Vérifiez les paramètres de récupération des comptes et surveillez les alertes de réinitialisation, de crédit, de transaction ou de vérification d’identité.',
        'Signalez l’exposition via le canal officiel de confidentialité, l’autorité de contrôle ou les forces de l’ordre compétentes dans votre juridiction.',
      ],
      'preserve': [
        'Conservez la notification initiale d’exposition, les échanges pertinents, les dates, les catégories de données concernées et les références du dossier.',
        'Notez qui a été informé et quelles recommandations ou mesures de protection ont été fournies.',
      ],
      'avoid': [
        'Ne publiez pas le document exposé ni des identifiants personnels complets lorsque vous demandez de l’aide.',
        'N’envoyez pas d’autres documents d’identité à un service de récupération non vérifié.',
        'Ne supposez pas que la suppression d’une publication ou d’un message efface les copies déjà obtenues par d’autres.',
      ],
      'limit': 'Les options de protection de l’identité et de signalement dépendent du type de données et de la juridiction. ORVIKA ne peut pas déterminer si les informations ont été copiées ou utilisées à mauvais escient.',
    },
  };

  static ResponsePlaybook localize(ResponsePlaybook playbook, String languageCode) {
    if (languageCode != 'fr') return playbook;
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
