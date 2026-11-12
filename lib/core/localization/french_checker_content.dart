import '../../features/link_check/domain/url_analyzer.dart';
import '../../features/qr_check/domain/qr_payload_analyzer.dart';

/// French wording for deterministic checker findings. Analyzer identifiers
/// remain canonical English so detection logic is language-neutral.
class FrenchCheckerContent {
  FrenchCheckerContent._();

  static const Map<String, ({String title, String detail})> _findings = {
    'Unicode hostname': (title: 'Nom d’hôte Unicode', detail: 'Le nom d’hôte contient des caractères non ASCII. Examinez attentivement le domaine internationalisé afin de repérer les caractères visuellement similaires et d’en vérifier l’orthographe exacte.'),
    'Unencrypted connection': (title: 'Connexion non chiffrée', detail: 'Cette adresse utilise HTTP. Les données échangées peuvent ne pas être protégées pendant leur transmission.'),
    'Embedded sign-in information': (title: 'Identifiants intégrés à l’adresse', detail: 'L’adresse contient des informations utilisateur avant le nom d’hôte. Cela peut rendre la destination affichée trompeuse.'),
    'Internationalised domain encoding': (title: 'Encodage de domaine internationalisé', detail: 'Le nom d’hôte contient du Punycode. Examinez attentivement le domaine affiché afin de repérer les caractères ressemblants.'),
    'IP-address destination': (title: 'Destination sous forme d’adresse IP', detail: 'L’adresse pointe directement vers une adresse IPv4 plutôt que vers un nom de domaine. Ce n’est pas nécessairement malveillant, mais cela mérite une vérification.'),
    'Malformed IPv4-looking hostname': (title: 'Nom d’hôte ressemblant à une adresse IPv4 incorrecte', detail: 'Le nom d’hôte ressemble à une adresse IPv4 à points, mais contient un octet hors de la plage autorisée. Ne supposez pas qu’il mène à la destination attendue.'),
    'Unusual numeric hostname': (title: 'Nom d’hôte numérique inhabituel', detail: 'Le nom d’hôte est numérique, mais ne correspond pas à une adresse IPv4 classique composée de quatre octets. Certains clients peuvent interpréter différemment ces formes numériques inhabituelles.'),
    'Long subdomain chain': (title: 'Chaîne de sous-domaines longue', detail: 'Le nom d’hôte comporte plusieurs niveaux de sous-domaines. Vérifiez attentivement le domaine enregistrable : la présence d’une marque connue dans un sous-domaine ne prouve pas qui contrôle la destination.'),
    'Non-standard port': (title: 'Port non standard', detail: 'Cette adresse utilise le port {port} au lieu du port HTTP ou HTTPS habituel.'),
    'Fragment present': (title: 'Fragment URL présent', detail: 'L’adresse contient un fragment. Celui-ci fait partie de l’URL fournie et peut influencer la page ou le routage côté client.'),
    'No structural warning detected': (title: 'Aucun avertissement structurel détecté', detail: 'L’adresse a passé ces vérifications locales de base. Cela ne prouve pas que le site soit fiable ou sûr.'),
    'Address not analysed': (title: 'Adresse non analysée', detail: 'L’adresse web n’a pas pu être analysée. Vérifiez la valeur saisie et réessayez.'),
    'Urgency or pressure language': (title: 'Langage urgent ou pressant', detail: 'Le message crée un sentiment d’urgence ou exige une action immédiate. Faites une pause et vérifiez la demande par un autre canal fiable.'),
    'Credential or sign-in request': (title: 'Demande d’identifiants ou de connexion', detail: 'Le texte semble demander un mot de passe, une connexion ou la vérification d’un compte. Ne saisissez pas vos identifiants via un lien reçu dans un message.'),
    'OTP or authentication-code reference': (title: 'Référence à un OTP ou à un code d’authentification', detail: 'Un mot de passe à usage unique ou un code d’authentification est mentionné. Ne partagez jamais un OTP, un code de récupération ou une demande d’approbation avec qui que ce soit.'),
    'Payment or financial action': (title: 'Paiement ou opération financière', detail: 'Le message concerne un paiement, un transfert, un remboursement, des frais ou une autre opération financière. Vérifiez indépendamment le destinataire et le montant avant de poursuivre.'),
    'Prize or unexpected reward': (title: 'Prix ou récompense inattendue', detail: 'Un prix ou une récompense inattendue est mentionné. Méfiez-vous des demandes de frais ou de données personnelles pour la réclamer.'),
    'Threat or consequence language': (title: 'Menace ou annonce de conséquences', detail: 'Le message menace d’une pénalité, d’une action en justice, d’une arrestation ou d’une perte d’accès. Vérifiez ces affirmations en utilisant des coordonnées de l’organisation obtenues indépendamment.'),
    'Obfuscated web address detected': (title: 'Adresse web obfusquée détectée', detail: 'Le message contient un lien dont le schéma a été remplacé, par exemple hxxp ou hxxps. Traitez-le comme une adresse à vérifier manuellement : il n’a pas été normalisé ni ouvert.'),
    'Link or web address detected': (title: 'Lien ou adresse web détecté', detail: '{count} adresse(s) web trouvée(s). Un lien visible peut masquer une destination différente. Vérifiez chaque adresse séparément avant de l’ouvrir.'),
    'No listed social-engineering cues detected': (title: 'Aucun indicateur répertorié d’ingénierie sociale détecté', detail: 'Le texte ne correspond pas aux modèles limités de cette version. Des messages malveillants peuvent néanmoins sembler ordinaires ou employer des formulations que ces vérifications ne détectent pas.'),
    'Message not analysed': (title: 'Message non analysé', detail: 'Le message n’a pas pu être analysé. Vérifiez le texte saisi et réessayez.'),
  };

