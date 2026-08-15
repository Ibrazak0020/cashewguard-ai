import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/weather_service.dart';
import '../data/disease_risk_predictor.dart';

/// Shows a full-screen "ad-style" disease risk alert every time the app
/// opens, predicted from the farmer's LIVE weather conditions (for the
/// three moisture-driven diseases) with a calendar-based fallback when
/// weather can't be fetched.
class SeasonalAlertScreen extends StatelessWidget {
  final LiveDiseaseRisk risk;
  final bool isLive;

  const SeasonalAlertScreen({
    super.key,
    required this.risk,
    required this.isLive,
  });

  static const _green = Color(0xFF0D631B);

  static bool _hasCheckedThisSession = false;

  static Future<void> maybeShow(BuildContext context) async {
    if (_hasCheckedThisSession) return;
    _hasCheckedThisSession = true;

    List<LiveDiseaseRisk> risks;
    bool isLive = true;
    try {
      final advisory = await WeatherService().getSprayAdvisory();
      risks = DiseaseRiskPredictor.predict(
        temperature: advisory.temperature,
        humidity: advisory.humidity,
        rainChance: advisory.rainChance,
      );
    } catch (_) {
      isLive = false;
      risks = DiseaseRiskPredictor.predictFromCalendarOnly();
    }

    final peak = risks.where((r) => r.level == RiskLevel.peak).toList();
    final elevated =
        risks.where((r) => r.level == RiskLevel.elevated).toList();

    LiveDiseaseRisk? target;
    if (peak.isNotEmpty) {
      target = peak.first;
    } else if (elevated.isNotEmpty) {
      target = elevated.first;
    }

    if (target == null) return;
    if (!context.mounted) return;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        pageBuilder: (_, __, ___) =>
            SeasonalAlertScreen(risk: target!, isLive: isLive),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  bool get _isPeak => risk.level == RiskLevel.peak;
  Color get _riskColor =>
      _isPeak ? const Color(0xFFBA1A1A) : const Color(0xFFE65100);

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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _riskColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _isPeak ? 'PEAK RISK NOW' : 'ELEVATED RISK',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _riskColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    if (isLive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wb_cloudy_outlined,
                                size: 12, color: _green),
                            const SizedBox(width: 4),
                            Text(
                              'LIVE WEATHER',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _green,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
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
                  '${risk.diseaseName} risk',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF191C1B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  risk.reason,
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
                          risk.tip,
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
                      Navigator.pushNamed(context, '/scan');
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