// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/tts_service.dart';
import '../providers/theme_provider.dart';

class DiagnosisDetail extends StatefulWidget {
  const DiagnosisDetail({super.key});

  @override
  State<DiagnosisDetail> createState() => _DiagnosisDetailState();
}

class _DiagnosisDetailState extends State<DiagnosisDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  final _ttsService = TtsService();
  bool _isSpeaking = false;
  // ✅ FIX: Read args directly in build() — not in didChangeDependencies
  // which fires too early before route args are available
  String _disease = 'Unknown';
  String _severity = 'Unknown';
  double _confidence = 0.0;
  double _infectedArea = 0.0;

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
  void dispose() {
    _controller.dispose();
    _ttsService.stop(); // Stop any ongoing speech when leaving the screen
    super.dispose();
  }

  Future<void> _toggleReadAloud(AppLocalizations l10n) async {
    if (_isSpeaking) {
      await _ttsService.stop();
      setState(() => _isSpeaking = false);
      return;
    }

    final languageName =
        Provider.of<ThemeProvider>(context, listen: false).currentLanguageName;

    // Build a natural-sounding summary from the diagnosis content already
    // shown on screen.
    final buffer = StringBuffer();
    buffer.write('${l10n.aboutDiseasePrefix}$_disease. ');
    buffer.write(_aboutText);
    buffer.write(' ${l10n.observedSymptoms}: ');
    buffer.write(_symptoms.join('. '));
    buffer.write('. ${l10n.recommendedTreatment}: ');
    buffer.write(_treatments.join('. '));

    setState(() => _isSpeaking = true);
    await _ttsService.speak(buffer.toString(), languageName);

    // Poll briefly to reset button state once speech completes — flutter_tts
    // completion handler updates isSpeaking, we just reflect it here.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isSpeaking = _ttsService.isSpeaking);
      }
    });
  }

  bool get _isHealthy => _disease.toLowerCase() == 'healthy';

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

  String get _aboutText {
    switch (_disease.toLowerCase()) {
      case 'anthracnose':
        return 'Anthracnose is a fungal disease caused by Colletotrichum spp. that commonly affects cashew plants in tropical regions. It manifests as dark, irregular spots on leaves that grow and merge over time, leading to leaf deformation and premature drop.';
      case 'gumosis':
        return 'Gumosis is caused by Phytophthora spp. and is characterized by gum exudation from the bark and branches. It thrives in waterlogged soils and spreads rapidly in humid conditions, causing cankers and dieback of branches.';
      case 'leaf miner':
        return 'Leaf Miner is caused by the larvae of Acrocercops spp. moths. The larvae tunnel through leaf tissue creating winding trails or blotches, causing photosynthetic area loss and reducing overall tree productivity.';
      case 'red rust':
        return 'Red Rust is caused by the parasitic green alga Cephaleuros virescens. It appears as reddish-brown powdery patches on leaves, weakening the plant and reducing photosynthesis. It spreads through wind and water splashes.';
      default:
        return 'The leaf appears healthy with no visible signs of disease or pest damage. Continue regular monitoring and maintenance practices to keep the plant in good condition.';
    }
  }

  String get _riskLevel {
    switch (_disease.toLowerCase()) {
      case 'anthracnose':
        return 'Moderate-High';
      case 'gumosis':
        return 'High';
      case 'leaf miner':
        return 'Moderate';
      case 'red rust':
        return 'Moderate';
      default:
        return 'None';
    }
  }

  String get _conditions {
    switch (_disease.toLowerCase()) {
      case 'anthracnose':
        return 'High humidity, warm temperatures';
      case 'gumosis':
        return 'Waterlogged soil, poor drainage';
      case 'leaf miner':
        return 'New leaf flush, dry conditions';
      case 'red rust':
        return 'High moisture, poor air circulation';
      default:
        return 'N/A';
    }
  }

  String get _spreadRate {
    switch (_disease.toLowerCase()) {
      case 'anthracnose':
        return 'Fast in rainy season';
      case 'gumosis':
        return 'Moderate, worsens with rain';
      case 'leaf miner':
        return 'Moderate during flush';
      case 'red rust':
        return 'Slow but persistent';
      default:
        return 'N/A';
    }
  }

  List<String> get _symptoms {
    switch (_disease.toLowerCase()) {
      case 'anthracnose':
        return [
          'Dark irregular spots on leaf surface',
          'Brown lesions with yellow margins',
          'Early signs of leaf deformation',
          'Slight wilting at leaf edges',
        ];
      case 'gumosis':
        return [
          'Gum exuding from bark or branches',
          'Dark water-soaked lesions on stem',
          'Wilting and dieback of branches',
          'Foul smell around affected areas',
        ];
      case 'leaf miner':
        return [
          'Winding white/brown trails on leaves',
          'Blistered or blotchy leaf surface',
          'Leaves curling or drying prematurely',
          'Small larvae visible inside mines',
        ];
      case 'red rust':
        return [
          'Reddish-brown powdery patches on leaves',
          'Velvety orange-red coating on surface',
          'Premature leaf drop',
          'Reduced leaf size and growth',
        ];
      default:
        return [
          'No visible symptoms detected',
          'Leaf color is normal and uniform',
          'No spots, lesions or deformation',
          'Healthy growth pattern observed',
        ];
    }
  }

  List<String> get _treatments {
    switch (_disease.toLowerCase()) {
      case 'anthracnose':
        return [
          'Apply copper-based fungicide immediately',
          'Remove all visibly infected leaves',
          'Improve drainage around tree base',
          'Repeat treatment after 14 days',
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
          'Remove heavily mined leaves immediately',
          'Introduce natural predators if possible',
          'Monitor new leaf flush regularly',
        ];
      case 'red rust':
        return [
          'Apply copper oxychloride fungicide',
          'Improve drainage and air circulation',
          'Prune overcrowded branches',
          'Repeat treatment after 2 weeks',
        ];
      default:
        return [
          'Continue regular field monitoring',
          'Maintain good field hygiene',
          'Ensure proper nutrition and irrigation',
          'Inspect again in 2 weeks',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // ✅ FIX: Read route arguments here — guaranteed to be available at build time
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _disease = args['disease']?.toString() ?? 'Unknown';
      _severity = args['severity']?.toString() ?? 'Unknown';
      _confidence = (args['confidence'] as num?)?.toDouble() ?? 0.0;
      _infectedArea = (args['infected_area'] as num?)?.toDouble() ?? 0.0;
    }

    final infectedPercent = (_infectedArea / 100).clamp(0.0, 1.0);
    final healthyPercent = (1.0 - infectedPercent).clamp(0.0, 1.0);
    final confidenceStr = (_confidence * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                color: const Color(0xFF0D631B).withOpacity(0.05),
              ),
            ),
          ),

          // ✅ FIX: SafeArea wraps a single ScrollView directly — no Expanded inside Column
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App bar
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                                child: const Icon(Icons.arrow_back,
                                    color: Color(0xFF0D631B), size: 20),
                              ),
                            ),
                            Text(
                              l10n.diagnosisDetailTitle,
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
                                  _isSpeaking
                                      ? Icons.stop
                                      : Icons.volume_up_outlined,
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
                      const SizedBox(height: 8),

                      // Hero card
                      Container(
                        width: double.infinity,
                        height: 200,
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
                                    const Color(0xFF1B5E20),
                                    _severityColor,
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0D631B)
                                  .withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                _isHealthy ? Icons.eco : Icons.coronavirus,
                                color: Colors.white.withValues(alpha: 0.3),
                                size: 100,
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      _disease,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _severityColor.withValues(
                                          alpha: 0.85),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      _severity,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Mini stat cards
                      Row(
                        children: [
                          Expanded(
                            child: _miniStatCard(
                              '${_infectedArea.toStringAsFixed(0)}%',
                              l10n.infectedAreaLabel,
                              _severityColor,
                              Icons.area_chart,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _miniStatCard(
                              '$confidenceStr%',
                              l10n.confidenceLabel,
                              const Color(0xFF0D631B),
                              Icons.verified,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _miniStatCard(
                              'CNN',
                              l10n.modelUsedLabel,
                              const Color(0xFF006E1C),
                              Icons.model_training,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Severity breakdown
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
                              l10n.severityBreakdown,
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: CircularPercentIndicator(
                                radius: 70,
                                lineWidth: 10,
                                percent: infectedPercent,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${_infectedArea.toStringAsFixed(0)}%',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: _severityColor,
                                      ),
                                    ),
                                    Text(
                                      l10n.infectedLabel,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                progressColor: _severityColor,
                                backgroundColor:
                                    _severityColor.withValues(alpha: 0.1),
                                circularStrokeCap: CircularStrokeCap.round,
                                animation: true,
                                animationDuration: 1500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _severityBar(l10n.healthyAreaLabel, healthyPercent,
                                const Color(0xFF0D631B)),
                            const SizedBox(height: 10),
                            _severityBar(l10n.infectedAreaBarLabel,
                                infectedPercent, _severityColor),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // About section
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
                              '${l10n.aboutDiseasePrefix}$_disease',
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _aboutText,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _infoRow(Icons.warning_amber, l10n.riskLevelLabel,
                                _riskLevel),
                            const SizedBox(height: 10),
                            _infoRow(Icons.cloud,
                                l10n.favourableConditionsLabel, _conditions),
                            const SizedBox(height: 10),
                            _infoRow(Icons.trending_up,
                                l10n.spreadRateInfoLabel, _spreadRate),
                            if (!_isHealthy) ...[
                              const SizedBox(height: 10),
                              _infoRow(
                                  Icons.science, l10n.pathogenLabel, _pathogen),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Symptoms
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
                              l10n.observedSymptoms,
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._symptoms.map((s) => _symptomItem(s)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Treatment
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF0D631B).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                const Color(0xFF0D631B).withValues(alpha: 0.15),
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
                                    color: const Color(0xFF0D631B)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.healing,
                                      color: Color(0xFF0D631B), size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.recommendedTreatment,
                                    style: GoogleFonts.manrope(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0D631B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ..._treatments.asMap().entries.map(
                                  (e) =>
                                      _treatmentItem('${e.key + 1}', e.value),
                                ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // View Full Treatment Guide button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/treatment',
                            arguments: {
                              'disease': _disease,
                              'severity': _severity,
                              'confidence': _confidence,
                              'infected_area': _infectedArea,
                            },
                          ),
                          icon: const Icon(Icons.library_books, size: 20),
                          label: Text(
                            l10n.viewFullTreatmentGuide,
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

                      const SizedBox(height: 12),

                      // Scan Another Leaf button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/scan'),
                          icon: const Icon(Icons.center_focus_strong, size: 20),
                          label: Text(
                            l10n.scanAnotherLeaf,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0D631B),
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStatCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _severityBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface)),
            Text(
              '${(value * 100).toInt()}%',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: value,
          backgroundColor: color.withOpacity(0.1),
          progressColor: color,
          barRadius: const Radius.circular(999),
          padding: EdgeInsets.zero,
          animation: true,
          animationDuration: 1500,
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF0D631B).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0D631B), size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface)),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _symptomItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: _severityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _treatmentItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF0D631B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D631B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface,
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
