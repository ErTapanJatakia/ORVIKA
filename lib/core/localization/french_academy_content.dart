import '../../features/academy/domain/academy_curriculum.dart';

/// French lesson copy keyed by stable curriculum IDs.
class FrenchAcademyContent {
  FrenchAcademyContent._();

  static const Map<String, Map<String, Object>> _lessons = {
    'verify_sender': {
      'title': 'Vérifiez l’expéditeur, pas le nom affiché',
      'summary': 'Les noms, logos et photos de profil sont faciles à copier. Vérifiez l’adresse, le numéro ou l’identifiant réel du compte avant de faire confiance à une demande.',
      'keyPoints': [
        'Ouvrez les détails de l’expéditeur et vérifiez l’adresse e-mail complète ou l’identifiant du compte.',
        'Pour une demande inattendue, contactez la personne ou l’organisation par un canal que vous savez déjà fiable.',
        'Un nom ou un logo familier ne prouve pas l’identité.',
      ],
      'question': 'Un message semble provenir de votre banque et vous demande d’agir rapidement. Quelle est la première étape la plus sûre ?',
      'options': [
        'Répondre et demander à l’expéditeur de confirmer',
        'Utiliser directement l’application bancaire ou un contact officiel déjà connu',
        'Faire confiance au message parce que le logo semble correct',
      ],
      'explanation': 'Utilisez des coordonnées obtenues indépendamment. Ne vous fiez pas aux liens ou numéros de téléphone figurant dans le message inattendu.',
    },
    'phishing_links': {
      'title': 'Lisez les liens avant de les ouvrir',
      'summary': 'Un lien peut imiter une marque de confiance tout en vous dirigeant vers un domaine sans rapport ou trompeur.',
      'keyPoints': [
        'Repérez le domaine enregistrable en lisant de droite à gauche : des sous-domaines supplémentaires peuvent masquer la destination.',
        'Méfiez-vous des fautes d’orthographe, des caractères ressemblants, des URL raccourcies inattendues et du texte de lien trompeur.',
        'En cas de doute, utilisez un favori enregistré ou saisissez vous-même l’adresse connue.',
      ],
      'question': 'Un message affiche « example.com », mais le lien mène à example-login.security-check.invalid. Que devriez-vous faire ?',
      'options': [
        'L’ouvrir parce que le texte visible semble familier',
        'L’éviter et accéder au service par son canal officiel connu',
        'L’ouvrir dans une fenêtre de navigation privée',
      ],
      'explanation': 'Le texte visible d’un lien peut différer de sa destination. La navigation privée ne rend pas sûre une destination malveillante.',
    },
    'otp_secrecy': {
      'title': 'Gardez les OTP et codes de récupération secrets',
      'summary': 'Les mots de passe à usage unique, les demandes d’approbation de connexion et les codes de récupération peuvent permettre à quelqu’un d’accéder à votre compte.',
      'keyPoints': [
        'Ne communiquez jamais un OTP ou un code de récupération à un appelant, à un contact de discussion ou à un faux agent d’assistance.',
        'N’approuvez pas une demande de connexion que vous n’avez pas initiée.',
        'Si vous avez partagé un code, sécurisez immédiatement votre compte par le service officiel.',
      ],
      'question': 'Une personne prétendant travailler au support vous demande un OTP pour annuler une transaction. Que devriez-vous faire ?',
      'options': [
        'Le communiquer si elle connaît votre nom',
        'Ne communiquer que la première moitié',
        'Ne pas le communiquer, interrompre le contact et utiliser le canal officiel du service',
      ],
      'explanation': 'Un OTP est un secret d’authentification. Une procédure d’assistance légitime ne devrait pas vous demander de le révéler.',
    },
    'mfa_fatigue': {
      'title': 'Reconnaissez les demandes MFA inattendues',
      'summary': 'Des demandes d’approbation répétées ou inattendues peuvent indiquer qu’une personne tente de se connecter avec vos identifiants.',
      'keyPoints': [
        'Refusez les demandes que vous n’avez pas initiées.',
        'N’approuvez pas une demande simplement pour faire cesser les notifications répétées.',
        'Si vous soupçonnez une compromission, changez votre mot de passe via le service officiel et vérifiez les sessions actives.',
      ],
      'question': 'Votre téléphone reçoit plusieurs demandes d’approbation de connexion alors que vous n’essayez pas de vous connecter. Quelle est la réaction sûre ?',
      'options': [
        'Les refuser et vérifier le compte dans les paramètres officiels',
        'En approuver une pour arrêter les alertes',
        'Ignorer toutes les futures alertes du compte',
      ],
      'explanation': 'Refusez les demandes inattendues. Vérifiez ensuite le compte depuis un appareil de confiance et par le canal officiel.',
    },
    'payment_pressure': {
      'title': 'Faites une pause avant un paiement urgent',
      'summary': 'Les fraudeurs exploitent l’urgence, le secret et l’autorité pour pousser les personnes à effectuer des virements, acheter des cartes-cadeaux ou approuver des paiements.',
      'keyPoints': [
        'Considérez comme risqués les changements de dernière minute des coordonnées bancaires et les demandes de transfert urgentes.',
        'Vérifiez les instructions de paiement auprès du destinataire à l’aide d’un numéro déjà connu.',
        'Ne laissez pas un appelant vous presser ou vous faire contourner les contrôles d’autorisation habituels.',
      ],
      'question': 'Un fournisseur envoie de nouvelles coordonnées bancaires par e-mail et demande un paiement sous dix minutes. Que devriez-vous faire ?',
      'options': [
        'Payer immédiatement pour éviter une pénalité',
        'Vérifier le changement à l’aide d’un contact déjà connu',
        'Répondre au même e-mail pour demander s’il est authentique',
      ],
      'explanation': 'Vérifiez indépendamment les changements de paiement. Répondre au même fil d’e-mails potentiellement compromis ne constitue pas une vérification indépendante.',
    },
    'qr_safety': {
      'title': 'Traitez les QR codes comme des liens',
      'summary': 'Un QR code peut contenir un site web, une demande de paiement, une action de contact ou d’autres données. Le scanner ne le rend pas fiable.',
      'keyPoints': [
        'Affichez un aperçu de la destination décodée ou des détails du paiement avant de poursuivre.',
        'Vérifiez attentivement le bénéficiaire et le montant avant d’autoriser un paiement.',
        'Méfiez-vous des autocollants QR placés par-dessus un code que vous vous attendiez à trouver.',
      ],
      'question': 'Un QR code ouvre un écran de paiement. Que devriez-vous vérifier avant d’approuver ?',
      'options': [
        'Uniquement si l’image du QR code semble professionnelle',
        'Le bénéficiaire, le montant et le motif à l’aide d’une source fiable',
        'Si le code est scanné rapidement',
      ],
      'explanation': 'Un QR code est simplement un moyen pratique de transporter des données. Vérifiez les détails réels de la transaction avant de l’autoriser.',
    },
    'device_updates': {
      'title': 'Maintenez vos appareils et applications à jour',
      'summary': 'Les mises à jour de sécurité corrigent des vulnérabilités connues. Les retarder peut laisser les appareils exposés à des problèmes pour lesquels un correctif existe déjà.',
      'keyPoints': [
        'Installez les mises à jour du système et des applications par les mécanismes officiels.',
        'Supprimez les applications que vous n’utilisez plus et vérifiez régulièrement leurs autorisations.',
        'Conservez une sauvegarde restaurable et protégez l’appareil par un verrouillage d’écran.',
      ],
      'question': 'Une mise à jour d’application est disponible dans la boutique officielle de votre appareil. Quelle est la pratique la plus sûre ?',
      'options': [
        'Installer la mise à jour rapidement après en avoir vérifié la source',
        'Télécharger depuis une publicité un paquet quelconque promettant une « mise à jour plus rapide »',
        'Désactiver définitivement les mises à jour',
      ],
      'explanation': 'Utilisez le mécanisme de mise à jour officiel de la plateforme et maintenez vos logiciels raisonnablement à jour.',
    },
    'incident_first_steps': {
      'title': 'Agissez rapidement si un compte semble compromis',
      'summary': 'Une réponse calme et méthodique peut limiter les accès supplémentaires et préserver des informations utiles.',
      'keyPoints': [
        'Depuis un appareil de confiance, sécurisez le compte concerné à l’aide du service officiel.',
        'Changez les mots de passe réutilisés, révoquez les sessions inconnues et activez la MFA si elle est disponible.',
        'Conservez les messages et relevés de transaction pertinents ; si des fonds sont concernés, contactez immédiatement votre banque.',
      ],
      'question': 'Vous pensez que votre compte e-mail a été ciblé et compromis. Quel est le meilleur point de départ ?',
      'options': [
        'Supprimer immédiatement tous les messages suspects',
        'Sécuriser le compte depuis un appareil de confiance au moyen de la procédure officielle de récupération',
        'Publier vos codes de récupération en ligne pour demander de l’aide',
      ],
      'explanation': 'Sécurisez le compte au moyen de la procédure officielle de récupération, vérifiez les sessions et conservez les éléments utiles à l’enquête.',
    },
  };

  static AcademyLesson localize(AcademyLesson lesson, String languageCode) {
    if (languageCode != 'fr') return lesson;
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
