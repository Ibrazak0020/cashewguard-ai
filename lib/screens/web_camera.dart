// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebCameraScreen extends StatefulWidget {
  const WebCameraScreen({super.key});

  @override
  State<WebCameraScreen> createState() => _WebCameraScreenState();
}

class _WebCameraScreenState extends State<WebCameraScreen> {
  html.VideoElement? _videoElement;
  html.MediaStream? _stream;
  bool _cameraReady = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isCapturing = false;
  final String _viewId = 'webcam-view-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      // Request camera access from browser
      _stream = await html.window.navigator.mediaDevices!.getUserMedia({
        'video': {
          'facingMode': 'environment', // prefer rear camera on phones
          'width': {'ideal': 1280},
          'height': {'ideal': 720},
        },
        'audio': false,
      });

      // Set up video element
      _videoElement = html.VideoElement()
        ..srcObject = _stream
        ..autoplay = true
        ..muted = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      // Register the video element as a Flutter platform view
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        _viewId,
        (int viewId) => _videoElement!,
      );

      await _videoElement!.play();

      if (mounted) {
        setState(() => _cameraReady = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          if (e.toString().contains('NotFoundError') ||
              e.toString().contains('DevicesNotFoundError')) {
            _errorMessage =
                'No camera found on this device. Please use "Upload from Gallery" instead.';
          } else if (e.toString().contains('NotAllowedError') ||
              e.toString().contains('PermissionDeniedError')) {
            _errorMessage =
                'Camera access was denied. Please allow camera access in your browser settings and try again.';
          } else {
            _errorMessage =
                'Could not access camera. Please use "Upload from Gallery" instead.';
          }
        });
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (!_cameraReady || _videoElement == null || _isCapturing) return;

    setState(() => _isCapturing = true);

    try {
      // Draw current video frame to a canvas and export as image bytes
      final canvas = html.CanvasElement(
        width: _videoElement!.videoWidth,
        height: _videoElement!.videoHeight,
      );
      canvas.context2D.drawImage(_videoElement!, 0, 0);

      // Convert canvas to blob then to Uint8List
      final blob = await canvas.toBlob('image/jpeg', 0.9);
      final reader = html.FileReader();
      reader.readAsArrayBuffer(blob);
      await reader.onLoad.first;

      final Uint8List bytes = Uint8List.fromList((reader.result as List<int>));

      _stopCamera();
      if (mounted) Navigator.pop(context, bytes);
    } catch (e) {
      if (mounted) {
        setState(() => _isCapturing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture photo: $e'),
            backgroundColor: const Color(0xFFBA1A1A),
          ),
        );
      }
    }
  }

  void _stopCamera() {
    _stream?.getTracks().forEach((track) => track.stop());
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera preview or error state
            if (_hasError)
              _buildErrorState()
            else if (_cameraReady)
              HtmlElementView(viewType: _viewId)
            else
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF0D631B)),
                    SizedBox(height: 16),
                    Text(
                      'Starting camera...',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),

            // Top bar — always visible
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _stopCamera();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Take Photo',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Capture button — only when camera is ready
            if (_cameraReady && !_hasError)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      'Tap to capture',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _capturePhoto,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: _isCapturing
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Container(
                                margin: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
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

  Widget _buildErrorState() {
    return Container(
      color: const Color(0xFF0D1A0D),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFBA1A1A).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.videocam_off,
                color: Color(0xFFBA1A1A), size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            'Camera Unavailable',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: Text(
              'Go Back',
              style: GoogleFonts.manrope(
                  fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D631B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
