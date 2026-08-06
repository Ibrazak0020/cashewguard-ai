// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Dot grid background
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
          ),

          // Top green blob
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                                    color: const Color(0xFF0D631B)
                                        .withOpacity(0.08),
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
                            'CashewGuard AI',
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D631B),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0D631B).withOpacity(0.1),
                          border: Border.all(
                            color: const Color(0xFF0D631B).withOpacity(0.2),
                          ),
                        ),
                        child: const Icon(Icons.person,
                            color: Color(0xFF0D631B), size: 22),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Hero icon
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2E7D32),
                                Color(0xFF4CAF50),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF0D631B).withOpacity(0.25),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shield,
                            color: Colors.white,
                            size: 52,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'CashewGuard AI',
                          style: GoogleFonts.manrope(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          l10n.intelligentCropStewardship,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Version badge
                        // ✅ AI: bumped 1.0.0 -> 2.0.0 to reflect the AI
                        // pipeline, push notifications, Outbreak Watch, and
                        // offline-first support added since the first
                        // release.
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF91F78E).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                          child: Text(
                            'VERSION 2.0.0',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF006E1C),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Mission card
                        _infoCard(
                          context,
                          icon: Icons.psychology,
                          title: l10n.intelligentStewardship,
                          child: Text(
                            l10n.missionText,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                              height: 1.7,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Key features card
                        // ✅ AI: reordered so the most distinctive features
                        // lead. New items (AI Assistant, Outbreak Watch,
                        // Real-Time Alerts, Offline-First) use plain English
                        // text rather than new l10n keys, matching the
                        // precedent set by disease-specific content
                        // elsewhere in the app.
                        _infoCard(
                          context,
                          icon: Icons.star_outline,
                          title: l10n.keyFeatures,
                          child: Column(
                            children: [
                              _featureItem(
                                context,
                                Icons.center_focus_strong,
                                l10n.featureScanTitle,
                                l10n.featureScanDesc,
                              ),
                              _featureItem(
                                context,
                                Icons.coronavirus_outlined,
                                l10n.featureDetectTitle,
                                l10n.featureDetectDesc,
                              ),
                              _featureItem(
                                context,
                                Icons.auto_awesome,
                                'AI Assistant & Chat',
                                'Get an AI-generated explanation of every diagnosis, or chat with an AI assistant about anything from your Dashboard',
                              ),
                              _featureItem(
                                context,
                                Icons.radar,
                                'Outbreak Watch',
                                'See anonymized disease reports from nearby farmers to catch regional outbreaks before they reach your farm',
                              ),
                              _featureItem(
                                context,
                                Icons.notifications_active,
                                'Real-Time Alerts',
                                'Instant push notifications for disease detections, weekly farm reports, and treatment reminders',
                              ),
                              _featureItem(
                                context,
                                Icons.cloud_off,
                                'Offline-First Scanning',
                                'Diagnose leaves with zero signal — results save on your device and sync automatically once you\'re back online',
                              ),
                              _featureItem(
                                context,
                                Icons.calendar_month,
                                'Seasonal Risk Alerts',
                                'Know which diseases are in season for your region, based on Nigeria\'s rainy and dry season calendar',
                              ),
                              _featureItem(
                                context,
                                Icons.healing,
                                l10n.featureTreatmentTitle,
                                l10n.featureTreatmentDesc,
                              ),
                              _featureItem(
                                context,
                                Icons.history,
                                l10n.featureHistoryTitle,
                                l10n.featureHistoryDesc,
                              ),
                              _featureItem(
                                context,
                                Icons.language,
                                l10n.featureLanguageTitle,
                                l10n.featureLanguageDesc,
                                isLast: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Tech stack card
                        // ✅ AI: added Groq and Firebase Cloud Messaging;
                        // broadened the Supabase description to reflect its
                        // expanded role (Edge Functions, scheduled jobs,
                        // device token storage) beyond just auth/backend.
                        _infoCard(
                          context,
                          icon: Icons.code,
                          title: l10n.technologyStack,
                          child: Column(
                            children: [
                              _techItem(context, Icons.phone_android, 'Flutter',
                                  l10n.techFlutterDesc),
                              _techItem(
                                  context,
                                  Icons.psychology,
                                  'TensorFlow / Keras',
                                  l10n.techTensorflowDesc),
                              _techItem(context, Icons.visibility, 'OpenCV',
                                  l10n.techOpencvDesc),
                              _techItem(context, Icons.model_training, 'CNN',
                                  l10n.techCnnDesc),
                              _techItem(
                                context,
                                Icons.auto_awesome,
                                'Groq',
                                'AI Chat & Diagnosis Insights',
                              ),
                              _techItem(
                                context,
                                Icons.cloud,
                                'Supabase',
                                'Backend, Automation & Authentication',
                              ),
                              _techItem(
                                context,
                                Icons.notifications,
                                'Firebase Cloud Messaging',
                                'Real-Time Push Notifications',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Legal links
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF0D631B).withOpacity(0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _legalRow(
                                context,
                                Icons.privacy_tip_outlined,
                                l10n.privacyPolicy,
                                null,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/privacy'),
                              ),
                              const Divider(
                                  height: 1,
                                  indent: 20,
                                  endIndent: 20,
                                  color: Color(0xFFECEEEC)),
                              _legalRow(
                                context,
                                Icons.gavel_outlined,
                                l10n.termsOfService,
                                null,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/terms'),
                              ),
                              const Divider(
                                  height: 1,
                                  indent: 20,
                                  endIndent: 20,
                                  color: Color(0xFFECEEEC)),
                              _legalRow(
                                context,
                                Icons.circle,
                                l10n.systemStatus,
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF006E1C),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      l10n.allSystemsOperational,
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF006E1C),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Footer
                        Text(
                          'CashewGuard AI  •  v2.0.0',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: const Color(0xFF40493D).withOpacity(0.4),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.allRightsReserved,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF40493D).withOpacity(0.4),
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

          // Bottom nav
          Positioned(
            bottom: 16,
            left: 20,
            right: 20,
            child: _buildBottomNav(context, l10n),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D631B).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF0D631B), size: 22),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _featureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0D631B).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0D631B), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.65),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _techItem(
      BuildContext context, IconData icon, String name, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0D631B).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0D631B), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legalRow(
      BuildContext context, IconData icon, String label, Widget? trailing,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, AppLocalizations l10n) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D631B).withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
              context, Icons.dashboard, l10n.dashboard, '/dashboard', false),
          _navItem(
              context, Icons.center_focus_strong, l10n.scan, '/scan', false),
          _navItem(
              context, Icons.library_books, l10n.library, '/treatment', false),
          _navItem(context, Icons.history, l10n.history, '/history', false),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label,
      String route, bool isActive) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isActive
                  ? const Color(0xFF0D631B)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? const Color(0xFF0D631B)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF0D631B),
                shape: BoxShape.circle,
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