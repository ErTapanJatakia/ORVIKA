import '../../features/intelligence/domain/intelligence_library.dart';

/// French wording for the curated offline intelligence reference.
class FrenchIntelligenceContent {
  FrenchIntelligenceContent._();

  static const Map<String, Map<String, String>> _entries = {
    'url-http': {
      'title': 'HTTP non chiffré',
      'signal': 'Une adresse web commence par http:// au lieu de https://.',
      'meaning': 'La connexion n’utilise pas TLS pour protéger les données en transit. Les informations échangées peuvent être exposées ou modifiées sur le réseau.',
      'action': 'Évitez de saisir des mots de passe ou des informations de paiement. Accédez à l’organisation à l’aide d’un favori fiable ou d’une adresse vérifiée indépendamment.',
      'limit': 'HTTPS protège la connexion ; il ne prouve pas que le site web est légitime.',
    },
    'url-userinfo': {
      'title': 'Informations utilisateur trompeuses dans une URL',
      'signal': 'Une URL contient du texte avant le symbole @, par exemple https://trusted.example@unknown.example/.',
      'meaning': 'Les navigateurs interprètent le texte après @ comme le nom d’hôte. Le texte apparemment fiable placé avant peut servir à détourner l’attention.',
      'action': 'Lisez le nom d’hôte réel juste après @ et vérifiez le domaine enregistrable avant de visiter le site.',
      'limit': 'Les informations utilisateur dans une URL sont inhabituelles, mais ne prouvent pas à elles seules une intention malveillante.',
    },
    'url-punycode': {
      'title': 'Domaine internationalisé / Punycode',
      'signal': 'Un nom d’hôte contient une étiquette xn-- ou des caractères visuellement similaires.',
      'meaning': 'Les noms de domaine internationalisés peuvent utiliser des caractères issus de différents systèmes d’écriture qui ressemblent aux lettres latines.',
      'action': 'Vérifiez l’orthographe exacte et le titulaire du domaine auprès d’une source fiable. Ne vous fiez pas uniquement à un logo ou à un nom affiché familier.',
      'limit': 'De nombreux sites légitimes utilisent des noms de domaine internationalisés.',
    },
    'url-subdomains': {
      'title': 'Chaîne de sous-domaines profonde',
      'signal': 'Un nom d’hôte comporte plusieurs étiquettes, par exemple login.account.example.invalid.',
      'meaning': 'Le domaine enregistré n’est pas nécessairement le premier mot familier de l’adresse. Des attaquants peuvent placer des noms de marque dans des sous-domaines qu’ils contrôlent.',
      'action': 'Lisez le nom d’hôte de droite à gauche et identifiez le domaine enregistrable. Vérifiez-le indépendamment.',
      'limit': 'Les longues chaînes de sous-domaines ont aussi des usages légitimes.',
    },
    'message-urgency': {
      'title': 'Urgence et pression',
      'signal': 'Un message exige une action immédiate, menace de fermer un compte ou impose une échéance artificielle.',
      'meaning': 'La pression peut décourager les vérifications indépendantes et pousser le destinataire à agir sans réfléchir.',
      'action': 'Faites une pause. Contactez l’organisation par une application, un site ou un numéro officiel déjà connu, et non par les coordonnées du message.',
      'limit': 'Un langage urgent peut aussi apparaître dans des communications légitimes ; le contexte compte.',
    },
    'message-credentials': {
      'title': 'Demande d’identifiants ou d’OTP',
      'signal': 'Un expéditeur demande un mot de passe, un OTP, un code de récupération ou l’approbation d’une demande de connexion inattendue.',
      'meaning': 'Ces secrets ou approbations peuvent donner à une autre personne accès à un compte ou autoriser une transaction.',
      'action': 'Ne communiquez jamais de mot de passe ou d’OTP. Refusez les demandes d’approbation inattendues et contactez le service par son canal officiel.',
      'limit': 'Une correspondance par mots-clés identifie uniquement un sujet ; elle ne permet pas d’établir qui a envoyé le message ni ses intentions.',
    },
    'message-payment': {
      'title': 'Paiement ou remboursement inattendu',
      'signal': 'Un message demande un virement, des frais de traitement, une action de remboursement ou un paiement pour débloquer un avantage.',
      'meaning': 'Des instructions financières inattendues peuvent servir à détourner des fonds ou à recueillir des informations de paiement.',
      'action': 'Vérifiez le bénéficiaire, le montant et le motif par un canal distinct et fiable avant d’agir.',
      'limit': 'Le langage relatif aux paiements est également courant dans les factures et notifications de service ordinaires.',
    },
    'qr-payment': {
      'title': 'Demande de paiement par QR code',
      'signal': 'Un contenu QR utilise un schéma de paiement tel que upi://pay.',
      'meaning': 'Le scan peut préremplir un paiement au profit d’un bénéficiaire. Un QR code n’authentifie pas le bénéficiaire et ne garantit pas que le montant soit correct.',
      'action': 'Vérifiez le nom du bénéficiaire, l’identifiant UPI et le montant dans l’application de paiement avant d’autoriser. Annulez si un élément ne correspond pas.',
      'limit': 'Un contenu de paiement n’est pas frauduleux par nature ; vérifiez les détails de la transaction.',
    },
    'qr-action': {
      'title': 'QR code contenant un lien d’action',
      'signal': 'Un contenu QR comprend une action web, téléphonique, e-mail, SMS ou propre à une application.',
      'meaning': 'Le contenu peut ouvrir une destination ou préremplir une action lorsqu’il est traité par une autre application.',
      'action': 'Examinez d’abord le contenu décodé. N’ouvrez pas de lien inconnu et n’approuvez pas d’action préremplie sans vérification.',
      'limit': 'Le type de contenu seul ne permet pas de déterminer si sa source est fiable.',
    },
    'account-mfa': {
      'title': 'Approbation MFA inattendue',
      'signal': 'Vous recevez une demande d’approbation de connexion ou un code à usage unique que vous n’avez pas demandé.',
      'meaning': 'Quelqu’un peut tenter de se connecter avec l’identifiant et le mot de passe de votre compte, ou le code peut avoir été généré par erreur.',
      'action': 'Refusez la demande, ne partagez pas le code, changez votre mot de passe via le service officiel si nécessaire et vérifiez les sessions actives.',
      'limit': 'Une demande inattendue est un signal d’alerte, pas la confirmation qu’un compte a été compromis.',
    },
    'url-shortener': {'title': 'Destination raccourcie ou masquée', 'signal': 'Un lien utilise un raccourcisseur d’URL ou masque la destination finale derrière une redirection.', 'meaning': 'L’adresse visible ne révèle pas le site que vous allez réellement atteindre. Les chaînes de redirection peuvent dissimuler une destination inattendue.', 'action': 'Ne vous fiez pas au texte raccourci. Utilisez un aperçu fiable ou accédez au site de l’organisation de manière indépendante ; évitez les liens raccourcis non sollicités.', 'limit': 'Les raccourcisseurs d’URL sont largement utilisés pour des campagnes et services légitimes.'},
    'url-lookalike': {'title': 'Orthographe de domaine ressemblante', 'signal': 'Un domaine remplace, ajoute ou supprime des caractères pour ressembler à une organisation connue.', 'meaning': 'De petites différences d’orthographe, des mots supplémentaires ou des caractères inversés peuvent donner une apparence familière à un domaine contrôlé par un attaquant.', 'action': 'Comparez chaque caractère du domaine enregistrable complet avec une adresse obtenue indépendamment.', 'limit': 'Un nom ressemblant est une raison de vérifier, pas une preuve que son propriétaire est malveillant.'},
    'url-download': {'title': 'Téléchargement de fichier inattendu', 'signal': 'Un site ou un message vous invite de façon inattendue à télécharger un exécutable, un script, une archive ou un paquet d’application mobile.', 'meaning': 'Un fichier téléchargé peut installer un logiciel, demander des autorisations excessives ou exploiter une application vulnérable.', 'action': 'N’exécutez pas les fichiers inattendus. Obtenez les logiciels depuis la boutique de confiance de la plateforme ou le site de l’éditeur vérifié indépendamment.', 'limit': 'Les logiciels légitimes sont aussi distribués sous forme de fichiers ; vérifiez l’éditeur, la source et l’intégrité.'},
    'url-certificate': {'title': 'Avertissement de certificat HTTPS', 'signal': 'Le navigateur signale un certificat de site invalide, expiré, non concordant ou non fiable.', 'meaning': 'Le navigateur ne peut pas établir la connexion chiffrée authentifiée attendue avec ce nom d’hôte.', 'action': 'Arrêtez-vous et ne contournez pas l’avertissement pour saisir des identifiants ou des données de paiement. Vérifiez l’adresse et réessayez plus tard.', 'limit': 'Les erreurs de certificat peuvent venir d’une mauvaise configuration ou de l’horloge de l’appareil ; elles n’en identifient pas la cause.'},
    'url-permission': {'title': 'Demande inattendue d’autorisation du navigateur', 'signal': 'Un site demande de façon inattendue l’accès aux notifications, à la caméra, au microphone, à la localisation ou aux fichiers.', 'meaning': 'Une autorisation peut exposer des fonctions sensibles de l’appareil ou activer des notifications persistantes indésirables.', 'action': 'Refusez les autorisations inutiles pour la tâche. Vérifiez et révoquez les autorisations du site dans les paramètres du navigateur.', 'limit': 'Certains services légitimes ont besoin d’autorisations pour des fonctions précises ; évaluez le but et l’origine.'},
    'message-secrecy': {'title': 'Demande de secret ou d’isolement', 'signal': 'Un expéditeur vous demande de ne pas parler d’une demande à votre famille, vos collègues, votre banque ou l’organisation concernée.', 'meaning': 'L’isolement peut empêcher un second avis et rendre l’usurpation d’identité ou la pression au paiement plus efficaces.', 'action': 'Faites une pause et vérifiez la demande indépendamment. Une procédure légitime doit accepter une vérification raisonnable.', 'limit': 'Les demandes de confidentialité peuvent être légitimes dans certains contextes ; l’urgence et l’action demandée comptent.'},
    'message-remote-access': {'title': 'Leurre d’accès à distance ou de partage d’écran', 'signal': 'Un expéditeur vous demande d’installer un logiciel d’assistance à distance, de partager votre écran ou d’autoriser le contrôle de l’appareil.', 'meaning': 'L’accès à distance peut exposer messages, sessions bancaires, codes d’authentification et fichiers, ou permettre d’agir en votre nom.', 'action': 'N’installez rien et n’accordez aucun accès à la suite d’une demande non sollicitée. Contactez l’organisation par un canal vérifié séparément.', 'limit': 'Les outils d’assistance à distance ont des usages légitimes lorsque vous sollicitez vous-même un fournisseur de confiance.'},
    'message-gift-card': {'title': 'Paiement par carte-cadeau ou cryptomonnaie', 'signal': 'Un message demande des codes de cartes-cadeaux, de la cryptomonnaie, des bons ou un autre paiement difficile à annuler.', 'meaning': 'Ces moyens de paiement peuvent être difficiles, voire impossibles, à récupérer après transfert.', 'action': 'N’achetez ni ne transférez de codes ou de cryptomonnaie sous pression. Vérifiez la demande auprès de l’expéditeur supposé via un canal connu.', 'limit': 'Ces moyens de paiement ont des usages légitimes ; le problème est la demande non sollicitée et son contexte.'},
    'message-secrets': {'title': 'Demande de données bancaires ou d’identité sensibles', 'signal': 'Un message demande le cryptogramme de carte, un numéro d’identité complet, des identifiants de compte ou des copies de documents d’identité.', 'meaning': 'Ces informations peuvent permettre une prise de contrôle de compte, une usurpation d’identité ou des transactions non autorisées.', 'action': 'N’envoyez pas de données sensibles en réponse ou par chat. Utilisez uniquement une procédure officielle vérifiée que vous avez initiée.', 'limit': 'Certaines procédures réglementées exigent une vérification d’identité ; vérifiez le canal et la nécessité avant tout partage.'},
    'qr-wifi': {'title': 'Code QR contenant des identifiants Wi-Fi', 'signal': 'Le contenu décodé d’un QR contient le nom d’un réseau Wi-Fi et son mot de passe.', 'meaning': 'La connexion peut relier votre appareil à un réseau contrôlé par quelqu’un d’autre ; les risques dépendent de sa configuration.', 'action': 'Ne rejoignez que des réseaux de confiance. Évitez les activités sensibles sur les réseaux inconnus et utilisez les protections de votre appareil.', 'limit': 'Les QR Wi-Fi sont pratiques et ne sont pas intrinsèquement malveillants.'},
    'qr-contact': {'title': 'Code QR avec action de contact ou de message', 'signal': 'Un QR contient une vCard, un numéro de téléphone, une adresse e-mail ou un SMS prérempli.', 'meaning': 'L’importation ou l’activation peut ajouter un contact ou préparer une communication vers une destination non vérifiée.', 'action': 'Vérifiez le nom, le numéro, l’adresse et le message affichés avant d’enregistrer ou d’envoyer quoi que ce soit.', 'limit': 'Les QR de contact servent souvent au partage légitime ; vérifiez les détails avant d’agir.'},
    'account-recovery': {'title': 'Activité inattendue de récupération de compte', 'signal': 'Vous recevez un avis de réinitialisation de mot de passe, une demande de code de récupération ou une alerte de modification des données de récupération que vous n’avez pas sollicitée.', 'meaning': 'Quelqu’un tente peut-être d’accéder à un compte ou d’en prendre le contrôle ; la notification peut aussi être du spam.', 'action': 'Ne partagez aucun code de récupération. Ouvrez le service avec son application officielle ou un favori fiable, vérifiez l’activité et sécurisez les moyens de récupération.', 'limit': 'Une notification seule ne confirme pas une prise de contrôle réussie.'},
  };

  static IntelligenceEntry localize(IntelligenceEntry entry, String languageCode) {
    if (languageCode != 'fr') return entry;
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
