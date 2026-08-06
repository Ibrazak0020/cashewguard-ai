import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/scan_service.dart';

// ============================================
// DATA BUCKETING
// ============================================

class _Bucket {
  final DateTime start;
  final String label;
  int healthy = 0;
  int diseased = 0;
  final Map<String, int> diseaseCounts = {};

  _Bucket({required this.start, required this.label});

  int get total => healthy + diseased;
}

enum _ChartRange { weekly, monthly }

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  final _scanService = ScanService();
  static const _green = Color(0xFF0D631B);
  static const _red = Color(0xFFBA1A1A);

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _scans = [];
  _ChartRange _range = _ChartRange.weekly;

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
      final scans = await _scanService.getScans();
      if (!mounted) return;
      setState(() {
        _scans = scans;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load scan history.';
        _isLoading = false;
      });
    }
  }

  // ---- Bucketing --------------------------------------------------------

  List<_Bucket> _weeklyBuckets({int weeks = 8}) {
    final now = DateTime.now();
    final thisWeekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final buckets = List.generate(weeks, (i) {
      final start =
          thisWeekStart.subtract(Duration(days: 7 * (weeks - 1 - i)));
      return _Bucket(start: start, label: DateFormat('MMM d').format(start));
    });
    _fill(buckets);
    return buckets;
  }

  List<_Bucket> _monthlyBuckets({int months = 6}) {
    final now = DateTime.now();
    final buckets = List.generate(months, (i) {
      final monthsAgo = months - 1 - i;
      final start = DateTime(now.year, now.month - monthsAgo, 1);
      return _Bucket(start: start, label: DateFormat('MMM').format(start));
    });
    _fill(buckets);
    return buckets;
  }

  void _fill(List<_Bucket> buckets) {
    for (final scan in _scans) {
      final createdAt =
          DateTime.tryParse(scan['created_at']?.toString() ?? '')?.toLocal();
      if (createdAt == null) continue;
      for (final bucket in buckets.reversed) {
        if (!createdAt.isBefore(bucket.start)) {
          final disease = (scan['disease_name'] ?? 'Unknown').toString();
          if (disease.toLowerCase() == 'healthy') {
            bucket.healthy++;
          } else {
            bucket.diseased++;
            bucket.diseaseCounts[disease] =
                (bucket.diseaseCounts[disease] ?? 0) + 1;
          }
          break;
        }
      }
    }
  }

  String? get _mostCommonDisease {
    final counts = <String, int>{};
    for (final scan in _scans) {
      final disease = (scan['disease_name'] ?? 'Unknown').toString();
      if (disease.toLowerCase() == 'healthy') continue;
      counts[disease] = (counts[disease] ?? 0) + 1;
    }
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  // ---- Build --------------------------------------------------------

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
                _buildHeader(context),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: _green),
                        )
                      : _error != null
                          ? _buildError()
                          : _scans.isEmpty
                              ? _buildEmpty()
                              : _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            'Trends',
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: _red, size: 40),
            const SizedBox(height: 12),
            Text(_error!,
                style: GoogleFonts.inter(fontSize: 14, color: _red)),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart,
                color: _green.withValues(alpha: 0.4), size: 48),
            const SizedBox(height: 16),
            Text(
              'No scan history yet',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF191C1B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Scan a few leaves and check back here to see trends over time.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF40493D),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final mostCommon = _mostCommonDisease;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary stat card
          if (mostCommon != null) _buildSummaryCard(mostCommon),
          if (mostCommon != null) const SizedBox(height: 20),

          // Range toggle
          _buildRangeToggle(),
          const SizedBox(height: 16),

          // Chart card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 20, 12),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _range == _ChartRange.weekly
                      ? 'Scans per week (last 8 weeks)'
                      : 'Scans per month (last 6 months)',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF191C1B),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: _range == _ChartRange.weekly
                      ? _buildBarChart(_weeklyBuckets())
                      : _buildLineChart(_monthlyBuckets()),
                ),
                const SizedBox(height: 12),
                _buildLegend(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Disease breakdown
          _buildDiseaseBreakdown(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String mostCommon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.insights, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Most common issue',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mostCommon,
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _toggleButton('Weekly', _ChartRange.weekly)),
          Expanded(child: _toggleButton('Monthly', _ChartRange.monthly)),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, _ChartRange value) {
    final isActive = _range == value;
    return GestureDetector(
      onTap: () => setState(() => _range = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? _green : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : const Color(0xFF40493D),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _legendDot(_green, 'Healthy'),
        const SizedBox(width: 16),
        _legendDot(_red, 'Disease detected'),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF40493D),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List<_Bucket> buckets) {
    final maxY = buckets
            .map((b) => b.total)
            .fold<int>(0, (a, b) => a > b ? a : b) +
        1;

    return BarChart(
      BarChartData(
        maxY: maxY.toDouble(),
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= buckets.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    buckets[i].label,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: const Color(0xFF40493D),
                    ),
                  ),
                );
              },
              reservedSize: 26,
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final b = buckets[group.x];
              return BarTooltipItem(
                '${b.label}\nHealthy: ${b.healthy}\nDiseased: ${b.diseased}',
                GoogleFonts.inter(fontSize: 11, color: Colors.white),
              );
            },
          ),
        ),
        barGroups: List.generate(buckets.length, (i) {
          final b = buckets[i];
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: b.total.toDouble(),
                width: 16,
                borderRadius: BorderRadius.circular(4),
                rodStackItems: [
                  BarChartRodStackItem(0, b.healthy.toDouble(), _green),
                  BarChartRodStackItem(
                    b.healthy.toDouble(),
                    b.total.toDouble(),
                    _red,
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLineChart(List<_Bucket> buckets) {
    final maxY = buckets
            .map((b) => b.total)
            .fold<int>(0, (a, b) => a > b ? a : b) +
        1;

    return LineChart(
      LineChartData(
        maxY: maxY.toDouble(),
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= buckets.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    buckets[i].label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF40493D),
                    ),
                  ),
                );
              },
              reservedSize: 26,
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((s) {
              final b = buckets[s.x.toInt()];
              return LineTooltipItem(
                '${b.label}\n${b.total} scans',
                GoogleFonts.inter(fontSize: 11, color: Colors.white),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              buckets.length,
              (i) => FlSpot(i.toDouble(), buckets[i].total.toDouble()),
            ),
            isCurved: true,
            color: _green,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: _green.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseBreakdown() {
    final counts = <String, int>{};
    for (final scan in _scans) {
      final disease = (scan['disease_name'] ?? 'Unknown').toString();
      if (disease.toLowerCase() == 'healthy') continue;
      counts[disease] = (counts[disease] ?? 0) + 1;
    }
    if (counts.isEmpty) return const SizedBox.shrink();

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = sorted.fold<int>(0, (a, e) => a + e.value);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disease breakdown (all-time)',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF191C1B),
            ),
          ),
          const SizedBox(height: 16),
          ...sorted.map((e) {
            final pct = total == 0 ? 0.0 : e.value / total;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.key,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF191C1B),
                        ),
                      ),
                      Text(
                        '${e.value}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      backgroundColor: _red.withValues(alpha: 0.08),
                      valueColor: const AlwaysStoppedAnimation<Color>(_red),
                    ),
                  ),
                ],
              ),
            );
          }),
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