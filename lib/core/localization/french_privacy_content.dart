import '../../features/privacy/domain/privacy_checklist.dart';

/// French privacy self-audit guidance keyed by stable practice IDs.
class FrenchPrivacyContent {
  FrenchPrivacyContent._();

  static const Map<String, Map<String, String>> _practices = {
    'account-unique-passwords': {
      'title': 'Utilisez des mots de passe uniques pour vos comptes importants',
      'why': 'La réutilisation d’un mot de passe signifie qu’une fuite chez un service peut également mettre vos autres comptes en danger.',
      'action': 'Utilisez un gestionnaire de mots de passe fiable pour créer un mot de passe long et différent pour chaque compte important. Protégez le gestionnaire par un mot de passe principal robuste et configurez les options de récupération disponibles.',
      'limit': 'Un gestionnaire de mots de passe ne peut pas protéger un compte si le mot de passe principal ou le canal de récupération est compromis.',
    },
    'account-mfa': {
      'title': 'Activez l’authentification multifacteur',
      'why': 'Un deuxième facteur peut réduire les conséquences du vol d’un mot de passe.',
      'action': 'Activez la MFA pour vos comptes de messagerie, financiers, cloud et sociaux. Lorsque c’est possible, privilégiez les clés d’accès ou les clés de sécurité et protégez les sauvegardes de votre application d’authentification.',
      'limit': 'Les méthodes MFA offrent des niveaux de sécurité différents. Les codes SMS peuvent être exposés aux attaques par échange de SIM ou portage frauduleux du numéro.',
    },
    'account-recovery': {
      'title': 'Vérifiez les options de récupération de vos comptes',
      'why': 'Une adresse e-mail ou un numéro de récupération obsolète peut empêcher une récupération légitime ou faciliter la prise de contrôle d’un compte.',
      'action': 'Vérifiez les adresses de récupération, numéros de téléphone, codes de secours et appareils de confiance dans les paramètres de sécurité officiels de chaque service.',
      'limit': 'Les paramètres de récupération dépendent du service. ORVIKA ne peut pas vérifier qu’un fournisseur a appliqué les modifications.',
    },
    'device-updates': {
      'title': 'Maintenez les systèmes et applications à jour',
      'why': 'Les mises à jour corrigent souvent des vulnérabilités qui pourraient autrement être exploitées par des attaquants.',
      'action': 'Activez les mises à jour automatiques de sécurité lorsque cela est possible. Installez les mises à jour à l’aide de l’outil intégré de l’appareil ou de la boutique officielle.',
      'limit': 'Une mise à jour réduit les risques connus, mais ne garantit pas qu’un appareil soit exempt de compromission.',
    },
    'device-lock': {
      'title': 'Protégez votre appareil avec un verrouillage d’écran robuste',
      'why': 'Un appareil perdu ou laissé sans surveillance et déverrouillé peut exposer vos messages, comptes et données stockées.',
      'action': 'Utilisez un code PIN ou un mot de passe long, définissez un délai court de verrouillage automatique et configurez la biométrie comme méthode de déverrouillage supplémentaire et pratique.',
      'limit': 'Les options biométriques et de verrouillage varient selon l’appareil. Le verrouillage de l’écran ne chiffre pas nécessairement toutes les sauvegardes externes.',
    },
    'device-backups': {
      'title': 'Vérifiez les sauvegardes et les options de localisation de l’appareil',
      'why': 'Les sauvegardes facilitent la restauration, tandis que les fonctions de localisation peuvent aider à retrouver ou à protéger à distance un appareil perdu.',
      'action': 'Vérifiez quelles données sont sauvegardées, qui peut accéder au compte de sauvegarde, si le chiffrement des sauvegardes est disponible et si la localisation et le verrouillage à distance sont activés.',
      'limit': 'La disponibilité et les paramètres de chiffrement par défaut varient selon le système d’exploitation et le fournisseur. Consultez la documentation actuelle du fournisseur.',
    },
    'apps-permissions': {
      'title': 'Vérifiez les autorisations des applications',
      'why': 'Les applications peuvent conserver l’accès à la localisation, aux contacts, à la caméra, au microphone, aux photos ou aux appareils proches au-delà de ce qui est nécessaire.',
      'action': 'Ouvrez les paramètres de confidentialité ou d’autorisations des applications du système. Supprimez les accès inutiles et, si possible, privilégiez un accès ponctuel ou limité à la durée d’utilisation.',
      'limit': 'Les intitulés et commandes des autorisations varient selon le système et sa version. ORVIKA ne lit ni ne modifie ces autorisations.',
    },
    'apps-unused': {
      'title': 'Supprimez les applications que vous n’utilisez plus',
      'why': 'Les applications inutilisées peuvent conserver des sessions ouvertes, stocker des données ou continuer à recevoir des mises à jour et des autorisations.',
      'action': 'Désinstallez les applications dont vous n’avez plus besoin. Avant de les supprimer, exportez les informations nécessaires et, le cas échéant, révoquez l’accès aux comptes associés.',
      'limit': 'La désinstallation d’une application ne supprime pas nécessairement les données déjà conservées par son fournisseur.',
    },
    'apps-sources': {
      'title': 'Installez les applications depuis des sources fiables',
      'why': 'Les fichiers d’installation non vérifiés et les applications modifiées peuvent contenir du code indésirable ou demander des accès excessifs.',
      'action': 'Utilisez les boutiques officielles ou le canal de distribution vérifié de l’éditeur. Avant l’installation, vérifiez le développeur, les autorisations demandées et l’historique des mises à jour.',
      'limit': 'La présence dans une boutique officielle ne garantit pas qu’une application soit sûre ou respectueuse de la vie privée.',
    },
    'browsing-tracking': {
      'title': 'Vérifiez les paramètres de confidentialité et de suivi du navigateur',
      'why': 'Les cookies, les autorisations des sites et le suivi entre sites peuvent révéler vos habitudes de navigation.',
      'action': 'Vérifiez la protection contre le suivi, les cookies tiers, les autorisations de sites enregistrées et les extensions. Supprimez les extensions que vous ne reconnaissez pas ou dont vous n’avez pas besoin.',
      'limit': 'Le blocage des traceurs peut perturber certaines fonctions des sites et ne rend pas la navigation anonyme.',
    },
    'browsing-sharing': {
      'title': 'Limitez les informations personnelles partagées publiquement',
      'why': 'Les publications publiques et les détails de profil peuvent être combinés pour faciliter l’usurpation d’identité, les escroqueries ciblées ou les attaques contre la récupération de comptes.',
      'action': 'Vérifiez les champs publics de votre profil, les paramètres d’audience, le partage de localisation et vos anciennes publications. Évitez de publier des pièces d’identité, des projets de voyage ou des indices de récupération de compte.',
      'limit': 'Un contenu peut être copié ou archivé avant même que vous modifiiez vos paramètres de confidentialité.',
    },
    'browsing-network': {
      'title': 'Utilisez des connexions fiables et vérifiez les demandes réseau',
      'why': 'Les faux portails Wi-Fi et les connexions non sécurisées peuvent exposer votre activité ou vous rediriger vers des pages trompeuses.',
      'action': 'Privilégiez les réseaux de confiance, vérifiez le nom du réseau auprès de son gestionnaire, évitez les opérations sensibles sur des réseaux inconnus et utilisez des sites HTTPS. Désactivez la connexion automatique aux points d’accès inconnus.',
      'limit': 'HTTPS protège les données pendant leur transfert vers un site, mais ne prouve pas la légitimité de celui-ci et ne rend pas fiable un réseau inconnu.',
    },
  };

  static PrivacyPractice localize(PrivacyPractice practice, String languageCode) {
    if (languageCode != 'fr') return practice;
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
