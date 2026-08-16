// ignore_for_file: avoid_print, unused_local_variable, deprecated_member_use
import 'dart:async';
import '../utils/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/scan_service.dart';
import '../l10n/app_localizations.dart';
import '../services/weather_service.dart';
import '../services/notification_service.dart';
import '../widgets/seasonal_alert_screen.dart';
import '../data/disease_risk_predictor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final _authService = AuthService();
  final _scanService = ScanService();
  final _weatherService = WeatherService();

  int _totalScans = 0;
  int _diseaseCount = 0;
  int _healthyCount = 0;
  List<Map<String, dynamic>> _recentScans = [];
  bool _isLoading = true;

  SprayAdvisory? _sprayAdvisory;
  bool _isLoadingWeather = true;
  String? _weatherError;

  // ✅ AI: one-time hint banner pointing at the new AI chat icon
  bool _showAiHint = false;
  static const _aiHintDismissedKey = 'ai_assistant_hint_dismissed';

  // ✅ AI: idle-triggered weather risk push notification
  Timer? _weatherRiskTimer;
  static const _weatherRiskNotificationDateKey = 'weather_risk_notification_date';

 @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _refreshUser();
    _loadWeatherAdvisory();
    _loadAiHintState();
    // ✅ AI: check for a seasonal disease alert once the frame is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) SeasonalAlertScreen.maybeShow(context);
    });
    // ✅ AI: if the farmer stays idle on the Dashboard for a while
    // (doesn't navigate away), send a real push notification with a
    // live weather-based disease risk prediction — a background-style
    // nudge, not just the immediate in-app alert above.
    _weatherRiskTimer = Timer(
      const Duration(seconds: 45),
      _maybeShowWeatherRiskNotification,
    );
  }

  @override
  void dispose() {
    _weatherRiskTimer?.cancel();
    super.dispose();
  }

  Future<void> _maybeShowWeatherRiskNotification() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastShown = prefs.getString(_weatherRiskNotificationDateKey);
    if (lastShown == today) return; // already nudged once today

    List<LiveDiseaseRisk> risks;
    try {
      final advisory = await _weatherService.getSprayAdvisory();
      risks = DiseaseRiskPredictor.predict(
        temperature: advisory.temperature,
        humidity: advisory.humidity,
        rainChance: advisory.rainChance,
      );
    } catch (_) {
      // No weather available — skip silently rather than nag with a
      // notification built on stale/generic data.
      return;
    }

    final peak = risks.where((r) => r.level == RiskLevel.peak).toList();
    final elevated = risks.where((r) => r.level == RiskLevel.elevated).toList();
    final target = peak.isNotEmpty
        ? peak.first
        : (elevated.isNotEmpty ? elevated.first : null);
    if (target == null) return;

    await prefs.setString(_weatherRiskNotificationDateKey, today);
    await NotificationService().requestPermission();
    await NotificationService().showNotification(
      id: 200,
      title: target.level == RiskLevel.peak
          ? '${target.diseaseName} risk is high today'
          : '${target.diseaseName} risk is rising today',
      body: '${target.reason} Tap to open CashewGuard AI.',
    );
  }

  Future<void> _loadAiHintState() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getBool(_aiHintDismissedKey) ?? false;
    if (mounted) setState(() => _showAiHint = !dismissed);
  }

  Future<void> _dismissAiHint() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_aiHintDismissedKey, true);
    if (mounted) setState(() => _showAiHint = false);
  }

  Future<void> _loadWeatherAdvisory() async {
    setState(() {
      _isLoadingWeather = true;
      _weatherError = null;
    });
    try {
      final advisory = await _weatherService.getSprayAdvisory();
      if (mounted) {
        setState(() {
          _sprayAdvisory = advisory;
          _isLoadingWeather = false;
        });

        // Notify the farmer if conditions are unfavorable for spraying —
        // this is the "reminder" piece of the feature.
        if (!advisory.isGoodForSpraying) {
          await NotificationService().requestPermission();
          await NotificationService().showNotification(
            id: 100,
            title: 'Weather Advisory',
            body: advisory.reason,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingWeather = false;
          _weatherError = e.toString();
        });
      }
    }
  }

  // ✅ Refresh user metadata so avatar is always up to date
  Future<void> _refreshUser() async {
    await _authService.refreshUser();
    if (mounted) setState(() {});
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final scans = await _scanService.getScans();
      setState(() {
        _totalScans = scans.length;
        _diseaseCount = scans
            .where(
                (s) => s['disease_name'].toString().toLowerCase() != 'healthy')
            .length;
        _healthyCount = scans
            .where(
                (s) => s['disease_name'].toString().toLowerCase() == 'healthy')
            .length;
        _recentScans = scans.take(3).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Dynamic greeting based on time of day
  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return l10n.goodMorning;
    if (hour >= 12 && hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  IconData _getDiseaseIcon(String disease) {
    switch (disease.toLowerCase()) {
      case 'anthracnose':
        return Icons.coronavirus;
      case 'gumosis':
        return Icons.water_drop;
      case 'healthy':
        return Icons.eco;
      case 'leaf_miner':
      case 'leaf miner':
        return Icons.bug_report;
      case 'red_rust':
      case 'red rust':
        return Icons.grain;
      default:
        return Icons.eco;
    }
  }

  Color _getDiseaseColor(String disease) {
    switch (disease.toLowerCase()) {
      case 'anthracnose':
        return const Color(0xFFBA1A1A);
      case 'gumosis':
        return const Color(0xFFE65100);
      case 'healthy':
        return const Color(0xFF0D631B);
      case 'leaf_miner':
      case 'leaf miner':
        return const Color(0xFF795548);
      case 'red_rust':
      case 'red rust':
        return const Color(0xFFB71C1C);
      default:
        return const Color(0xFF0D631B);
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays == 0) return 'Today';
      if (diff.inDays == 1) return 'Yesterday';
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }

  String _formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return '';
    }
  }

  // ✅ Build avatar widget — shows profile photo or fallback icon
  Widget _buildAvatar() {
    final avatarUrl = _authService.avatarUrl;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/profile'),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF0D631B).withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF0D631B).withOpacity(0.2),
          ),
        ),
        child: ClipOval(
          child: avatarUrl.isNotEmpty
              ? Image.network(
                  '$avatarUrl?t=${DateTime.now().millisecondsSinceEpoch ~/ 60000}',
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.person,
                    color: Color(0xFF0D631B),
                    size: 22,
                  ),
                )
              : const Icon(
                  Icons.person,
                  color: Color(0xFF0D631B),
                  size: 22,
                ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    if (_isLoadingWeather) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF0D631B),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'Checking weather conditions...',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (_weatherError != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF40493D).withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF40493D).withOpacity(0.15)),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_off_outlined,
                color: Color(0xFF40493D), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Enable location access to get weather-based spraying advice.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF40493D),
                ),
              ),
            ),
            TextButton(
              onPressed: _loadWeatherAdvisory,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final advisory = _sprayAdvisory!;
    final color = advisory.isGoodForSpraying
        ? const Color(0xFF0D631B)
        : const Color(0xFFE65100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  advisory.isGoodForSpraying
                      ? Icons.wb_sunny_outlined
                      : Icons.warning_amber_rounded,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      advisory.isGoodForSpraying
                          ? 'Good day for spraying'
                          : 'Not ideal for spraying',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    Text(
                      '${advisory.cityName} • ${advisory.temperature.toStringAsFixed(0)}°C • ${advisory.condition}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: color.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            advisory.reason,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color.withOpacity(0.85),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = TH.primary(context);
    final bg = TH.bg(context);
    final card = TH.card(context);
    final textColor = TH.text(context);
    final subText = TH.subText(context);
    final isDark = TH.isDark(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DotGridPainter(color: TH.dotGrid(context)),
            ),
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
                // Top App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
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
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/ai-assistant'),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2E7D32),
                                    Color(0xFF4CAF50),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0D631B)
                                        .withOpacity(0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const Center(
                                    child: Icon(Icons.chat_bubble_outline,
                                        color: Colors.white, size: 19),
                                  ),
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.auto_awesome,
                                          color: Color(0xFF0D631B), size: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildAvatar(),
                        ],
                      ),
                    ],
                  ),
                ),

                if (_showAiHint)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D631B).withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF0D631B).withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.chat_bubble_outline,
                                color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'New: tap the chat icon up top anytime to talk to your AI assistant.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF0D631B),
                                height: 1.4,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _dismissAiHint,
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close,
                                  color: Color(0xFF0D631B), size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadDashboardData,
                    color: const Color(0xFF0D631B),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  color:
                                      const Color(0xFF0D631B).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _greeting(l10n),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _authService.userFullName,
                                        style: GoogleFonts.manrope(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _healthyCount > _diseaseCount
                                            ? l10n.farmHealthyMessage
                                            : l10n.diseasesDetectedMessage,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.75),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.eco,
                                      color: Colors.white, size: 36),
                                ),
                              ],
                            ),
                          ),

                         const SizedBox(height: 24),

                          _buildWeatherCard(),

                          const SizedBox(height: 24),

                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFF0D631B)))
                              : Row(
                                  children: [
                                    Expanded(
                                      child: _statCard(
                                        icon: Icons.document_scanner,
                                        label: l10n.totalScans,
                                        value: '$_totalScans',
                                        color: const Color(0xFF0D631B),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _statCard(
                                        icon: Icons.warning_amber,
                                        label: l10n.diseasesFound,
                                        value: '$_diseaseCount',
                                        color: const Color(0xFFBA1A1A),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _statCard(
                                        icon: Icons.check_circle,
                                        label: l10n.healthyScans,
                                        value: '$_healthyCount',
                                        color: const Color(0xFF006E1C),
                                      ),
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 24),

                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/scan'),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      const Color(0xFF0D631B).withOpacity(0.15),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0D631B)
                                        .withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF2E7D32),
                                          Color(0xFF4CAF50),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(Icons.center_focus_strong,
                                        color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.scanLeafNow,
                                          style: GoogleFonts.manrope(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          l10n.takeOrUploadPhoto,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      color: Color(0xFF0D631B), size: 16),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          if (_diseaseCount > 0)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFBA1A1A).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      const Color(0xFFBA1A1A).withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBA1A1A)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.warning_amber,
                                        color: Color(0xFFBA1A1A), size: 24),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.diseasesDetectedTitle(
                                              _diseaseCount),
                                          style: GoogleFonts.manrope(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFBA1A1A),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          l10n.checkScanHistoryDetails,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/history'),
                                    child: Text(
                                      l10n.view,
                                      style: GoogleFonts.manrope(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFBA1A1A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (_diseaseCount > 0) const SizedBox(height: 24),

                          Text(
                            l10n.quickActions,
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                                MediaQuery.of(context).size.width < 380
                                    ? 1.1
                                    : 1.4,
                            children: [
                              _actionCard(
                                icon: Icons.library_books,
                                label: l10n.diseaseLibrary,
                                subtitle: l10n.diseaseLibrarySubtitle,
                                color: const Color(0xFF0D631B),
                                onTap: () =>
                                    Navigator.pushNamed(context, '/treatment'),
                              ),
                              _actionCard(
                                icon: Icons.history,
                                label: l10n.scanHistory,
                                subtitle: l10n.scanHistorySubtitle(_totalScans),
                                color: const Color(0xFF006E1C),
                                onTap: () =>
                                    Navigator.pushNamed(context, '/history'),
                              ),
                              _actionCard(
                                icon: Icons.healing,
                                label: l10n.treatmentGuide,
                                subtitle: l10n.stepByStep,
                                color: const Color(0xFF1D622B),
                                onTap: () =>
                                    Navigator.pushNamed(context, '/treatment'),
                              ),
                              _actionCard(
                                icon: Icons.show_chart,
                                label: 'Trends',
                                subtitle: 'Charts over time',
                                color: const Color(0xFF2E7D32),
                                onTap: () =>
                                    Navigator.pushNamed(context, '/trends'),
                              ),
                              _actionCard(
                                icon: Icons.radar,
                                label: 'Outbreak Watch',
                                subtitle: 'Nearby disease reports',
                                color: const Color(0xFFBA1A1A),
                                onTap: () =>
                                    Navigator.pushNamed(context, '/outbreak'),
                              ),
                              _actionCard(
                                icon: Icons.settings,
                                label: l10n.settings,
                                subtitle: l10n.preferences,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/settings'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          Text(
                            l10n.recentScans,
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFF0D631B)))
                              : _recentScans.isEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          l10n.noScansYet,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: _recentScans
                                          .map((scan) => _recentScanItem(scan))
                                          .toList(),
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

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

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentScanItem(Map<String, dynamic> scan) {
    final disease = (scan['disease_name'] ?? 'Unknown').toString();
    final severity = (scan['severity'] ?? 'Unknown').toString();
    final createdAt = (scan['created_at'] ?? '').toString();
    final color = _getDiseaseColor(disease);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/diagnosis',
        arguments: {
          'disease': disease,
          'severity': severity,
          'confidence': (scan['confidence'] as num?)?.toDouble() ?? 0.0,
          'infected_area': (scan['infected_area'] as num?)?.toDouble() ?? 0.0,
        },
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D631B).withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_getDiseaseIcon(disease), color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${_formatDate(createdAt)} ${_formatTime(createdAt)}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                severity,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
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
        color: Theme.of(context).cardColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).cardColor.withOpacity(0.2)),
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
        if (index != 0) Navigator.pushNamed(context, route);
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

class DotGridPainter extends CustomPainter {
  final Color color;
  DotGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.07)
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