// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nigerian Pidgin (`pcm`).
class AppLocalizationsPcm extends AppLocalizations {
  AppLocalizationsPcm([String locale = 'pcm']) : super(locale);

  @override
  String get appName => 'CashewGuard AI';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue =>
      'Sign in make you continue to dey monitor your cashew farm.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'You forget Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get or => 'OR';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinCashewGuard =>
      'Join CashewGuard AI make you start to dey protect your farm today.';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get agreeToTerms => 'I agree to di ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get alreadyHaveAccount => 'You don get account before? ';

  @override
  String get verifyYourEmail => 'Verify Your Email';

  @override
  String get weSentCodeTo => 'We don send 6-digit code go ';

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get didntGetCode => 'You never see di code? ';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get checkSpamFolder =>
      'You never see di code? Abeg check your Spam or Junk folder — sometimes na dia e dey enter.';

  @override
  String get goodMorning => 'Good Morning,';

  @override
  String get goodAfternoon => 'Good Afternoon,';

  @override
  String get goodEvening => 'Good Evening,';

  @override
  String get totalScans => 'Total Scans';

  @override
  String get diseasesFound => 'Diseases Wey We Find';

  @override
  String get healthyScans => 'Healthy Scans';

  @override
  String get scanLeafNow => 'Scan Leaf Now';

  @override
  String get takeOrUploadPhoto => 'Take or upload picture of cashew leaf';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get diseaseLibrary => 'Disease Library';

  @override
  String get scanHistory => 'Scan History';

  @override
  String get treatmentGuide => 'Treatment Guide';

  @override
  String get settings => 'Settings';

  @override
  String get recentScans => 'Recent Scans';

  @override
  String get noScansYet => 'No scan dey yet. Scan leaf make you start.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get scan => 'Scan';

  @override
  String get library => 'Library';

  @override
  String get history => 'History';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get areYouSureLogout => 'You sure say you wan logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get updateYourInfo => 'Update your personal information';

  @override
  String get enhanceSecurity => 'Make your account security betta';

  @override
  String get manageLinkedServices => 'Manage linked services and data';

  @override
  String get notifications => 'Notifications';

  @override
  String get aboutApp => 'About App';

  @override
  String get loggedInAs => 'You don login as ';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email address make we send 6-digit code go you to reset your password.';

  @override
  String get sendResetCode => 'Send Reset Code';

  @override
  String get enterResetCode => 'Enter Reset Code';

  @override
  String get setNewPassword => 'Set New Password';

  @override
  String get chooseNewPasswordSubtitle =>
      'Choose new password for your account.';

  @override
  String get newPassword => 'New Password';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get farmHealthyMessage => 'Your farm dey healthy today.';

  @override
  String get diseasesDetectedMessage =>
      'We don find some diseases. Make you take action!';

  @override
  String get checkScanHistoryDetails => 'Check your scan history for detail';

  @override
  String get view => 'View';

  @override
  String get diseaseLibrarySubtitle => '5 diseases';

  @override
  String get stepByStep => 'Step-by-step';

  @override
  String get preferences => 'Preferences';

