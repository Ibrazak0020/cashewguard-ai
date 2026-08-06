// ignore_for_file: avoid_print
// Mobile only — this file is never imported on web

import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class MobilePrediction {
  // Disease detection model — 5-class classifier
  Interpreter? _interpreter;

  // Leaf validator model — binary classifier
  Interpreter? _validatorInterpreter;

  // FIX: matches the actual trained optimal_threshold (0.3), not the
  // previous (1.0 - threshold) formula which compared against 0.55-0.7.
  static const double _validatorThreshold = 0.3;

  static const List<String> labels = [
    'Anthracnose',
    'Gumosis',
    'Healthy',
    'Leaf Miner',
    'Red Rust',
  ];

  // ============================================
  // LOAD DISEASE MODEL
  // ============================================
  Future<void> loadModel() async {
    if (_interpreter != null) return;
    _interpreter = await Interpreter.fromAsset(
      'assets/model/cashew_model_final.tflite',
    );
    print('✅ Disease model loaded');
  }

  // ============================================
  // LOAD LEAF VALIDATOR MODEL
  // ============================================
  Future<void> loadValidator() async {
    if (_validatorInterpreter != null) return;
    _validatorInterpreter = await Interpreter.fromAsset(
      'assets/model/leaf_validator.tflite',
    );
    print('✅ Leaf validator model loaded');
  }

  // ============================================
  // VALIDATE — is this a cashew leaf?
  // Returns true if cashew leaf, false if not
  // Uses leaf_validator.tflite binary classifier
  // ============================================
  Future<bool> validateLeaf(Uint8List imageBytes) async {
    await loadValidator();

    img.Image? decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      print('❌ Validator: Failed to decode image — allowing through');
      return true; // allow through if decode fails
    }

    img.Image resized = img.copyResize(decoded, width: 224, height: 224);

    // Build input tensor [1, 224, 224, 3]
    List<List<List<List<double>>>> input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    // Output is [1, 1] — single sigmoid value
    // cashew_leaf=0 → sigmoid close to 0.0, not_cashew_leaf=1 → close to 1.0
    final output = List.generate(1, (_) => List.filled(1, 0.0));
    _validatorInterpreter!.run(input, output);

    final confidence = output[0][0];

    // FIX: direct comparison against the trained threshold (0.3),
    // matching cashew_leaf=0/not_cashew_leaf=1 direction.
    final isCashew = confidence < _validatorThreshold;

    print(
        '🌿 Validator confidence: ${(confidence * 100).toStringAsFixed(1)}% | isCashew: $isCashew | threshold: $_validatorThreshold');

    return isCashew;
  }

  // ============================================
  // RUN DISEASE INFERENCE
  // ============================================
  Future<List<double>> runInference(Uint8List imageBytes) async {
    await loadModel();

    img.Image? decoded = img.decodeImage(imageBytes);
    if (decoded == null) throw Exception('Failed to decode image');

    img.Image resized = img.copyResize(decoded, width: 224, height: 224);

    // Build input tensor [1, 224, 224, 3] normalized to [0.0, 1.0]
    List<List<List<List<double>>>> input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    final output = List.generate(1, (_) => List.filled(5, 0.0));
    _interpreter!.run(input, output);
    return output[0];
  }

  // ============================================
  // DISPOSE BOTH MODELS
  // ============================================
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _validatorInterpreter?.close();
    _validatorInterpreter = null;
  }
}
