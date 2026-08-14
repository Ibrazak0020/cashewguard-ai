// photo_filter.dart
//
// Fast pre-filter that catches screenshots/charts/documents/UI images
// BEFORE the ML validator or disease classifier run. No retraining needed.
//
// Why this is needed: the leaf validator was trained only on real
// photographs (cashew leaves + other-plant leaves), so it has never seen
// a screenshot, chart, or document, and its behavior on one is essentially
// undefined. Real camera photos have high pixel-color diversity (natural
// noise/gradients); screenshots and charts use large areas of flat,
// identical color and often large white margins. This mirrors the same
// logic used server-side in app_final.py's looks_photographic().

import 'package:image/image.dart' as img;

class PhotoCheckResult {
  final bool isPhotographic;
  final double colorDiversityRatio;
  final double whiteRatio;
  PhotoCheckResult(this.isPhotographic, this.colorDiversityRatio, this.whiteRatio);
}

PhotoCheckResult looksPhotographic(
  img.Image originalImage, {
  double minDiversity = 0.12,
  double maxWhiteRatio = 0.35,
}) {
  final img.Image small = img.copyResize(originalImage, width: 100, height: 100);
  const int totalPixels = 100 * 100;

  final Set<int> uniqueColors = {};
  int whiteCount = 0;

  for (int y = 0; y < 100; y++) {
    for (int x = 0; x < 100; x++) {
      final pixel = small.getPixel(x, y);
      final r = pixel.r.toInt();
      final g = pixel.g.toInt();
      final b = pixel.b.toInt();

      // pack into a single int for fast Set membership
      final packed = (r << 16) | (g << 8) | b;
      uniqueColors.add(packed);

      if (r > 245 && g > 245 && b > 245) {
        whiteCount++;
      }
    }
  }

  final double colorDiversityRatio = uniqueColors.length / totalPixels;
  final double whiteRatio = whiteCount / totalPixels;

  final bool isPhotographic =
      colorDiversityRatio > minDiversity && whiteRatio < maxWhiteRatio;

  return PhotoCheckResult(isPhotographic, colorDiversityRatio, whiteRatio);
}