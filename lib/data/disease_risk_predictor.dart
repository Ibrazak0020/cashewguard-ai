import 'disease_seasonality.dart';

enum RiskLevel { peak, elevated, low }

class LiveDiseaseRisk {
  final String diseaseName;
  final RiskLevel level;
  final String reason;
  final String tip;

  const LiveDiseaseRisk({
    required this.diseaseName,
    required this.level,
    required this.reason,
    required this.tip,
  });
}

/// Predicts real-time disease risk using live weather data (for the three
/// moisture/temperature-driven diseases) combined with Nigeria's
/// rainy/dry season calendar (for Leaf Miner, which is driven by
/// new-leaf-flush growth stage rather than humidity).
class DiseaseRiskPredictor {
  static List<LiveDiseaseRisk> predict({
    required double temperature,
    required int humidity,
    required double rainChance,
    int? month,
  }) {
    final currentMonth = month ?? DateTime.now().month;
    final results = <LiveDiseaseRisk>[];

    // --- Anthracnose: warm temp + sustained humidity/rain ---
    int anthracnoseScore = 0;
    if (temperature >= 22 && temperature <= 30) anthracnoseScore += 40;
    if (humidity >= 80) {
      anthracnoseScore += 30;
    } else if (humidity >= 60) {
      anthracnoseScore += 20;
    }
    if (rainChance > 0.6) {
      anthracnoseScore += 30;
    } else if (rainChance > 0.2) {
      anthracnoseScore += 15;
    }
    results.add(LiveDiseaseRisk(
      diseaseName: 'Anthracnose',
      level: _levelFor(anthracnoseScore, peakAt: 70, elevatedAt: 40),
      reason:
          'Current conditions — ${temperature.toStringAsFixed(0)}°C, $humidity% humidity${rainChance > 0.4 ? ', rain likely' : ''} — favor Anthracnose spread.',
      tip: 'Inspect leaves and young shoots this week. Remove infected material and improve airflow around trees.',
    ));

    // --- Gumosis: wound + water-splash transmission ---
    int gumosisScore = 0;
    if (rainChance > 0.6) {
      gumosisScore += 50;
    } else if (rainChance > 0.2) {
      gumosisScore += 25;
    }
    if (humidity >= 85) {
      gumosisScore += 25;
    } else if (humidity >= 70) {
      gumosisScore += 10;
    }
    results.add(LiveDiseaseRisk(
      diseaseName: 'Gumosis',
      level: _levelFor(gumosisScore, peakAt: 65, elevatedAt: 35),
      reason:
          'Wet conditions${rainChance > 0.4 ? ' with rain likely today' : ''} raise the risk of water-splash spread through wounds and pruning cuts.',
      tip: 'Avoid pruning in wet weather, and check trunks and branches for gum exudation after rain.',
    ));

    // --- Red Rust: sustained humidity, shaded canopies ---
    int redRustScore = 0;
    if (humidity >= 85) {
      redRustScore += 45;
    } else if (humidity >= 70) {
      redRustScore += 25;
    }
    if (temperature >= 20 && temperature <= 28) redRustScore += 15;
    if (rainChance > 0.3) redRustScore += 15;
    results.add(LiveDiseaseRisk(
      diseaseName: 'Red Rust',
      level: _levelFor(redRustScore, peakAt: 65, elevatedAt: 35),
      reason:
          'Sustained humidity of $humidity% favors this algal disease, especially in shaded, poorly-ventilated parts of the canopy.',
      tip: 'Watch for reddish-orange powdery patches on leaves, especially in shaded canopy areas.',
    ));

    // --- Leaf Miner: driven by new-leaf flush growth stage, not
    // humidity — stays on the seasonal calendar rather than live weather.
    final leafMinerPeak = const [10, 11, 12].contains(currentMonth);
    final leafMinerElevated = const [9, 1].contains(currentMonth);
    results.add(LiveDiseaseRisk(
      diseaseName: 'Leaf Miner',
      level: leafMinerPeak
          ? RiskLevel.peak
          : (leafMinerElevated ? RiskLevel.elevated : RiskLevel.low),
      reason:
          'Leaf miners target tender new leaves, which flush heavily as the rains end and flowering begins — a growth-stage risk rather than a weather-driven one.',
      tip: 'Check new leaf flushes for winding trails or blistered patches. Young trees are most vulnerable.',
    ));

    return results;
  }

  /// Fallback used when live weather can't be fetched (no location
  /// permission, offline, API failure) — uses the static seasonal
  /// calendar for all four diseases instead, so the feature still works.
  static List<LiveDiseaseRisk> predictFromCalendarOnly({int? month}) {
    final peak = DiseaseSeasonality.peakFor(month: month);
    final elevated = DiseaseSeasonality.elevatedFor(month: month);
    final results = <LiveDiseaseRisk>[];
    for (final d in peak) {
      results.add(LiveDiseaseRisk(
        diseaseName: d.diseaseName,
        level: RiskLevel.peak,
        reason: d.reason,
        tip: d.tip,
      ));
    }
    for (final d in elevated) {
      results.add(LiveDiseaseRisk(
        diseaseName: d.diseaseName,
        level: RiskLevel.elevated,
        reason: d.reason,
        tip: d.tip,
      ));
    }
    return results;
  }

  static RiskLevel _levelFor(int score,
      {required int peakAt, required int elevatedAt}) {
    if (score >= peakAt) return RiskLevel.peak;
    if (score >= elevatedAt) return RiskLevel.elevated;
    return RiskLevel.low;
  }
}