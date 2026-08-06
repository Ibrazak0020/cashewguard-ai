// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CashewGuard AI';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue =>
      'Sign in to continue monitoring your cashew farm.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

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
      'Join CashewGuard AI and start protecting your farm today.';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get agreeToTerms => 'I agree to the ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get verifyYourEmail => 'Verify Your Email';

  @override
  String get weSentCodeTo => 'We sent a 6-digit code to ';

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get didntGetCode => 'Didn\'t get the code? ';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get checkSpamFolder =>
      'Can\'t find the code? Please check your Spam or Junk folder — it sometimes ends up there.';

  @override
  String get goodMorning => 'Good Morning,';

  @override
  String get goodAfternoon => 'Good Afternoon,';

  @override
  String get goodEvening => 'Good Evening,';

  @override
  String get totalScans => 'Total Scans';

  @override
  String get diseasesFound => 'Diseases Found';

  @override
  String get healthyScans => 'Healthy Scans';

  @override
  String get scanLeafNow => 'Scan a Leaf Now';

  @override
  String get takeOrUploadPhoto => 'Take or upload a cashew leaf photo';

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
  String get noScansYet => 'No scans yet. Scan a leaf to get started.';

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
  String get areYouSureLogout => 'Are you sure you want to logout?';

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
  String get enhanceSecurity => 'Enhance your account security';

  @override
  String get manageLinkedServices => 'Manage linked services and data';

  @override
  String get notifications => 'Notifications';

  @override
  String get aboutApp => 'About App';

  @override
  String get loggedInAs => 'Logged in as ';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email address and we\'ll send you a 6-digit code to reset your password.';

  @override
  String get sendResetCode => 'Send Reset Code';

  @override
  String get enterResetCode => 'Enter Reset Code';

  @override
  String get setNewPassword => 'Set New Password';

  @override
  String get chooseNewPasswordSubtitle =>
      'Choose a new password for your account.';

  @override
  String get newPassword => 'New Password';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get farmHealthyMessage => 'Your farm is looking healthy today.';

  @override
  String get diseasesDetectedMessage => 'Some diseases detected. Take action!';

  @override
  String get checkScanHistoryDetails => 'Check your scan history for details';

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
      other: '$count Diseases Detected',
      one: '$count Disease Detected',
    );
    return '$_temp0';
  }

  @override
  String scanHistorySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '$count record',
    );
    return '$_temp0';
  }

  @override
  String get changeProfilePhoto => 'Change Profile Photo';

  @override
  String get takeAPhoto => 'Take a Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get photoUpdatedSuccess => 'Profile photo updated successfully';

  @override
  String get diseasesFoundMultiline => 'Diseases\nFound';

  @override
  String get healthyLeavesStat => 'Healthy\nLeaves';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get appPreferencesSection => 'App Preferences';

  @override
  String get notificationsSubtitle => 'Control AI alerts and field updates';

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
  String get generatingPdfReport => 'Generating PDF report...';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearCacheConfirm =>
      'This will clear all temporary files and cached images. The app may load slightly slower until cache rebuilds. Continue?';

  @override
  String get clear => 'Clear';

  @override
  String get clearingCache => 'Clearing cache...';

  @override
  String get cacheClearedSuccess => 'Cache cleared successfully';

  @override
  String get cacheClearedFailed => 'Failed to clear cache';

  @override
  String get accountActions => 'Account Actions';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageComingSoonNotice =>
      'App text will remain in English for now — full translation is coming soon.';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get emailCannotBeChanged => 'Email cannot be changed';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String get passwordRequirementNotice =>
      'Your new password must be at least 8 characters long.';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordRequiredError => 'Password is required';

  @override
  String get passwordMinLengthError => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String get diseaseAlertsTitle => 'Disease Alerts';

  @override
  String get diseaseAlertsSubtitle =>
      'Get notified when a disease is detected on your leaf scan';

  @override
  String get scanRemindersTitle => 'Scan Reminders';

  @override
  String get scanRemindersSubtitle =>
      'Weekly reminders to scan your cashew leaves';

  @override
  String get treatmentRemindersTitle => 'Treatment Reminders';

  @override
  String get treatmentRemindersSubtitle =>
      'Reminders to follow up on treatment steps';

  @override
  String get weeklyReportsTitle => 'Weekly Reports';

  @override
  String get weeklyReportsSubtitle =>
      'Receive a weekly summary of your farm scan history';

  @override
  String get appUpdatesTitle => 'App Updates';

  @override
  String get appUpdatesSubtitle =>
      'Be notified about new features and improvements';

  @override
  String notificationsEnabledCount(int enabled, int total) {
    return '$enabled of $total notifications enabled';
  }

  @override
  String get changesSavedAutomatically => 'Changes are saved automatically';

  @override
  String get notificationPrefsSaved => 'Notification preferences saved';

  @override
  String get turnOffAllNotifications => 'Turn Off All Notifications';

  @override
  String get intelligentCropStewardship => 'Intelligent Crop Stewardship';

  @override
  String get intelligentStewardship => 'Intelligent Stewardship';

  @override
  String get missionText =>
      'CashewGuard AI bridges the gap between raw agricultural productivity and high-tech artificial intelligence. Designed for cashew farmers and agricultural practitioners, our platform uses Convolutional Neural Network (CNN) deep learning models to detect leaf diseases and predict severity levels from smartphone images — providing actionable insights for the preservation of cashew plantation health.';

  @override
  String get keyFeatures => 'Key Features';

  @override
  String get featureScanTitle => 'Instant Leaf Scanning';

  @override
  String get featureScanDesc =>
      'Take or upload a photo and get an AI diagnosis in seconds';

  @override
  String get featureDetectTitle => 'Disease Detection';

  @override
  String get featureDetectDesc =>
      'Identifies Anthracnose, Gumosis, Leaf Miner, Red Rust and more';

  @override
  String get featureTreatmentTitle => 'Treatment Guidance';

  @override
  String get featureTreatmentDesc =>
      'Step-by-step treatment and prevention protocols for every diagnosis';

  @override
  String get featureHistoryTitle => 'Scan History';

  @override
  String get featureHistoryDesc =>
      'Track your farm\'s health over time with a full diagnostic history';

  @override
  String get featureLanguageTitle => 'Multilingual Support';

  @override
  String get featureLanguageDesc =>
      'Available in English, Yoruba, Hausa, Igbo, Nigerian Pidgin and French';

  @override
  String get technologyStack => 'Technology Stack';

  @override
  String get techFlutterDesc => 'Mobile Application Framework';

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
  String get allSystemsOperational => 'All Systems Operational';

  @override
  String get allRightsReserved => '© 2026 CashewGuard AI. All rights reserved.';

  @override
  String get deleteAccountWarningTitle =>
      'This action is permanent and cannot be undone. All your data will be permanently erased.';

  @override
  String get deletionItemProfile => 'Your profile and account information';

  @override
  String get deletionItemScans => 'All your scan records and history';

  @override
  String get deletionItemDiagnosis => 'All AI diagnosis results';

  @override
  String get deletionItemSettings => 'App preferences and settings';

  @override
  String get pleaseConfirm => 'Please Confirm';

  @override
  String get confirmDeleteCheck1 =>
      'I understand that all my scan history and diagnosis data will be permanently deleted.';

  @override
  String get confirmDeleteCheck2 =>
      'I understand that this action cannot be reversed or recovered.';

  @override
  String get confirmDeleteCheck3 =>
      'I confirm that I want to permanently delete my CashewGuard AI account.';

  @override
  String get verifyYourIdentity => 'Verify Your Identity';

  @override
  String get enterPasswordToConfirm =>
      'Enter your password to confirm account deletion.';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get processing => 'Processing...';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String get cancelKeepAccount => 'Cancel — Keep My Account';

  @override
  String get needHelpInstead =>
      'Need help instead? Contact support at support@cashewguard.ai before deleting your account.';

  @override
  String get accountDeletedTitle => 'Account Deleted';

  @override
  String get accountDeletedMessage =>
      'Your account and all associated data have been permanently deleted. You will be logged out now.';

  @override
  String get okLogout => 'OK, Logout';

  @override
  String get incorrectPassword => 'Incorrect password. Please try again.';

  @override
  String get lastUpdated => 'Last updated: June 2026';

  @override
  String get goBack => 'Go Back';

  @override
  String get scanLeafTitle => 'Scan Leaf';

  @override
  String get scanInstructionText =>
      'Take a clear photo of a cashew leaf or upload one from your gallery for AI analysis.';

  @override
  String get positionLeafInFrame => 'Position leaf in frame';

  @override
  String get ensureGoodLighting => 'Ensure good lighting for best results';

  @override
  String get tipsForBestResults => 'Tips for Best Results';

  @override
  String get tipDaylight => 'Use natural daylight when possible';

  @override
  String get tipFillFrame => 'Fill the frame with the leaf';

  @override
  String get tipSteadyCamera => 'Keep the camera steady';

  @override
  String get tipBothSides => 'Capture both sides of the leaf';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get uploadFromGallery => 'Upload from Gallery';

  @override
  String get diagnosticHistory => 'Diagnostic History';

  @override
  String get searchDiagnoses => 'Search diagnoses...';

  @override
  String scansCount(int count) {
    return '$count Scans';
  }

  @override
  String diseasesCount(int count) {
    return '$count Diseases';
  }

  @override
  String healthyCount(int count) {
    return '$count Healthy';
  }

  @override
  String get noScansYetHistory => 'No scans yet';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get scanCashewLeafToStart => 'Scan a cashew leaf to get started';

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
  String get preMonsoonTitle => 'Pre-Rainy Season Protection Protocol';

  @override
  String get preMonsoonDesc =>
      'Prepare your cashew farm in March, before the rains begin, to sharply cut disease risk through the wet season ahead.';

  @override
  String get readFullGuide => 'Read full guide';

  @override
  String get treatmentDetailTitle => 'Seasonal Protection Guide';

  @override
  String get readTimeLabel => '5 min read';

  @override
  String get allCashewLabel => 'All Varieties';

  @override
  String get expertLevelLabel => 'Beginner Friendly';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String stepsCount(int completed, int total) {
    return '$completed/$total steps';
  }

  @override
  String get overview => 'Overview';

  @override
  String get preMonsoonOverviewText =>
      'Nigeria\'s cashew belt faces its highest disease pressure of the year once the rains begin, typically in April. Anthracnose, Gumosis, and Red Rust all thrive in the warm, humid, wet conditions that follow and by the time symptoms are obvious, treatment is playing catch-up. This guide covers the preparation farmers should complete in March, before the rains start, so your trees enter the wet season with disease pressure already reduced.';

  @override
  String get materialsNeeded => 'Materials Needed';

  @override
  String get materialCopperFungicide =>
      'Copper-based fungicide (e.g. copper oxychloride)';

  @override
  String get materialSulphurSpray =>
      'Sulphur-based spray (for additional fungal coverage)';

  @override
  String get materialSprayer => 'Knapsack or hand sprayer';

  @override
  String get materialGloves => 'Protective gloves and mask';

  @override
  String get materialShears => 'Pruning shears';

  @override
  String get stepByStepGuide => 'Step-by-Step Guide';

  @override
  String get step1Title => 'Inspect Every Tree';

  @override
  String get step1Desc =>
      'Walk your farm and check each tree for old lesions, gum spots, dead wood, and leftover pest damage from last season. Note which trees will need extra attention once the rains start.';

  @override
  String get step1Duration => '15 min/tree';

  @override
  String get step2Title => 'Prune and Sanitize';

  @override
  String get step2Desc =>
      'Remove and burn or bury dead branches, mummified fruits, and heavily infected leaves. Open up the canopy for better airflow — dense, shaded canopies favor Red Rust and fungal spread.';

  @override
  String get step2Duration => '20-30 min/tree';

  @override
  String get step3Title => 'Apply Preventive Copper Spray';

  @override
  String get step3Desc =>
      'Spray a copper-based fungicide across the canopy and directly on any pruning wounds before the first heavy rains fall. This single step is the most effective defense against Anthracnose and Red Rust.';

  @override
  String get step3Duration => '1 day (whole farm)';

  @override
  String get step4Title => 'Improve Drainage';

  @override
  String get step4Desc =>
      'Clear drainage channels around the base of each tree so water cannot pool at the trunk. Waterlogged soil is the leading cause of Gumosis outbreaks.';

  @override
  String get step4Duration => 'Half day';

  @override
  String get step5Title => 'Set a Weekly Monitoring Routine';

  @override
  String get step5Desc =>
      'Once the rains begin, scan your trees weekly with CashewGuard AI. May through October is peak risk season for Anthracnose, Gumosis, and Red Rust — catching symptoms early means treating before major damage is done.';

  @override
  String get step5Duration => 'Ongoing, weekly';

  @override
  String get importantSafetyNote => 'Important Safety Note';

  @override
  String get safetyNoteText =>
      'Always wear gloves and a mask when handling fungicides. Avoid spraying on windy days or right before rain, and keep children and livestock away from treated trees until the spray has fully dried.';

  @override
  String get markAllStepsComplete => 'Mark All Steps Complete';

  @override
  String get treatmentGuideCompleted =>
      'Great work — you\'ve completed the seasonal protection protocol!';

  @override
  String get completed => 'Completed';

  @override
  String get diseaseDetailTitle => 'Disease Detail';

  @override
  String get severityLabel => 'SEVERITY';

  @override
  String get optimalTempLabel => 'OPTIMAL TEMP';

  @override
  String get humidityLabel => 'HUMIDITY';

  @override
  String get spreadRateLabel => 'SPREAD RATE';

  @override
  String get targetLabel => 'TARGET';

  @override
  String get aboutDiseasePrefix => 'About ';

  @override
  String get observedSymptoms => 'Observed Symptoms';

  @override
  String get preventionProtocol => 'Prevention Protocol';

  @override
  String get activeTreatment => 'Active Treatment';

  @override
  String get recommendedTreatmentLabel => 'RECOMMENDED TREATMENT';

  @override
  String get biologicalControlLabel => 'BIOLOGICAL CONTROL';

  @override
  String get applicationWindowLabel => 'APPLICATION WINDOW';

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
  String get modelUsedLabel => 'Model Used';

  @override
  String get severityBreakdown => 'Severity Breakdown';

  @override
  String get infectedLabel => 'Infected';

  @override
  String get healthyAreaLabel => 'Healthy Area';

  @override
  String get infectedAreaBarLabel => 'Infected Area';

  @override
  String get riskLevelLabel => 'Risk Level';

  @override
  String get favourableConditionsLabel => 'Favourable Conditions';

  @override
  String get spreadRateInfoLabel => 'Spread Rate';

  @override
  String get pathogenLabel => 'Pathogen';

  @override
  String get recommendedTreatment => 'Recommended Treatment';

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
  String get imageLoaded => 'Image loaded';

  @override
  String get noImage => 'No image';

  @override
  String get checkingImage => 'Checking Image...';

  @override
  String get readyForAnalysis => 'Ready for Analysis';

  @override
  String get verifyingLeaf => 'Verifying this is a cashew leaf...';

  @override
  String get imageWillBeValidated => 'Image will be validated before analysis.';

  @override
  String get validating => 'Validating...';

  @override
  String get preparing => 'Preparing...';

  @override
  String get analyseThisLeaf => 'Analyse This Leaf';

  @override
  String get retakePhoto => 'Retake Photo';

  @override
  String get notCashewLeafTitle => 'Not a Cashew Leaf';

  @override
  String get notCashewLeafMessage =>
      'This does not appear to be a cashew leaf. Please upload a clear photo of a cashew leaf.';

  @override
  String get tryAnotherImage => 'Try Another Image';

  @override
  String get noImageFoundError => 'No image found. Please try again.';

  @override
  String get cashewLeafSample => 'Cashew Leaf Sample';

  @override
  String get scanResultTitle => 'Scan Result';

  @override
  String get healthyLeafCheckmark => 'Healthy Leaf ✓';

  @override
  String get diseaseDetectedSuffix => ' Detected';

  @override
  String get severitySuffix => ' Severity';

  @override
  String get confidenceSuffix => '% Confidence';

  @override
  String get severityLevel => 'Severity Level';

  @override
  String get infectedLabelResult => 'Infected';

  @override
  String get healthyBadge => 'Healthy';

  @override
  String get mildBadge => 'Mild';

  @override
  String get moderateBadge => 'Moderate';

  @override
  String get severeBadge => 'Severe';

  @override
  String get detectionDetails => 'Detection Details';

  @override
  String get diseaseTypeLabel => 'Disease Type';

  @override
  String get pathogenLabelResult => 'Pathogen';

  @override
  String get pathogenNone => 'None';

  @override
  String get leafAreaAffectedLabel => 'Leaf Area Affected';

  @override
  String get scanTimeLabel => 'Scan Time';

  @override
  String get modelUsedLabelResult => 'Model Used';

  @override
  String get leafIsHealthy => 'Leaf is Healthy';

  @override
  String get immediateActionRequired => 'Immediate Action Required';

  @override
  String get viewFullDiagnosis => 'View Full Diagnosis';

  @override
  String get viewTreatmentGuide => 'View Treatment Guide';

  @override
  String get scanAnotherLeafResult => 'Scan Another Leaf';

  @override
  String get notCashewLeafBody =>
      'The image you uploaded does not appear to be a cashew leaf. Please upload a clear, well-lit photo of a cashew leaf for accurate disease detection.';

  @override
  String get tipsForBetterResults => 'Tips for Better Results';

  @override
  String get tipUploadClearPhoto => 'Upload a clear photo of a cashew leaf';

  @override
  String get tipGoodLighting => 'Ensure good natural lighting';

  @override
  String get tipFillFrameResult => 'Fill the frame with the leaf';

  @override
  String get tipAvoidBlurry => 'Avoid blurry or dark images';

  @override
  String get scanAgainButton => 'Scan Again';

  @override
  String get goToDashboard => 'Go to Dashboard';

  @override
  String get serverStartingUp => 'Server is Starting Up';

  @override
  String get serverWakingUpMessage =>
      'The AI server was asleep and is now waking up. Please wait about 30 seconds and try again.';

  @override
  String get serverIdleInfo =>
      'This happens when the server has been idle. It usually takes 30–60 seconds to wake up. Your next scan will be fast.';

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
  String get onboardTitle1 => 'Detect Diseases\nInstantly';

  @override
  String get onboardSubtitle1 =>
      'Point your camera at any cashew leaf and our AI will identify diseases within seconds.';

  @override
  String get onboardFeature1a => 'Results in under 3 seconds';

  @override
  String get onboardFeature1b => 'Works offline in the field';

  @override
  String get onboardFeature1c => '95%+ detection accuracy';

  @override
  String get onboardTitle2 => 'Analyse Severity\nLevels';

  @override
  String get onboardSubtitle2 =>
      'Get precise infection severity scores from Healthy to Severe.';

  @override
  String get onboardFeature2a => 'Percentage infection score';

  @override
  String get onboardFeature2b => 'Disease progression tracking';

  @override
  String get onboardFeature2c => 'CNN deep learning model';

  @override
  String get onboardTitle3 => 'Get Treatment\nGuidance';

  @override
  String get onboardSubtitle3 =>
      'Receive actionable treatment recommendations for detected diseases.';

  @override
  String get onboardFeature3a => 'Crop-specific advice';

  @override
  String get onboardFeature3b => 'Timely intervention alerts';

  @override
  String get onboardFeature3c => 'Full disease library';

  @override
  String get nextButton => 'Next';

  @override
  String get getStartedButton => 'Get Started';
}
