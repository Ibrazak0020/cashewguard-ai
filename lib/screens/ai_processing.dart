// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:typed_data';
import '../services/prediction_service.dart';
import '../services/scan_service.dart';

class AiProcessing extends StatefulWidget {
  const AiProcessing({super.key});

  @override
  State<AiProcessing> createState() => _AiProcessingState();
}

class _AiProcessingState extends State<AiProcessing>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnim;
  late Animation<double> _rotateAnim;
  late Animation<double> _progressAnim;

  int _currentStep = 0;
  bool _processingStarted = false;

  File? _imageFile;
  Uint8List? _imageBytes;

  // ✅ Updated steps to reflect the new leaf validation pipeline
  final List<String> _steps = [
    'Validating image — checking for cashew leaf...',
    'Loading image into CNN model...',
    'Extracting leaf features...',
    'Classifying disease patterns...',
    'Predicting severity level...',
    'Generating recommendations...',
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _rotateAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_processingStarted) {
      _processingStarted = true;

      // ✅ FIX: Read args here — didChangeDependencies is safe for
      // reading route args as it's called after the route is fully built
      final args = ModalRoute.of(context)?.settings.arguments;
      debugPrint('🔍 AiProcessing args type: ${args.runtimeType}');

      if (args is Uint8List) {
        debugPrint('✅ Got Uint8List: ${args.length} bytes');
        _imageBytes = args;
      } else if (args is String) {
        // ✅ FIX: Handle String path from mobile camera/gallery
        debugPrint('✅ Got file path: $args');
        _imageFile = File(args);
      } else if (args is File) {
        debugPrint('✅ Got File: ${args.path}');
        _imageFile = args;
      } else {
        debugPrint('❌ No image args received: ${args.runtimeType}');
      }

      _startProcessing();
    }
  }

  void _startProcessing() async {
    final predictionService = PredictionService();

    // Step through UI steps
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) setState(() => _currentStep = i);
    }

    Map<String, dynamic> result;

    try {
      // ✅ Convert to bytes — works on both web and mobile
      Uint8List? bytes = _imageBytes;
      if (bytes == null && _imageFile != null) {
        bytes = await _imageFile!.readAsBytes();
        debugPrint('✅ Converted File to bytes: ${bytes.length}');
      }

      if (bytes != null) {
        debugPrint('✅ Running prediction on ${bytes.length} bytes');
        result = await predictionService.predictDiseaseFromBytes(bytes);
      } else {
        debugPrint('❌ No image bytes available');
        result = {
          'success': false,
          'disease': 'Unknown',
          'confidence': 0.0,
          'severity': 'Unknown',
          'infected_area': 0.0,
          'all_predictions': {},
          'error': 'No image provided',
        };
      }
    } catch (e) {
      debugPrint('❌ Prediction error: $e');
      result = {
        'success': false,
        'disease': 'Unknown',
        'confidence': 0.0,
        'severity': 'Unknown',
        'infected_area': 0.0,
        'all_predictions': {},
        'error': e.toString(),
      };
    }

    // ✅ Save scan to Supabase only if it's a real successful leaf prediction
    // Don't save if image was rejected as "not a leaf"
    if (result['success'] == true &&
        result['disease'] != 'Unrecognized' &&
        result['disease'] != 'Unknown') {
      try {
        final scanService = ScanService();
        await scanService.saveScan(
          diseaseName: result['disease'],
          severity: result['severity'],
          confidence: (result['confidence'] as num).toDouble(),
          infectedArea: (result['infected_area'] as num).toDouble(),
        );
        debugPrint('✅ Scan saved to Supabase');
      } catch (e) {
        debugPrint('⚠️ Scan save error (non-blocking): $e');
      }
    }

    // Navigate to result screen
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/result',
        arguments: result,
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Widget _buildImagePreview() {
    if (_imageBytes != null) {
      return Image.memory(_imageBytes!, fit: BoxFit.cover);
    }
    if (_imageFile != null && !kIsWeb) {
      return Image.file(_imageFile!, fit: BoxFit.cover);
    }
    return const SizedBox.shrink();
  }

  bool get _hasImage => _imageBytes != null || _imageFile != null;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
          ),
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0D631B).withValues(alpha: 0.05),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 40),

                          Text(
                            'Analysing Leaf',
                            style: GoogleFonts.manrope(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF191C1B),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'CashewGuard AI is analysing your cashew leaf image',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF40493D),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Show uploaded image
                          if (_hasImage)
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0D631B)
                                        .withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: _buildImagePreview(),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Animated rings
                          ScaleTransition(
                            scale: _pulseAnim,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: size.width * 0.55,
                                  height: size.width * 0.55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF0D631B)
                                        .withValues(alpha: 0.04),
                                    border: Border.all(
                                      color: const Color(0xFF0D631B)
                                          .withValues(alpha: 0.1),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.42,
                                  height: size.width * 0.42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF0D631B)
                                        .withValues(alpha: 0.06),
                                    border: Border.all(
                                      color: const Color(0xFF0D631B)
                                          .withValues(alpha: 0.15),
                                    ),
                                  ),
                                ),
                                RotationTransition(
                                  turns: _rotateAnim,
                                  child: Container(
                                    width: size.width * 0.32,
                                    height: size.width * 0.32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF0D631B)
                                            .withValues(alpha: 0.3),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.24,
                                  height: size.width * 0.24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF2E7D32),
                                        Color(0xFF4CAF50),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.psychology,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Progress bar
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Processing',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF40493D),
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _progressAnim,
                                    builder: (context, child) {
                                      return Text(
                                        '${(_progressAnim.value * 100).toInt()}%',
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0D631B),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              AnimatedBuilder(
                                animation: _progressAnim,
                                builder: (context, child) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: LinearProgressIndicator(
                                      value: _progressAnim.value,
                                      backgroundColor: const Color(0xFF0D631B)
                                          .withValues(alpha: 0.1),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xFF0D631B)),
                                      minHeight: 8,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Steps
                          Container(
                            padding: const EdgeInsets.all(16),
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
                              children: List.generate(_steps.length, (index) {
                                final isDone = index < _currentStep;
                                final isActive = index == _currentStep;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: isDone
                                              ? const Color(0xFF0D631B)
                                              : isActive
                                                  ? const Color(0xFF0D631B)
                                                      .withValues(alpha: 0.1)
                                                  : const Color(0xFFECEEEC),
                                          shape: BoxShape.circle,
                                        ),
                                        child: isDone
                                            ? const Icon(Icons.check,
                                                color: Colors.white, size: 14)
                                            : isActive
                                                ? const Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Color(0xFF0D631B),
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : Center(
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: GoogleFonts
                                                          .jetBrainsMono(
                                                        fontSize: 10,
                                                        color: const Color(
                                                            0xFF40493D),
                                                      ),
                                                    ),
                                                  ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _steps[index],
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: isActive
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: isDone
                                                ? const Color(0xFF0D631B)
                                                : isActive
                                                    ? const Color(0xFF191C1B)
                                                    : const Color(0xFF40493D)
                                                        .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),

                      // Bottom note
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Powered by CashewGuard AI',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color:
                                const Color(0xFF40493D).withValues(alpha: 0.5),
                            letterSpacing: 0.5,
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
