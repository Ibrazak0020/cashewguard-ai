// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../l10n/app_localizations.dart';

class OnboardingDetect extends StatelessWidget {
  const OnboardingDetect({super.key});
  @override
  Widget build(BuildContext context) {
    return const OnboardingFlow();
  }
}

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});
  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  // Page content now resolved via AppLocalizations at build time, since it
  // needs BuildContext for translations.
  List<Map<String, dynamic>> _pages(AppLocalizations l10n) => [
        {
          'icon': Icons.center_focus_strong,
          'secondaryIcon': Icons.search,
          'color': const Color(0xFF0D631B),
          'label': l10n.onboardStep01,
          'title': l10n.onboardTitle1,
          'subtitle': l10n.onboardSubtitle1,
          'features': [
            {'icon': Icons.bolt, 'text': l10n.onboardFeature1a},
            {'icon': Icons.wifi_off, 'text': l10n.onboardFeature1b},
            {'icon': Icons.verified, 'text': l10n.onboardFeature1c},
          ],
        },
        {
          'icon': Icons.analytics,
          'secondaryIcon': Icons.bar_chart,
          'color': const Color(0xFF006E1C),
          'label': l10n.onboardStep02,
          'title': l10n.onboardTitle2,
          'subtitle': l10n.onboardSubtitle2,
          'features': [
            {'icon': Icons.percent, 'text': l10n.onboardFeature2a},
            {'icon': Icons.timeline, 'text': l10n.onboardFeature2b},
            {'icon': Icons.science, 'text': l10n.onboardFeature2c},
          ],
        },
        {
          'icon': Icons.healing,
          'secondaryIcon': Icons.local_pharmacy,
          'color': const Color(0xFF1D622B),
          'label': l10n.onboardStep03,
          'title': l10n.onboardTitle3,
          'subtitle': l10n.onboardSubtitle3,
          'features': [
            {'icon': Icons.agriculture, 'text': l10n.onboardFeature3a},
            {'icon': Icons.schedule, 'text': l10n.onboardFeature3b},
            {'icon': Icons.library_books, 'text': l10n.onboardFeature3c},
          ],
        },
      ];

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _nextPage(int pageCount) {
    if (_currentPage < pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _pages(l10n);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // ✅ Changed from gradient icon to image asset
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/cashewguard_logo.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'CashewGuard AI',
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D631B),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: Text(
                      l10n.skip,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page view — takes remaining space
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.02),

                        // Icon
                        // Icon
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ScaleTransition(
                              scale: _pulseAnim,
                              child: Container(
                                width: size.width * 0.45,
                                height: size.width * 0.45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (page['color'] as Color)
                                      .withOpacity(0.05),
                                ),
                              ),
                            ),
                            ScaleTransition(
                              scale: _pulseAnim,
                              child: Container(
                                width: size.width * 0.35,
                                height: size.width * 0.35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (page['color'] as Color)
                                      .withOpacity(0.08),
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 0.28,
                              height: size.width * 0.28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    page['color'] as Color,
                                    (page['color'] as Color).withOpacity(0.7),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (page['color'] as Color)
                                        .withOpacity(0.3),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Icon(
                                page['icon'] as IconData,
                                color: Colors.white,
                                size: size.width * 0.12,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: size.height * 0.025),

                        // Step label
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: (page['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            page['label'] as String,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: page['color'] as Color,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.015),

                        // Title
                        Text(
                          page['title'] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: size.width * 0.065,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),

                        SizedBox(height: size.height * 0.012),

                        // Subtitle
                        Text(
                          page['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: size.width * 0.037,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: size.height * 0.02),

                        // Features
                        ...((page['features'] as List<Map<String, dynamic>>)
                            .map((feature) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: (page['color'] as Color)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          feature['icon'] as IconData,
                                          color: page['color'] as Color,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          feature['text'] as String,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList()),

                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: const Color(0xFF0D631B),
                      dotColor: const Color(0xFF0D631B).withOpacity(0.2),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _nextPage(pages.length),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D631B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == pages.length - 1
                                ? l10n.getStartedButton
                                : l10n.nextButton,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == pages.length - 1
                                ? Icons.check
                                : Icons.arrow_forward,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingAnalysis extends StatelessWidget {
  const OnboardingAnalysis({super.key});
  @override
  Widget build(BuildContext context) => const OnboardingFlow();
}

class OnboardingTreatment extends StatelessWidget {
  const OnboardingTreatment({super.key});
  @override
  Widget build(BuildContext context) => const OnboardingFlow();
}
