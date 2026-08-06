// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hausa (`ha`).
class AppLocalizationsHa extends AppLocalizations {
  AppLocalizationsHa([String locale = 'ha']) : super(locale);

  @override
  String get appName => 'CashewGuard AI';

  @override
  String get welcomeBack => 'Barka da Dawowa';

  @override
  String get signInToContinue =>
      'Shiga don ci gaba da sa ido kan gonar cashew ɗinka.';

  @override
  String get emailAddress => 'Adireshin Imel';

  @override
  String get password => 'Kalmar Sirri';

  @override
  String get forgotPassword => 'Ka manta da Kalmar Sirri?';

  @override
  String get signIn => 'Shiga';

  @override
  String get or => 'KO';

  @override
  String get createNewAccount => 'Ƙirƙiri Sabon Asusu';

  @override
  String get createAccount => 'Ƙirƙiri Asusu';

  @override
  String get joinCashewGuard =>
      'Shiga CashewGuard AI kuma ka fara kare gonarka a yau.';

  @override
  String get fullName => 'Cikakken Suna';

  @override
  String get confirmPassword => 'Tabbatar da Kalmar Sirri';

  @override
  String get agreeToTerms => 'Na yarda da ';

  @override
  String get termsOfService => 'Sharuɗɗan Sabis';

  @override
  String get and => ' da ';

  @override
  String get privacyPolicy => 'Manufar Sirri';

  @override
  String get alreadyHaveAccount => 'Kana da asusu tuni? ';

  @override
  String get verifyYourEmail => 'Tabbatar da Imel ɗinka';

  @override
  String get weSentCodeTo => 'Mun aika lambar lamba shida zuwa ';

  @override
  String get verifyEmail => 'Tabbatar da Imel';

  @override
  String get didntGetCode => 'Ba ka samu lambar ba? ';

  @override
  String get resendCode => 'Sake Aika Lamba';

  @override
  String get checkSpamFolder =>
      'Ba ka samu lambar ba? Da fatan za ka duba fayil ɗin Spam ko Junk — wani lokaci yakan shiga can.';

  @override
  String get goodMorning => 'Ina kwana,';

  @override
  String get goodAfternoon => 'Ina wuni,';

  @override
  String get goodEvening => 'Ina yamma,';

  @override
  String get totalScans => 'Jimillar Dubawa';

  @override
  String get diseasesFound => 'Cututtukan da Aka Samu';

  @override
  String get healthyScans => 'Dubawa Lafiyayye';

  @override
  String get scanLeafNow => 'Duba Ganye Yanzu';

  @override
  String get takeOrUploadPhoto => 'Ɗauki ko ɗora hoton ganyen cashew';

  @override
  String get quickActions => 'Ayyuka Masu Sauri';

  @override
  String get diseaseLibrary => 'Ɗakin Karatun Cuta';

  @override
  String get scanHistory => 'Tarihin Dubawa';

  @override
  String get treatmentGuide => 'Jagorar Magani';

  @override
  String get settings => 'Saituna';

  @override
  String get recentScans => 'Dubawar Kwanan Nan';

  @override
  String get noScansYet => 'Babu dubawa tukuna. Duba ganye don farawa.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get scan => 'Duba';

  @override
  String get library => 'Ɗakin Karatu';

  @override
  String get history => 'Tarihi';

  @override
  String get profile => 'Bayani';

  @override
  String get logout => 'Fita';

  @override
  String get areYouSureLogout => 'Ka tabbata kana son fita?';

  @override
  String get cancel => 'Soke';

  @override
  String get editProfile => 'Gyara Bayani';

  @override
  String get changePassword => 'Canza Kalmar Sirri';

  @override
  String get accountSettings => 'Saitunan Asusu';

  @override
  String get updateYourInfo => 'Sabunta bayanan ka';

  @override
  String get enhanceSecurity => 'Ƙara tsaron asusunka';

