import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/disease_data.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/tts_service.dart';
import '../services/ai_service.dart';
import '../providers/theme_provider.dart';

// NOTE ON LOCALIZATION: This screen's disease-specific content (name,
// description, symptoms, prevention, treatment text) comes from
// disease_data.dart, which was not shared for translation. Only the
// surrounding UI labels (section headers, stat labels, buttons) are
// translated here. If disease_data.dart content should also be translated,
// that file needs to be converted separately.

class DiseaseDetail extends StatefulWidget {
  final String diseaseId;
  const DiseaseDetail({super.key, this.diseaseId = 'anthracnose'});

  @override
  State<DiseaseDetail> createState() => _DiseaseDetailState();
}

class _DiseaseDetailState extends State<DiseaseDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  late Disease disease;
  final _ttsService = TtsService();
  bool _isSpeaking = false;

  // ✅ AI: live insight state — replaces the static disease.aiInsight text
  final AiService _aiService = AiService();
  String? _liveInsight;
  bool _insightLoading = true;
  bool _insightFailed = false;
  String? _insightLoadedForDisease;

  @override
  void initState() {
    super.initState();
    disease = DiseaseData.getById(widget.diseaseId);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _loadInsight();
  }

  // ✅ FIX 2: Read the diseaseId from route arguments when the widget is built
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      setState(() {
        disease = DiseaseData.getById(args);
      });
    }
    // ✅ AI: (re)load insight if the disease shown has changed
    _loadInsight();
  }

  // ✅ AI: fetch a live, Groq-generated insight for the current disease.
  // Guarded so it only fires once per disease (didChangeDependencies can
  // run more than once during the widget's lifetime).
  Future<void> _loadInsight() async {
    if (_insightLoadedForDisease == disease.name) return;
    _insightLoadedForDisease = disease.name;

    setState(() {
      _insightLoading = true;
      _insightFailed = false;
    });

    try {
      final insight = await _aiService.getInsight(
        disease: disease.name,
        severity: disease.severity,
      );
      if (!mounted) return;
      setState(() {
        _liveInsight = insight;
        _insightLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _insightFailed = true;
        _insightLoading = false;
      });
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
    buffer.write('${l10n.aboutDiseasePrefix}${disease.name}. ');
    buffer.write(disease.description);
    buffer.write(' ${l10n.observedSymptoms}: ');
    buffer.write(disease.symptoms.join('. '));
    buffer.write('. ${l10n.recommendedTreatmentLabel}: ');
    buffer.write(disease.recommendedFungicide);
    buffer.write('. ${disease.fungicideDescription}');

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
    _pulseController.dispose();
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
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
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
                              width: 44,
                              height: 44,
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
                                  color: Color(0xFF0D631B), size: 22),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.diseaseDetailTitle,
                            style: GoogleFonts.manrope(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D631B),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _iconBtn(Icons.share_outlined),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _toggleReadAloud(l10n),
                            child: Container(
                              width: 44,
                              height: 44,
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
                                _isSpeaking
                                    ? Icons.stop
                                    : Icons.volume_up_outlined,
                                color: _isSpeaking
                                    ? Colors.white
                                    : const Color(0xFF0D631B),
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero card
                        Container(
                          width: double.infinity,
                          height: 280,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                disease.color.withValues(alpha: 0.9),
                                disease.color,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: disease.color.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                top: -20,
                                child: Icon(disease.icon,
                                    size: 200,
                                    color:
                                        Colors.white.withValues(alpha: 0.06)),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(disease.icon,
                                          color: Colors.white, size: 50),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      disease.name,
                                      style: GoogleFonts.manrope(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      disease.scientificName,
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 14,
                                        color: Colors.white
                                            .withValues(alpha: 0.75),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (disease.severity != 'None')
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        ScaleTransition(
                                          scale: _pulseAnim,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${disease.severity.toUpperCase()} ${l10n.severityLabel}',
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Stat grid
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.4,
                          children: [
                            _statCard(Icons.device_thermostat,
                                l10n.optimalTempLabel, disease.optimalTemp),
                            _statCard(Icons.water_drop, l10n.humidityLabel,
                                disease.humidity),
                            _statCard(Icons.speed, l10n.spreadRateLabel,
                                disease.spreadRate),
                            _statCard(Icons.gps_fixed, l10n.targetLabel,
                                disease.target),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // About section
                        _sectionCard(
                          icon: Icons.info_outline,
                          title: '${l10n.aboutDiseasePrefix}${disease.name}',
                          backgroundIcon: Icons.eco,
                          child: Text(
                            disease.description,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              height: 1.7,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Symptoms section
                        _sectionCard(
                          icon: Icons.search,
                          title: l10n.observedSymptoms,
                          backgroundIcon: Icons.biotech,
                          child: Column(
                            children: disease.symptoms
                                .map((s) => _symptomItem(s))
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Prevention section
                        _sectionCard(
                          icon: Icons.health_and_safety,
                          title: l10n.preventionProtocol,
                          backgroundIcon: Icons.shield,
                          child: Column(
                            children: disease.prevention
                                .map((p) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: _preventionItem(
                                        title: p['title']!,
                                        description: p['description']!,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Active treatment section
                        _sectionCard(
                          icon: Icons.medication,
                          title: l10n.activeTreatment,
                          backgroundIcon: Icons.vaccines,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F4F2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border(
                                    left: BorderSide(
                                      color: disease.color,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.recommendedTreatmentLabel,
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: disease.color,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      disease.recommendedFungicide,
                                      style: GoogleFonts.manrope(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      disease.fungicideDescription,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _infoBox(l10n.biologicalControlLabel,
                                        disease.biologicalControl),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _infoBox(l10n.applicationWindowLabel,
                                        disease.applicationWindow),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // AI Insight card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                disease.color,
                                disease.color.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: disease.color.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.psychology,
                                        color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.cashewGuardInsight,
                                          style: GoogleFonts.manrope(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // ✅ AI: live insight, with a loading
                                        // state and a graceful fallback to
                                        // the static text if the call fails.
                                        _insightLoading
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    width: 14,
                                                    height: 14,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        Colors.white
                                                            .withValues(
                                                                alpha: 0.9),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      'Thinking...',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                        color: Colors.white
                                                            .withValues(
                                                                alpha: 0.9),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                (!_insightFailed &&
                                                        _liveInsight != null)
                                                    ? _liveInsight!
                                                    : disease.aiInsight,
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: Colors.white
                                                      .withValues(alpha: 0.9),
                                                  height: 1.6,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      // ✅ AI: opens the chat screen, passing
                                      // this disease + severity as context
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/log-action-chat',
                                        arguments: {
                                          'disease': disease.name,
                                          'severity': disease.severity,
                                        },
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: disease.color,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        l10n.logAction,
                                        style: GoogleFonts.manrope(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () =>
                                          Navigator.pushNamed(context, '/scan'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        side: BorderSide(
                                          color: Colors.white
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Text(
                                        l10n.scanAgain,
                                        style: GoogleFonts.manrope(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D631B).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon,
          color: Theme.of(context).colorScheme.onSurfaceVariant, size: 22),
    );
  }

  Widget _statCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D631B).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF0D631B), size: 26),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0D631B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required IconData backgroundIcon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D631B).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: Icon(backgroundIcon,
                size: 80,
                color: const Color(0xFF0D631B).withValues(alpha: 0.04)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF0D631B), size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D631B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ],
      ),
    );
  }

  Widget _symptomItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: disease.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _preventionItem({required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF0D631B).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Color(0xFF0D631B), size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoBox(String label, String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, AppLocalizations l10n) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D631B).withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.dashboard, l10n.dashboard, '/dashboard'),
          _navItem(context, Icons.center_focus_strong, l10n.scan, '/scan'),
          _navItem(context, Icons.library_books, l10n.library, '/treatment',
              isActive: true),
          _navItem(context, Icons.history, l10n.history, '/history'),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    String route, {
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color:
                  isActive ? const Color(0xFF0D631B) : const Color(0xFF40493D),
              size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color:
                  isActive ? const Color(0xFF0D631B) : const Color(0xFF40493D),
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