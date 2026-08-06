// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';

// NOTE ON LOCALIZATION: The legal body text on this screen is intentionally
// kept in English only, even though the rest of the app supports 6
// languages. Legal documents carry real liability weight, and an imprecise
// translation could create a gap between what a user believes they've
// agreed to and what's actually legally binding. This mirrors common
// practice in production apps (banking, healthcare, etc.), which often ship
// a single authoritative-language legal document rather than a casually
// translated one. Only the surrounding UI chrome (title, "last updated"
// label, back button) is translated here.

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            child: Column(
              children: [
                // App bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF0D631B).withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Color(0xFF0D631B), size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.termsOfService,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D631B),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Hero banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1D622B),
                                Color(0xFF2E7D32),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0D631B).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.gavel,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.termsOfService,
                                style: GoogleFonts.manrope(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l10n.lastUpdated,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Legal body text intentionally kept in English —
                        // see note at top of file.
                        _termsSection(
                          context,
                          '1. Acceptance of Terms',
                          'By downloading, installing, or using CashewGuard AI, you agree to be '
                              'bound by these Terms of Service. If you do not agree to these terms, '
                              'please do not use the application.\n\n'
                              'These terms apply to all users of CashewGuard AI, including farmers, '
                              'agricultural extension workers, and researchers.',
                        ),

                        _termsSection(
                          context,
                          '2. Use of the Application',
                          'CashewGuard AI is designed exclusively for agricultural disease detection '
                              'in cashew plants. You agree to use the application only for lawful purposes '
                              'and in accordance with these terms:\n\n'
                              '• You must be at least 18 years old to create an account.\n\n'
                              '• You are responsible for maintaining the confidentiality of your account credentials.\n\n'
                              '• You agree not to misuse or attempt to interfere with the proper working of the application.',
                        ),

                        _termsSection(
                          context,
                          '3. AI Diagnosis Disclaimer',
                          'The disease detection and severity prediction features of CashewGuard AI '
                              'are powered by a Convolutional Neural Network (CNN) model. Please note:\n\n'
                              '• AI diagnosis results are provided for informational purposes only.\n\n'
                              '• Results should not replace professional agricultural advice.\n\n'
                              '• The accuracy of results depends on the quality of the leaf image provided.\n\n'
                              '• We recommend consulting a certified agronomist for severe disease outbreaks.',
                        ),

                        _termsSection(
                          context,
                          '4. Intellectual Property',
                          'CashewGuard AI and all its content, features, and functionality are owned '
                              'by the Department of Computer Sciences, Abiola Ajimobi Technical University.\n\n'
                              '• The CNN model, source code, and design are protected by applicable intellectual property laws.\n\n'
                              '• You may not copy, modify, distribute, or reverse engineer any part of the application without prior written permission.',
                        ),

                        _termsSection(
                          context,
                          '5. Limitation of Liability',
                          'To the maximum extent permitted by applicable law, CashewGuard AI and its '
                              'developers shall not be liable for any indirect, incidental, or consequential '
                              'damages arising from:\n\n'
                              '• Inaccurate disease detection results.\n\n'
                              '• Loss of crops or revenue based on AI recommendations.\n\n'
                              '• Any interruption or unavailability of the service.',
                        ),

                        _termsSection(
                          context,
                          '6. Modifications to Terms',
                          'We reserve the right to modify these Terms of Service at any time. '
                              'We will notify you of significant changes through the application. '
                              'Your continued use of CashewGuard AI after changes are posted '
                              'constitutes your acceptance of the updated terms.',
                        ),

                        _termsSection(
                          context,
                          '7. Contact Information',
                          'For questions about these Terms of Service, please contact us at:\n\n'
                              'Email: support@cashewguard.ai\n\n'
                              'Department of Computer Sciences\n'
                              'Abiola Ajimobi Technical University\n'
                              'Ibadan, Nigeria',
                        ),

                        const SizedBox(height: 24),

                        // Back button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, size: 20),
                            label: Text(
                              l10n.goBack,
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D631B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _termsSection(BuildContext context, String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.7,
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
