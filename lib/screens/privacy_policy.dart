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

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
                        l10n.privacyPolicy,
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
                                Color(0xFF2E7D32),
                                Color(0xFF4CAF50),
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
                                  Icons.privacy_tip,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.privacyPolicy,
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
                        _policySection(
                          context,
                          '1. Information We Collect',
                          'CashewGuard AI collects the following information to provide our disease detection services:\n\n'
                              '• Account information such as your name and email address when you register.\n\n'
                              '• Leaf images you capture or upload for disease analysis.\n\n'
                              '• Scan history and diagnosis results generated by the AI model.\n\n'
                              '• Device information such as smartphone model and operating system version.',
                        ),

                        _policySection(
                          context,
                          '2. How We Use Your Information',
                          'Your information is used solely to provide and improve the CashewGuard AI service:\n\n'
                              '• To analyze cashew leaf images and provide disease detection results.\n\n'
                              '• To store your scan history for future reference and comparison.\n\n'
                              '• To improve the accuracy of our CNN deep learning model.\n\n'
                              '• To send important notifications about your farm health status.',
                        ),

                        _policySection(
                          context,
                          '3. Data Storage and Security',
                          'We take the security of your data seriously:\n\n'
                              '• All data is encrypted in transit using SSL/TLS protocols.\n\n'
                              '• Leaf images are stored securely on our cloud servers and are not shared with third parties.\n\n'
                              '• You can request deletion of all your data at any time through the Delete Account feature.\n\n'
                              '• We retain your data only for as long as your account is active.',
                        ),

                        _policySection(
                          context,
                          '4. Sharing of Information',
                          'CashewGuard AI does not sell or share your personal information with third parties. '
                              'Your data may only be shared in the following limited circumstances:\n\n'
                              '• With your explicit consent.\n\n'
                              '• To comply with applicable law or legal process.\n\n'
                              '• To protect the rights and safety of our users.',
                        ),

                        _policySection(
                          context,
                          '5. Your Rights',
                          'You have the following rights regarding your personal data:\n\n'
                              '• The right to access your personal data at any time.\n\n'
                              '• The right to correct inaccurate personal data.\n\n'
                              '• The right to request deletion of your personal data.\n\n'
                              '• The right to withdraw consent at any time by deleting your account.',
                        ),

                        _policySection(
                          context,
                          '6. Contact Us',
                          'If you have any questions about this Privacy Policy or your data, '
                              'please contact us at:\n\n'
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

  Widget _policySection(BuildContext context, String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D631B).withOpacity(0.06),
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
                  color: const Color(0xFF0D631B),
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
