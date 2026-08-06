import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/disease_seasonality.dart';

/// Shows a full-screen "ad-style" seasonal disease alert every time the
/// app opens, if any disease is currently in its peak or elevated risk
/// window. Call [SeasonalAlertScreen.maybeShow] from the Dashboard after
/// first build.
class SeasonalAlertScreen extends StatelessWidget {
  final DiseaseSeasonality disease;
  final bool isPeak;

  const SeasonalAlertScreen({
    super.key,
    required this.disease,
    required this.isPeak,
  });

  static const _green = Color(0xFF0D631B);

  // ✅ AI: in-memory flag (not persisted) — resets on app cold start, but
  // stays true for the rest of the session so navigating back to the
  // Dashboard doesn't re-trigger the check.
  static bool _hasCheckedThisSession = false;

  /// Shows the seasonal alert for the highest-priority disease currently
  /// in season (peak takes priority over elevated), once per app launch.
  /// No-op if nothing is in season, or if already checked this session.
  static Future<void> maybeShow(BuildContext context) async {
    if (_hasCheckedThisSession) return;
    _hasCheckedThisSession = true;

    final peak = DiseaseSeasonality.peakFor();
    final elevated = DiseaseSeasonality.elevatedFor();

    DiseaseSeasonality? target;
    bool isPeak = true;
    if (peak.isNotEmpty) {
      target = peak.first;
      isPeak = true;
    } else if (elevated.isNotEmpty) {
      target = elevated.first;
      isPeak = false;
    }

    if (target == null) return;
    if (!context.mounted) return;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        pageBuilder: (_, __, ___) =>
            SeasonalAlertScreen(disease: target!, isPeak: isPeak),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  Color get _riskColor =>
      isPeak ? const Color(0xFFBA1A1A) : const Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _riskColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isPeak ? 'PEAK RISK SEASON' : 'ELEVATED RISK',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _riskColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_riskColor, _riskColor.withValues(alpha: 0.7)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: 20),

                Text(
                  '${disease.diseaseName} season',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF191C1B),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  disease.reason,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF40493D),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _green.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _green.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline, color: _green, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          disease.tip,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: _green,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/scan',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Scan my trees now',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Got it',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF40493D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}