  static LinkFinding localizeFinding(LinkFinding finding, String languageCode) {
    if (languageCode != 'fr') return finding;
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
    if (languageCode != 'fr') return notice;
    if (notice == 'No network request was made.') return 'Aucune requête réseau n’a été effectuée.';
    return 'Seules des vérifications structurelles locales ont été effectuées. Aucune requête réseau ni vérification de réputation n’a eu lieu.';
  }

  static String localizeMessageNotice(String languageCode) => languageCode == 'fr'
      ? 'Vérifications heuristiques du texte uniquement. Aucun message n’a été envoyé, aucun lien n’a été ouvert et l’identité ou l’intention de l’expéditeur n’a pas été vérifiée.'
      : 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.';

  static QrPayloadAnalysis localizeQr(QrPayloadAnalysis result, String languageCode) {
    if (languageCode != 'fr') return result;
    const titles = <String, String>{
      'Wi-Fi configuration': 'Configuration Wi-Fi',
      'Contact card': 'Fiche de contact',
      'Calendar event': 'Événement de calendrier',
      'UPI payment request': 'Demande de paiement UPI',
      'Phone call action': 'Action d’appel téléphonique',
      'Email action': 'Action d’e-mail',
      'Text-message action': 'Action de SMS',
      'Location coordinates': 'Coordonnées de localisation',
      'Application-specific link': 'Lien propre à une application',
      'Plain text': 'Texte brut',
      'Web address': 'Adresse web',
      'Unrecognised web address': 'Adresse web non reconnue',
      'QR content not analysed': 'Contenu QR non analysé',
    };
    const details = <String, String>{
      'Wi-Fi configuration': 'Ce contenu QR peut inclure le nom du réseau, le type de sécurité et le mot de passe Wi-Fi. Vérifiez le réseau avant de vous connecter : ORVIKA ne se connecte pas automatiquement.',
      'Contact card': 'Ce contenu comprend des coordonnées. Vérifiez les noms, numéros de téléphone, adresses e-mail et informations sur l’organisation avant de les enregistrer.',
      'Calendar event': 'Ce contenu décrit un événement de calendrier. Vérifiez le titre, le lieu, les horaires et les liens intégrés avant de l’importer.',
      'UPI payment request': 'Ce contenu QR peut préparer un paiement dans une application UPI. Vérifiez indépendamment l’identifiant UPI, le nom du bénéficiaire et le montant. ORVIKA ne lance ni n’autorise aucun paiement.',
      'Phone call action': 'Ce contenu comprend une action d’appel. Vérifiez le numéro de manière indépendante : ORVIKA ne passe aucun appel.',
      'Email action': 'Ce contenu peut préremplir un destinataire ou le texte d’un e-mail. Vérifiez tous les champs avant l’envoi : ORVIKA n’ouvre aucune application de messagerie.',
      'Text-message action': 'Ce contenu peut préremplir un destinataire ou un message. Vérifiez le numéro et le texte avant l’envoi : ORVIKA n’envoie aucun SMS.',
      'Location coordinates': 'Ce contenu comprend une référence de localisation. Vérifiez les coordonnées et le contexte avant de les utiliser : ORVIKA n’ouvre aucune carte.',
      'Application-specific link': 'Ce contenu utilise le schéma « {scheme}: » au lieu d’une URL web classique. Il peut lancer une application ou une action. Ne l’ouvrez que si vous faites confiance à la source après une vérification indépendante.',
      'Plain text': 'Ce contenu QR contient du texte plutôt qu’une adresse web ou une action reconnue. Examinez-le attentivement : un texte peut aussi contenir des instructions trompeuses ou des informations sensibles.',
      'Web address': 'Une destination web a été détectée. Vérifiez le domaine et le chemin avant d’ouvrir le lien.',
      'Unrecognised web address': 'Le contenu ressemble à une adresse web, mais n’a pas pu être interprété de manière fiable. Ne l’ouvrez pas avant d’avoir vérifié sa destination.',
      'QR content not analysed': 'Le contenu QR n’a pas pu être analysé. Vérifiez le code ou l’image et réessayez.',
    };
    final title = titles[result.title] ?? result.title;
    var detail = details[result.title] ?? result.detail;
    final scheme = RegExp(r'([a-zA-Z][a-zA-Z0-9+.-]*):').firstMatch(result.detail);
    if (scheme != null) detail = detail.replaceAll('{scheme}', scheme.group(1)!);
    return QrPayloadAnalysis(
      title: title, detail: detail, severity: result.severity, kind: result.kind,
      normalizedUrl: result.normalizedUrl, linkFindings: result.linkFindings, isValid: result.isValid,
    );
  }
}
