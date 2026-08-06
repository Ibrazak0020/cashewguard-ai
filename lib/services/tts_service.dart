import 'package:flutter_tts/flutter_tts.dart';

/// Wraps flutter_tts with language-aware speaking and graceful fallback.
///
/// Not every device has every language's voice installed. If the requested
/// language isn't available, this falls back to English rather than
/// silently failing or throwing — since even Nigerian Pidgin (which has no
/// dedicated TTS voice on virtually any device) is written with English
/// spelling and reads back reasonably naturally with an English voice.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _isSpeaking = false;

  // Maps our app's language names to BCP-47 locale codes flutter_tts expects.
  static const Map<String, String> _languageToTtsLocale = {
    'English': 'en-US',
    'Yoruba': 'yo-NG',
    'Hausa': 'ha-NG',
    'Igbo': 'ig-NG',
    'Nigerian Pidgin': 'en-NG', // no dedicated Pidgin voice; falls back to
    // Nigerian-accented English if available, else plain English.
    'French': 'fr-FR',
  };

  bool get isSpeaking => _isSpeaking;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _tts.setSpeechRate(0.45); // slightly slower than default for clarity
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
    });
    _tts.setCancelHandler(() {
      _isSpeaking = false;
    });
    _tts.setErrorHandler((_) {
      _isSpeaking = false;
    });

    _initialized = true;
  }

  /// Speaks [text] using the voice for [languageName] (one of our app's
  /// supported language names, e.g. 'Yoruba'). If that language's voice
  /// isn't available on this device, falls back to English automatically.
  Future<void> speak(String text, String languageName) async {
    await _ensureInit();

    if (text.trim().isEmpty) return;

    final requestedLocale = _languageToTtsLocale[languageName] ?? 'en-US';

    final available = await _isLocaleAvailable(requestedLocale);
    final localeToUse = available ? requestedLocale : 'en-US';

    await _tts.setLanguage(localeToUse);
    _isSpeaking = true;
    await _tts.speak(text);
  }

  Future<bool> _isLocaleAvailable(String locale) async {
    try {
      final languages = await _tts.getLanguages;
      if (languages == null) return false;
      // getLanguages returns codes like "en-US", "yo-NG" etc; some
      // platforms return slightly different casing/format, so compare
      // case-insensitively and allow partial match on language prefix.
      final normalized =
          List<String>.from(languages).map((l) => l.toString().toLowerCase());
      final localeLower = locale.toLowerCase();
      final prefix = localeLower.split('-').first; // e.g. "yo"
      return normalized.any(
          (l) => l == localeLower || l.startsWith('$prefix-') || l == prefix);
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }
}
