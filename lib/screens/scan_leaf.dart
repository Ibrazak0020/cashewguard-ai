// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';

class ScanLeaf extends StatefulWidget {
  const ScanLeaf({super.key});

  @override
  State<ScanLeaf> createState() => _ScanLeafState();
}

class _ScanLeafState extends State<ScanLeaf>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    debugPrint('📷 Take photo button pressed');

    final status = await Permission.camera.request();
    debugPrint('📷 Camera permission: $status');

    if (status.isDenied || status.isPermanentlyDenied) {
      debugPrint('❌ Camera permission denied');
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      debugPrint('📷 Photo picked: ${photo?.path}');

      if (photo != null && mounted) {
        final bytes = await photo.readAsBytes();
        debugPrint('📷 Bytes length: ${bytes.length}');
        debugPrint('📷 Navigating to /preview...');
        Navigator.pushNamed(context, '/preview', arguments: bytes);
      } else {
        debugPrint('❌ Photo is null or widget not mounted');
      }
    } catch (e) {
      debugPrint('❌ Camera error: $e');
    }
  }

  Future<void> _uploadFromGallery() async {
    debugPrint('🖼️ Gallery button pressed');

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      debugPrint('🖼️ Image picked: ${image?.path}');

      if (image != null && mounted) {
        final bytes = await image.readAsBytes();
        debugPrint('🖼️ Bytes length: ${bytes.length}');
        debugPrint('🖼️ Navigating to /preview...');
        Navigator.pushNamed(context, '/preview', arguments: bytes);
      } else {
        debugPrint('❌ Image is null or widget not mounted');
      }
    } catch (e) {
      debugPrint('❌ Gallery error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final card = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subText = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Dot grid background
          Positioned.fill(
            child: CustomPaint(
              painter: _DotGridPainter(color: primary),
            ),
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
                color: primary.withValues(alpha: 0.05),
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
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child:
                              Icon(Icons.arrow_back, color: primary, size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        l10n.scanLeafTitle,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Instruction card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: primary.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: primary, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.scanInstructionText,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: primary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Camera viewfinder
                        ScaleTransition(
                          scale: _pulseAnim,
                          child: Container(
                            width: double.infinity,
                            height: 260,
                            decoration: BoxDecoration(
                              color: card.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: primary.withValues(alpha: 0.2),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.08),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Corner brackets
                                Positioned(
                                    top: 16,
                                    left: 16,
                                    child: _cornerBracket(
                                        topLeft: true, color: primary)),
                                Positioned(
                                    top: 16,
                                    right: 16,
                                    child: _cornerBracket(
                                        topRight: true, color: primary)),
                                Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: _cornerBracket(
                                        bottomLeft: true, color: primary)),
                                Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: _cornerBracket(
                                        bottomRight: true, color: primary)),

                                // Center content
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: primary.withValues(alpha: 0.08),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.center_focus_strong,
                                        color: primary,
                                        size: 36,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      l10n.positionLeafInFrame,
                                      style: GoogleFonts.manrope(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.ensureGoodLighting,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: subText,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Tips section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: card.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.tipsForBestResults,
                                style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _tip(Icons.wb_sunny_outlined, l10n.tipDaylight,
                                  primary, subText),
                              _tip(Icons.crop_free, l10n.tipFillFrame, primary,
                                  subText),
                              _tip(Icons.do_not_touch, l10n.tipSteadyCamera,
                                  primary, subText),
                              _tip(Icons.visibility, l10n.tipBothSides, primary,
                                  subText),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Take photo button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _takePhoto,
                            icon: const Icon(Icons.camera_alt, size: 22),
                            label: Text(
                              l10n.takePhoto,
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
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

                        // Upload from gallery button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _uploadFromGallery,
                            icon: const Icon(Icons.upload_file, size: 22),
                            label: Text(
                              l10n.uploadFromGallery,
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              side: BorderSide(
                                color: primary,
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

  Widget _tip(IconData icon, String text, Color primary, Color subText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primary, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: subText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerBracket({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
    required Color color,
  }) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _CornerPainter(
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
          color: color,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool topLeft, topRight, bottomLeft, bottomRight;
  final Color color;

  _CornerPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (topLeft) {
      canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
      canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
    }
    if (topRight) {
      canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
      canvas.drawLine(
          Offset(size.width, 0), Offset(size.width, size.height), paint);
    }
    if (bottomLeft) {
      canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
      canvas.drawLine(
          Offset(0, size.height), Offset(size.width, size.height), paint);
    }
    if (bottomRight) {
      canvas.drawLine(
          Offset(size.width, 0), Offset(size.width, size.height), paint);
      canvas.drawLine(
          Offset(0, size.height), Offset(size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DotGridPainter extends CustomPainter {
  final Color color;

  const _DotGridPainter({this.color = const Color(0xFF2E7D32)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.07)
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
