// severity_estimator.dart
//
// On-device severity estimation via HSV color segmentation.
// Mirrors the Flask API's get_infected_area / get_severity logic exactly,
// so mobile (offline) and web (server) predictions report severity the
// same way. NOT based on classifier confidence -- infectedArea is a real
// measured pixel-area ratio (diseased pixels / leaf pixels).

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:image/image.dart' as img;

class SeverityResult {
  final double? infectedArea; // null if segmentation failed
  final String severity;
  SeverityResult(this.infectedArea, this.severity);
}

// Work on a modest downscale for segmentation (not the 224x224 classifier
// input, which is too small for an accurate area measurement, but not the
// full original camera resolution either, which would be slow on-device).
const int _segmentationSize = 400;

SeverityResult estimateSeverity(img.Image originalImage, String diseaseLabel) {
  if (diseaseLabel == 'Healthy') {
    return SeverityResult(0.0, 'Healthy');
  }

  final img.Image resized = img.copyResize(
    originalImage,
    width: _segmentationSize,
    height: _segmentationSize,
  );

  final int w = resized.width;
  final int h = resized.height;

  // ── Step 1: convert to HSV, build saturation histogram for Otsu ──
  final List<List<double>> hue = List.generate(h, (_) => List.filled(w, 0.0));
  final List<List<double>> sat = List.generate(h, (_) => List.filled(w, 0.0));
  final List<int> satHistogram = List.filled(256, 0);

  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      final pixel = resized.getPixel(x, y);
      final r = pixel.r / 255.0;
      final g = pixel.g / 255.0;
      final b = pixel.b / 255.0;

      final maxC = [r, g, b].reduce((a, b2) => a > b2 ? a : b2);
      final minC = [r, g, b].reduce((a, b2) => a < b2 ? a : b2);
      final delta = maxC - minC;

      double hDeg;
      if (delta == 0) {
        hDeg = 0;
      } else if (maxC == r) {
        hDeg = 60 * (((g - b) / delta) % 6);
      } else if (maxC == g) {
        hDeg = 60 * (((b - r) / delta) + 2);
      } else {
        hDeg = 60 * (((r - g) / delta) + 4);
      }
      if (hDeg < 0) hDeg += 360;

      final s = maxC == 0 ? 0.0 : delta / maxC; // 0..1

      hue[y][x] = hDeg;
      sat[y][x] = s;

      satHistogram[(s * 255).round().clamp(0, 255)]++;
    }
  }

  // ── Step 2: Otsu threshold on saturation histogram ──
  final int totalPixels = w * h;
  double sumAll = 0;
  for (int i = 0; i < 256; i++) sumAll += i * satHistogram[i];

  double sumB = 0;
  int wB = 0;
  double maxVariance = 0;
  int threshold = 0;

  for (int t = 0; t < 256; t++) {
    wB += satHistogram[t];
    if (wB == 0) continue;
    final int wF = totalPixels - wB;
    if (wF == 0) break;

    sumB += t * satHistogram[t];
    final double mB = sumB / wB;
    final double mF = (sumAll - sumB) / wF;

    final double variance = wB * wF * (mB - mF) * (mB - mF);
    if (variance > maxVariance) {
      maxVariance = variance;
      threshold = t;
    }
  }
  final double satThreshold = threshold / 255.0;

  // ── Step 3: leaf mask (saturation above Otsu threshold) ──
  int leafPixelCount = 0;
  int diseasedPixelCount = 0;

  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      final bool isLeaf = sat[y][x] > satThreshold;
      if (!isLeaf) continue;
      leafPixelCount++;

      // Healthy green: hue 60-190 degrees (matches OpenCV's 30-95 on its
      // 0-179 scale, converted to standard 0-360 degrees), with real
      // saturation (not washed-out/pale pixels).
      final bool isHealthyGreen =
          hue[y][x] >= 60 && hue[y][x] <= 190 && sat[y][x] > (40 / 255.0);

      if (!isHealthyGreen) diseasedPixelCount++;
    }
  }

  const int minLeafPixels = 500;
  if (leafPixelCount < minLeafPixels) {
    return SeverityResult(null, 'Unknown');
  }

  double infectedArea = (diseasedPixelCount / leafPixelCount) * 100;
  infectedArea = infectedArea.clamp(0.0, 100.0);
  infectedArea = double.parse(infectedArea.toStringAsFixed(1));

  final String severity = _severityFromArea(infectedArea);
  return SeverityResult(infectedArea, severity);
}

String _severityFromArea(double infectedArea) {
  // Healthy  : only when predicted class is healthy (handled above)
  // Mild     : 0%  to 25% infected area
  // Moderate : 26% to 50% infected area
  // Severe   : above 50% infected area
  if (infectedArea <= 25) return 'Mild';
  if (infectedArea <= 50) return 'Moderate';
  return 'Severe';
}