  @override
  String get manageLinkedServices => 'Sarrafa ayyuka da bayanan da aka haɗa';

  @override
  String get notifications => 'Sanarwa';

  @override
  String get aboutApp => 'Game da Manhaja';

  @override
  String get loggedInAs => 'An shiga a matsayin ';

  @override
  String get forgotPasswordSubtitle =>
      'Shigar da adireshin imel ɗinka kuma za mu aika maka lambar lamba shida don sake saita kalmar sirrinka.';

  @override
  String get sendResetCode => 'Aika Lambar Sake Saitawa';

  @override
  String get enterResetCode => 'Shigar da Lambar Sake Saitawa';

  @override
  String get setNewPassword => 'Saita Sabuwar Kalmar Sirri';

  @override
  String get chooseNewPasswordSubtitle =>
      'Zaɓi sabuwar kalmar sirri don asusunka.';

  @override
  String get newPassword => 'Sabuwar Kalmar Sirri';

  @override
  String get verifyCode => 'Tabbatar da Lamba';

  @override
  String get updatePassword => 'Sabunta Kalmar Sirri';

  @override
  String get farmHealthyMessage => 'Gonarka tana da lafiya yau.';

  @override
  String get diseasesDetectedMessage =>
      'An sami wasu cututtuka. Ka ɗauki mataki!';

  @override
  String get checkScanHistoryDetails =>
      'Duba tarihin dubawarka don ƙarin bayani';

  @override
  String get view => 'Duba';

  @override
  String get diseaseLibrarySubtitle => 'cututtuka biyar';

  @override
  String get stepByStep => 'Mataki-bi-mataki';

  @override
  String get preferences => 'Zaɓuɓɓuka';

