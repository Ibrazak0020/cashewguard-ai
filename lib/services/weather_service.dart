// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../config/weather_config.dart';

/// Simple result object describing whether conditions are good for
/// spraying fungicide/pesticide today, and why.
class SprayAdvisory {
  final bool isGoodForSpraying;
  final String reason;
  final double temperature;
  final double windSpeed; // in m/s
  final int humidity; // percentage
  final double rainChance; // 0.0–1.0, probability of precipitation
  final String condition; // e.g. "Clear", "Rain", "Clouds"
  final String cityName;

  SprayAdvisory({
    required this.isGoodForSpraying,
    required this.reason,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.rainChance,
    required this.condition,
    required this.cityName,
  });
}

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Requests location permission and returns the device's current
  /// position. Throws if permission is denied or location services are
  /// disabled — callers should catch and handle this gracefully (e.g. show
  /// a message asking the user to enable location, or fall back silently).
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permission permanently denied. Enable it in device settings.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }

  /// Fetches current weather + a simple spraying recommendation for the
  /// user's current GPS location.
  Future<SprayAdvisory> getSprayAdvisory() async {
    final position = await _getCurrentPosition();

    final url = Uri.parse(
      '$_baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}'
      '&appid=${WeatherConfig.apiKey}&units=metric',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather (${response.statusCode}).');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final double temp = (data['main']?['temp'] as num?)?.toDouble() ?? 0.0;
    final int humidity = (data['main']?['humidity'] as num?)?.toInt() ?? 0;
    final double windSpeed =
        (data['wind']?['speed'] as num?)?.toDouble() ?? 0.0;
    final String condition = (data['weather'] as List?)?.isNotEmpty == true
        ? data['weather'][0]['main']?.toString() ?? 'Unknown'
        : 'Unknown';
    final String cityName = data['name']?.toString() ?? 'Your location';

    // OpenWeatherMap's free "current weather" endpoint doesn't include a
    // direct rain probability field, so we estimate rain likelihood from
    // the condition + humidity as a simple heuristic. For a more precise
    // forecast, the One Call API (also free tier) provides pop (probability
    // of precipitation) directly — worth upgrading to later if desired.
    final bool isRainy = condition.toLowerCase().contains('rain') ||
        condition.toLowerCase().contains('drizzle') ||
        condition.toLowerCase().contains('thunderstorm');
    final double rainChance =
        isRainy ? 0.85 : (humidity > 85 ? 0.4 : (humidity > 70 ? 0.2 : 0.05));

    final advisory = _buildAdvisory(
      isRainy: isRainy,
      windSpeed: windSpeed,
      humidity: humidity,
      rainChance: rainChance,
    );

    return SprayAdvisory(
      isGoodForSpraying: advisory.$1,
      reason: advisory.$2,
      temperature: temp,
      windSpeed: windSpeed,
      humidity: humidity,
      rainChance: rainChance,
      condition: condition,
      cityName: cityName,
    );
  }

  /// Determines whether conditions are suitable for spraying, using simple
  /// agronomic rules of thumb:
  /// - Rain expected → don't spray (washes off treatment)
  /// - High wind (>4.5 m/s, ~16 km/h) → don't spray (spray drift)
  /// - Very high humidity with no rain → generally fine, slight caution
  /// Returns (isGood, reasonMessage).
  (bool, String) _buildAdvisory({
    required bool isRainy,
    required double windSpeed,
    required int humidity,
    required double rainChance,
  }) {
    if (isRainy || rainChance > 0.6) {
      return (
        false,
        'Rain is likely today. Spraying now risks the treatment washing off before it can work. Wait for a drier day.',
      );
    }
    if (windSpeed > 4.5) {
      return (
        false,
        'Wind speed is high today. Spraying in strong wind causes drift and uneven coverage. Try early morning when it\'s usually calmer.',
      );
    }
    if (humidity > 90) {
      return (
        true,
        'Conditions are generally fine, but humidity is very high apply treatment in the morning to allow better drying time.',
      );
    }
    return (
      true,
      'Conditions look good for spraying today low rain risk and manageable wind.',
    );
  }
}
