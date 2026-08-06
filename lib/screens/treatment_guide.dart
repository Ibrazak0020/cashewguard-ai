// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../services/weather_service.dart';
import 'package:provider/provider.dart';
import '../services/tts_service.dart';
import '../providers/theme_provider.dart';

// NOTE ON LOCALIZATION: Disease names, descriptions, treatments, and
// prevention text in _diseases below are intentionally kept in English,
// similar to the Privacy Policy / Terms of Service approach — this is
// precise agricultural/scientific terminology where imprecise translation
// could lead to incorrect treatment being applied. The surrounding UI
// chrome (search, filters, featured guide card) is fully translated.

class TreatmentGuide extends StatefulWidget {
  const TreatmentGuide({super.key});

  @override
  State<TreatmentGuide> createState() {
    return _TreatmentGuideState();
  }
}

class _TreatmentGuideState extends State<TreatmentGuide> {
  int _currentIndex = 2;
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
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
    buffer.write(l10n.preMonsoonDesc);

    setState(() => _isSpeaking = true);
    await _ttsService.speak(buffer.toString(), languageName);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isSpeaking = _ttsService.isSpeaking);
      }
    });
  }

  // ✅ AI: refined with accurate pathology-grounded descriptions and
  // treatment/prevention consistent with the seasonal risk data used
  // elsewhere in the app.
  final List<Map<String, dynamic>> _diseases = [
    {
      'id': 'anthracnose',
      'name': 'Anthracnose',
      'type': 'Fungal',
      'severity': 'High',
      'severityColor': const Color(0xFFBA1A1A),
      'icon': Icons.coronavirus,
      'color': const Color(0xFFBA1A1A),
      'description':
          'Dark, sunken lesions on leaves, shoots, and inflorescences. Most severe during the rainy season (May–Sept) under warm, humid conditions.',
      'treatment': 'Copper fungicide',
      'prevention': 'Prune infected material',
    },
    {
      'id': 'gumosis',
      'name': 'Gumosis',
      'type': 'Fungal',
      'severity': 'High',
      'severityColor': const Color(0xFFE65100),
      'icon': Icons.water_drop,
      'color': const Color(0xFFE65100),
      'description':
          'Gum oozing from bark and branches, often at wounds or pruning cuts. Spreads faster in wet, waterlogged conditions.',
      'treatment': 'Thiophanate-methyl',
      'prevention': 'Improve drainage',
    },
    {
      'id': 'healthy',
      'name': 'Healthy Leaf',
      'type': 'Healthy',
      'severity': 'None',
      'severityColor': const Color(0xFF0D631B),
      'icon': Icons.eco,
      'color': const Color(0xFF0D631B),
      'description':
          'No disease detected. Leaf shows normal coloration and healthy tissue structure.',
      'treatment': 'No treatment',
      'prevention': 'Regular monitoring',
    },
    {
      'id': 'leaf_miner',
      'name': 'Leaf Miner',
      'type': 'Pest',
      'severity': 'Moderate',
      'severityColor': const Color(0xFF795548),
      'icon': Icons.bug_report,
      'color': const Color(0xFF795548),
      'description':
          'Larvae tunnel inside tender new leaves, creating winding trails and blistered patches. Peaks during new leaf flush (Oct–Dec).',
      'treatment': 'Neem or dimethoate spray',
      'prevention': 'Monitor new flushes',
    },
    {
      'id': 'red_rust',
      'name': 'Red Rust',
      'type': 'Algal',
      'severity': 'Moderate',
      'severityColor': const Color(0xFFB71C1C),
      'icon': Icons.grain,
      'color': const Color(0xFFB71C1C),
      'description':
          'Orange-red algal patches on the leaf surface, caused by Cephaleuros virescens. Favors moist, shaded, poorly-ventilated canopies (Jun–Oct).',
      'treatment': 'Copper hydroxide',
      'prevention': 'Prune for airflow',
    },
  ];

  List<Map<String, dynamic>> get _filteredDiseases {
    return _diseases.where((disease) {
      final matchesFilter =
          _selectedFilter == 'All' || disease['type'] == _selectedFilter;

      final matchesSearch = disease['name']
          .toString()
          .toLowerCase()
          .contains(_searchText.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Filters mapped to internal values ('All','Fungal','Pest','Algal') with
    // translated display labels.
    final filters = <String, String>{
      'All': l10n.filterAll,
      'Fungal': l10n.filterFungal,
      'Pest': l10n.filterPest,
      'Algal': l10n.filterAlgal,
    };

    var children = [
      // App bar
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.diseaseLibrary,
              style: GoogleFonts.manrope(
                fontSize: 22,
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
                    color: const Color(0xFF0D631B).withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search,
                color: Color(0xFF0D631B),
                size: 20,
              ),
            ),
          ],
        ),
      ),

      // Search bar
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFBFCABA),
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: l10n.searchDiseasesHint,
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFF0D631B),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),

      const SizedBox(height: 16),

      // Weather advisory banner (compact)
      if (!_isLoadingWeather && _sprayAdvisory != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: (_sprayAdvisory!.isGoodForSpraying
                      ? const Color(0xFF0D631B)
                      : const Color(0xFFE65100))
                  .withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (_sprayAdvisory!.isGoodForSpraying
                        ? const Color(0xFF0D631B)
                        : const Color(0xFFE65100))
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _sprayAdvisory!.isGoodForSpraying
                      ? Icons.wb_sunny_outlined
                      : Icons.warning_amber_rounded,
                  color: _sprayAdvisory!.isGoodForSpraying
                      ? const Color(0xFF0D631B)
                      : const Color(0xFFE65100),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _sprayAdvisory!.isGoodForSpraying
                        ? 'Weather looks good for applying treatment today.'
                        : 'Weather caution: ${_sprayAdvisory!.reason}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: _sprayAdvisory!.isGoodForSpraying
                          ? const Color(0xFF0D631B)
                          : const Color(0xFFE65100),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

      // Filter chips
      SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filterKey = filters.keys.elementAt(index);
            final filterLabel = filters.values.elementAt(index);
            final isSelected = _selectedFilter == filterKey;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filterKey),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0D631B) : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0D631B)
                        : const Color(0xFFBFCABA),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFF0D631B).withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  filterLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF40493D),
                  ),
                ),
              ),
            );
          },
        ),
      ),

      const SizedBox(height: 16),

      // Disease cards list
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          child: Column(
            children: [
              // Disease cards
              ..._filteredDiseases.map((disease) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _diseaseCard(disease),
                  )),

              const SizedBox(height: 16),

              // Featured guide card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D631B).withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
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
                        color: const Color(0xFF0D631B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.featuredGuideBadge,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D631B),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.preMonsoonTitle,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.preMonsoonDesc,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/treatment-detail'),
                          child: Row(
                            children: [
                              Text(
                                l10n.readFullGuide,
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0D631B),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward,
                                color: Color(0xFF0D631B),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleReadAloud(l10n),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _isSpeaking
                                  ? const Color(0xFF0D631B)
                                  : const Color(0xFF0D631B)
                                      .withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isSpeaking
                                  ? Icons.stop
                                  : Icons.volume_up_outlined,
                              color: _isSpeaking
                                  ? Colors.white
                                  : const Color(0xFF0D631B),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
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
              children: children,
            ),
          ),

          // Bottom Navigation Bar
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

  Widget _diseaseCard(Map<String, dynamic> disease) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/disease',
        arguments: disease['id'], // ✅ passes 'anthracnose', 'gumosis', etc.
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (disease['color'] as Color).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (disease['color'] as Color).withOpacity(0.7),
                    disease['color'] as Color,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      disease['icon'] as IconData,
                      color: Colors.white.withOpacity(0.3),
                      size: 54,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        disease['severity'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease['name'] as String,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    disease['description'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      _tagChip(
                        Icons.science,
                        disease['treatment'] as String,
                      ),
                      _tagChip(
                        Icons.shield,
                        disease['prevention'] as String,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D631B).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF0D631B).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF0D631B)),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D631B),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
          _navItem(context, Icons.dashboard, l10n.dashboard, 0, '/dashboard'),
          _navItem(context, Icons.center_focus_strong, l10n.scan, 1, '/scan'),
          _navItem(context, Icons.library_books, l10n.library, 2, '/treatment'),
          _navItem(context, Icons.history, l10n.history, 3, '/history'),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int index,
      String route) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        if (index != 2) Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF0D631B) : const Color(0xFF40493D),
            size: 24,
          ),
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