  @override
  String diseasesDetectedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Diseases $count Wey We Find',
      one: 'Disease $count Wey We Find',
    );
    return '$_temp0';
  }

  @override
  String scanHistorySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'records $count',
      one: 'record $count',
    );
    return '$_temp0';
  }

  @override
  String get changeProfilePhoto => 'Change Profile Photo';

  @override
  String get takeAPhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get photoUpdatedSuccess => 'Profile photo don update well well';

  @override
  String get diseasesFoundMultiline => 'Diseases\nWey We Find';

  @override
  String get healthyLeavesStat => 'Healthy\nLeaves';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get appPreferencesSection => 'App Preferences';

  @override
  String get notificationsSubtitle => 'Manage AI alerts and field updates';

  @override
  String get aboutAppSubtitle => 'Version 1.0.0 (Stewardship Edition)';

  @override
  String get general => 'General';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get dataAndSecurity => 'Data & Security';

  @override
  String get exportScanData => 'Export Scan Data';

  @override
  String get generatingPdfReport => 'We dey generate PDF report...';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearCacheConfirm =>
      'This go clear all temporary files and cached images. App fit load small slow small until cache rebuild. You wan continue?';

  @override
  String get clear => 'Clear';

  @override
  String get clearingCache => 'We dey clear cache...';

  @override
  String get cacheClearedSuccess => 'Cache don clear well well';

  @override
  String get cacheClearedFailed => 'Cache no clear';

  @override
  String get accountActions => 'Account Actions';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageComingSoonNotice =>
      'App text go remain for English for now — full translation dey come.';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get emailCannotBeChanged => 'You no fit change email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get nameRequired => 'Name na must';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdatedSuccess => 'Profile don update well well';

  @override
  String get passwordRequirementNotice =>
      'Your new password must reach at least 8 characters.';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordRequiredError => 'Password na must';

  @override
  String get passwordMinLengthError =>
      'Password must reach at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords no match';

  @override
  String get passwordChangedSuccess => 'Password don change well well';

  @override
  String get diseaseAlertsTitle => 'Disease Alerts';

  @override
  String get diseaseAlertsSubtitle =>
      'Get alert when disease enter your leaf scan';

  @override
  String get scanRemindersTitle => 'Scan Reminders';

  @override
  String get scanRemindersSubtitle =>
      'Weekly reminder make you scan your cashew leaves';

  @override
  String get treatmentRemindersTitle => 'Treatment Reminders';

  @override
  String get treatmentRemindersSubtitle => 'Reminder to follow treatment steps';

  @override
  String get weeklyReportsTitle => 'Weekly Reports';

  @override
  String get weeklyReportsSubtitle =>
      'Receive weekly summary of your farm scan history';

  @override
  String get appUpdatesTitle => 'App Updates';

  @override
  String get appUpdatesSubtitle =>
      'Get alert about new features and improvements';

  @override
  String notificationsEnabledCount(int enabled, int total) {
    return '$enabled out of $total notifications don enable';
  }

  @override
  String get changesSavedAutomatically => 'Changes dey save automatic';

  @override
  String get notificationPrefsSaved => 'Notification preferences don save';

  @override
  String get turnOffAllNotifications => 'Turn Off All Notifications';

  @override
  String get intelligentCropStewardship => 'Smart Crop Care';

  @override
  String get intelligentStewardship => 'Smart Care';

  @override
  String get missionText =>
      'CashewGuard AI dey join di gap between real agric work and high-tech AI. We build am for cashew farmers and agric people, our platform dey use CNN deep learning model to detect leaf disease and predict how bad e be from phone picture — e dey give you info wey you fit use protect your cashew farm.';

  @override
  String get keyFeatures => 'Main Features';

  @override
  String get featureScanTitle => 'Quick Leaf Scan';

  @override
  String get featureScanDesc =>
      'Take or upload picture make you get AI diagnosis for seconds';

  @override
  String get featureDetectTitle => 'Disease Detection';

  @override
  String get featureDetectDesc =>
      'E dey identify Anthracnose, Gumosis, Leaf Miner, Red Rust and others';

  @override
  String get featureTreatmentTitle => 'Treatment Guide';

  @override
  String get featureTreatmentDesc =>
      'Step-by-step treatment and prevention plan for every diagnosis';

  @override
  String get featureHistoryTitle => 'Scan History';

  @override
  String get featureHistoryDesc =>
      'Track your farm health over time with full diagnosis history';

  @override
  String get featureLanguageTitle => 'Multi-Language Support';

  @override
  String get featureLanguageDesc =>
      'E dey available for English, Yoruba, Hausa, Igbo, Naija Pidgin and French';

  @override
  String get technologyStack => 'Technology Wey We Use';

  @override
  String get techFlutterDesc => 'Mobile App Framework';

  @override
  String get techTensorflowDesc => 'Deep Learning Model';

  @override
  String get techOpencvDesc => 'Image Processing';

  @override
  String get techSupabaseDesc => 'Backend & Authentication';

  @override
  String get techCnnDesc => 'Convolutional Neural Network';

  @override
  String get systemStatus => 'System Status';

  @override
  String get allSystemsOperational => 'Everything Dey Work Fine';

  @override
  String get allRightsReserved => '© 2026 CashewGuard AI. All rights reserved.';

  @override
  String get deleteAccountWarningTitle =>
      'This action na permanent one, e no fit undo. All your data go delete forever.';

  @override
  String get deletionItemProfile => 'Your profile and account information';

  @override
  String get deletionItemScans => 'All your scan records and history';

  @override
  String get deletionItemDiagnosis => 'All AI diagnosis results';

  @override
  String get deletionItemSettings => 'App preferences and settings';

  @override
  String get pleaseConfirm => 'Abeg Confirm';

  @override
  String get confirmDeleteCheck1 =>
      'I understand say all my scan history and diagnosis data go delete forever.';

  @override
  String get confirmDeleteCheck2 =>
      'I understand say dem no fit reverse or recover this action.';

  @override
  String get confirmDeleteCheck3 =>
      'I confirm say I wan delete my CashewGuard AI account forever.';

  @override
  String get verifyYourIdentity => 'Verify Your Identity';

  @override
  String get enterPasswordToConfirm =>
      'Enter your password to confirm say you wan delete account.';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get processing => 'E dey process...';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String get cancelKeepAccount => 'Cancel — Keep My Account';

  @override
  String get needHelpInstead =>
      'You need help instead? Contact support for support@cashewguard.ai before you delete your account.';

  @override
  String get accountDeletedTitle => 'Account Don Delete';

  @override
  String get accountDeletedMessage =>
      'Your account and everything wey connect to am don delete forever. Dem go logout you now.';

  @override
  String get okLogout => 'OK, Logout';

  @override
  String get incorrectPassword => 'Password no correct. Abeg try again.';

  @override
  String get lastUpdated => 'Last update: June 2026';

  @override
  String get goBack => 'Go Back';

  @override
  String get scanLeafTitle => 'Scan Leaf';

  @override
  String get scanInstructionText =>
      'Take clear picture of cashew leaf or upload one from your gallery for AI analysis.';

  @override
  String get positionLeafInFrame => 'Put leaf inside di frame';

  @override
  String get ensureGoodLighting =>
      'Make sure light dey enough for better result';

  @override
  String get tipsForBestResults => 'Tips For Better Result';

  @override
  String get tipDaylight => 'Use natural sunlight if e possible';

  @override
  String get tipFillFrame => 'Make leaf fill di frame';

  @override
  String get tipSteadyCamera => 'Hold camera steady';

  @override
  String get tipBothSides => 'Capture both sides of di leaf';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get uploadFromGallery => 'Upload From Gallery';

  @override
  String get diagnosticHistory => 'Diagnostic History';

  @override
  String get searchDiagnoses => 'Search diagnoses...';

  @override
  String scansCount(int count) {
    return 'Scan $count';
  }

  @override
  String diseasesCount(int count) {
    return 'Disease $count';
  }

  @override
  String healthyCount(int count) {
    return 'Healthy $count';
  }

  @override
  String get noScansYetHistory => 'No scan dey yet';

  @override
  String get noResultsFound => 'No result found';

  @override
  String get scanCashewLeafToStart => 'Scan cashew leaf make you start';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get searchDiseasesHint => 'Search diseases...';

  @override
  String get filterAll => 'All';

  @override
  String get filterFungal => 'Fungal';

  @override
  String get filterPest => 'Pest';

  @override
  String get filterAlgal => 'Algal';

  @override
  String get featuredGuideBadge => 'FEATURED GUIDE';

  @override
  String get preMonsoonTitle => 'Before-Rain Protection Protocol';

  @override
  String get preMonsoonDesc =>
      'Prepare your cashew farm for March, before rain start, make you reduce disease risk well well before di rainy season wey dey come.';

  @override
  String get readFullGuide => 'Read full guide';

  @override
  String get treatmentDetailTitle => 'Seasonal Protection Guide';

  @override
  String get readTimeLabel => '5 min read';

  @override
  String get allCashewLabel => 'All Types';

  @override
  String get expertLevelLabel => 'E Easy For Beginner';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String stepsCount(int completed, int total) {
    return 'step $completed/$total';
  }

  @override
  String get overview => 'Overview';

  @override
  String get preMonsoonOverviewText =>
      'Nigeria cashew belt dey face di highest disease wahala for di year once rain start, wey be normally for April. Anthracnose, Gumosis, and Red Rust all dey do well for warm, humid, wet condition wey dey follow — and by di time symptoms show clear, treatment don already dey follow behind. This guide cover di preparation wey farmers suppose complete for March, before rain start, so your trees fit enter di rainy season with disease wahala wey don already reduce.';

  @override
  String get materialsNeeded => 'Materials Wey You Need';

  @override
  String get materialCopperFungicide =>
      'Copper-based fungicide (like copper oxychloride)';

  @override
  String get materialSulphurSpray =>
      'Sulphur-based spray (for extra fungal coverage)';

  @override
  String get materialSprayer => 'Knapsack or hand sprayer';

  @override
  String get materialGloves => 'Protective gloves and mask';

  @override
  String get materialShears => 'Pruning shears';

  @override
  String get stepByStepGuide => 'Step-by-Step Guide';

  @override
  String get step1Title => 'Check Every Tree';

  @override
  String get step1Desc =>
      'Waka round your farm check every tree for old wound, gum spot, dead wood, and pest damage wey remain from last season. Note which trees go need extra attention once rain start.';

  @override
  String get step1Duration => '15 min/tree';

  @override
  String get step2Title => 'Prune And Clean Am';

  @override
  String get step2Desc =>
      'Remove and burn or bury dead branch, dried fruit, and leaf wey badly infected. Open up di tree top make air fit pass well — thick, shady tree top dey favour Red Rust and fungal spread.';

  @override
  String get step2Duration => '20-30 min/tree';

  @override
  String get step3Title => 'Spray Copper Make E Prevent';

  @override
  String get step3Desc =>
      'Spray copper-based fungicide for di whole tree and directly for any pruning wound before di first heavy rain fall. This one step be di best defense against Anthracnose and Red Rust.';

  @override
  String get step3Duration => '1 day (whole farm)';

  @override
  String get step4Title => 'Improve Drainage';

  @override
  String get step4Desc =>
      'Clear drainage channel round di base of every tree so water no go stay for di trunk. Waterlogged soil na di main cause of Gumosis outbreak.';

  @override
  String get step4Duration => 'Half day';

  @override
  String get step5Title => 'Set Weekly Monitoring Routine';

  @override
  String get step5Desc =>
      'Once rain start, use CashewGuard AI scan your trees every week. May to October na di period wey risk high pass for Anthracnose, Gumosis, and Red Rust — if you catch symptom early e mean say you go treat am before big damage happen.';

  @override
  String get step5Duration => 'Ongoing, every week';

  @override
  String get importantSafetyNote => 'Important Safety Note';

  @override
  String get safetyNoteText =>
      'Always wear gloves and mask when you dey handle fungicide. Avoid spraying for windy day or just before rain, and keep children and animal away from treated trees until di spray don dry well well.';

  @override
  String get markAllStepsComplete => 'Mark All Steps Complete';

  @override
  String get treatmentGuideCompleted =>
      'Good work — you don complete di seasonal protection protocol!';

  @override
  String get completed => 'E Don Complete';

  @override
  String get diseaseDetailTitle => 'Disease Detail';

  @override
  String get severityLabel => 'HOW BAD E BE';

  @override
  String get optimalTempLabel => 'BEST TEMPERATURE';

  @override
  String get humidityLabel => 'HUMIDITY';

  @override
  String get spreadRateLabel => 'HOW E DEY SPREAD';

  @override
  String get targetLabel => 'TARGET';

  @override
  String get aboutDiseasePrefix => 'About ';

  @override
  String get observedSymptoms => 'Symptoms Wey We See';

  @override
  String get preventionProtocol => 'Prevention Plan';

  @override
  String get activeTreatment => 'Treatment Wey Dey Work';

  @override
  String get recommendedTreatmentLabel => 'TREATMENT WEY WE RECOMMEND';

  @override
  String get biologicalControlLabel => 'BIOLOGICAL CONTROL';

  @override
  String get applicationWindowLabel => 'WHEN TO APPLY';

  @override
  String get cashewGuardInsight => 'CashewGuard Insight';

  @override
  String get logAction => 'Log Action';

  @override
  String get scanAgain => 'Scan Again';

  @override
  String get diagnosisDetailTitle => 'Diagnosis Detail';

  @override
  String get infectedAreaLabel => 'Infected Area';

  @override
  String get confidenceLabel => 'Confidence';

  @override
  String get modelUsedLabel => 'Model Wey We Use';

  @override
  String get severityBreakdown => 'How Bad E Be Breakdown';

  @override
  String get infectedLabel => 'E Infected';

  @override
  String get healthyAreaLabel => 'Healthy Area';

  @override
  String get infectedAreaBarLabel => 'Infected Area';

  @override
  String get riskLevelLabel => 'Risk Level';

  @override
  String get favourableConditionsLabel => 'Conditions Wey Support Am';

  @override
  String get spreadRateInfoLabel => 'How E Dey Spread';

  @override
  String get pathogenLabel => 'Pathogen';

  @override
  String get recommendedTreatment => 'Treatment Wey We Recommend';

  @override
  String get viewFullTreatmentGuide => 'View Full Treatment Guide';

  @override
  String get scanAnotherLeaf => 'Scan Another Leaf';

  @override
  String get imagePreviewTitle => 'Image Preview';

  @override
  String get imageDetails => 'Image Details';

  @override
  String get formatLabel => 'Format';

  @override
  String get lightingLabel => 'Lighting';

  @override
  String get lightingGood => 'Good';

  @override
  String get focusLabel => 'Focus';

  @override
  String get focusSharp => 'Sharp';

  @override
  String get statusLabel => 'Status';

  @override
  String get imageLoaded => 'Image don load';

  @override
  String get noImage => 'No image';

  @override
  String get checkingImage => 'We dey check image...';

  @override
  String get readyForAnalysis => 'Ready for Analysis';

  @override
  String get verifyingLeaf => 'We dey verify say na cashew leaf be dis...';

  @override
  String get imageWillBeValidated => 'Dem go validate image before analysis.';

  @override
  String get validating => 'E dey validate...';

  @override
  String get preparing => 'E dey prepare...';

  @override
  String get analyseThisLeaf => 'Analyse This Leaf';

  @override
  String get retakePhoto => 'Retake Photo';

  @override
  String get notCashewLeafTitle => 'Na Not Cashew Leaf';

  @override
  String get notCashewLeafMessage =>
      'This one no look like cashew leaf. Abeg upload clear picture of cashew leaf.';

  @override
  String get tryAnotherImage => 'Try Another Image';

  @override
  String get noImageFoundError => 'No image dey. Abeg try again.';

  @override
  String get cashewLeafSample => 'Cashew Leaf Sample';

  @override
  String get scanResultTitle => 'Scan Result';

  @override
  String get healthyLeafCheckmark => 'Healthy Leaf ✓';

  @override
  String get diseaseDetectedSuffix => ' Wey We Find';

  @override
  String get severitySuffix => ' Severity';

  @override
  String get confidenceSuffix => '% Confidence';

  @override
  String get severityLevel => 'Severity Level';

  @override
  String get infectedLabelResult => 'E Infected';

  @override
  String get healthyBadge => 'Healthy';

  @override
  String get mildBadge => 'Small';

  @override
  String get moderateBadge => 'Medium';

  @override
  String get severeBadge => 'Bad Well Well';

  @override
  String get detectionDetails => 'Detection Details';

  @override
  String get diseaseTypeLabel => 'Disease Type';

  @override
  String get pathogenLabelResult => 'Pathogen';

  @override
  String get pathogenNone => 'None';

  @override
  String get leafAreaAffectedLabel => 'Leaf Area Wey Affected';

  @override
  String get scanTimeLabel => 'Scan Time';

  @override
  String get modelUsedLabelResult => 'Model Wey We Use';

  @override
  String get leafIsHealthy => 'Leaf Dey Healthy';

  @override
  String get immediateActionRequired => 'You Need Take Action Now Now';

  @override
  String get viewFullDiagnosis => 'View Full Diagnosis';

  @override
  String get viewTreatmentGuide => 'View Treatment Guide';

  @override
  String get scanAnotherLeafResult => 'Scan Another Leaf';

  @override
  String get notCashewLeafBody =>
      'Di image wey you upload no be cashew leaf. Abeg upload clear picture wey get better light of cashew leaf for correct disease detection.';

  @override
  String get tipsForBetterResults => 'Tips For Better Result';

  @override
  String get tipUploadClearPhoto => 'Upload clear picture of cashew leaf';

  @override
  String get tipGoodLighting => 'Make sure natural light dey good';

  @override
  String get tipFillFrameResult => 'Make leaf fill di frame';

  @override
  String get tipAvoidBlurry => 'Avoid blur or dark picture';

  @override
  String get scanAgainButton => 'Scan Again';

  @override
  String get goToDashboard => 'Go Dashboard';

  @override
  String get serverStartingUp => 'Server Dey Start Up';

  @override
  String get serverWakingUpMessage =>
      'Di AI server been dey sleep and e dey wake up now. Abeg wait like 30 seconds try again.';

  @override
  String get serverIdleInfo =>
      'This dey happen when server don idle. E dey normally take 30–60 seconds wake up. Your next scan go fast.';

  @override
  String get tryAgainButton => 'Try Again';

  @override
  String get skip => 'Skip';

  @override
  String get onboardStep01 => 'STEP 01';

  @override
  String get onboardStep02 => 'STEP 02';

  @override
  String get onboardStep03 => 'STEP 03';

  @override
  String get onboardTitle1 => 'Detect Disease\nSharp Sharp';

  @override
  String get onboardSubtitle1 =>
      'Point your camera go any cashew leaf and our AI go identify disease within seconds.';

  @override
  String get onboardFeature1a => 'Result within 3 seconds';

  @override
  String get onboardFeature1b => 'E dey work even without internet for farm';

  @override
  String get onboardFeature1c => '95%+ detection accuracy';

  @override
  String get onboardTitle2 => 'Analyse How Bad\nE Be';

  @override
  String get onboardSubtitle2 =>
      'Get correct infection severity score from Healthy to Severe.';

  @override
  String get onboardFeature2a => 'Percentage infection score';

  @override
  String get onboardFeature2b => 'Disease progression tracking';

  @override
  String get onboardFeature2c => 'CNN deep learning model';

  @override
  String get onboardTitle3 => 'Get Treatment\nGuide';

  @override
  String get onboardSubtitle3 =>
      'Receive treatment recommendation wey go work for disease wey we detect.';

  @override
  String get onboardFeature3a => 'Advice wey suit di crop';

  @override
  String get onboardFeature3b => 'Alert wey come on time';

  @override
  String get onboardFeature3c => 'Full disease library';

  @override
  String get nextButton => 'Next';

  @override
  String get getStartedButton => 'Start Now';
}
