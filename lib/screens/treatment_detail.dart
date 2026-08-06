import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../services/weather_service.dart';
import 'package:provider/provider.dart';
import '../services/tts_service.dart';
import '../providers/theme_provider.dart';

class TreatmentDetail extends StatefulWidget {
  const TreatmentDetail({super.key});

  @override
  State<TreatmentDetail> createState() => _TreatmentDetailState();
}

class _TreatmentDetailState extends State<TreatmentDetail> {
  final List<bool> _completedSteps = [false, false, false, false, false];
  final _weatherService = WeatherService();
  final _ttsService = TtsService();
  SprayAdvisory? _sprayAdvisory;
  bool _isLoadingWeather = true;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _loadWeatherAdvisory();
  }

  Future<void> _loadWeatherAdvisory() async {
    try {
      final advisory = await _weatherService.getSprayAdvisory();
      if (mounted) {
        setState(() {
          _sprayAdvisory = advisory;
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingWeather = false);
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
    buffer.write('${l10n.preMonsoonTitle}. ');
    buffer.write('${l10n.overview}: ${l10n.preMonsoonOverviewText} ');
    buffer.write('${l10n.stepByStepGuide}. ');
    buffer.write('${l10n.step1Title}. ${l10n.step1Desc} ');
    buffer.write('${l10n.step2Title}. ${l10n.step2Desc} ');
    buffer.write('${l10n.step3Title}. ${l10n.step3Desc} ');
    buffer.write('${l10n.step4Title}. ${l10n.step4Desc} ');
    buffer.write('${l10n.step5Title}. ${l10n.step5Desc}');

    setState(() => _isSpeaking = true);
    await _ttsService.speak(buffer.toString(), languageName);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isSpeaking = _ttsService.isSpeaking);
      }
    });
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

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

          // Top blob
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
                                    .withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF0D631B),
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        l10n.treatmentDetailTitle,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D631B),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _toggleReadAloud(l10n),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _isSpeaking
                                ? const Color(0xFF0D631B)
                                : Colors.white,
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
                          child: Icon(
                            _isSpeaking ? Icons.stop : Icons.volume_up_outlined,
                            color: _isSpeaking
                                ? Colors.white
                                : const Color(0xFF0D631B),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                color: const Color(0xFF0D631B)
                                    .withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  l10n.featuredGuideBadge,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.preMonsoonTitle,
                                style: GoogleFonts.manrope(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.preMonsoonDesc,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _infoPill(
                                      Icons.access_time, l10n.readTimeLabel),
                                  const SizedBox(width: 8),
                                  _infoPill(Icons.eco, l10n.allCashewLabel),
                                  const SizedBox(width: 8),
                                  _infoPill(Icons.star, l10n.expertLevelLabel),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Weather advisory banner
                        if (!_isLoadingWeather && _sprayAdvisory != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: (_sprayAdvisory!.isGoodForSpraying
                                      ? const Color(0xFF0D631B)
                                      : const Color(0xFFE65100))
                                  .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: (_sprayAdvisory!.isGoodForSpraying
                                        ? const Color(0xFF0D631B)
                                        : const Color(0xFFE65100))
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  _sprayAdvisory!.isGoodForSpraying
                                      ? Icons.wb_sunny_outlined
                                      : Icons.warning_amber_rounded,
                                  color: _sprayAdvisory!.isGoodForSpraying
                                      ? const Color(0xFF0D631B)
                                      : const Color(0xFFE65100),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _sprayAdvisory!.isGoodForSpraying
                                            ? 'Good conditions today'
                                            : 'Weather caution',
                                        style: GoogleFonts.manrope(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              _sprayAdvisory!.isGoodForSpraying
                                                  ? const Color(0xFF0D631B)
                                                  : const Color(0xFFE65100),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _sprayAdvisory!.reason,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color:
                                              (_sprayAdvisory!.isGoodForSpraying
                                                      ? const Color(0xFF0D631B)
                                                      : const Color(0xFFE65100))
                                                  .withValues(alpha: 0.85),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Progress tracker
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.yourProgress,
                                    style: GoogleFonts.manrope(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  Text(
                                    l10n.stepsCount(
                                        _completedSteps.where((s) => s).length,
                                        _completedSteps.length),
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value:
                                      _completedSteps.where((s) => s).length /
                                          _completedSteps.length,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Overview
                        Text(
                          l10n.overview,
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.preMonsoonOverviewText,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Materials needed
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
                                l10n.materialsNeeded,
                                style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _materialItem(
                                  Icons.science, l10n.materialCopperFungicide),
                              _materialItem(
                                  Icons.water_drop, l10n.materialSulphurSpray),
                              _materialItem(
                                  Icons.agriculture, l10n.materialSprayer),
                              _materialItem(
                                  Icons.safety_divider, l10n.materialGloves),
                              _materialItem(Icons.cut, l10n.materialShears),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Step by step guide
                        Text(
                          l10n.stepByStepGuide,
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _treatmentStep(
                          index: 0,
                          stepNumber: '01',
                          title: l10n.step1Title,
                          description: l10n.step1Desc,
                          duration: l10n.step1Duration,
                          icon: Icons.search,
                          l10n: l10n,
                        ),
                        _treatmentStep(
                          index: 1,
                          stepNumber: '02',
                          title: l10n.step2Title,
                          description: l10n.step2Desc,
                          duration: l10n.step2Duration,
                          icon: Icons.cut,
                          l10n: l10n,
                        ),
                        _treatmentStep(
                          index: 2,
                          stepNumber: '03',
                          title: l10n.step3Title,
                          description: l10n.step3Desc,
                          duration: l10n.step3Duration,
                          icon: Icons.science,
                          l10n: l10n,
                        ),
                        _treatmentStep(
                          index: 3,
                          stepNumber: '04',
                          title: l10n.step4Title,
                          description: l10n.step4Desc,
                          duration: l10n.step4Duration,
                          icon: Icons.cleaning_services,
                          l10n: l10n,
                        ),
                        _treatmentStep(
                          index: 4,
                          stepNumber: '05',
                          title: l10n.step5Title,
                          description: l10n.step5Desc,
                          duration: l10n.step5Duration,
                          icon: Icons.monitor_heart,
                          l10n: l10n,
                        ),

                        const SizedBox(height: 24),

                        // Warning card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFBA1A1A).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFBA1A1A)
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFBA1A1A)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.warning_amber,
                                  color: Color(0xFFBA1A1A),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.importantSafetyNote,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFBA1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.safetyNoteText,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: const Color(0xFFBA1A1A)
                                            .withValues(alpha: 0.8),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Mark complete button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                for (int i = 0;
                                    i < _completedSteps.length;
                                    i++) {
                                  _completedSteps[i] = true;
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.treatmentGuideCompleted,
                                    style:
                                        GoogleFonts.inter(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFF0D631B),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle, size: 20),
                            label: Text(
                              l10n.markAllStepsComplete,
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

  Widget _infoPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _materialItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF0D631B).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0D631B), size: 16),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _treatmentStep({
    required int index,
    required String stepNumber,
    required String title,
    required String description,
    required String duration,
    required IconData icon,
    required AppLocalizations l10n,
  }) {
    final isCompleted = _completedSteps[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          _completedSteps[index] = !_completedSteps[index];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isCompleted
              ? const Color(0xFF0D631B).withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFF0D631B).withValues(alpha: 0.3)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D631B).withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step number / check
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF0D631B)
                    : const Color(0xFF0D631B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 22)
                  : Center(
                      child: Text(
                        stepNumber,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D631B),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF0D631B).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          duration,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D631B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  if (isCompleted) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF0D631B),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.completed,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D631B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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
