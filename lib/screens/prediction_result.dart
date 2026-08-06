// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/tts_service.dart';
import '../providers/theme_provider.dart';

// NOTE ON LOCALIZATION: The _recommendations content (treatment steps per
// disease) is intentionally kept in English, same reasoning as Disease
// Detail / Treatment Guide — precise agricultural terminology where
// imprecise translation could lead to incorrect treatment.

class PredictionResult extends StatefulWidget {
  const PredictionResult({super.key});

  @override
  State<PredictionResult> createState() => _PredictionResultState();
}

class _PredictionResultState extends State<PredictionResult>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  final _ttsService = TtsService();
  bool _isSpeaking = false;

  String _disease = 'Unknown';
  String _severity = 'Unknown';
  double _confidence = 0.0;
  double _infectedArea = 0.0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        _disease = args['disease'] ?? 'Unknown';
        _severity = args['severity'] ?? 'Unknown';
        _confidence = (args['confidence'] as num?)?.toDouble() ?? 0.0;
        _infectedArea = (args['infected_area'] as num?)?.toDouble() ?? 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _ttsService.stop();
    super.dispose();
  }

  // ============================================
  // HELPERS
  // ============================================

  bool get _isHealthy => _disease.toLowerCase() == 'healthy';
  bool get _isUnrecognized => _disease.toLowerCase() == 'unrecognized';
  bool get _isTimeout => _disease.toLowerCase() == 'timeout';

  Color get _severityColor {
    switch (_severity.toLowerCase()) {
      case 'healthy':
        return const Color(0xFF0D631B);
      case 'mild':
        return const Color(0xFF388E3C);
      case 'moderate':
        return const Color(0xFFE65100);
      case 'severe':
        return const Color(0xFFBA1A1A);
      default:
        return const Color(0xFF40493D);
    }
  }

  String _displayTitle(AppLocalizations l10n) => _isHealthy
      ? l10n.healthyLeafCheckmark
      : '$_disease${l10n.diseaseDetectedSuffix}';

  String get _pathogen {
    switch (_disease.toLowerCase()) {
      case 'anthracnose':
        return 'Colletotrichum spp.';
      case 'gumosis':
        return 'Phytophthora spp.';
      case 'leaf miner':
        return 'Acrocercops spp.';
      case 'red rust':
        return 'Cephaleuros virescens';
      default:
        return 'N/A';
    }
  }

  List<String> get _recommendations {
    switch (_disease.toLowerCase()) {
      case 'anthracnose':
        return [
          'Apply copper-based fungicide spray',
          'Remove and destroy infected leaves',
          'Improve air circulation around trees',
          'Monitor daily for spread',
        ];
      case 'gumosis':
        return [
          'Scrape off gum deposits carefully',
          'Apply Bordeaux paste on wounds',
          'Avoid waterlogging around roots',
          'Use systemic fungicide treatment',
        ];
      case 'leaf miner':
        return [
          'Apply neem-based insecticide spray',
          'Remove heavily mined leaves',
          'Introduce natural predators if possible',
          'Monitor new leaf flush regularly',
        ];
      case 'red rust':
        return [
          'Apply copper oxychloride fungicide',
          'Improve drainage around trees',
          'Prune overcrowded branches',
          'Repeat treatment after 2 weeks',
        ];
      default:
        return [
          'Continue regular monitoring',
          'Maintain good field hygiene',
          'Ensure proper nutrition and irrigation',
        ];
    }
  }

  Future<void> _toggleReadAloud(AppLocalizations l10n) async {
    if (_isSpeaking) {
      await _ttsService.stop();
      setState(() => _isSpeaking = false);
      return;
    }

    final languageName =
        Provider.of<ThemeProvider>(context, listen: false).currentLanguageName;

    final buffer = StringBuffer();
    buffer.write('${_displayTitle(l10n)}. ');
    buffer.write('$_severity${l10n.severitySuffix}. ');
    buffer.write(
        '${(_confidence * 100).toStringAsFixed(0)}${l10n.confidenceSuffix}. ');
    buffer
        .write(_isHealthy ? l10n.leafIsHealthy : l10n.immediateActionRequired);
    buffer.write('. ');
    buffer.write(_recommendations.join('. '));

    setState(() => _isSpeaking = true);
    await _ttsService.speak(buffer.toString(), languageName);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isSpeaking = _ttsService.isSpeaking);
      }
    });
  }
  // ============================================
  // NOT A LEAF SCREEN
  // ============================================

  Widget _buildNotALeafScreen(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE65100).withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE65100).withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.hide_image_outlined,
                      color: Color(0xFFE65100),
                      size: 52,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.notCashewLeafTitle,
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF191C1B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.notCashewLeafBody,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF40493D),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Tips card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF0D631B).withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.tipsForBetterResults,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF191C1B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _tipItem(l10n.tipUploadClearPhoto),
                        _tipItem(l10n.tipGoodLighting),
                        _tipItem(l10n.tipFillFrameResult),
                        _tipItem(l10n.tipAvoidBlurry),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/scan'),
                      icon: const Icon(Icons.camera_alt, size: 20),
                      label: Text(l10n.scanAgainButton,
                          style: GoogleFonts.manrope(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D631B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/dashboard'),
                      icon: const Icon(Icons.dashboard, size: 20),
                      label: Text(l10n.goToDashboard,
                          style: GoogleFonts.manrope(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0D631B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999)),
                        side: const BorderSide(
                            color: Color(0xFF0D631B), width: 1.5),
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
    );
  }

  // ============================================
  // TIMEOUT SCREEN
  // ============================================

  Widget _buildTimeoutScreen(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D631B).withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0D631B).withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.cloud_off_outlined,
                      color: Color(0xFF0D631B),
                      size: 52,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.serverStartingUp,
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF191C1B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.serverWakingUpMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF40493D),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D631B).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF0D631B).withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Color(0xFF0D631B), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.serverIdleInfo,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF0D631B),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/scan'),
                      icon: const Icon(Icons.refresh, size: 20),
                      label: Text(l10n.tryAgainButton,
                          style: GoogleFonts.manrope(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D631B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/dashboard'),
                      icon: const Icon(Icons.dashboard, size: 20),
                      label: Text(l10n.goToDashboard,
                          style: GoogleFonts.manrope(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0D631B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999)),
                        side: const BorderSide(
                            color: Color(0xFF0D631B), width: 1.5),
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
    );
  }

  Widget _tipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline,
              color: Color(0xFF0D631B), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF40493D),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // MAIN BUILD
  // ============================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // ✅ Show "not a leaf" screen
    if (_isUnrecognized) return _buildNotALeafScreen(context, l10n);

    // ✅ Show "server waking up" screen
    if (_isTimeout) return _buildTimeoutScreen(context, l10n);

    final infectedPercent = (_infectedArea / 100).clamp(0.0, 1.0);
    final confidencePercent = (_confidence * 100).toStringAsFixed(1);
    final now = TimeOfDay.now();
    final timeStr =
        'Today, ${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period.name.toUpperCase()}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0D631B).withValues(alpha: 0.05),
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
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, '/dashboard'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0D631B)
                                    .withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Color(0xFF0D631B), size: 20),
                        ),
                      ),
                      Text(
                        l10n.scanResultTitle,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D631B),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0D631B)
                                  .withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.share_outlined,
                            color: Color(0xFF0D631B), size: 20),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),

                            // Disease result card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: _isHealthy
                                      ? [
                                          const Color(0xFF1B5E20),
                                          const Color(0xFF4CAF50),
                                        ]
                                      : [
                                          const Color(0xFF2E7D32),
                                          _severityColor,
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0D631B)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Icon(
                                      _isHealthy
                                          ? Icons.eco
                                          : Icons.coronavirus,
                                      color: Colors.white,
                                      size: 38,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _displayTitle(l10n),
                                    style: GoogleFonts.manrope(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      '$_severity${l10n.severitySuffix}',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.verified,
                                          color: Colors.white, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        '$confidencePercent${l10n.confidenceSuffix}',
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                              .withValues(alpha: 0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Read aloud button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _toggleReadAloud(l10n),
                                icon: Icon(
                                  _isSpeaking
                                      ? Icons.stop_circle_outlined
                                      : Icons.volume_up_outlined,
                                  size: 20,
                                ),
                                label: Text(
                                  _isSpeaking
                                      ? 'Stop Reading'
                                      : 'Read Result Aloud',
                                  style: GoogleFonts.manrope(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF0D631B),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF0D631B),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // ✅ AI: Ask AI to Explain button — opens the
                            // chat screen with the real scan numbers so the
                            // AI can explain this exact result and answer
                            // any follow-up questions (about the result,
                            // farming generally, or the app itself).
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/log-action-chat',
                                  arguments: {
                                    'disease': _disease,
                                    'severity': _severity,
                                    'confidence': _confidence,
                                    'infectedArea': _infectedArea,
                                  },
                                ),
                                icon: const Icon(Icons.psychology, size: 20),
                                label: Text(
                                  'Ask AI to Explain This Result',
                                  style: GoogleFonts.manrope(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D631B),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Severity meter
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0D631B)
                                        .withValues(alpha: 0.06),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.severityLevel,
                                    style: GoogleFonts.manrope(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF191C1B),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: CircularPercentIndicator(
                                      radius: 80,
                                      lineWidth: 12,
                                      percent: infectedPercent,
                                      center: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${_infectedArea.toStringAsFixed(0)}%',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: _severityColor,
                                            ),
                                          ),
                                          Text(
                                            l10n.infectedLabelResult,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: const Color(0xFF40493D),
                                            ),
                                          ),
                                        ],
                                      ),
                                      progressColor: _severityColor,
                                      backgroundColor:
                                          _severityColor.withValues(alpha: 0.1),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      animation: true,
                                      animationDuration: 1500,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _severityBadge(
                                          l10n.healthyBadge,
                                          const Color(0xFF0D631B),
                                          _severity.toLowerCase() == 'healthy'),
                                      _severityBadge(
                                          l10n.mildBadge,
                                          const Color(0xFF388E3C),
                                          _severity.toLowerCase() == 'mild'),
                                      _severityBadge(
                                          l10n.moderateBadge,
                                          const Color(0xFFE65100),
                                          _severity.toLowerCase() ==
                                              'moderate'),
                                      _severityBadge(
                                          l10n.severeBadge,
                                          const Color(0xFFBA1A1A),
                                          _severity.toLowerCase() == 'severe'),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Detection details
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0D631B)
                                        .withValues(alpha: 0.06),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.detectionDetails,
                                    style: GoogleFonts.manrope(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF191C1B),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _detailRow(Icons.biotech,
                                      l10n.diseaseTypeLabel, _disease),
                                  const SizedBox(height: 12),
                                  _detailRow(
                                      Icons.science,
                                      l10n.pathogenLabelResult,
                                      _isHealthy
                                          ? l10n.pathogenNone
                                          : _pathogen),
                                  const SizedBox(height: 12),
                                  _detailRow(
                                      Icons.area_chart,
                                      l10n.leafAreaAffectedLabel,
                                      '${_infectedArea.toStringAsFixed(0)}%'),
                                  const SizedBox(height: 12),
                                  _detailRow(Icons.access_time,
                                      l10n.scanTimeLabel, timeStr),
                                  const SizedBox(height: 12),
                                  _detailRow(
                                      Icons.model_training,
                                      l10n.modelUsedLabelResult,
                                      'VGGNet CNN v1.0'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Recommendations
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: _isHealthy
                                    ? const Color(0xFF0D631B)
                                        .withValues(alpha: 0.05)
                                    : const Color(0xFFE65100)
                                        .withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _isHealthy
                                      ? const Color(0xFF0D631B)
                                          .withValues(alpha: 0.2)
                                      : const Color(0xFFE65100)
                                          .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: _isHealthy
                                              ? const Color(0xFF0D631B)
                                                  .withValues(alpha: 0.1)
                                              : const Color(0xFFE65100)
                                                  .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          _isHealthy
                                              ? Icons.check_circle_outline
                                              : Icons.tips_and_updates,
                                          color: _isHealthy
                                              ? const Color(0xFF0D631B)
                                              : const Color(0xFFE65100),
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _isHealthy
                                              ? l10n.leafIsHealthy
                                              : l10n.immediateActionRequired,
                                          style: GoogleFonts.manrope(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: _isHealthy
                                                ? const Color(0xFF0D631B)
                                                : const Color(0xFFE65100),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ..._recommendations.map((r) =>
                                      _recommendationItem(
                                          r,
                                          _isHealthy
                                              ? const Color(0xFF0D631B)
                                              : const Color(0xFFE65100))),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // View Full Diagnosis
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/diagnosis',
                                  arguments: {
                                    'disease': _disease,
                                    'severity': _severity,
                                    'confidence': _confidence,
                                    'infected_area': _infectedArea,
                                  },
                                ),
                                icon: const Icon(Icons.info_outline, size: 20),
                                label: Text(l10n.viewFullDiagnosis,
                                    style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D631B),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999)),
                                  elevation: 0,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // View Treatment Guide
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/treatment'),
                                icon: const Icon(Icons.healing, size: 20),
                                label: Text(l10n.viewTreatmentGuide,
                                    style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF0D631B),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999)),
                                  side: const BorderSide(
                                      color: Color(0xFF0D631B), width: 1.5),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Scan Another Leaf
                            SizedBox(
                              width: double.infinity,
                              child: TextButton.icon(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/scan'),
                                icon: const Icon(Icons.center_focus_strong,
                                    size: 20),
                                label: Text(l10n.scanAnotherLeafResult,
                                    style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF40493D),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
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

  // ============================================
  // HELPER WIDGETS
  // ============================================

  Widget _severityBadge(String label, Color color, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? color : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive ? color : color.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : color,
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF0D631B).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0D631B), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF40493D))),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF191C1B),
          ),
        ),
      ],
    );
  }

  Widget _recommendationItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF40493D),
                height: 1.5,
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
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.07)
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
