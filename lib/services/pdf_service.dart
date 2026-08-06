import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PdfService {
  final _supabase = Supabase.instance.client;

  // Get all scans for current user
  Future<List<Map<String, dynamic>>> _getScans() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('scans')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  // Format date
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  // Get severity color
  PdfColor _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'healthy':
        return const PdfColor.fromInt(0xFF0D631B);
      case 'mild':
        return const PdfColor.fromInt(0xFF388E3C);
      case 'moderate':
        return const PdfColor.fromInt(0xFFE65100);
      case 'severe':
        return const PdfColor.fromInt(0xFFBA1A1A);
      default:
        return const PdfColor.fromInt(0xFF0D631B);
    }
  }

  // Generate and share PDF
  Future<void> exportToPdf({
    required String userName,
    required String userEmail,
  }) async {
    // Get scans from Supabase
    final scans = await _getScans();

    // Create PDF document
    final pdf = pw.Document();

    // Count stats
    final totalScans = scans.length;
    final diseaseCount = scans
        .where((s) => s['disease_name'].toString().toLowerCase() != 'healthy')
        .length;
    final healthyCount = scans
        .where((s) => s['disease_name'].toString().toLowerCase() == 'healthy')
        .length;

    // Colors
    const primaryGreen = PdfColor.fromInt(0xFF0D631B);
    const lightGreen = PdfColor.fromInt(0xFFE8F5E9);
    const darkText = PdfColor.fromInt(0xFF191C1B);
    const subText = PdfColor.fromInt(0xFF40493D);
    const white = PdfColors.white;
    const lightGrey = PdfColor.fromInt(0xFFF5F5F5);
    const borderGrey = PdfColor.fromInt(0xFFE0E0E0);

    // Add page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(
          userName: userName,
          userEmail: userEmail,
          primaryGreen: primaryGreen,
          white: white,
        ),
        footer: (context) => _buildFooter(
          context: context,
          subText: subText,
        ),
        build: (context) => [
          pw.SizedBox(height: 24),

          // Summary stats
          pw.Row(
            children: [
              _statBox(
                label: 'Total Scans',
                value: '$totalScans',
                color: primaryGreen,
                lightColor: lightGreen,
              ),
              pw.SizedBox(width: 12),
              _statBox(
                label: 'Diseases Found',
                value: '$diseaseCount',
                color: const PdfColor.fromInt(0xFFBA1A1A),
                lightColor: const PdfColor.fromInt(0xFFFFEBEE),
              ),
              pw.SizedBox(width: 12),
              _statBox(
                label: 'Healthy Scans',
                value: '$healthyCount',
                color: primaryGreen,
                lightColor: lightGreen,
              ),
            ],
          ),

          pw.SizedBox(height: 24),

          // Section title
          pw.Text(
            'Scan History',
            style: const pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: darkText,
            ),
          ),

          pw.SizedBox(height: 12),

          // Table
          scans.isEmpty
              ? pw.Container(
                  padding: const pw.EdgeInsets.all(24),
                  decoration: const pw.BoxDecoration(
                    color: lightGrey,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      'No scan records found.',
                      style: const pw.TextStyle(color: subText),
                    ),
                  ),
                )
              : pw.Table(
                  border: pw.TableBorder.all(
                    color: borderGrey,
                    width: 0.5,
                  ),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2.5),
                    1: const pw.FlexColumnWidth(1.5),
                    2: const pw.FlexColumnWidth(1.5),
                    3: const pw.FlexColumnWidth(1.5),
                    4: const pw.FlexColumnWidth(2),
                  },
                  children: [
                    // Table header
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: primaryGreen,
                      ),
                      children: [
                        _tableHeader('Disease', white),
                        _tableHeader('Severity', white),
                        _tableHeader('Confidence', white),
                        _tableHeader('Infected Area', white),
                        _tableHeader('Date & Time', white),
                      ],
                    ),

                    // Table rows
                    ...scans.asMap().entries.map((entry) {
                      final index = entry.key;
                      final scan = entry.value;
                      final disease =
                          (scan['disease_name'] ?? 'Unknown').toString();
                      final severity =
                          (scan['severity'] ?? 'Unknown').toString();
                      final confidence =
                          (scan['confidence'] as num?)?.toDouble() ?? 0.0;
                      final infectedArea =
                          (scan['infected_area'] as num?)?.toDouble() ?? 0.0;
                      final createdAt = (scan['created_at'] ?? '').toString();
                      final isEven = index % 2 == 0;

                      return pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: isEven ? white : lightGrey,
                        ),
                        children: [
                          _tableCell(disease, darkText),
                          _tableCellColored(
                            severity,
                            _getSeverityColor(severity),
                          ),
                          _tableCell(
                            '${(confidence * 100).toStringAsFixed(1)}%',
                            darkText,
                          ),
                          _tableCell(
                            '${infectedArea.toStringAsFixed(1)}%',
                            darkText,
                          ),
                          _tableCell(
                            _formatDate(createdAt),
                            subText,
                            fontSize: 9,
                          ),
                        ],
                      );
                    }),
                  ],
                ),

          pw.SizedBox(height: 24),

          // Disease breakdown
          if (scans.isNotEmpty) ...[
            pw.Text(
              'Disease Breakdown',
              style: const pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: darkText,
              ),
            ),
            pw.SizedBox(height: 12),
            _buildDiseaseBreakdown(
              scans: scans,
              primaryGreen: primaryGreen,
              lightGreen: lightGreen,
              darkText: darkText,
              subText: subText,
            ),
          ],
        ],
      ),
    );

    // Share/print the PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'CashewGuard_Report_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}.pdf',
    );
  }

  // Build PDF header
  pw.Widget _buildHeader({
    required String userName,
    required String userEmail,
    required PdfColor primaryGreen,
    required PdfColor white,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: primaryGreen,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'CashewGuard AI',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: white,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Diagnostic Scan Report',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: white,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Name: $userName',
                style: pw.TextStyle(
                  fontSize: 11,
                  color: white,
                ),
              ),
              pw.Text(
                'Email: $userEmail',
                style: pw.TextStyle(
                  fontSize: 11,
                  color: white,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Generated on',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: white,
                ),
              ),
              pw.Text(
                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build PDF footer
  pw.Widget _buildFooter({
    required pw.Context context,
    required PdfColor subText,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: subText, width: 0.5),
        ),
      ),
      padding: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'CashewGuard AI • Confidential Report',
            style: pw.TextStyle(fontSize: 9, color: subText),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 9, color: subText),
          ),
        ],
      ),
    );
  }

  // Stat box widget
  pw.Widget _statBox({
    required String label,
    required String value,
    required PdfColor color,
    required PdfColor lightColor,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(
          color: lightColor,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: color, width: 0.5),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
            pw.Text(
              label,
              style: const pw.TextStyle(
                fontSize: 11,
                color: PdfColor.fromInt(0xFF40493D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Table header cell
  pw.Widget _tableHeader(String text, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // Table regular cell
  pw.Widget _tableCell(
    String text,
    PdfColor color, {
    double fontSize = 10,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: fontSize, color: color),
      ),
    );
  }

  // Table colored cell for severity
  pw.Widget _tableCellColored(String text, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: pw.BoxDecoration(
          color: PdfColor(
            color.red,
            color.green,
            color.blue,
            0.1,
          ),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  // Disease breakdown section
  pw.Widget _buildDiseaseBreakdown({
    required List<Map<String, dynamic>> scans,
    required PdfColor primaryGreen,
    required PdfColor lightGreen,
    required PdfColor darkText,
    required PdfColor subText,
  }) {
    // Count each disease
    final Map<String, int> diseaseCounts = {};
    for (final scan in scans) {
      final disease = (scan['disease_name'] ?? 'Unknown').toString();
      diseaseCounts[disease] = (diseaseCounts[disease] ?? 0) + 1;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: lightGreen,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: primaryGreen, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: diseaseCounts.entries.map((entry) {
          final percentage =
              (entry.value / scans.length * 100).toStringAsFixed(1);
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  entry.key,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: darkText,
                  ),
                ),
                pw.Text(
                  '${entry.value} scan${entry.value > 1 ? 's' : ''} ($percentage%)',
                  style: pw.TextStyle(
                    fontSize: 11,
                    color: subText,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
