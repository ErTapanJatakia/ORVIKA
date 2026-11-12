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
