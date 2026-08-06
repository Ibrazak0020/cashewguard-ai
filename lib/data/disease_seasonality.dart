/// Seasonal disease risk data for cashew, calibrated to Nigeria's climate
/// calendar (rainy season ~April–October, dry season ~November–March).
///
/// Sources synthesized from published epidemiology of the major cashew
/// diseases (anthracnose, gummosis, red rust, leaf miner) in West Africa
/// and comparable tropical cashew-growing regions — see conversation
/// notes for citations. Peak/elevated months are informed estimates for
/// awareness purposes, not a precise agronomic forecast.
class DiseaseSeasonality {
  final String diseaseName;
  final List<int> peakMonths; // 1 = January ... 12 = December
  final List<int> elevatedMonths;
  final String reason;
  final String tip;

  const DiseaseSeasonality({
    required this.diseaseName,
    required this.peakMonths,
    required this.elevatedMonths,
    required this.reason,
    required this.tip,
  });

  static const List<DiseaseSeasonality> all = [
    DiseaseSeasonality(
      diseaseName: 'Anthracnose',
      peakMonths: [5, 6, 7, 8, 9],
      elevatedMonths: [4, 10],
      reason:
          'Anthracnose thrives in warm, saturated-humidity conditions typical of the core rainy season.',
      tip:
          'Inspect leaves and young shoots weekly. Remove and destroy infected leaves promptly, and improve air circulation around trees.',
    ),
    DiseaseSeasonality(
      diseaseName: 'Gumosis',
      peakMonths: [5, 6, 7, 8, 9],
      elevatedMonths: [4, 10],
      reason:
          'Gumosis spreads faster in the rainy season, often through water-splash on wounds and pruning cuts.',
      tip:
          'Avoid pruning during heavy rains, and check trunks/branches for gum exudation after storms.',
    ),
    DiseaseSeasonality(
      diseaseName: 'Red Rust',
      peakMonths: [6, 7, 8, 9, 10],
      elevatedMonths: [5, 11],
      reason:
          'This algal disease favors consistently moist, humid conditions and can persist briefly after rains ease.',
      tip:
          'Watch for reddish-orange powdery patches on leaves, especially in shaded, poorly-ventilated parts of the canopy.',
    ),
    DiseaseSeasonality(
      diseaseName: 'Leaf Miner',
      peakMonths: [10, 11, 12],
      elevatedMonths: [9, 1],
      reason:
          'Leaf miners target tender new leaves, which flush heavily as the rains end and flowering begins.',
      tip:
          'Check new leaf flushes for winding trails or blistered patches. Young trees and nursery seedlings are most vulnerable.',
    ),
  ];

  /// Returns diseases currently in their peak risk window for [month]
  /// (1-12, defaults to the current month).
  static List<DiseaseSeasonality> peakFor({int? month}) {
    final m = month ?? DateTime.now().month;
    return all.where((d) => d.peakMonths.contains(m)).toList();
  }

  /// Returns diseases currently in an elevated (but not peak) risk window.
  static List<DiseaseSeasonality> elevatedFor({int? month}) {
    final m = month ?? DateTime.now().month;
    return all.where((d) => d.elevatedMonths.contains(m)).toList();
  }
}
