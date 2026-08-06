// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'CashewGuard AI';

  @override
  String get welcomeBack => 'Bon Retour';

  @override
  String get signInToContinue =>
      'Connectez-vous pour continuer à surveiller votre ferme d\'anacarde.';

  @override
  String get emailAddress => 'Adresse E-mail';

  @override
  String get password => 'Mot de Passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get signIn => 'Se Connecter';

  @override
  String get or => 'OU';

  @override
  String get createNewAccount => 'Créer un Nouveau Compte';

  @override
  String get createAccount => 'Créer un Compte';

  @override
  String get joinCashewGuard =>
      'Rejoignez CashewGuard AI et commencez à protéger votre ferme dès aujourd\'hui.';

  @override
  String get fullName => 'Nom Complet';

  @override
  String get confirmPassword => 'Confirmer le Mot de Passe';

  @override
  String get agreeToTerms => 'J\'accepte les ';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get and => ' et la ';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get verifyYourEmail => 'Vérifiez Votre E-mail';

  @override
  String get weSentCodeTo => 'Nous avons envoyé un code à 6 chiffres à ';

  @override
  String get verifyEmail => 'Vérifier l\'E-mail';

  @override
  String get didntGetCode => 'Vous n\'avez pas reçu le code ? ';

  @override
  String get resendCode => 'Renvoyer le Code';

  @override
  String get checkSpamFolder =>
      'Vous ne trouvez pas le code ? Veuillez vérifier votre dossier Spam ou Courrier indésirable — il y arrive parfois.';

  @override
  String get goodMorning => 'Bonjour,';

  @override
  String get goodAfternoon => 'Bon Après-midi,';

  @override
  String get goodEvening => 'Bonsoir,';

  @override
  String get totalScans => 'Total des Analyses';

  @override
  String get diseasesFound => 'Maladies Détectées';

  @override
  String get healthyScans => 'Analyses Saines';

  @override
  String get scanLeafNow => 'Analyser une Feuille Maintenant';

  @override
  String get takeOrUploadPhoto =>
      'Prenez ou téléchargez une photo de feuille d\'anacarde';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get diseaseLibrary => 'Bibliothèque des Maladies';

  @override
  String get scanHistory => 'Historique des Analyses';

  @override
  String get treatmentGuide => 'Guide de Traitement';

  @override
  String get settings => 'Paramètres';

  @override
  String get recentScans => 'Analyses Récentes';

  @override
  String get noScansYet =>
      'Aucune analyse pour l\'instant. Analysez une feuille pour commencer.';

  @override
  String get dashboard => 'Tableau de Bord';

  @override
  String get scan => 'Analyser';

  @override
  String get library => 'Bibliothèque';

  @override
  String get history => 'Historique';

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Déconnexion';

  @override
  String get areYouSureLogout => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get editProfile => 'Modifier le Profil';

  @override
  String get changePassword => 'Changer le Mot de Passe';

  @override
  String get accountSettings => 'Paramètres du Compte';

  @override
  String get updateYourInfo => 'Mettez à jour vos informations personnelles';

  @override
  String get enhanceSecurity => 'Améliorez la sécurité de votre compte';

  @override
  String get manageLinkedServices => 'Gérez les services et données liés';

  @override
  String get notifications => 'Notifications';

  @override
  String get aboutApp => 'À Propos de l\'Application';

  @override
  String get loggedInAs => 'Connecté en tant que ';

  @override
  String get forgotPasswordSubtitle =>
      'Entrez votre adresse e-mail et nous vous enverrons un code à 6 chiffres pour réinitialiser votre mot de passe.';

  @override
  String get sendResetCode => 'Envoyer le Code de Réinitialisation';

  @override
  String get enterResetCode => 'Entrez le Code de Réinitialisation';

  @override
  String get setNewPassword => 'Définir un Nouveau Mot de Passe';

  @override
  String get chooseNewPasswordSubtitle =>
      'Choisissez un nouveau mot de passe pour votre compte.';

  @override
  String get newPassword => 'Nouveau Mot de Passe';

  @override
  String get verifyCode => 'Vérifier le Code';

  @override
  String get updatePassword => 'Mettre à Jour le Mot de Passe';

  @override
  String get farmHealthyMessage =>
      'Votre ferme semble en bonne santé aujourd\'hui.';

  @override
  String get diseasesDetectedMessage =>
      'Des maladies ont été détectées. Agissez !';

  @override
  String get checkScanHistoryDetails =>
      'Consultez votre historique d\'analyses pour plus de détails';

  @override
  String get view => 'Voir';

  @override
  String get diseaseLibrarySubtitle => '5 maladies';

  @override
  String get stepByStep => 'Étape par étape';

  @override
  String get preferences => 'Préférences';

  @override
  String diseasesDetectedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Maladies Détectées',
      one: '$count Maladie Détectée',
    );
    return '$_temp0';
  }

  @override
  String scanHistorySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enregistrements',
      one: '$count enregistrement',
    );
    return '$_temp0';
  }

  @override
  String get changeProfilePhoto => 'Changer la Photo de Profil';

  @override
  String get takeAPhoto => 'Prendre une Photo';

  @override
  String get chooseFromGallery => 'Choisir dans la Galerie';

  @override
  String get removePhoto => 'Supprimer la Photo';

  @override
  String get photoUpdatedSuccess => 'Photo de profil mise à jour avec succès';

  @override
  String get diseasesFoundMultiline => 'Maladies\nDétectées';

  @override
  String get healthyLeavesStat => 'Feuilles\nSaines';

  @override
  String get accountManagement => 'Gestion du Compte';

  @override
  String get appPreferencesSection => 'Préférences de l\'Application';

  @override
  String get notificationsSubtitle =>
      'Gérez les alertes IA et les mises à jour de terrain';

  @override
  String get aboutAppSubtitle => 'Version 1.0.0 (Édition Intendance)';

  @override
  String get general => 'Général';

  @override
  String get privacySettings => 'Paramètres de Confidentialité';

  @override
  String get notificationSettings => 'Paramètres de Notification';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get language => 'Langue';

  @override
  String get dataAndSecurity => 'Données et Sécurité';

  @override
  String get exportScanData => 'Exporter les Données d\'Analyse';

  @override
  String get generatingPdfReport => 'Génération du rapport PDF...';

  @override
  String get clearCache => 'Vider le Cache';

  @override
  String get clearCacheConfirm =>
      'Cela effacera tous les fichiers temporaires et images en cache. L\'application pourrait se charger un peu plus lentement jusqu\'à la reconstruction du cache. Continuer ?';

  @override
  String get clear => 'Effacer';

  @override
  String get clearingCache => 'Effacement du cache...';

  @override
  String get cacheClearedSuccess => 'Cache vidé avec succès';

  @override
  String get cacheClearedFailed => 'Échec du vidage du cache';

  @override
  String get accountActions => 'Actions du Compte';

  @override
  String get deleteAccount => 'Supprimer le Compte';

  @override
  String get selectLanguage => 'Choisir la Langue';

  @override
  String get languageComingSoonNotice =>
      'Le texte de l\'application restera en anglais pour l\'instant — la traduction complète arrive bientôt.';

  @override
  String get personalInformation => 'Informations Personnelles';

  @override
  String get emailCannotBeChanged => 'L\'e-mail ne peut pas être modifié';

  @override
  String get phoneNumber => 'Numéro de Téléphone';

  @override
  String get nameRequired => 'Le nom est requis';

  @override
  String get saveChanges => 'Enregistrer les Modifications';

  @override
  String get profileUpdatedSuccess => 'Profil mis à jour avec succès';

  @override
  String get passwordRequirementNotice =>
      'Votre nouveau mot de passe doit comporter au moins 8 caractères.';

  @override
  String get confirmNewPassword => 'Confirmer le Nouveau Mot de Passe';

  @override
  String get passwordRequiredError => 'Le mot de passe est requis';

  @override
  String get passwordMinLengthError =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordChangedSuccess => 'Mot de passe changé avec succès';

  @override
  String get diseaseAlertsTitle => 'Alertes de Maladie';

  @override
  String get diseaseAlertsSubtitle =>
      'Recevez des alertes en temps réel lorsque des maladies sont détectées';

  @override
  String get scanRemindersTitle => 'Rappels d\'Analyse';

  @override
  String get scanRemindersSubtitle =>
      'Rappels hebdomadaires pour analyser vos feuilles d\'anacarde';

  @override
  String get treatmentRemindersTitle => 'Rappels de Traitement';

  @override
  String get treatmentRemindersSubtitle =>
      'Rappels pour suivre les étapes de traitement';

  @override
  String get weeklyReportsTitle => 'Rapports Hebdomadaires';

  @override
  String get weeklyReportsSubtitle =>
      'Recevez un résumé hebdomadaire de l\'historique d\'analyse de votre ferme';

  @override
  String get appUpdatesTitle => 'Mises à Jour de l\'App';

  @override
  String get appUpdatesSubtitle =>
      'Soyez informé des nouvelles fonctionnalités et améliorations';

  @override
  String notificationsEnabledCount(int enabled, int total) {
    return '$enabled sur $total notifications activées';
  }

  @override
  String get changesSavedAutomatically =>
      'Les modifications sont enregistrées automatiquement';

  @override
  String get notificationPrefsSaved =>
      'Préférences de notification enregistrées';

  @override
  String get turnOffAllNotifications => 'Désactiver Toutes les Notifications';

  @override
  String get intelligentCropStewardship => 'Gestion Intelligente des Cultures';

  @override
  String get intelligentStewardship => 'Gestion Intelligente';

  @override
  String get missionText =>
      'CashewGuard AI comble le fossé entre la productivité agricole brute et l\'intelligence artificielle de haute technologie. Conçue pour les agriculteurs et praticiens de l\'anacarde, notre plateforme utilise des modèles d\'apprentissage profond par réseau de neurones convolutifs (CNN) pour détecter les maladies des feuilles et prédire les niveaux de gravité à partir d\'images de smartphone — fournissant des informations exploitables pour préserver la santé des plantations d\'anacarde.';

  @override
  String get keyFeatures => 'Fonctionnalités Clés';

  @override
  String get featureScanTitle => 'Analyse Instantanée des Feuilles';

  @override
  String get featureScanDesc =>
      'Prenez ou téléchargez une photo et obtenez un diagnostic IA en quelques secondes';

  @override
  String get featureDetectTitle => 'Détection des Maladies';

  @override
  String get featureDetectDesc =>
      'Identifie l\'Anthracnose, la Gommose, la Mineuse des Feuilles, la Rouille Rouge et plus';

  @override
  String get featureTreatmentTitle => 'Guide de Traitement';

  @override
  String get featureTreatmentDesc =>
      'Protocoles de traitement et de prévention étape par étape pour chaque diagnostic';

  @override
  String get featureHistoryTitle => 'Historique des Analyses';

  @override
  String get featureHistoryDesc =>
      'Suivez la santé de votre ferme au fil du temps avec un historique diagnostique complet';

  @override
  String get featureLanguageTitle => 'Support Multilingue';

  @override
  String get featureLanguageDesc =>
      'Disponible en anglais, yoruba, haoussa, igbo, pidgin nigérian et français';

  @override
  String get technologyStack => 'Pile Technologique';

  @override
  String get techFlutterDesc => 'Cadre d\'Application Mobile';

  @override
  String get techTensorflowDesc => 'Modèle d\'Apprentissage Profond';

  @override
  String get techOpencvDesc => 'Traitement d\'Image';

  @override
  String get techSupabaseDesc => 'Backend et Authentification';

  @override
  String get techCnnDesc => 'Réseau de Neurones Convolutifs';

  @override
  String get systemStatus => 'État du Système';

  @override
  String get allSystemsOperational => 'Tous les Systèmes Opérationnels';

  @override
  String get allRightsReserved =>
      '© 2026 CashewGuard AI. Tous droits réservés.';

  @override
  String get deleteAccountWarningTitle =>
      'Cette action est permanente et ne peut pas être annulée. Toutes vos données seront définitivement effacées.';

  @override
  String get deletionItemProfile =>
      'Votre profil et les informations de compte';

  @override
  String get deletionItemScans =>
      'Tous vos enregistrements et historique d\'analyses';

  @override
  String get deletionItemDiagnosis => 'Tous les résultats de diagnostic IA';

  @override
  String get deletionItemSettings =>
      'Préférences et paramètres de l\'application';

  @override
  String get pleaseConfirm => 'Veuillez Confirmer';

  @override
  String get confirmDeleteCheck1 =>
      'Je comprends que tout mon historique d\'analyses et mes données de diagnostic seront définitivement supprimés.';

  @override
  String get confirmDeleteCheck2 =>
      'Je comprends que cette action ne peut pas être annulée ni récupérée.';

  @override
  String get confirmDeleteCheck3 =>
      'Je confirme vouloir supprimer définitivement mon compte CashewGuard AI.';

  @override
  String get verifyYourIdentity => 'Vérifiez Votre Identité';

  @override
  String get enterPasswordToConfirm =>
      'Entrez votre mot de passe pour confirmer la suppression du compte.';

  @override
  String get enterYourPassword => 'Entrez votre mot de passe';

  @override
  String get processing => 'Traitement en cours...';

  @override
  String get deleteMyAccount => 'Supprimer Mon Compte';

  @override
  String get cancelKeepAccount => 'Annuler — Conserver Mon Compte';

  @override
  String get needHelpInstead =>
      'Besoin d\'aide à la place ? Contactez le support à support@cashewguard.ai avant de supprimer votre compte.';

  @override
  String get accountDeletedTitle => 'Compte Supprimé';

  @override
  String get accountDeletedMessage =>
      'Votre compte et toutes les données associées ont été définitivement supprimés. Vous allez être déconnecté maintenant.';

  @override
  String get okLogout => 'OK, Déconnexion';

  @override
  String get incorrectPassword => 'Mot de passe incorrect. Veuillez réessayer.';

  @override
  String get lastUpdated => 'Dernière mise à jour : juin 2026';

  @override
  String get goBack => 'Retour';

  @override
  String get scanLeafTitle => 'Analyser une Feuille';

  @override
  String get scanInstructionText =>
      'Prenez une photo nette d\'une feuille d\'anacarde ou téléchargez-en une depuis votre galerie pour l\'analyse IA.';

  @override
  String get positionLeafInFrame => 'Positionnez la feuille dans le cadre';

  @override
  String get ensureGoodLighting =>
      'Assurez un bon éclairage pour de meilleurs résultats';

  @override
  String get tipsForBestResults => 'Conseils Pour de Meilleurs Résultats';

  @override
  String get tipDaylight => 'Utilisez la lumière naturelle du jour si possible';

  @override
  String get tipFillFrame => 'Remplissez le cadre avec la feuille';

  @override
  String get tipSteadyCamera => 'Gardez l\'appareil photo stable';

  @override
  String get tipBothSides => 'Capturez les deux côtés de la feuille';

  @override
  String get takePhoto => 'Prendre une Photo';

  @override
  String get uploadFromGallery => 'Télécharger depuis la Galerie';

  @override
  String get diagnosticHistory => 'Historique de Diagnostic';

  @override
  String get searchDiagnoses => 'Rechercher des diagnostics...';

  @override
  String scansCount(int count) {
    return '$count Analyses';
  }

  @override
  String diseasesCount(int count) {
    return '$count Maladies';
  }

  @override
  String healthyCount(int count) {
    return '$count Saines';
  }

  @override
  String get noScansYetHistory => 'Aucune analyse pour l\'instant';

  @override
  String get noResultsFound => 'Aucun résultat trouvé';

  @override
  String get scanCashewLeafToStart =>
      'Analysez une feuille d\'anacarde pour commencer';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get searchDiseasesHint => 'Rechercher des maladies...';

  @override
  String get filterAll => 'Toutes';

  @override
  String get filterFungal => 'Fongique';

  @override
  String get filterPest => 'Ravageur';

  @override
  String get filterAlgal => 'Algale';

  @override
  String get featuredGuideBadge => 'GUIDE VEDETTE';

  @override
  String get preMonsoonTitle =>
      'Protocole de Protection Avant la Saison des Pluies';

  @override
  String get preMonsoonDesc =>
      'Préparez votre ferme d\'anacarde en mars, avant le début des pluies, pour réduire nettement le risque de maladies pendant la saison des pluies à venir.';

  @override
  String get readFullGuide => 'Lire le guide complet';

  @override
  String get treatmentDetailTitle => 'Guide de Protection Saisonnière';

  @override
  String get readTimeLabel => '5 min de lecture';

  @override
  String get allCashewLabel => 'Toutes Variétés';

  @override
  String get expertLevelLabel => 'Accessible aux Débutants';

  @override
  String get yourProgress => 'Votre Progression';

  @override
  String stepsCount(int completed, int total) {
    return '$completed/$total étapes';
  }

  @override
  String get overview => 'Aperçu';

  @override
  String get preMonsoonOverviewText =>
      'La ceinture anacardière du Nigeria connaît sa plus forte pression de maladies de l\'année dès le début des pluies, généralement en avril. L\'Anthracnose, la Gommose et la Rouille Rouge prospèrent toutes dans les conditions chaudes, humides et pluvieuses qui suivent — et le temps que les symptômes deviennent visibles, le traitement est déjà en retard. Ce guide couvre la préparation que les agriculteurs doivent effectuer en mars, avant le début des pluies, afin que vos arbres entament la saison des pluies avec une pression de maladie déjà réduite.';

  @override
  String get materialsNeeded => 'Matériel Nécessaire';

  @override
  String get materialCopperFungicide =>
      'Fongicide à base de cuivre (ex. : oxychlorure de cuivre)';

  @override
  String get materialSulphurSpray =>
      'Pulvérisation à base de soufre (pour une couverture fongique supplémentaire)';

  @override
  String get materialSprayer => 'Pulvérisateur à dos ou manuel';

  @override
  String get materialGloves => 'Gants et masque de protection';

  @override
  String get materialShears => 'Sécateur';

  @override
  String get stepByStepGuide => 'Guide Étape par Étape';

  @override
  String get step1Title => 'Inspecter Chaque Arbre';

  @override
  String get step1Desc =>
      'Parcourez votre ferme et vérifiez chaque arbre à la recherche d\'anciennes lésions, de taches de gomme, de bois mort et de dégâts de ravageurs laissés par la saison précédente. Notez les arbres qui nécessiteront une attention particulière une fois les pluies arrivées.';

  @override
  String get step1Duration => '15 min/arbre';

  @override
  String get step2Title => 'Élaguer et Assainir';

  @override
  String get step2Desc =>
      'Retirez et brûlez ou enterrez les branches mortes, les fruits momifiés et les feuilles fortement infectées. Ouvrez la canopée pour une meilleure circulation d\'air — les canopées denses et ombragées favorisent la Rouille Rouge et la propagation fongique.';

  @override
  String get step2Duration => '20-30 min/arbre';

  @override
  String get step3Title => 'Appliquer une Pulvérisation Préventive de Cuivre';

  @override
  String get step3Desc =>
      'Pulvérisez un fongicide à base de cuivre sur toute la canopée et directement sur les plaies de taille avant les premières fortes pluies. Cette seule étape est la défense la plus efficace contre l\'Anthracnose et la Rouille Rouge.';

  @override
  String get step3Duration => '1 jour (toute la ferme)';

  @override
  String get step4Title => 'Améliorer le Drainage';

  @override
  String get step4Desc =>
      'Dégagez les canaux de drainage autour de la base de chaque arbre pour que l\'eau ne stagne pas au tronc. Un sol détrempé est la principale cause des épidémies de Gommose.';

  @override
  String get step4Duration => 'Demi-journée';

  @override
  String get step5Title => 'Établir une Routine de Surveillance Hebdomadaire';

  @override
  String get step5Desc =>
      'Une fois les pluies arrivées, analysez vos arbres chaque semaine avec CashewGuard AI. De mai à octobre est la période de risque maximal pour l\'Anthracnose, la Gommose et la Rouille Rouge — détecter les symptômes tôt permet de traiter avant que des dommages majeurs ne surviennent.';

  @override
  String get step5Duration => 'Continu, chaque semaine';

  @override
  String get importantSafetyNote => 'Note de Sécurité Importante';

  @override
  String get safetyNoteText =>
      'Portez toujours des gants et un masque lors de la manipulation des fongicides. Évitez de pulvériser par temps venteux ou juste avant la pluie, et éloignez les enfants et le bétail des arbres traités jusqu\'à ce que la pulvérisation soit complètement sèche.';

  @override
  String get markAllStepsComplete =>
      'Marquer Toutes les Étapes Comme Terminées';

  @override
  String get treatmentGuideCompleted =>
      'Excellent travail — vous avez terminé le protocole de protection saisonnière !';

  @override
  String get completed => 'Terminé';

  @override
  String get diseaseDetailTitle => 'Détail de la Maladie';

  @override
  String get severityLabel => 'GRAVITÉ';

  @override
  String get optimalTempLabel => 'TEMPÉRATURE OPTIMALE';

  @override
  String get humidityLabel => 'HUMIDITÉ';

  @override
  String get spreadRateLabel => 'TAUX DE PROPAGATION';

  @override
  String get targetLabel => 'CIBLE';

  @override
  String get aboutDiseasePrefix => 'À propos de ';

  @override
  String get observedSymptoms => 'Symptômes Observés';

  @override
  String get preventionProtocol => 'Protocole de Prévention';

  @override
  String get activeTreatment => 'Traitement Actif';

  @override
  String get recommendedTreatmentLabel => 'TRAITEMENT RECOMMANDÉ';

  @override
  String get biologicalControlLabel => 'LUTTE BIOLOGIQUE';

  @override
  String get applicationWindowLabel => 'FENÊTRE D\'APPLICATION';

  @override
  String get cashewGuardInsight => 'Analyse CashewGuard';

  @override
  String get logAction => 'Enregistrer l\'Action';

  @override
  String get scanAgain => 'Analyser à Nouveau';

  @override
  String get diagnosisDetailTitle => 'Détail du Diagnostic';

  @override
  String get infectedAreaLabel => 'Zone Infectée';

  @override
  String get confidenceLabel => 'Confiance';

  @override
  String get modelUsedLabel => 'Modèle Utilisé';

  @override
  String get severityBreakdown => 'Répartition de la Gravité';

  @override
  String get infectedLabel => 'Infecté';

  @override
  String get healthyAreaLabel => 'Zone Saine';

  @override
  String get infectedAreaBarLabel => 'Zone Infectée';

  @override
  String get riskLevelLabel => 'Niveau de Risque';

  @override
  String get favourableConditionsLabel => 'Conditions Favorables';

  @override
  String get spreadRateInfoLabel => 'Taux de Propagation';

  @override
  String get pathogenLabel => 'Pathogène';

  @override
  String get recommendedTreatment => 'Traitement Recommandé';

  @override
  String get viewFullTreatmentGuide => 'Voir le Guide de Traitement Complet';

  @override
  String get scanAnotherLeaf => 'Analyser une Autre Feuille';

  @override
  String get imagePreviewTitle => 'Aperçu de l\'Image';

  @override
  String get imageDetails => 'Détails de l\'Image';

  @override
  String get formatLabel => 'Format';

  @override
  String get lightingLabel => 'Éclairage';

  @override
  String get lightingGood => 'Bon';

  @override
  String get focusLabel => 'Mise au Point';

  @override
  String get focusSharp => 'Nette';

  @override
  String get statusLabel => 'Statut';

  @override
  String get imageLoaded => 'Image chargée';

  @override
  String get noImage => 'Aucune image';

  @override
  String get checkingImage => 'Vérification de l\'Image...';

  @override
  String get readyForAnalysis => 'Prêt pour l\'Analyse';

  @override
  String get verifyingLeaf =>
      'Vérification qu\'il s\'agit d\'une feuille d\'anacarde...';

  @override
  String get imageWillBeValidated => 'L\'image sera validée avant l\'analyse.';

  @override
  String get validating => 'Validation en cours...';

  @override
  String get preparing => 'Préparation en cours...';

  @override
  String get analyseThisLeaf => 'Analyser Cette Feuille';

  @override
  String get retakePhoto => 'Reprendre la Photo';

  @override
  String get notCashewLeafTitle => 'Pas une Feuille d\'Anacarde';

  @override
  String get notCashewLeafMessage =>
      'Ceci ne semble pas être une feuille d\'anacarde. Veuillez télécharger une photo nette d\'une feuille d\'anacarde.';

  @override
  String get tryAnotherImage => 'Essayer une Autre Image';

  @override
  String get noImageFoundError => 'Aucune image trouvée. Veuillez réessayer.';

  @override
  String get cashewLeafSample => 'Échantillon de Feuille d\'Anacarde';

  @override
  String get scanResultTitle => 'Résultat de l\'Analyse';

  @override
  String get healthyLeafCheckmark => 'Feuille Saine ✓';

  @override
  String get diseaseDetectedSuffix => ' Détecté';

  @override
  String get severitySuffix => ' Gravité';

  @override
  String get confidenceSuffix => '% Confiance';

  @override
  String get severityLevel => 'Niveau de Gravité';

  @override
  String get infectedLabelResult => 'Infecté';

  @override
  String get healthyBadge => 'Sain';

  @override
  String get mildBadge => 'Léger';

  @override
  String get moderateBadge => 'Modéré';

  @override
  String get severeBadge => 'Sévère';

  @override
  String get detectionDetails => 'Détails de Détection';

  @override
  String get diseaseTypeLabel => 'Type de Maladie';

  @override
  String get pathogenLabelResult => 'Pathogène';

  @override
  String get pathogenNone => 'Aucun';

  @override
  String get leafAreaAffectedLabel => 'Zone de Feuille Affectée';

  @override
  String get scanTimeLabel => 'Heure de l\'Analyse';

  @override
  String get modelUsedLabelResult => 'Modèle Utilisé';

  @override
  String get leafIsHealthy => 'La Feuille est Saine';

  @override
  String get immediateActionRequired => 'Action Immédiate Requise';

  @override
  String get viewFullDiagnosis => 'Voir le Diagnostic Complet';

  @override
  String get viewTreatmentGuide => 'Voir le Guide de Traitement';

  @override
  String get scanAnotherLeafResult => 'Analyser une Autre Feuille';

  @override
  String get notCashewLeafBody =>
      'L\'image que vous avez téléchargée ne semble pas être une feuille d\'anacarde. Veuillez télécharger une photo nette et bien éclairée d\'une feuille d\'anacarde pour une détection précise.';

  @override
  String get tipsForBetterResults => 'Conseils Pour de Meilleurs Résultats';

  @override
  String get tipUploadClearPhoto =>
      'Téléchargez une photo nette d\'une feuille d\'anacarde';

  @override
  String get tipGoodLighting => 'Assurez un bon éclairage naturel';

  @override
  String get tipFillFrameResult => 'Remplissez le cadre avec la feuille';

  @override
  String get tipAvoidBlurry => 'Évitez les images floues ou sombres';

  @override
  String get scanAgainButton => 'Analyser à Nouveau';

  @override
  String get goToDashboard => 'Aller au Tableau de Bord';

  @override
  String get serverStartingUp => 'Le Serveur Démarre';

  @override
  String get serverWakingUpMessage =>
      'Le serveur IA était en veille et se réveille maintenant. Veuillez patienter environ 30 secondes et réessayer.';

  @override
  String get serverIdleInfo =>
      'Cela se produit lorsque le serveur a été inactif. Cela prend généralement 30 à 60 secondes pour se réveiller. Votre prochaine analyse sera rapide.';

  @override
  String get tryAgainButton => 'Réessayer';

  @override
  String get skip => 'Passer';

  @override
  String get onboardStep01 => 'ÉTAPE 01';

  @override
  String get onboardStep02 => 'ÉTAPE 02';

  @override
  String get onboardStep03 => 'ÉTAPE 03';

  @override
  String get onboardTitle1 => 'Détectez les Maladies\nInstantanément';

  @override
  String get onboardSubtitle1 =>
      'Pointez votre appareil photo vers n\'importe quelle feuille d\'anacarde et notre IA identifiera les maladies en quelques secondes.';

  @override
  String get onboardFeature1a => 'Résultats en moins de 3 secondes';

  @override
  String get onboardFeature1b => 'Fonctionne hors ligne sur le terrain';

  @override
  String get onboardFeature1c => 'Précision de détection supérieure à 95 %';

  @override
  String get onboardTitle2 => 'Analysez les Niveaux\nde Gravité';

  @override
  String get onboardSubtitle2 =>
      'Obtenez des scores précis de gravité d\'infection, de Sain à Sévère.';

  @override
  String get onboardFeature2a => 'Score d\'infection en pourcentage';

  @override
  String get onboardFeature2b => 'Suivi de la progression de la maladie';

  @override
  String get onboardFeature2c => 'Modèle d\'apprentissage profond CNN';

  @override
  String get onboardTitle3 => 'Obtenez des Conseils\nde Traitement';

  @override
  String get onboardSubtitle3 =>
      'Recevez des recommandations de traitement exploitables pour les maladies détectées.';

  @override
  String get onboardFeature3a => 'Conseils spécifiques à la culture';

  @override
  String get onboardFeature3b => 'Alertes d\'intervention rapide';

  @override
  String get onboardFeature3c => 'Bibliothèque complète des maladies';

  @override
  String get nextButton => 'Suivant';

  @override
  String get getStartedButton => 'Commencer';
}