  @override
  String diseasesDetectedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'An Sami Cututtuka $count',
      one: 'An Sami Cuta $count',
    );
    return '$_temp0';
  }

  @override
  String scanHistorySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'rikodin $count',
      one: 'rikodin $count',
    );
    return '$_temp0';
  }

  @override
  String get changeProfilePhoto => 'Canza Hoton Bayani';

  @override
  String get takeAPhoto => 'Ɗauki Hoto';

  @override
  String get chooseFromGallery => 'Zaɓa Daga Hotuna';

  @override
  String get removePhoto => 'Cire Hoto';

  @override
  String get photoUpdatedSuccess => 'An sabunta hoton bayani cikin nasara';

  @override
  String get diseasesFoundMultiline => 'Cututtukan\nDa Aka Samu';

  @override
  String get healthyLeavesStat => 'Ganyayen\nLafiyayye';

  @override
  String get accountManagement => 'Sarrafa Asusu';

  @override
  String get appPreferencesSection => 'Zaɓuɓɓukan Manhaja';

  @override
  String get notificationsSubtitle =>
      'Sarrafa faɗakarwar AI da sabuntawar gona';

  @override
  String get aboutAppSubtitle => 'Sigar 1.0.0 (Fitowar Kulawa)';

  @override
  String get general => 'Gaba Ɗaya';

  @override
  String get privacySettings => 'Saitunan Sirri';

  @override
  String get notificationSettings => 'Saitunan Sanarwa';

  @override
  String get darkMode => 'Yanayin Duhu';

  @override
  String get language => 'Harshe';

  @override
  String get dataAndSecurity => 'Bayanai da Tsaro';

  @override
  String get exportScanData => 'Fitar da Bayanan Dubawa';

  @override
  String get generatingPdfReport => 'Ana ƙirƙirar rahoton PDF...';

  @override
  String get clearCache => 'Share Cache';

  @override
  String get clearCacheConfirm =>
      'Wannan zai share duk fayilolin ɗan lokaci da hotunan da aka adana. Manhajar na iya ɗan jinkirin lodi har sai cache ya sake ginuwa. Ci gaba?';

  @override
  String get clear => 'Share';

  @override
  String get clearingCache => 'Ana share cache...';

  @override
  String get cacheClearedSuccess => 'An share cache cikin nasara';

  @override
  String get cacheClearedFailed => 'An kasa share cache';

  @override
  String get accountActions => 'Ayyukan Asusu';

  @override
  String get deleteAccount => 'Share Asusu';

  @override
  String get selectLanguage => 'Zaɓi Harshe';

  @override
  String get languageComingSoonNotice =>
      'Rubutun manhaja zai kasance a Turanci a yanzu — cikakken fassara na zuwa.';

  @override
  String get personalInformation => 'Bayanan Sirri';

  @override
  String get emailCannotBeChanged => 'Ba za a iya canza imel ba';

  @override
  String get phoneNumber => 'Lambar Waya';

  @override
  String get nameRequired => 'Ana buƙatar suna';

  @override
  String get saveChanges => 'Ajiye Canje-canje';

  @override
  String get profileUpdatedSuccess => 'An sabunta bayanin cikin nasara';

  @override
  String get passwordRequirementNotice =>
      'Sabuwar kalmar sirrinka dole ta kai aƙalla haruffa takwas.';

  @override
  String get confirmNewPassword => 'Tabbatar da Sabuwar Kalmar Sirri';

  @override
  String get passwordRequiredError => 'Ana buƙatar kalmar sirri';

  @override
  String get passwordMinLengthError =>
      'Kalmar sirri dole ta kai aƙalla haruffa takwas';

  @override
  String get passwordsDoNotMatch => 'Kalmomin sirri ba su dace ba';

  @override
  String get passwordChangedSuccess => 'An canza kalmar sirri cikin nasara';

  @override
  String get diseaseAlertsTitle => 'Faɗakarwar Cuta';

  @override
  String get diseaseAlertsSubtitle =>
      'Sami sanarwa idan an gano cuta a dubawar ganyenka';

  @override
  String get scanRemindersTitle => 'Tunatarwar Dubawa';

  @override
  String get scanRemindersSubtitle =>
      'Tunatarwa ta mako-mako don duba ganyayen cashew ɗinka';

  @override
  String get treatmentRemindersTitle => 'Tunatarwar Magani';

  @override
  String get treatmentRemindersSubtitle => 'Tunatarwa don bin matakan magani';

  @override
  String get weeklyReportsTitle => 'Rahoton Mako-mako';

  @override
  String get weeklyReportsSubtitle =>
      'Karɓi taƙaitaccen rahoton mako-mako na tarihin dubawar gonarka';

  @override
  String get appUpdatesTitle => 'Sabuntawar Manhaja';

  @override
  String get appUpdatesSubtitle =>
      'A sanar da kai game da sabbin fasaloli da haɓakawa';

  @override
  String notificationsEnabledCount(int enabled, int total) {
    return '$enabled daga cikin $total sanarwa an kunna';
  }

  @override
  String get changesSavedAutomatically => 'Ana ajiye canje-canje ta atomatik';

  @override
  String get notificationPrefsSaved => 'An ajiye zaɓuɓɓukan sanarwa';

  @override
  String get turnOffAllNotifications => 'Kashe Duk Sanarwa';

  @override
  String get intelligentCropStewardship => 'Kulawar Amfanin Gona Mai Hankali';

  @override
  String get intelligentStewardship => 'Kulawa Mai Hankali';

  @override
  String get missionText =>
      'CashewGuard AI yana haɗa gibin da ke tsakanin ainihin aikin gona da fasahar basirar wucin gadi mai zurfi. An ƙera shi don manoman cashew da masu aikin gona, dandalinmu yana amfani da samfuran koyo mai zurfi na Convolutional Neural Network (CNN) don gano cututtukan ganye da hango matakan tsanani daga hotunan waya — yana ba da haske mai amfani don kiyaye lafiyar gonar cashew.';

  @override
  String get keyFeatures => 'Manyan Fasaloli';

  @override
  String get featureScanTitle => 'Duba Ganye Nan Take';

  @override
  String get featureScanDesc =>
      'Ɗauki ko ɗora hoto ka sami ganewar AI cikin daƙiƙa';

  @override
  String get featureDetectTitle => 'Gano Cuta';

  @override
  String get featureDetectDesc =>
      'Yana gano Anthracnose, Gumosis, Leaf Miner, Red Rust da sauransu';

  @override
  String get featureTreatmentTitle => 'Jagorar Magani';

  @override
  String get featureTreatmentDesc =>
      'Jagororin magani da rigakafi mataki-bi-mataki don kowace ganewa';

  @override
  String get featureHistoryTitle => 'Tarihin Dubawa';

  @override
  String get featureHistoryDesc =>
      'Bibiyi lafiyar gonarka akan lokaci tare da cikakken tarihin dubawa';

  @override
  String get featureLanguageTitle => 'Tallafin Harsuna Da Yawa';

  @override
  String get featureLanguageDesc =>
      'Ana samu a Turanci, Yoruba, Hausa, Igbo, Pidgin na Najeriya da Faransanci';

  @override
  String get technologyStack => 'Fasahar Da Ake Amfani Da Ita';

  @override
  String get techFlutterDesc => 'Tsarin Manhajar Waya';

  @override
  String get techTensorflowDesc => 'Samfurin Koyo Mai Zurfi';

  @override
  String get techOpencvDesc => 'Sarrafa Hoto';

  @override
  String get techSupabaseDesc => 'Baya da Tabbatarwa';

  @override
  String get techCnnDesc => 'Convolutional Neural Network';

  @override
  String get systemStatus => 'Yanayin Tsarin';

  @override
  String get allSystemsOperational => 'Duk Tsarin Yana Aiki';

  @override
  String get allRightsReserved =>
      '© 2026 CashewGuard AI. Duk haƙƙin an tanada.';

  @override
  String get deleteAccountWarningTitle =>
      'Wannan aikin na dindindin ne kuma ba za a iya juyawa ba. Duk bayananka za a share su har abada.';

  @override
  String get deletionItemProfile => 'Bayanan bayanin ka da asusu';

  @override
  String get deletionItemScans => 'Duk bayanan dubawarka da tarihi';

  @override
  String get deletionItemDiagnosis => 'Duk sakamakon ganewar AI';

  @override
  String get deletionItemSettings => 'Zaɓuɓɓukan manhaja da saituna';

  @override
  String get pleaseConfirm => 'Da Fatan Za Ka Tabbatar';

  @override
  String get confirmDeleteCheck1 =>
      'Na fahimci cewa duk tarihin dubawata da bayanan ganewa za a share su har abada.';

  @override
  String get confirmDeleteCheck2 =>
      'Na fahimci cewa ba za a iya juya wannan aikin ba ko dawo da shi.';

  @override
  String get confirmDeleteCheck3 =>
      'Na tabbatar cewa ina son share asusun CashewGuard AI na har abada.';

  @override
  String get verifyYourIdentity => 'Tabbatar da Ainihinka';

  @override
  String get enterPasswordToConfirm =>
      'Shigar da kalmar sirrinka don tabbatar da share asusu.';

  @override
  String get enterYourPassword => 'Shigar da kalmar sirrinka';

  @override
  String get processing => 'Ana aiki...';

  @override
  String get deleteMyAccount => 'Share Asusuna';

  @override
  String get cancelKeepAccount => 'Soke — Ajiye Asusuna';

  @override
  String get needHelpInstead =>
      'Kana buƙatar taimako maimakon? Tuntuɓi tallafi a support@cashewguard.ai kafin share asusunka.';

  @override
  String get accountDeletedTitle => 'An Share Asusu';

  @override
  String get accountDeletedMessage =>
      'An share asusunka da duk bayanan da suka danganta da shi har abada. Za a fitar da kai yanzu.';

  @override
  String get okLogout => 'TO, Fita';

  @override
  String get incorrectPassword =>
      'Kalmar sirri ba daidai ba. Da fatan za ka sake gwadawa.';

  @override
  String get lastUpdated => 'Sabuntawa ta ƙarshe: Yuni 2026';

  @override
  String get goBack => 'Koma Baya';

  @override
  String get scanLeafTitle => 'Duba Ganye';

  @override
  String get scanInstructionText =>
      'Ɗauki bayyanannen hoton ganyen cashew ko ɗora ɗaya daga hotunanka don nazarin AI.';

  @override
  String get positionLeafInFrame => 'Sanya ganye a tsakiyar firam';

  @override
  String get ensureGoodLighting =>
      'Tabbatar da haske mai kyau don sakamako mafi kyau';

  @override
  String get tipsForBestResults => 'Shawarwari Don Sakamako Mafi Kyau';

  @override
  String get tipDaylight => 'Yi amfani da hasken rana na dabi\'a idan zai yiwu';

  @override
  String get tipFillFrame => 'Cika firam ɗin da ganyen';

  @override
  String get tipSteadyCamera => 'Riƙe kyamara a natse';

  @override
  String get tipBothSides => 'Ɗauki hotunan ɓangarorin ganye guda biyu';

  @override
  String get takePhoto => 'Ɗauki Hoto';

  @override
  String get uploadFromGallery => 'Ɗora Daga Hotuna';

  @override
  String get diagnosticHistory => 'Tarihin Ganewa';

  @override
  String get searchDiagnoses => 'Bincika ganewa...';

  @override
  String scansCount(int count) {
    return 'Dubawa $count';
  }

  @override
  String diseasesCount(int count) {
    return 'Cututtuka $count';
  }

  @override
  String healthyCount(int count) {
    return 'Lafiyayye $count';
  }

  @override
  String get noScansYetHistory => 'Babu dubawa tukuna';

  @override
  String get noResultsFound => 'Ba a sami sakamako ba';

  @override
  String get scanCashewLeafToStart => 'Duba ganyen cashew don farawa';

  @override
  String get today => 'Yau';

  @override
  String get yesterday => 'Jiya';

  @override
  String get searchDiseasesHint => 'Bincika cututtuka...';

  @override
  String get filterAll => 'Duka';

  @override
  String get filterFungal => 'Fungal';

  @override
  String get filterPest => 'Kwari';

  @override
  String get filterAlgal => 'Algal';

  @override
  String get featuredGuideBadge => 'JAGORAR FITACCE';

  @override
  String get preMonsoonTitle => 'Ka\'idar Kariya Kafin Lokacin Damina';

  @override
  String get preMonsoonDesc =>
      'Shirya gonar cashew ɗinka a watan Maris, kafin damina ta fara, don rage haɗarin cuta sosai a lokacin damina mai zuwa.';

  @override
  String get readFullGuide => 'Karanta cikakken jagora';

  @override
  String get treatmentDetailTitle => 'Jagorar Kariya ta Yanayi';

  @override
  String get readTimeLabel => 'minti 5 karatu';

  @override
  String get allCashewLabel => 'Duk Nau\'ukan';

  @override
  String get expertLevelLabel => 'Ya Dace da Masu Farawa';

  @override
  String get yourProgress => 'Ci Gabanka';

  @override
  String stepsCount(int completed, int total) {
    return 'matakai $completed/$total';
  }

  @override
  String get overview => 'Bayani Gaba Ɗaya';

  @override
  String get preMonsoonOverviewText =>
      'Yankin noman cashew na Najeriya yana fuskantar mafi girman matsin cuta na shekara da zarar damina ta fara, yawanci a watan Afrilu. Anthracnose, Gumosis, da Red Rust duk suna bunƙasa a yanayin zafi, danshi, da ruwan sama da ke biyowa — kuma a lokacin da alamomin suka bayyana, magani ya riga ya makara. Wannan jagorar ta ƙunshi shirye-shiryen da manoma ya kamata su kammala a watan Maris, kafin damina ta fara, don itatuwanka su shiga lokacin damina da matsin cuta da aka riga aka rage.';

  @override
  String get materialsNeeded => 'Kayan Da Ake Buƙata';

  @override
  String get materialCopperFungicide =>
      'Maganin fungicide na tagulla (misali copper oxychloride)';

  @override
  String get materialSulphurSpray =>
      'Feshin da aka yi da sulphur (don ƙarin kariya daga fungal)';

  @override
  String get materialSprayer => 'Na\'urar feshi ta baya ko ta hannu';

  @override
  String get materialGloves => 'Safar hannu da abin rufe fuska na kariya';

  @override
  String get materialShears => 'Almakashin datsawa';

  @override
  String get stepByStepGuide => 'Jagora Mataki-bi-Mataki';

  @override
  String get step1Title => 'Bincika Kowane Itace';

  @override
  String get step1Desc =>
      'Yi tafiya cikin gonarka ka bincika kowane itace don tsofaffin raunuka, tabon gum, itace matacce, da barnar kwari da suka rage daga lokacin da ya gabata. Ka lura da itatuwan da za su buƙaci ƙarin kulawa da zarar damina ta fara.';

  @override
  String get step1Duration => 'minti 15/itace';

  @override
  String get step2Title => 'Datsa Ka Tsaftace';

  @override
  String get step2Desc =>
      'Cire ka ƙona ko binne rassan da suka mutu, \'ya\'yan da suka bushe, da ganyayen da suka kamu sosai. Buɗe kambin itace don kyakkyawan iska — kambi masu yawa da inuwa suna taimaka wa Red Rust da yaduwar fungal.';

  @override
  String get step2Duration => 'minti 20-30/itace';

  @override
  String get step3Title => 'Yi Amfani da Feshin Tagulla na Rigakafi';

  @override
  String get step3Desc =>
      'Fesa maganin fungicide na tagulla a kan kambin itace da kai tsaye a duk wani raunin datsawa kafin ruwan sama mai ƙarfi ya fara sauka. Wannan mataki ɗaya shi ne mafi kyawun kariya daga Anthracnose da Red Rust.';

  @override
  String get step3Duration => 'rana ɗaya (dukan gona)';

  @override
  String get step4Title => 'Inganta Magudanar Ruwa';

  @override
  String get step4Desc =>
      'Share magudanan ruwa kewaye da gindin kowane itace domin ruwa kada ya tsaya a kututture. Ƙasa mai ruwa mai yawa ita ce babbar sanadin barkewar Gumosis.';

  @override
  String get step4Duration => 'Rabin rana';

  @override
  String get step5Title => 'Saita Tsarin Bincike na Mako-mako';

  @override
  String get step5Desc =>
      'Da zarar damina ta fara, duba itatuwanka kowane mako da CashewGuard AI. Watan Mayu zuwa Oktoba shine lokacin da haɗarin Anthracnose, Gumosis, da Red Rust ya fi girma — gano alamomi da wuri yana nufin magani kafin babbar illa ta faru.';

  @override
  String get step5Duration => 'Ci gaba, kowane mako';

  @override
  String get importantSafetyNote => 'Muhimmin Bayanin Tsaro';

  @override
  String get safetyNoteText =>
      'Ka koyaushe sa safar hannu da abin rufe fuska lokacin amfani da fungicide. Ka guji feshi a ranakun iska mai ƙarfi ko kafin ruwan sama, kuma ka kiyaye yara da dabbobi daga itatuwan da aka yi wa magani har sai feshin ya bushe sosai.';

  @override
  String get markAllStepsComplete => 'Alamta Duk Matakan A Matsayin Cikawa';

  @override
  String get treatmentGuideCompleted =>
      'Kyakkyawan aiki — ka kammala ka\'idar kariya ta yanayi!';

  @override
  String get completed => 'An Cika';

  @override
  String get diseaseDetailTitle => 'Cikakken Bayanin Cuta';

  @override
  String get severityLabel => 'TSANANI';

  @override
  String get optimalTempLabel => 'MAFI KYAWUN ZAFI';

  @override
  String get humidityLabel => 'DANSHI';

  @override
  String get spreadRateLabel => 'SAURIN YADUWA';

  @override
  String get targetLabel => 'MAKASUDI';

  @override
  String get aboutDiseasePrefix => 'Game da ';

  @override
  String get observedSymptoms => 'Alamomin Da Aka Gani';

  @override
  String get preventionProtocol => 'Ka\'idar Rigakafi';

  @override
  String get activeTreatment => 'Maganin Da Ake Amfani Da Shi';

  @override
  String get recommendedTreatmentLabel => 'SHAWARWARIN MAGANI';

  @override
  String get biologicalControlLabel => 'SARRAFA HALITTA';

  @override
  String get applicationWindowLabel => 'LOKACIN AMFANI';

  @override
  String get cashewGuardInsight => 'Basirar CashewGuard';

  @override
  String get logAction => 'Rubuta Aiki';

  @override
  String get scanAgain => 'Sake Dubawa';

  @override
  String get diagnosisDetailTitle => 'Cikakken Bayanin Ganewa';

  @override
  String get infectedAreaLabel => 'Yankin Da Ya Kamu';

  @override
  String get confidenceLabel => 'Tabbaci';

  @override
  String get modelUsedLabel => 'Samfurin Da Aka Yi Amfani Da Shi';

  @override
  String get severityBreakdown => 'Rarrabuwar Tsanani';

  @override
  String get infectedLabel => 'Ya Kamu';

  @override
  String get healthyAreaLabel => 'Yankin Lafiyayye';

  @override
  String get infectedAreaBarLabel => 'Yankin Da Ya Kamu';

  @override
  String get riskLevelLabel => 'Matakin Haɗari';

  @override
  String get favourableConditionsLabel => 'Yanayin Da Ya Dace';

  @override
  String get spreadRateInfoLabel => 'Saurin Yaduwa';

  @override
  String get pathogenLabel => 'Kwayar Cuta';

  @override
  String get recommendedTreatment => 'Maganin Da Aka Shawarta';

  @override
  String get viewFullTreatmentGuide => 'Duba Cikakkiyar Jagorar Magani';

  @override
  String get scanAnotherLeaf => 'Duba Wani Ganye';

  @override
  String get imagePreviewTitle => 'Duban Hoto';

  @override
  String get imageDetails => 'Bayanan Hoto';

  @override
  String get formatLabel => 'Nau\'i';

  @override
  String get lightingLabel => 'Haske';

  @override
  String get lightingGood => 'Mai Kyau';

  @override
  String get focusLabel => 'Mayar Da Hankali';

  @override
  String get focusSharp => 'Bayyananne';

  @override
  String get statusLabel => 'Matsayi';

  @override
  String get imageLoaded => 'Hoto ya shigo';

  @override
  String get noImage => 'Babu hoto';

  @override
  String get checkingImage => 'Ana Duba Hoto...';

  @override
  String get readyForAnalysis => 'A Shirye Don Bincike';

  @override
  String get verifyingLeaf => 'Ana tabbatar da cewa wannan ganyen cashew ne...';

  @override
  String get imageWillBeValidated => 'Za a tabbatar da hoto kafin bincike.';

  @override
  String get validating => 'Ana Tabbatarwa...';

  @override
  String get preparing => 'Ana Shiryawa...';

  @override
  String get analyseThisLeaf => 'Bincika Wannan Ganye';

  @override
  String get retakePhoto => 'Sake Ɗaukar Hoto';

  @override
  String get notCashewLeafTitle => 'Ba Ganyen Cashew Ba Ne';

  @override
  String get notCashewLeafMessage =>
      'Wannan bai zama ganyen cashew ba. Da fatan za a ɗora bayyananen hoton ganyen cashew.';

  @override
  String get tryAnotherImage => 'Gwada Wani Hoto';

  @override
  String get noImageFoundError =>
      'Ba a sami hoto ba. Da fatan za a sake gwadawa.';

  @override
  String get cashewLeafSample => 'Samfurin Ganyen Cashew';

  @override
  String get scanResultTitle => 'Sakamakon Dubawa';

  @override
  String get healthyLeafCheckmark => 'Ganye Lafiyayye ✓';

  @override
  String get diseaseDetectedSuffix => ' An Gano';

  @override
  String get severitySuffix => ' Tsanani';

  @override
  String get confidenceSuffix => '% Tabbaci';

  @override
  String get severityLevel => 'Matakin Tsanani';

  @override
  String get infectedLabelResult => 'Ya Kamu';

  @override
  String get healthyBadge => 'Lafiyayye';

  @override
  String get mildBadge => 'Kadan';

  @override
  String get moderateBadge => 'Matsakaici';

  @override
  String get severeBadge => 'Mai Tsanani';

  @override
  String get detectionDetails => 'Bayanan Ganewa';

  @override
  String get diseaseTypeLabel => 'Nau\'in Cuta';

  @override
  String get pathogenLabelResult => 'Kwayar Cuta';

  @override
  String get pathogenNone => 'Babu';

  @override
  String get leafAreaAffectedLabel => 'Yankin Ganyen Da Ya Kamu';

  @override
  String get scanTimeLabel => 'Lokacin Dubawa';

  @override
  String get modelUsedLabelResult => 'Samfurin Da Aka Yi Amfani Da Shi';

  @override
  String get leafIsHealthy => 'Ganye Yana Lafiya';

  @override
  String get immediateActionRequired => 'Ana Buƙatar Matakin Gaggawa';

  @override
  String get viewFullDiagnosis => 'Duba Cikakken Ganewa';

  @override
  String get viewTreatmentGuide => 'Duba Jagorar Magani';

  @override
  String get scanAnotherLeafResult => 'Duba Wani Ganye';

  @override
  String get notCashewLeafBody =>
      'Hoton da ka ɗora bai zama ganyen cashew ba. Da fatan za a ɗora bayyananen hoto mai kyawun haske na ganyen cashew don ingantacciyar ganewar cuta.';

  @override
  String get tipsForBetterResults => 'Shawarwari Don Sakamako Mafi Kyau';

  @override
  String get tipUploadClearPhoto => 'Ɗora bayyananen hoton ganyen cashew';

  @override
  String get tipGoodLighting => 'Tabbatar da hasken rana mai kyau';

  @override
  String get tipFillFrameResult => 'Cika firam ɗin da ganyen';

  @override
  String get tipAvoidBlurry => 'Guji hotuna marasa kyau ko duhu';

  @override
  String get scanAgainButton => 'Sake Dubawa';

  @override
  String get goToDashboard => 'Je Zuwa Dashboard';

  @override
  String get serverStartingUp => 'Uwar Garke Tana Farawa';

  @override
  String get serverWakingUpMessage =>
      'Uwar garken AI tana barci kuma yanzu tana farkawa. Da fatan za a jira kimanin daƙiƙa 30 sannan a sake gwadawa.';

  @override
  String get serverIdleInfo =>
      'Wannan yakan faru ne lokacin da uwar garken ta yi barci. Yawanci yakan ɗauki daƙiƙa 30–60 don farkawa. Dubawarka ta gaba za ta yi sauri.';

  @override
  String get tryAgainButton => 'Sake Gwadawa';

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
