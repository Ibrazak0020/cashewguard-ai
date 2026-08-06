// ignore_for_file: use_build_context_synchronously, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../l10n/app_localizations.dart';
import '../services/prediction_service_mobile.dart'
    if (dart.library.html) '../services/tflite_stub.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({super.key});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool _isAnalyzing = false;
  bool _isValidating = false;
  Uint8List? _imageBytes;
  File? _imageFile;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      debugPrint('🖼️ ImagePreview args type: ${args.runtimeType}');
      if (args is Uint8List) {
        debugPrint('✅ Got Uint8List bytes: ${args.length}');
        _imageBytes = args;
      } else if (args is File) {
        debugPrint('✅ Got File: ${args.path}');
        _imageFile = args;
      } else if (args is String) {
        debugPrint('✅ Got file path: $args');
        _imageFile = File(args);
      } else {
        debugPrint('❌ Args is null or unknown type: ${args.runtimeType}');
      }
    }
  }

  bool get _hasImage => _imageBytes != null || _imageFile != null;

  // ============================================
  // STEP 1: VALIDATE IMAGE
  // Web    → /validate API on Render (color analysis on server)
  // Mobile → leaf_validator.tflite on-device (98.12% accuracy)
  // Both work without internet on their respective platforms
  // ============================================
  Future<bool> _validateImage(Uint8List bytes) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      setState(() => _isValidating = true);

      if (kIsWeb) {
        // ✅ Web: use color analysis via Render API
        debugPrint('🌐 Web — validating via API');
        return await _validateViaApi(bytes);
      } else {
        // ✅ Mobile: use leaf_validator.tflite on-device
        debugPrint('📱 Mobile — validating via leaf_validator.tflite');
        final mobile = MobilePrediction();
        final isCashew = await mobile.validateLeaf(bytes);
        mobile.dispose();

        if (!isCashew && mounted) {
          await _showRejectionDialog(l10n.notCashewLeafMessage);
          return false;
        }
        return true;
      }
    } catch (e) {
      debugPrint('⚠️ Validation error: $e — allowing through');
      return true;
    } finally {
      if (mounted) setState(() => _isValidating = false);
    }
  }

  // ── Web validation via Render API ────────────────────────
  Future<bool> _validateViaApi(Uint8List bytes) async {
    try {
      // ignore: unnecessary_import
      // ignore: avoid_web_libraries_in_flutter
      final base64Image = base64Encode(bytes);
      final response = await http
          .post(
            Uri.parse('https://cashewguard-api.onrender.com/validate'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'image': base64Image}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final isLeaf = data['is_leaf'] as bool? ?? false;
        final message = data['message'] as String? ?? '';
        debugPrint('🌿 API Validation: isLeaf=$isLeaf | $message');
        if (!isLeaf && mounted) {
          await _showRejectionDialog(message);
          return false;
        }
        return true;
      }
      return true; // API error — allow through
    } catch (e) {
      debugPrint('⚠️ API validation error: $e — allowing through');
      return true;
    }
  }

  // ============================================
  // REJECTION DIALOG
  // ============================================
  Future<void> _showRejectionDialog(String message) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE65100).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hide_image_outlined,
                color: Color(0xFFE65100),
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.notCashewLeafTitle,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF191C1B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF40493D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // go back to scan screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D631B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.tryAnotherImage,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // STEP 2: ANALYSE — only if validation passes
  // ============================================
  void _analyzeImage() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isAnalyzing = true);

    try {
      // Get image bytes
      Uint8List? bytesToPass = _imageBytes;
      if (bytesToPass == null && _imageFile != null) {
        bytesToPass = await _imageFile!.readAsBytes();
      }

      if (bytesToPass == null) {
        debugPrint('❌ No image to validate');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noImageFoundError)),
          );
        }
        setState(() => _isAnalyzing = false);
        return;
      }

      // ✅ Validate locally on BOTH web and mobile
      // Pure Dart color analysis — no API call, no internet needed
      // Works instantly on both platforms
      final bool isValid = await _validateImage(bytesToPass);

      if (!isValid) {
        setState(() => _isAnalyzing = false);
        return;
      }

      // ✅ Passed validation — navigate to processing
      if (mounted) {
        debugPrint(
            '✅ Navigating to /processing with ${bytesToPass.length} bytes');
        Navigator.pushNamed(
          context,
          '/processing',
          arguments: bytesToPass,
        );
      }
    } catch (e) {
      debugPrint('❌ Error in _analyzeImage: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  Widget _buildImage() {
    if (_imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 300,
        errorBuilder: (context, error, stack) => _placeholderImage(),
      );
    } else if (_imageFile != null && !kIsWeb) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 300,
        errorBuilder: (context, error, stack) => _placeholderImage(),
      );
    }
    return _placeholderImage();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
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
                        l10n.imagePreviewTitle,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D631B),
                        ),
                      ),
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
                          child: const Icon(Icons.refresh,
                              color: Color(0xFF0D631B), size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Image preview
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0D631B)
                                    .withValues(alpha: 0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: _buildImage(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Image details card
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
                                l10n.imageDetails,
                                style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF191C1B),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _detailRow(
                                  Icons.photo_size_select_actual_outlined,
                                  l10n.formatLabel,
                                  'JPEG / PNG'),
                              const SizedBox(height: 12),
                              _detailRow(Icons.wb_sunny_outlined,
                                  l10n.lightingLabel, l10n.lightingGood),
                              const SizedBox(height: 12),
                              _detailRow(Icons.center_focus_strong,
                                  l10n.focusLabel, l10n.focusSharp),
                              const SizedBox(height: 12),
                              _detailRow(
                                  Icons.check_circle_outline,
                                  l10n.statusLabel,
                                  _hasImage ? l10n.imageLoaded : l10n.noImage),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Readiness card — updates during validation
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _isValidating
                                ? const Color(0xFFE65100)
                                    .withValues(alpha: 0.06)
                                : const Color(0xFF0D631B)
                                    .withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isValidating
                                  ? const Color(0xFFE65100)
                                      .withValues(alpha: 0.15)
                                  : const Color(0xFF0D631B)
                                      .withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _isValidating
                                      ? const Color(0xFFE65100)
                                          .withValues(alpha: 0.1)
                                      : const Color(0xFF0D631B)
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _isValidating
                                    ? const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFFE65100),
                                        ),
                                      )
                                    : const Icon(Icons.verified,
                                        color: Color(0xFF0D631B), size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isValidating
                                          ? l10n.checkingImage
                                          : l10n.readyForAnalysis,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: _isValidating
                                            ? const Color(0xFFE65100)
                                            : const Color(0xFF0D631B),
                                      ),
                                    ),
                                    Text(
                                      _isValidating
                                          ? l10n.verifyingLeaf
                                          : l10n.imageWillBeValidated,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: _isValidating
                                            ? const Color(0xFFE65100)
                                                .withValues(alpha: 0.7)
                                            : const Color(0xFF0D631B)
                                                .withValues(alpha: 0.7),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Analyse button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: (_isAnalyzing || _isValidating)
                                ? null
                                : _analyzeImage,
                            icon: (_isAnalyzing || _isValidating)
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.analytics, size: 22),
                            label: Text(
                              _isValidating
                                  ? l10n.validating
                                  : _isAnalyzing
                                      ? l10n.preparing
                                      : l10n.analyseThisLeaf,
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

                        // Retake button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: (_isAnalyzing || _isValidating)
                                ? null
                                : () => Navigator.pop(context),
                            icon: const Icon(Icons.camera_alt, size: 22),
                            label: Text(
                              l10n.retakePhoto,
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

  Widget _placeholderImage() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF388E3C),
            Color(0xFF66BB6A),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco,
                color: Colors.white.withValues(alpha: 0.6), size: 80),
            const SizedBox(height: 12),
            Text(
              l10n.cashewLeafSample,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF0D631B).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0D631B), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 14, color: const Color(0xFF40493D))),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF191C1B),
          ),
        ),
      ],
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
