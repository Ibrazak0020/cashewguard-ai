import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/scan_service.dart';

class OutbreakScreen extends StatefulWidget {
  const OutbreakScreen({super.key});

  @override
  State<OutbreakScreen> createState() => _OutbreakScreenState();
}

class _OutbreakScreenState extends State<OutbreakScreen> {
  final _scanService = ScanService();
  static const _green = Color(0xFF0D631B);

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _reports = [];
  double _radiusKm = 15;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final reports = await _scanService.getNearbyOutbreaks(
        radiusKm: _radiusKm,
        days: 14,
      );
      if (!mounted) return;
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Color _diseaseColor(String disease) {
    switch (disease.toLowerCase()) {
      case 'anthracnose':
        return const Color(0xFFBA1A1A);
      case 'gumosis':
        return const Color(0xFFE65100);
      case 'leaf_miner':
      case 'leaf miner':
        return const Color(0xFF795548);
      case 'red_rust':
      case 'red rust':
        return const Color(0xFFB71C1C);
      default:
        return _green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: _green))
                      : _error != null
                          ? _buildError()
                          : _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
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
                    color: _green.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: _green, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Outbreak Watch',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    final isLocationIssue = _error!.toLowerCase().contains('location');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLocationIssue ? Icons.location_off_outlined : Icons.error_outline,
              color: const Color(0xFFBA1A1A),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF40493D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _reports.isEmpty
                ? "No disease reports from nearby farmers in the last 2 weeks — looking clear."
                : "Here's what nearby farmers have reported in the last 2 weeks.",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF40493D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          _buildRadiusToggle(),
          const SizedBox(height: 20),

          // Radar visualization
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _green.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: _RadarPainter(
                  reports: _reports,
                  radiusKm: _radiusKm,
                  colorFor: _diseaseColor,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (_reports.isNotEmpty) ...[
            Text(
              'Nearby reports',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF191C1B),
              ),
            ),
            const SizedBox(height: 12),
            ..._reports.map(_buildReportCard),
          ],
        ],
      ),
    );
  }

  Widget _buildRadiusToggle() {
    final options = [10.0, 15.0, 25.0];
    return Row(
      children: options.map((r) {
        final isActive = _radiusKm == r;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              setState(() => _radiusKm = r);
              _load();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? _green : Colors.white,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: _green.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                '${r.toInt()}km',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : const Color(0xFF40493D),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final disease = (report['disease_name'] ?? 'Unknown').toString();
    final count = report['report_count'] ?? 0;
    final closest = (report['closest_km'] as num?)?.toDouble() ?? 0;
    final color = _diseaseColor(disease);

    return GestureDetector(
      onTap: () => _showReportDetail(context, disease, count, closest, color),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
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
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.report_problem_outlined, color: color, size: 22),
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
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF191C1B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$count report${count == 1 ? '' : 's'} • ~${closest}km away',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF40493D),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF40493D), size: 20),
          ],
        ),
      ),
    );
  }

  // ✅ AI: shows the actual report details before offering to chat, so
  // tapping a card doesn't jump straight past the information itself.
  void _showReportDetail(
    BuildContext context,
    String disease,
    int count,
    double closest,
    Color color,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFBFCABA),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.report_problem_outlined,
                        color: color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      disease,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF191C1B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '$count farmer${count == 1 ? '' : 's'} within ~${closest}km reported $disease in the last 2 weeks.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF40493D),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reports are anonymous — exact farm locations are never shown, only aggregate counts.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF40493D).withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushNamed(
                      context,
                      '/log-action-chat',
                      arguments: {
                        'disease': disease,
                        'severity': 'Regional Alert',
                      },
                    );
                  },
                  icon: const Icon(Icons.psychology, size: 20),
                  label: const Text('Ask AI for Prevention Tips'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<Map<String, dynamic>> reports;
  final double radiusKm;
  final Color Function(String) colorFor;

  _RadarPainter({
    required this.reports,
    required this.radiusKm,
    required this.colorFor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = (size.shortestSide / 2) - 24;

    final ringPaint = Paint()
      ..color = const Color(0xFF0D631B).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 3 concentric distance rings
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, maxRadius * i / 3, ringPaint);
    }

    // Ring distance labels
    final labelStyle = TextStyle(
      color: const Color(0xFF40493D).withValues(alpha: 0.6),
      fontSize: 9,
    );
    for (int i = 1; i <= 3; i++) {
      final km = (radiusKm * i / 3).round();
      final tp = TextPainter(
        text: TextSpan(text: '${km}km', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(center.dx + 4, center.dy - (maxRadius * i / 3) - tp.height),
      );
    }

    // Center "you" marker
    final centerPaint = Paint()..color = const Color(0xFF0D631B);
    canvas.drawCircle(center, 8, centerPaint);
    canvas.drawCircle(
      center,
      8,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Plot each disease report at an angle derived from its name (stable
    // across rebuilds) and distance scaled to closest_km.
    for (int i = 0; i < reports.length; i++) {
      final report = reports[i];
      final disease = (report['disease_name'] ?? '').toString();
      final closest = (report['closest_km'] as num?)?.toDouble() ?? 0;
      final count = (report['report_count'] as num?)?.toInt() ?? 1;

      final angle = (disease.hashCode % 360) * (3.14159 / 180);
      final distanceRatio = (closest / radiusKm).clamp(0.05, 1.0);
      final dist = maxRadius * distanceRatio;

      final dotCenter = Offset(
        center.dx + dist * cosApprox(angle),
        center.dy + dist * sinApprox(angle),
      );

      final dotRadius = 6.0 + (count.clamp(1, 8) * 1.2);
      final dotPaint = Paint()..color = colorFor(disease).withValues(alpha: 0.85);
      canvas.drawCircle(dotCenter, dotRadius, dotPaint);
      canvas.drawCircle(
        dotCenter,
        dotRadius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  // Lightweight trig without importing dart:math at the top (kept local
  // for clarity in this painter).
  double cosApprox(double radians) => _cos(radians);
  double sinApprox(double radians) => _sin(radians);

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.reports != reports || oldDelegate.radiusKm != radiusKm;
}

// Simple wrappers so the painter above reads cleanly.
double _cos(double radians) => math.cos(radians);
double _sin(double radians) => math.sin(radians);

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