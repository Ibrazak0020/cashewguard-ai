// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Locale _appLocale = const Locale('en');

  bool get isDarkMode => _isDarkMode;
  Locale get appLocale => _appLocale;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  static const Map<String, String> _languageToLocaleCode = {
    'English': 'en',
    'Yoruba': 'yo',
    'Hausa': 'ha',
    'Igbo': 'ig',
    'Nigerian Pidgin': 'pcm',
    'French': 'fr',
  };

  static const Map<String, String> _localeCodeToLanguage = {
    'en': 'English',
    'yo': 'Yoruba',
    'ha': 'Hausa',
    'ig': 'Igbo',
    'pcm': 'Nigerian Pidgin',
    'fr': 'French',
  };

  /// Returns the current app language as a human-readable name (e.g.
  /// 'Yoruba') matching the names used throughout the app's language
  /// picker and TTS service.
  String get currentLanguageName =>
      _localeCodeToLanguage[_appLocale.languageCode] ?? 'English';
  static const String _prefsKey = 'app_language_code';

  /// Call this once on app startup, BEFORE checking any Supabase session.
  /// Reads the saved language directly from local browser/device storage,
  /// so it's available immediately — even on the Login screen, even before
  /// anyone is authenticated.
  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_prefsKey);

    if (savedCode != null) {
      // Local preference exists — use it immediately.
      _appLocale = Locale(savedCode);
    } else {
      // No local preference yet. If a session already exists (e.g. app
      // was refreshed while logged in), fall back to their account setting
      // and also cache it locally for next time.
      final authService = AuthService();
      final savedLanguage = authService.userLanguage;
      final code = _languageToLocaleCode[savedLanguage] ?? 'en';
      _appLocale = Locale(code);
      await prefs.setString(_prefsKey, code);
    }
    notifyListeners();
  }

  /// Call this when the user picks a new language from the picker. Updates
  /// the in-memory locale immediately, saves it to local storage (so it
  /// survives refreshes even before login), and syncs it to their Supabase
  /// account if they're logged in (so it follows them across devices).
  Future<void> setLanguage(String languageName) async {
    final code = _languageToLocaleCode[languageName] ?? 'en';
    _appLocale = Locale(code);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);

    final authService = AuthService();
    if (authService.currentUser != null) {
      await authService.updateLanguage(languageName);
    }
  }
}
