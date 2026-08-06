// Web stub — provides dummy MobilePrediction class so web compiler
// can resolve the type. This code never actually runs on web
// because prediction_service.dart checks kIsWeb before calling it.

import 'dart:typed_data';

class MobilePrediction {
  Future<void> loadModel() async {}

  Future<void> loadValidator() async {}

  // ✅ Added stub — never called on web (API is used instead)
  Future<bool> validateLeaf(Uint8List imageBytes) async {
    throw UnsupportedError('TFLite is not supported on web.');
  }

  Future<List<double>> runInference(Uint8List imageBytes) async {
    throw UnsupportedError('TFLite is not supported on web.');
  }

  void dispose() {}
}
