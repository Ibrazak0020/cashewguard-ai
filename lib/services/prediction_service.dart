// ignore_for_file: unnecessary_import, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import 'severity_estimator.dart';
import 'photo_filter.dart';

// Only import tflite on mobile — never on web
import 'prediction_service_mobile.dart'
    if (dart.library.html) 'tflite_stub.dart';

class PredictionService {
  // Render cloud API — used on Web (Chrome)
  static const String _apiUrl = 'https://cashewguard-api.onrender.com/predict';

  // Confidence/entropy gate below -- consider loosening now that the
  // retrained model has balanced per-class recall (89-99.9% across all
  // 5 classes). These thresholds were likely tuned against the OLD,
  // imbalanced model and may now be silently rejecting correct
  // predictions on the naturally-less-confident classes (e.g. anthracnose,
  // leaf_miner) while red_rust's more distinctive signature passes
  // through easily -- which could look like "only red_rust ever shows up"
  // from the user's side even with a fixed, well-calibrated model.
  // Test with real photos across all 5 classes before finalizing these.
  static const double _minConfidence = 0.75;
  static const double _maxEntropy = 1.5;

  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 5);

  MobilePrediction? _mobile;

  static const List<String> _labels = [
    'Anthracnose',
    'Gumosis',
    'Healthy',
    'Leaf Miner',
    'Red Rust',
  ];

  // ============================================
  // PUBLIC METHODS
  // ============================================

  Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return _runPrediction(bytes);
  }

  Future<Map<String, dynamic>> predictDiseaseFromBytes(
      Uint8List imageBytes) async {
    return _runPrediction(imageBytes);
  }

  // ============================================
  // ROUTING — Web vs Mobile
  // ============================================

  Future<Map<String, dynamic>> _runPrediction(Uint8List imageBytes) async {
    if (kIsWeb) {
      print('🌐 Web — using Render API');
      return await _predictViaApiWithRetry(imageBytes);
    } else {
      print('📱 Mobile — using TFLite on-device');
      return await _predictViaTflite(imageBytes);
    }
  }

  // ============================================
  // ENTROPY CALCULATOR
  // ============================================

  double _calculateEntropy(List<double> probs) {
    double entropy = 0.0;
    for (final p in probs) {
      if (p > 0) entropy -= p * (log(p) / log(2));
    }
    return entropy;
  }

  // ============================================
  // VALIDATION — confidence + entropy combined
  // ============================================

  Map<String, dynamic>? _validatePrediction(
      List<double> probabilities, double maxProb) {
    if (maxProb < _minConfidence) {
      print(
          '⚠️ Low confidence (${(maxProb * 100).toStringAsFixed(1)}%) — rejecting');
      return _unrecognizedResult(maxProb);
    }

    final entropy = _calculateEntropy(probabilities);
    print('🔍 Entropy: ${entropy.toStringAsFixed(3)} (max: $_maxEntropy)');

    if (entropy >= _maxEntropy) {
      print(
          '⚠️ High entropy ${entropy.toStringAsFixed(3)} — not a cashew leaf');
      return _unrecognizedResult(maxProb);
    }

    return null; // Valid cashew leaf
  }

  // ============================================
  // WEB PATH — Render Flask API with retry
  // Severity/infected_area come straight from the API response --
  // already fixed server-side (color segmentation), no change needed here.
  // ============================================

  Future<Map<String, dynamic>> _predictViaApiWithRetry(
      Uint8List imageBytes) async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      print('📡 Attempt $attempt of $_maxRetries...');
      try {
        final result = await _predictViaApi(imageBytes);

        final error = result['error'] as String?;
        if (error != null &&
            error.contains('Server error') &&
            attempt < _maxRetries) {
          print('🔄 Server error — retrying in ${_retryDelay.inSeconds}s...');
          await Future.delayed(_retryDelay);
          continue;
        }

        return result;
      } on TimeoutException {
        print('⏱️ Timeout on attempt $attempt');
        if (attempt < _maxRetries) {
          print('🔄 Retrying in ${_retryDelay.inSeconds}s...');
          await Future.delayed(_retryDelay);
        } else {
          print('❌ All $attempt attempts timed out');
          return {
            'success': false,
            'disease': 'Timeout',
            'confidence': 0.0,
            'severity': 'Unknown',
            'infected_area': 0.0,
            'all_predictions': {},
            'error': 'timeout',
          };
        }
      } catch (e) {
        print('❌ Unexpected error on attempt $attempt: $e');
        if (attempt < _maxRetries) {
          await Future.delayed(_retryDelay);
        } else {
          return _errorResult(e.toString());
        }
      }
    }
    return _errorResult('All retries failed');
  }

  Future<Map<String, dynamic>> _predictViaApi(Uint8List imageBytes) async {
    final base64Image = base64Encode(imageBytes);

    final response = await http
        .post(
          Uri.parse(_apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'image': base64Image}),
        )
        .timeout(const Duration(seconds: 90));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final disease = data['disease'] as String;
      final confidence = (data['confidence'] as num).toDouble();

      print(
          '✅ API result: $disease (${(confidence * 100).toStringAsFixed(1)}%)');

      final allPredictionsRaw =
          data['all_predictions'] as Map<String, dynamic>? ?? {};

      final List<double> probabilities = _labels.map((label) {
        final val = allPredictionsRaw[label];
        if (val == null) return 0.0;
        final d = (val as num).toDouble();
        return d > 1.0 ? d / 100.0 : d;
      }).toList();

      final rejection = _validatePrediction(probabilities, confidence);
      if (rejection != null) return rejection;

      return {
        'success': true,
        'disease': disease,
        'confidence': confidence,
        'severity': data['severity'],
        'infected_area': data['infected_area'],
        'all_predictions': allPredictionsRaw,
      };
    } else {
      print('❌ API error: ${response.statusCode}');
      return _errorResult('Server error: ${response.statusCode}');
    }
  }

  // ============================================
  // MOBILE PATH — TFLite On-Device
  // FIXED: severity now computed via real color segmentation
  // (severity_estimator.dart), not classifier confidence.
  // ============================================

  Future<Map<String, dynamic>> _predictViaTflite(Uint8List imageBytes) async {
    try {
      _mobile ??= MobilePrediction();

      // Fast pre-filter: catches screenshots/charts/documents before
      // the ML validator or disease classifier run at all. No retraining
      // needed -- targets the specific failure mode of non-photographic
      // images the validator was never trained to recognize.
      final img.Image? decodedForCheck = img.decodeImage(imageBytes);
      if (decodedForCheck != null) {
        final photoCheck = looksPhotographic(decodedForCheck);
        print(
            '📷 Photographic check: diversity=${photoCheck.colorDiversityRatio.toStringAsFixed(3)} '
            'white_ratio=${photoCheck.whiteRatio.toStringAsFixed(3)} '
            'is_photo=${photoCheck.isPhotographic}');
        if (!photoCheck.isPhotographic) {
          print('❌ Pre-filter rejected image -- not a photo of a leaf');
          return _unrecognizedResult(0.0);
        }
      }

      // FIX: the real leaf_validator model was loaded but never actually
      // called on this path -- only a confidence/entropy heuristic on the
      // disease classifier's own output was used, which cannot reliably
      // detect non-cashew images (a 5-class classifier will often confidently
      // pick one of its 5 known classes even for an unrelated image, since
      // it was never trained with a "none of these" option). Call the real
      // validator FIRST, before running disease inference at all.
      final isLeaf = await _mobile!.validateLeaf(imageBytes);
      if (!isLeaf) {
        print('❌ Leaf validator rejected image -- not a cashew leaf');
        return _unrecognizedResult(0.0);
      }

      final probabilities = await _mobile!.runInference(imageBytes);

      int predictedIndex = 0;
      double maxProb = probabilities[0];
      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          predictedIndex = i;
        }
      }

      final disease = _labels[predictedIndex];
      final confidence = maxProb;

      print('✅ TFLite: $disease (${(confidence * 100).toStringAsFixed(1)}%)');
      print(
          '🔍 All probs: ${probabilities.map((p) => (p * 100).toStringAsFixed(1)).toList()}');

      final rejection = _validatePrediction(probabilities, confidence);
      if (rejection != null) return rejection;

      // FIX: real color-segmentation severity, decoded from the original
      // image bytes (full resolution, not the 224x224 classifier input).
      final img.Image? decoded = img.decodeImage(imageBytes);
      double? infectedArea;
      String severity;
      if (decoded == null) {
        infectedArea = null;
        severity = 'Unknown';
      } else {
        final result = estimateSeverity(decoded, disease);
        infectedArea = result.infectedArea;
        severity = result.severity;
      }

      print('✅ Infected Area: ${infectedArea ?? "N/A"}% | Severity: $severity');

      final Map<String, double> allPredictions = {};
      for (int i = 0; i < _labels.length; i++) {
        allPredictions[_labels[i]] = probabilities[i];
      }

      return {
        'success': true,
        'disease': disease,
        'confidence': confidence,
        'severity': severity,
        'infected_area': infectedArea ?? 0.0,
        'all_predictions': allPredictions,
      };
    } catch (e) {
      print('❌ TFLite error: $e');
      return _errorResult('On-device prediction failed: ${e.toString()}');
    }
  }

  // ============================================
  // HELPERS
  // ============================================

  Map<String, dynamic> _unrecognizedResult(double confidence) {
    return {
      'success': false,
      'disease': 'Unrecognized',
      'confidence': confidence,
      'severity': 'Unknown',
      'infected_area': 0.0,
      'all_predictions': {},
      'error': 'not_a_leaf',
    };
  }

  Map<String, dynamic> _errorResult(String message) {
    return {
      'success': false,
      'error': message,
      'disease': 'Unknown',
      'confidence': 0.0,
      'severity': 'Unknown',
      'infected_area': 0.0,
      'all_predictions': {},
    };
  }

  void dispose() {
    _mobile?.dispose();
    _mobile = null;
  }
}
