// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/supabase_config.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen_1.dart';
import 'screens/splash_screen_2.dart';
import 'screens/onboarding_detect.dart'
    hide OnboardingTreatment, OnboardingAnalysis;
import 'screens/onboarding_analysis.dart';
import 'screens/onboarding_treatment.dart';
import 'screens/login_screen.dart';
import 'screens/create_account.dart';
import 'screens/dashboard.dart';
import 'screens/scan_leaf.dart';
import 'screens/image_preview.dart';
import 'screens/ai_processing.dart';
import 'screens/prediction_result.dart';
import 'screens/diagnosis_detail.dart';
import 'screens/treatment_guide.dart';
import 'screens/treatment_detail.dart';
import 'screens/disease_detail.dart';
import 'screens/history.dart';
import 'screens/profile.dart';
import 'screens/account_settings.dart';
import 'screens/delete_account.dart';
import 'screens/about_app.dart';
import 'screens/privacy_policy.dart';
import 'screens/terms_of_service.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/forgot_password.dart';
import 'l10n/app_localizations.dart';
import 'screens/language_selection_screen.dart';
import 'services/notification_service.dart';
import 'screens/log_action_chat.dart';
import 'screens/trends_screen.dart';
import 'services/offline_sync_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'screens/outbreak_screen.dart';
import 'screens/ai_assistant_screen.dart';
import 'screens/privacy_settings.dart';
// NotificationService already imported above; duplicate import removed.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService().init();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  await NotificationService().init();
  OfflineSyncService().startListening();
  final themeProvider = ThemeProvider();
  await themeProvider.loadSavedLocale();

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const CashewGuardApp(),
    ),
  );
}

final supabase = Supabase.instance.client;

class CashewGuardApp extends StatelessWidget {
  const CashewGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        debugPrint('App rebuilding — isDark: ${themeProvider.isDarkMode}');
        return MaterialApp(
          title: 'CashewGuard AI',
          theme: AppTheme.lightTheme,
          darkTheme: ThemeData.dark(),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            _FallbackMaterialLocalizationsDelegate(),
            GlobalWidgetsLocalizations.delegate,
            _FallbackCupertinoLocalizationsDelegate(),
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('yo'),
            Locale('ha'),
            Locale('ig'),
            Locale('pcm'),
            Locale('fr'),
          ],
          locale: themeProvider.appLocale,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaleFactor: 1.0,
              ),
              child: ScrollConfiguration(
                behavior: _NoGlowScrollBehavior(),
                child: child!,
              ),
            );
          },
          initialRoute: '/splash1',
          routes: {
            '/splash1': (_) => const SplashScreen1(),
            '/splash2': (_) => const SplashScreen2(),
            '/onboard1': (_) => const OnboardingDetect(),
            '/onboard2': (_) => const OnboardingAnalysis(),
            '/onboard3': (_) => const OnboardingTreatment(),
            '/login': (_) => const LoginScreen(),
            '/create': (_) => const CreateAccount(),
            '/dashboard': (_) => const Dashboard(),
            '/scan': (_) => const ScanLeaf(),
            '/preview': (_) => const ImagePreview(),
            '/processing': (_) => const AiProcessing(),
            '/result': (_) => const PredictionResult(),
            '/diagnosis': (_) => const DiagnosisDetail(),
            '/treatment': (_) => const TreatmentGuide(),
            '/treatment-detail': (_) => const TreatmentDetail(),
            '/disease': (_) => const DiseaseDetail(),
            '/history': (_) => const HistoryScreen(),
            '/profile': (_) => const ProfileScreen(),
            '/settings': (_) => const AccountSettings(),
            '/delete': (_) => const DeleteAccount(),
            '/about': (_) => const AboutApp(),
            '/privacy': (_) => const PrivacyPolicy(),
            '/terms': (_) => const TermsOfService(),
            '/edit-profile': (context) => const EditProfileScreen(),
            '/change-password': (context) => const ChangePasswordScreen(),
            '/notifications': (context) => const NotificationsScreen(),
            '/language-select': (_) => const LanguageSelectionScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/log-action-chat': (context) => const LogActionChat(),
            '/trends': (context) => const TrendsScreen(),
            '/outbreak': (context) => const OutbreakScreen(),
            '/privacy-settings': (context) => const PrivacySettings(),
            '/ai-assistant': (context) => const AiAssistantScreen(),
          },
        );
      },
    );
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    // Flutter's built-in Material widget translations (calendar, dialogs,
    // tooltips, etc.) don't include Yoruba/Hausa/Igbo/Pidgin, so those
    // specific widgets fall back to English. Our own app text (via
    // AppLocalizations) still displays correctly in the selected language.
    return GlobalMaterialLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(_FallbackMaterialLocalizationsDelegate old) => false;
}

class _FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return GlobalCupertinoLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(_FallbackCupertinoLocalizationsDelegate old) => false;
}
