import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_ig.dart';
import 'app_localizations_pcm.dart';
import 'app_localizations_yo.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ha'),
    Locale('ig'),
    Locale('pcm'),
    Locale('yo')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CashewGuard AI'**
  String get appName;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue monitoring your cashew farm.'**
  String get signInToContinue;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinCashewGuard.
  ///
  /// In en, this message translates to:
  /// **'Join CashewGuard AI and start protecting your farm today.'**
  String get joinCashewGuard;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToTerms;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @weSentCodeTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to '**
  String get weSentCodeTo;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @didntGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code? '**
  String get didntGetCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @checkSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find the code? Please check your Spam or Junk folder — it sometimes ends up there.'**
  String get checkSpamFolder;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening,'**
  String get goodEvening;

  /// No description provided for @totalScans.
  ///
  /// In en, this message translates to:
  /// **'Total Scans'**
  String get totalScans;

  /// No description provided for @diseasesFound.
  ///
  /// In en, this message translates to:
  /// **'Diseases Found'**
  String get diseasesFound;

  /// No description provided for @healthyScans.
  ///
  /// In en, this message translates to:
  /// **'Healthy Scans'**
  String get healthyScans;

  /// No description provided for @scanLeafNow.
  ///
  /// In en, this message translates to:
  /// **'Scan a Leaf Now'**
  String get scanLeafNow;

  /// No description provided for @takeOrUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take or upload a cashew leaf photo'**
  String get takeOrUploadPhoto;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @diseaseLibrary.
  ///
  /// In en, this message translates to:
  /// **'Disease Library'**
  String get diseaseLibrary;

  /// No description provided for @scanHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistory;

  /// No description provided for @treatmentGuide.
  ///
  /// In en, this message translates to:
  /// **'Treatment Guide'**
  String get treatmentGuide;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// No description provided for @noScansYet.
  ///
  /// In en, this message translates to:
  /// **'No scans yet. Scan a leaf to get started.'**
  String get noScansYet;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureLogout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @updateYourInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updateYourInfo;

  /// No description provided for @enhanceSecurity.
  ///
  /// In en, this message translates to:
  /// **'Enhance your account security'**
  String get enhanceSecurity;

  /// No description provided for @manageLinkedServices.
  ///
  /// In en, this message translates to:
  /// **'Manage linked services and data'**
  String get manageLinkedServices;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @loggedInAs.
  ///
  /// In en, this message translates to:
  /// **'Logged in as '**
  String get loggedInAs;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a 6-digit code to reset your password.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get sendResetCode;

  /// No description provided for @enterResetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Reset Code'**
  String get enterResetCode;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @chooseNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your account.'**
  String get chooseNewPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @farmHealthyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your farm is looking healthy today.'**
  String get farmHealthyMessage;

  /// No description provided for @diseasesDetectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Some diseases detected. Take action!'**
  String get diseasesDetectedMessage;

  /// No description provided for @checkScanHistoryDetails.
  ///
  /// In en, this message translates to:
  /// **'Check your scan history for details'**
  String get checkScanHistoryDetails;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @diseaseLibrarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'5 diseases'**
  String get diseaseLibrarySubtitle;

  /// No description provided for @stepByStep.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step'**
  String get stepByStep;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @diseasesDetectedTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} Disease Detected} other {{count} Diseases Detected}}'**
  String diseasesDetectedTitle(int count);

  /// No description provided for @scanHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} record} other {{count} records}}'**
  String scanHistorySubtitle(int count);

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get changeProfilePhoto;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takeAPhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @photoUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully'**
  String get photoUpdatedSuccess;

  /// No description provided for @diseasesFoundMultiline.
  ///
  /// In en, this message translates to:
  /// **'Diseases\nFound'**
  String get diseasesFoundMultiline;

  /// No description provided for @healthyLeavesStat.
  ///
  /// In en, this message translates to:
  /// **'Healthy\nLeaves'**
  String get healthyLeavesStat;

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// No description provided for @appPreferencesSection.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferencesSection;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control AI alerts and field updates'**
  String get notificationsSubtitle;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0 (Stewardship Edition)'**
  String get aboutAppSubtitle;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dataAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data & Security'**
  String get dataAndSecurity;

  /// No description provided for @exportScanData.
  ///
  /// In en, this message translates to:
  /// **'Export Scan Data'**
  String get exportScanData;

  /// No description provided for @generatingPdfReport.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF report...'**
  String get generatingPdfReport;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will clear all temporary files and cached images. The app may load slightly slower until cache rebuilds. Continue?'**
  String get clearCacheConfirm;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearingCache.
  ///
  /// In en, this message translates to:
  /// **'Clearing cache...'**
  String get clearingCache;

  /// No description provided for @cacheClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheClearedSuccess;

  /// No description provided for @cacheClearedFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear cache'**
  String get cacheClearedFailed;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'Account Actions'**
  String get accountActions;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageComingSoonNotice.
  ///
  /// In en, this message translates to:
  /// **'App text will remain in English for now — full translation is coming soon.'**
  String get languageComingSoonNotice;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @emailCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed'**
  String get emailCannotBeChanged;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @passwordRequirementNotice.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be at least 8 characters long.'**
  String get passwordRequirementNotice;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequiredError;

  /// No description provided for @passwordMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLengthError;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccess;

  /// No description provided for @diseaseAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Disease Alerts'**
  String get diseaseAlertsTitle;

  /// No description provided for @diseaseAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified when a disease is detected on your leaf scan'**
  String get diseaseAlertsSubtitle;

  /// No description provided for @scanRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Reminders'**
  String get scanRemindersTitle;

  /// No description provided for @scanRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly reminders to scan your cashew leaves'**
  String get scanRemindersSubtitle;

  /// No description provided for @treatmentRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment Reminders'**
  String get treatmentRemindersTitle;

  /// No description provided for @treatmentRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders to follow up on treatment steps'**
  String get treatmentRemindersSubtitle;

  /// No description provided for @weeklyReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Reports'**
  String get weeklyReportsTitle;

  /// No description provided for @weeklyReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive a weekly summary of your farm scan history'**
  String get weeklyReportsSubtitle;

  /// No description provided for @appUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'App Updates'**
  String get appUpdatesTitle;

  /// No description provided for @appUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be notified about new features and improvements'**
  String get appUpdatesSubtitle;

  /// No description provided for @notificationsEnabledCount.
  ///
  /// In en, this message translates to:
  /// **'{enabled} of {total} notifications enabled'**
  String notificationsEnabledCount(int enabled, int total);

  /// No description provided for @changesSavedAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Changes are saved automatically'**
  String get changesSavedAutomatically;

  /// No description provided for @notificationPrefsSaved.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences saved'**
  String get notificationPrefsSaved;

  /// No description provided for @turnOffAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Turn Off All Notifications'**
  String get turnOffAllNotifications;

  /// No description provided for @intelligentCropStewardship.
  ///
  /// In en, this message translates to:
  /// **'Intelligent Crop Stewardship'**
  String get intelligentCropStewardship;

  /// No description provided for @intelligentStewardship.
  ///
  /// In en, this message translates to:
  /// **'Intelligent Stewardship'**
  String get intelligentStewardship;

  /// No description provided for @missionText.
  ///
  /// In en, this message translates to:
  /// **'CashewGuard AI bridges the gap between raw agricultural productivity and high-tech artificial intelligence. Designed for cashew farmers and agricultural practitioners, our platform uses Convolutional Neural Network (CNN) deep learning models to detect leaf diseases and predict severity levels from smartphone images — providing actionable insights for the preservation of cashew plantation health.'**
  String get missionText;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @featureScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Instant Leaf Scanning'**
  String get featureScanTitle;

  /// No description provided for @featureScanDesc.
  ///
  /// In en, this message translates to:
  /// **'Take or upload a photo and get an AI diagnosis in seconds'**
  String get featureScanDesc;

  /// No description provided for @featureDetectTitle.
  ///
  /// In en, this message translates to:
  /// **'Disease Detection'**
  String get featureDetectTitle;

  /// No description provided for @featureDetectDesc.
  ///
  /// In en, this message translates to:
  /// **'Identifies Anthracnose, Gumosis, Leaf Miner, Red Rust and more'**
  String get featureDetectDesc;

  /// No description provided for @featureTreatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment Guidance'**
  String get featureTreatmentTitle;

  /// No description provided for @featureTreatmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step treatment and prevention protocols for every diagnosis'**
  String get featureTreatmentDesc;

  /// No description provided for @featureHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get featureHistoryTitle;

  /// No description provided for @featureHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your farm\'s health over time with a full diagnostic history'**
  String get featureHistoryDesc;

  /// No description provided for @featureLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Multilingual Support'**
  String get featureLanguageTitle;

  /// No description provided for @featureLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Available in English, Yoruba, Hausa, Igbo, Nigerian Pidgin and French'**
  String get featureLanguageDesc;

  /// No description provided for @technologyStack.
  ///
  /// In en, this message translates to:
  /// **'Technology Stack'**
  String get technologyStack;

  /// No description provided for @techFlutterDesc.
  ///
  /// In en, this message translates to:
  /// **'Mobile Application Framework'**
  String get techFlutterDesc;

  /// No description provided for @techTensorflowDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep Learning Model'**
  String get techTensorflowDesc;

  /// No description provided for @techOpencvDesc.
  ///
  /// In en, this message translates to:
  /// **'Image Processing'**
  String get techOpencvDesc;

  /// No description provided for @techSupabaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Backend & Authentication'**
  String get techSupabaseDesc;

  /// No description provided for @techCnnDesc.
  ///
  /// In en, this message translates to:
  /// **'Convolutional Neural Network'**
  String get techCnnDesc;

  /// No description provided for @systemStatus.
  ///
  /// In en, this message translates to:
  /// **'System Status'**
  String get systemStatus;

  /// No description provided for @allSystemsOperational.
  ///
  /// In en, this message translates to:
  /// **'All Systems Operational'**
  String get allSystemsOperational;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'© 2026 CashewGuard AI. All rights reserved.'**
  String get allRightsReserved;

  /// No description provided for @deleteAccountWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. All your data will be permanently erased.'**
  String get deleteAccountWarningTitle;

  /// No description provided for @deletionItemProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile and account information'**
  String get deletionItemProfile;

  /// No description provided for @deletionItemScans.
  ///
  /// In en, this message translates to:
  /// **'All your scan records and history'**
  String get deletionItemScans;

  /// No description provided for @deletionItemDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'All AI diagnosis results'**
  String get deletionItemDiagnosis;

  /// No description provided for @deletionItemSettings.
  ///
  /// In en, this message translates to:
  /// **'App preferences and settings'**
  String get deletionItemSettings;

  /// No description provided for @pleaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please Confirm'**
  String get pleaseConfirm;

  /// No description provided for @confirmDeleteCheck1.
  ///
  /// In en, this message translates to:
  /// **'I understand that all my scan history and diagnosis data will be permanently deleted.'**
  String get confirmDeleteCheck1;

  /// No description provided for @confirmDeleteCheck2.
  ///
  /// In en, this message translates to:
  /// **'I understand that this action cannot be reversed or recovered.'**
  String get confirmDeleteCheck2;

  /// No description provided for @confirmDeleteCheck3.
  ///
  /// In en, this message translates to:
  /// **'I confirm that I want to permanently delete my CashewGuard AI account.'**
  String get confirmDeleteCheck3;

  /// No description provided for @verifyYourIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Identity'**
  String get verifyYourIdentity;

  /// No description provided for @enterPasswordToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm account deletion.'**
  String get enterPasswordToConfirm;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteMyAccount;

  /// No description provided for @cancelKeepAccount.
  ///
  /// In en, this message translates to:
  /// **'Cancel — Keep My Account'**
  String get cancelKeepAccount;

  /// No description provided for @needHelpInstead.
  ///
  /// In en, this message translates to:
  /// **'Need help instead? Contact support at support@cashewguard.ai before deleting your account.'**
  String get needHelpInstead;

  /// No description provided for @accountDeletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted'**
  String get accountDeletedTitle;

  /// No description provided for @accountDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account and all associated data have been permanently deleted. You will be logged out now.'**
  String get accountDeletedMessage;

  /// No description provided for @okLogout.
  ///
  /// In en, this message translates to:
  /// **'OK, Logout'**
  String get okLogout;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get incorrectPassword;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: June 2026'**
  String get lastUpdated;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @scanLeafTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Leaf'**
  String get scanLeafTitle;

  /// No description provided for @scanInstructionText.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of a cashew leaf or upload one from your gallery for AI analysis.'**
  String get scanInstructionText;

  /// No description provided for @positionLeafInFrame.
  ///
  /// In en, this message translates to:
  /// **'Position leaf in frame'**
  String get positionLeafInFrame;

  /// No description provided for @ensureGoodLighting.
  ///
  /// In en, this message translates to:
  /// **'Ensure good lighting for best results'**
  String get ensureGoodLighting;

  /// No description provided for @tipsForBestResults.
  ///
  /// In en, this message translates to:
  /// **'Tips for Best Results'**
  String get tipsForBestResults;

  /// No description provided for @tipDaylight.
  ///
  /// In en, this message translates to:
  /// **'Use natural daylight when possible'**
  String get tipDaylight;

  /// No description provided for @tipFillFrame.
  ///
  /// In en, this message translates to:
  /// **'Fill the frame with the leaf'**
  String get tipFillFrame;

  /// No description provided for @tipSteadyCamera.
  ///
  /// In en, this message translates to:
  /// **'Keep the camera steady'**
  String get tipSteadyCamera;

  /// No description provided for @tipBothSides.
  ///
  /// In en, this message translates to:
  /// **'Capture both sides of the leaf'**
  String get tipBothSides;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @uploadFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Upload from Gallery'**
  String get uploadFromGallery;

  /// No description provided for @diagnosticHistory.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic History'**
  String get diagnosticHistory;

  /// No description provided for @searchDiagnoses.
  ///
  /// In en, this message translates to:
  /// **'Search diagnoses...'**
  String get searchDiagnoses;

  /// No description provided for @scansCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Scans'**
  String scansCount(int count);

  /// No description provided for @diseasesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Diseases'**
  String diseasesCount(int count);

  /// No description provided for @healthyCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Healthy'**
  String healthyCount(int count);

  /// No description provided for @noScansYetHistory.
  ///
  /// In en, this message translates to:
  /// **'No scans yet'**
  String get noScansYetHistory;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @scanCashewLeafToStart.
  ///
  /// In en, this message translates to:
  /// **'Scan a cashew leaf to get started'**
  String get scanCashewLeafToStart;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @searchDiseasesHint.
  ///
  /// In en, this message translates to:
  /// **'Search diseases...'**
  String get searchDiseasesHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterFungal.
  ///
  /// In en, this message translates to:
  /// **'Fungal'**
  String get filterFungal;

  /// No description provided for @filterPest.
  ///
  /// In en, this message translates to:
  /// **'Pest'**
  String get filterPest;

  /// No description provided for @filterAlgal.
  ///
  /// In en, this message translates to:
  /// **'Algal'**
  String get filterAlgal;

  /// No description provided for @featuredGuideBadge.
  ///
  /// In en, this message translates to:
  /// **'FEATURED GUIDE'**
  String get featuredGuideBadge;

  /// No description provided for @preMonsoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-Rainy Season Protection Protocol'**
  String get preMonsoonTitle;

  /// No description provided for @preMonsoonDesc.
  ///
  /// In en, this message translates to:
  /// **'Prepare your cashew farm in March, before the rains begin, to sharply cut disease risk through the wet season ahead.'**
  String get preMonsoonDesc;

  /// No description provided for @readFullGuide.
  ///
  /// In en, this message translates to:
  /// **'Read full guide'**
  String get readFullGuide;

  /// No description provided for @treatmentDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Protection Guide'**
  String get treatmentDetailTitle;

  /// No description provided for @readTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'5 min read'**
  String get readTimeLabel;

  /// No description provided for @allCashewLabel.
  ///
  /// In en, this message translates to:
  /// **'All Varieties'**
  String get allCashewLabel;

  /// No description provided for @expertLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Beginner Friendly'**
  String get expertLevelLabel;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @stepsCount.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} steps'**
  String stepsCount(int completed, int total);

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @preMonsoonOverviewText.
  ///
  /// In en, this message translates to:
  /// **'Nigeria\'s cashew belt faces its highest disease pressure of the year once the rains begin, typically in April. Anthracnose, Gumosis, and Red Rust all thrive in the warm, humid, wet conditions that follow and by the time symptoms are obvious, treatment is playing catch-up. This guide covers the preparation farmers should complete in March, before the rains start, so your trees enter the wet season with disease pressure already reduced.'**
  String get preMonsoonOverviewText;

  /// No description provided for @materialsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Materials Needed'**
  String get materialsNeeded;

  /// No description provided for @materialCopperFungicide.
  ///
  /// In en, this message translates to:
  /// **'Copper-based fungicide (e.g. copper oxychloride)'**
  String get materialCopperFungicide;

  /// No description provided for @materialSulphurSpray.
  ///
  /// In en, this message translates to:
  /// **'Sulphur-based spray (for additional fungal coverage)'**
  String get materialSulphurSpray;

  /// No description provided for @materialSprayer.
  ///
  /// In en, this message translates to:
  /// **'Knapsack or hand sprayer'**
  String get materialSprayer;

  /// No description provided for @materialGloves.
  ///
  /// In en, this message translates to:
  /// **'Protective gloves and mask'**
  String get materialGloves;

  /// No description provided for @materialShears.
  ///
  /// In en, this message translates to:
  /// **'Pruning shears'**
  String get materialShears;

  /// No description provided for @stepByStepGuide.
  ///
  /// In en, this message translates to:
  /// **'Step-by-Step Guide'**
  String get stepByStepGuide;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Inspect Every Tree'**
  String get step1Title;

  /// No description provided for @step1Desc.
  ///
  /// In en, this message translates to:
  /// **'Walk your farm and check each tree for old lesions, gum spots, dead wood, and leftover pest damage from last season. Note which trees will need extra attention once the rains start.'**
  String get step1Desc;

  /// No description provided for @step1Duration.
  ///
  /// In en, this message translates to:
  /// **'15 min/tree'**
  String get step1Duration;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Prune and Sanitize'**
  String get step2Title;

  /// No description provided for @step2Desc.
  ///
  /// In en, this message translates to:
  /// **'Remove and burn or bury dead branches, mummified fruits, and heavily infected leaves. Open up the canopy for better airflow — dense, shaded canopies favor Red Rust and fungal spread.'**
  String get step2Desc;

  /// No description provided for @step2Duration.
  ///
  /// In en, this message translates to:
  /// **'20-30 min/tree'**
  String get step2Duration;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Apply Preventive Copper Spray'**
  String get step3Title;

  /// No description provided for @step3Desc.
  ///
  /// In en, this message translates to:
  /// **'Spray a copper-based fungicide across the canopy and directly on any pruning wounds before the first heavy rains fall. This single step is the most effective defense against Anthracnose and Red Rust.'**
  String get step3Desc;

  /// No description provided for @step3Duration.
  ///
  /// In en, this message translates to:
  /// **'1 day (whole farm)'**
  String get step3Duration;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Improve Drainage'**
  String get step4Title;

  /// No description provided for @step4Desc.
  ///
  /// In en, this message translates to:
  /// **'Clear drainage channels around the base of each tree so water cannot pool at the trunk. Waterlogged soil is the leading cause of Gumosis outbreaks.'**
  String get step4Desc;

  /// No description provided for @step4Duration.
  ///
  /// In en, this message translates to:
  /// **'Half day'**
  String get step4Duration;

  /// No description provided for @step5Title.
  ///
  /// In en, this message translates to:
  /// **'Set a Weekly Monitoring Routine'**
  String get step5Title;

  /// No description provided for @step5Desc.
  ///
  /// In en, this message translates to:
  /// **'Once the rains begin, scan your trees weekly with CashewGuard AI. May through October is peak risk season for Anthracnose, Gumosis, and Red Rust — catching symptoms early means treating before major damage is done.'**
  String get step5Desc;

  /// No description provided for @step5Duration.
  ///
  /// In en, this message translates to:
  /// **'Ongoing, weekly'**
  String get step5Duration;

  /// No description provided for @importantSafetyNote.
  ///
  /// In en, this message translates to:
  /// **'Important Safety Note'**
  String get importantSafetyNote;

  /// No description provided for @safetyNoteText.
  ///
  /// In en, this message translates to:
  /// **'Always wear gloves and a mask when handling fungicides. Avoid spraying on windy days or right before rain, and keep children and livestock away from treated trees until the spray has fully dried.'**
  String get safetyNoteText;

  /// No description provided for @markAllStepsComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark All Steps Complete'**
  String get markAllStepsComplete;

  /// No description provided for @treatmentGuideCompleted.
  ///
  /// In en, this message translates to:
  /// **'Great work — you\'ve completed the seasonal protection protocol!'**
  String get treatmentGuideCompleted;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @diseaseDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Disease Detail'**
  String get diseaseDetailTitle;

  /// No description provided for @severityLabel.
  ///
  /// In en, this message translates to:
  /// **'SEVERITY'**
  String get severityLabel;

  /// No description provided for @optimalTempLabel.
  ///
  /// In en, this message translates to:
  /// **'OPTIMAL TEMP'**
  String get optimalTempLabel;

  /// No description provided for @humidityLabel.
  ///
  /// In en, this message translates to:
  /// **'HUMIDITY'**
  String get humidityLabel;

  /// No description provided for @spreadRateLabel.
  ///
  /// In en, this message translates to:
  /// **'SPREAD RATE'**
  String get spreadRateLabel;

  /// No description provided for @targetLabel.
  ///
  /// In en, this message translates to:
  /// **'TARGET'**
  String get targetLabel;

  /// No description provided for @aboutDiseasePrefix.
  ///
  /// In en, this message translates to:
  /// **'About '**
  String get aboutDiseasePrefix;

  /// No description provided for @observedSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Observed Symptoms'**
  String get observedSymptoms;

  /// No description provided for @preventionProtocol.
  ///
  /// In en, this message translates to:
  /// **'Prevention Protocol'**
  String get preventionProtocol;

  /// No description provided for @activeTreatment.
  ///
  /// In en, this message translates to:
  /// **'Active Treatment'**
  String get activeTreatment;

  /// No description provided for @recommendedTreatmentLabel.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED TREATMENT'**
  String get recommendedTreatmentLabel;

  /// No description provided for @biologicalControlLabel.
  ///
  /// In en, this message translates to:
  /// **'BIOLOGICAL CONTROL'**
  String get biologicalControlLabel;

  /// No description provided for @applicationWindowLabel.
  ///
  /// In en, this message translates to:
  /// **'APPLICATION WINDOW'**
  String get applicationWindowLabel;

  /// No description provided for @cashewGuardInsight.
  ///
  /// In en, this message translates to:
  /// **'CashewGuard Insight'**
  String get cashewGuardInsight;

  /// No description provided for @logAction.
  ///
  /// In en, this message translates to:
  /// **'Log Action'**
  String get logAction;

  /// No description provided for @scanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scanAgain;

  /// No description provided for @diagnosisDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis Detail'**
  String get diagnosisDetailTitle;

  /// No description provided for @infectedAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Infected Area'**
  String get infectedAreaLabel;

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidenceLabel;

  /// No description provided for @modelUsedLabel.
  ///
  /// In en, this message translates to:
  /// **'Model Used'**
  String get modelUsedLabel;

  /// No description provided for @severityBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Severity Breakdown'**
  String get severityBreakdown;

  /// No description provided for @infectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Infected'**
  String get infectedLabel;

  /// No description provided for @healthyAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Healthy Area'**
  String get healthyAreaLabel;

  /// No description provided for @infectedAreaBarLabel.
  ///
  /// In en, this message translates to:
  /// **'Infected Area'**
  String get infectedAreaBarLabel;

  /// No description provided for @riskLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get riskLevelLabel;

  /// No description provided for @favourableConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Favourable Conditions'**
  String get favourableConditionsLabel;

  /// No description provided for @spreadRateInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Spread Rate'**
  String get spreadRateInfoLabel;

  /// No description provided for @pathogenLabel.
  ///
  /// In en, this message translates to:
  /// **'Pathogen'**
  String get pathogenLabel;

  /// No description provided for @recommendedTreatment.
  ///
  /// In en, this message translates to:
  /// **'Recommended Treatment'**
  String get recommendedTreatment;

  /// No description provided for @viewFullTreatmentGuide.
  ///
  /// In en, this message translates to:
  /// **'View Full Treatment Guide'**
  String get viewFullTreatmentGuide;

  /// No description provided for @scanAnotherLeaf.
  ///
  /// In en, this message translates to:
  /// **'Scan Another Leaf'**
  String get scanAnotherLeaf;

  /// No description provided for @imagePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Image Preview'**
  String get imagePreviewTitle;

  /// No description provided for @imageDetails.
  ///
  /// In en, this message translates to:
  /// **'Image Details'**
  String get imageDetails;

  /// No description provided for @formatLabel.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get formatLabel;

  /// No description provided for @lightingLabel.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get lightingLabel;

  /// No description provided for @lightingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get lightingGood;

  /// No description provided for @focusLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusLabel;

  /// No description provided for @focusSharp.
  ///
  /// In en, this message translates to:
  /// **'Sharp'**
  String get focusSharp;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @imageLoaded.
  ///
  /// In en, this message translates to:
  /// **'Image loaded'**
  String get imageLoaded;

  /// No description provided for @noImage.
  ///
  /// In en, this message translates to:
  /// **'No image'**
  String get noImage;

  /// No description provided for @checkingImage.
  ///
  /// In en, this message translates to:
  /// **'Checking Image...'**
  String get checkingImage;

  /// No description provided for @readyForAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Ready for Analysis'**
  String get readyForAnalysis;

  /// No description provided for @verifyingLeaf.
  ///
  /// In en, this message translates to:
  /// **'Verifying this is a cashew leaf...'**
  String get verifyingLeaf;

  /// No description provided for @imageWillBeValidated.
  ///
  /// In en, this message translates to:
  /// **'Image will be validated before analysis.'**
  String get imageWillBeValidated;

  /// No description provided for @validating.
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get validating;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get preparing;

  /// No description provided for @analyseThisLeaf.
  ///
  /// In en, this message translates to:
  /// **'Analyse This Leaf'**
  String get analyseThisLeaf;

  /// No description provided for @retakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Retake Photo'**
  String get retakePhoto;

  /// No description provided for @notCashewLeafTitle.
  ///
  /// In en, this message translates to:
  /// **'Not a Cashew Leaf'**
  String get notCashewLeafTitle;

  /// No description provided for @notCashewLeafMessage.
  ///
  /// In en, this message translates to:
  /// **'This does not appear to be a cashew leaf. Please upload a clear photo of a cashew leaf.'**
  String get notCashewLeafMessage;

  /// No description provided for @tryAnotherImage.
  ///
  /// In en, this message translates to:
  /// **'Try Another Image'**
  String get tryAnotherImage;

  /// No description provided for @noImageFoundError.
  ///
  /// In en, this message translates to:
  /// **'No image found. Please try again.'**
  String get noImageFoundError;

  /// No description provided for @cashewLeafSample.
  ///
  /// In en, this message translates to:
  /// **'Cashew Leaf Sample'**
  String get cashewLeafSample;

  /// No description provided for @scanResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get scanResultTitle;

  /// No description provided for @healthyLeafCheckmark.
  ///
  /// In en, this message translates to:
  /// **'Healthy Leaf ✓'**
  String get healthyLeafCheckmark;

  /// No description provided for @diseaseDetectedSuffix.
  ///
  /// In en, this message translates to:
  /// **' Detected'**
  String get diseaseDetectedSuffix;

  /// No description provided for @severitySuffix.
  ///
  /// In en, this message translates to:
  /// **' Severity'**
  String get severitySuffix;

  /// No description provided for @confidenceSuffix.
  ///
  /// In en, this message translates to:
  /// **'% Confidence'**
  String get confidenceSuffix;

  /// No description provided for @severityLevel.
  ///
  /// In en, this message translates to:
  /// **'Severity Level'**
  String get severityLevel;

  /// No description provided for @infectedLabelResult.
  ///
  /// In en, this message translates to:
  /// **'Infected'**
  String get infectedLabelResult;

  /// No description provided for @healthyBadge.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthyBadge;

  /// No description provided for @mildBadge.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get mildBadge;

  /// No description provided for @moderateBadge.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderateBadge;

  /// No description provided for @severeBadge.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get severeBadge;

  /// No description provided for @detectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Detection Details'**
  String get detectionDetails;

  /// No description provided for @diseaseTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Disease Type'**
  String get diseaseTypeLabel;

  /// No description provided for @pathogenLabelResult.
  ///
  /// In en, this message translates to:
  /// **'Pathogen'**
  String get pathogenLabelResult;

  /// No description provided for @pathogenNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get pathogenNone;

  /// No description provided for @leafAreaAffectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Leaf Area Affected'**
  String get leafAreaAffectedLabel;

  /// No description provided for @scanTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan Time'**
  String get scanTimeLabel;

  /// No description provided for @modelUsedLabelResult.
  ///
  /// In en, this message translates to:
  /// **'Model Used'**
  String get modelUsedLabelResult;

  /// No description provided for @leafIsHealthy.
  ///
  /// In en, this message translates to:
  /// **'Leaf is Healthy'**
  String get leafIsHealthy;

  /// No description provided for @immediateActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Immediate Action Required'**
  String get immediateActionRequired;

  /// No description provided for @viewFullDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'View Full Diagnosis'**
  String get viewFullDiagnosis;

  /// No description provided for @viewTreatmentGuide.
  ///
  /// In en, this message translates to:
  /// **'View Treatment Guide'**
  String get viewTreatmentGuide;

  /// No description provided for @scanAnotherLeafResult.
  ///
  /// In en, this message translates to:
  /// **'Scan Another Leaf'**
  String get scanAnotherLeafResult;

  /// No description provided for @notCashewLeafBody.
  ///
  /// In en, this message translates to:
  /// **'The image you uploaded does not appear to be a cashew leaf. Please upload a clear, well-lit photo of a cashew leaf for accurate disease detection.'**
  String get notCashewLeafBody;

  /// No description provided for @tipsForBetterResults.
  ///
  /// In en, this message translates to:
  /// **'Tips for Better Results'**
  String get tipsForBetterResults;

  /// No description provided for @tipUploadClearPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear photo of a cashew leaf'**
  String get tipUploadClearPhoto;

  /// No description provided for @tipGoodLighting.
  ///
  /// In en, this message translates to:
  /// **'Ensure good natural lighting'**
  String get tipGoodLighting;

  /// No description provided for @tipFillFrameResult.
  ///
  /// In en, this message translates to:
  /// **'Fill the frame with the leaf'**
  String get tipFillFrameResult;

  /// No description provided for @tipAvoidBlurry.
  ///
  /// In en, this message translates to:
  /// **'Avoid blurry or dark images'**
  String get tipAvoidBlurry;

  /// No description provided for @scanAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scanAgainButton;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @serverStartingUp.
  ///
  /// In en, this message translates to:
  /// **'Server is Starting Up'**
  String get serverStartingUp;

  /// No description provided for @serverWakingUpMessage.
  ///
  /// In en, this message translates to:
  /// **'The AI server was asleep and is now waking up. Please wait about 30 seconds and try again.'**
  String get serverWakingUpMessage;

  /// No description provided for @serverIdleInfo.
  ///
  /// In en, this message translates to:
  /// **'This happens when the server has been idle. It usually takes 30–60 seconds to wake up. Your next scan will be fast.'**
  String get serverIdleInfo;

  /// No description provided for @tryAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgainButton;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @onboardStep01.
  ///
  /// In en, this message translates to:
  /// **'STEP 01'**
  String get onboardStep01;

  /// No description provided for @onboardStep02.
  ///
  /// In en, this message translates to:
  /// **'STEP 02'**
  String get onboardStep02;

  /// No description provided for @onboardStep03.
  ///
  /// In en, this message translates to:
  /// **'STEP 03'**
  String get onboardStep03;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Detect Diseases\nInstantly'**
  String get onboardTitle1;

  /// No description provided for @onboardSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at any cashew leaf and our AI will identify diseases within seconds.'**
  String get onboardSubtitle1;

  /// No description provided for @onboardFeature1a.
  ///
  /// In en, this message translates to:
  /// **'Results in under 3 seconds'**
  String get onboardFeature1a;

  /// No description provided for @onboardFeature1b.
  ///
  /// In en, this message translates to:
  /// **'Works offline in the field'**
  String get onboardFeature1b;

  /// No description provided for @onboardFeature1c.
  ///
  /// In en, this message translates to:
  /// **'95%+ detection accuracy'**
  String get onboardFeature1c;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Analyse Severity\nLevels'**
  String get onboardTitle2;

  /// No description provided for @onboardSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Get precise infection severity scores from Healthy to Severe.'**
  String get onboardSubtitle2;

  /// No description provided for @onboardFeature2a.
  ///
  /// In en, this message translates to:
  /// **'Percentage infection score'**
  String get onboardFeature2a;

  /// No description provided for @onboardFeature2b.
  ///
  /// In en, this message translates to:
  /// **'Disease progression tracking'**
  String get onboardFeature2b;

  /// No description provided for @onboardFeature2c.
  ///
  /// In en, this message translates to:
  /// **'CNN deep learning model'**
  String get onboardFeature2c;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Get Treatment\nGuidance'**
  String get onboardTitle3;

  /// No description provided for @onboardSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Receive actionable treatment recommendations for detected diseases.'**
  String get onboardSubtitle3;

  /// No description provided for @onboardFeature3a.
  ///
  /// In en, this message translates to:
  /// **'Crop-specific advice'**
  String get onboardFeature3a;

  /// No description provided for @onboardFeature3b.
  ///
  /// In en, this message translates to:
  /// **'Timely intervention alerts'**
  String get onboardFeature3b;

  /// No description provided for @onboardFeature3c.
  ///
  /// In en, this message translates to:
  /// **'Full disease library'**
  String get onboardFeature3c;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'fr',
        'ha',
        'ig',
        'pcm',
        'yo'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ha':
      return AppLocalizationsHa();
    case 'ig':
      return AppLocalizationsIg();
    case 'pcm':
      return AppLocalizationsPcm();
    case 'yo':
      return AppLocalizationsYo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
