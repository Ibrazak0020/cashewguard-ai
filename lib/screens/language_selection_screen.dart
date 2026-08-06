// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import 'account_settings.dart' show kSupportedLanguages;

// NOTE: This screen's own text (title/subtitle/button) is intentionally
// kept in English, since it is shown BEFORE the user has picked a
// language — there's no "current language" yet to translate into. This is
// standard practice for first-run language pickers.

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;
  bool _isSaving = false;

  // Maps each supported language to how its name is written in its own
  // script/spelling, shown as a subtle secondary line under the English
  // label — helps native speakers recognize their language at a glance.
  static const Map<String, String> _nativeNames = {
    'English': 'English',
    'Yoruba': 'Yorùbá',
    'Hausa': 'Hausa',
    'Igbo': 'Igbo',
    'Nigerian Pidgin': 'Naija Pidgin',
    'French': 'Français',
  };

  Future<void> _continue() async {
    if (_selectedLanguage == null) return;
    setState(() => _isSaving = true);

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.setLanguage(_selectedLanguage!);

    // Remember that the user has completed language selection so this
    // screen doesn't show again on future launches.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('language_selected_once', true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/splash2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
          ),
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0D631B).withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Logo
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/cashewguard_logo.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Choose Your Language',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF191C1B),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Select the language you\'re most comfortable with. You can change this anytime in Settings.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF40493D),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Language options
                  Expanded(
                    child: ListView.builder(
                      itemCount: kSupportedLanguages.length,
                      itemBuilder: (context, index) {
                        final lang = kSupportedLanguages[index];
                        final isSelected = _selectedLanguage == lang;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedLanguage = lang),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0D631B).withOpacity(0.08)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF0D631B)
                                    : const Color(0xFFBFCABA),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF0D631B).withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF0D631B)
                                        : const Color(0xFF0D631B)
                                            .withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.language,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF0D631B),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang,
                                        style: GoogleFonts.manrope(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? const Color(0xFF0D631B)
                                              : const Color(0xFF191C1B),
                                        ),
                                      ),
                                      if (_nativeNames[lang] != lang)
                                        Text(
                                          _nativeNames[lang] ?? '',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: const Color(0xFF40493D),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle,
                                      color: Color(0xFF0D631B), size: 24),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_selectedLanguage == null || _isSaving)
                          ? null
                          : _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D631B),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFF0D631B).withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Continue',
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E7D32).withOpacity(0.07)
      ..style = PaintingStyle.fill;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
