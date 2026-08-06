// ignore_for_file: unnecessary_string_interpolations, deprecated_member_use, avoid_print, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/scan_service.dart';
import '../l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _currentIndex = 3;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final _scanService = ScanService();
  List<Map<String, dynamic>> _scans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScans();
  }

  Future<void> _loadScans() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      final session = supabase.auth.currentSession;

      debugPrint('=== HISTORY DEBUG ===');
      debugPrint('User ID: ${user?.id}');
      debugPrint('Session: $session');

      if (user == null) {
        debugPrint('NO USER FOUND - redirecting to login');
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final scans = await _scanService.getScans();
      debugPrint('Scans loaded: ${scans.length}');

      setState(() {
        _scans = scans;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error in _loadScans: $e');
      setState(() => _isLoading = false);
    }
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

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'healthy':
        return const Color(0xFF0D631B);
      case 'mild':
        return const Color(0xFF388E3C);
      case 'moderate':
        return const Color(0xFFE65100);
      case 'severe':
        return const Color(0xFFBA1A1A);
      default:
        return const Color(0xFF0D631B);
    }
  }

  String _formatDate(String dateStr, AppLocalizations l10n) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays == 0) return l10n.today;
      if (diff.inDays == 1) return l10n.yesterday;
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  List<Map<String, dynamic>> get _filteredScans {
    if (_searchQuery.isEmpty) return _scans;
    return _scans
        .where((s) => (s['disease_name'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  int get _totalScans => _scans.length;
  int get _diseaseCount => _scans
      .where((s) => s['disease_name'].toString().toLowerCase() != 'healthy')
      .length;
  int get _healthyCount => _scans
      .where((s) => s['disease_name'].toString().toLowerCase() == 'healthy')
      .length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                      GestureDetector(
                        onTap: _loadScans,
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
                          child: const Icon(Icons.refresh,
                              color: Color(0xFF0D631B), size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                // Header + search
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.diagnosticHistory,
                        style: GoogleFonts.manrope(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D631B)
                                    .withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color(0xFF0D631B)
                                        .withValues(alpha: 0.2),
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (val) =>
                                    setState(() => _searchQuery = val),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: l10n.searchDiagnoses,
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xFF40493D)
                                        .withValues(alpha: 0.5),
                                  ),
                                  prefixIcon: const Icon(Icons.search,
                                      color: Color(0xFF40493D), size: 20),
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0D631B)
                                      .withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.filter_list,
                                color: Color(0xFF0D631B), size: 22),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Summary stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _summaryChip(
                          Icons.document_scanner,
                          l10n.scansCount(_totalScans),
                          const Color(0xFF0D631B)),
                      const SizedBox(width: 8),
                      _summaryChip(
                          Icons.warning_amber,
                          l10n.diseasesCount(_diseaseCount),
                          const Color(0xFFBA1A1A)),
                      const SizedBox(width: 8),
                      _summaryChip(
                          Icons.check_circle,
                          l10n.healthyCount(_healthyCount),
                          const Color(0xFF006E1C)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Content
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0D631B)))
                      : _filteredScans.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _searchQuery.isEmpty
                                        ? Icons.history
                                        : Icons.search_off,
                                    size: 64,
                                    color: const Color(0xFF40493D)
                                        .withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isEmpty
                                        ? l10n.noScansYetHistory
                                        : l10n.noResultsFound,
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (_searchQuery.isEmpty)
                                    Text(
                                      l10n.scanCashewLeafToStart,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadScans,
                              color: const Color(0xFF0D631B),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(24, 0, 24, 120),
                                child: Column(
                                  children: _filteredScans
                                      .map((scan) => _historyItem(scan, l10n))
                                      .toList(),
                                ),
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

  Widget _historyItem(Map<String, dynamic> scan, AppLocalizations l10n) {
    // ✅ Safe type casting — handles int, double, null from both
    // Supabase (web) and SQLite (mobile)
    final disease = (scan['disease_name'] ?? 'Unknown').toString();
    final severity = (scan['severity'] ?? 'Unknown').toString();
    final confidence = (scan['confidence'] as num?)?.toDouble() ?? 0.0;
    final createdAt = (scan['created_at'] ?? '').toString();

    final color = _getDiseaseColor(disease);
    final severityColor = _getSeverityColor(severity);

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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).cardColor.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D631B).withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Disease icon box
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.9), color],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child:
                  Icon(_getDiseaseIcon(disease), color: Colors.white, size: 26),
            ),

            const SizedBox(width: 10),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          disease,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          severity,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: severityColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.analytics,
                          size: 12, color: Color(0xFF40493D)),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          '${(confidence * 100).toStringAsFixed(1)}%',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.schedule,
                          size: 12, color: Color(0xFF40493D)),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          _formatDate(createdAt, l10n),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios,
                size: 12, color: Color(0xFF40493D)),
          ],
        ),
      ),
    );
  }

  Widget _summaryChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
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
        color: Theme.of(context).cardColor.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
            color: Theme.of(context).cardColor.withValues(alpha: 0.2)),
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
        if (index != 3) Navigator.pushNamed(context, route);
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
