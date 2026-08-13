// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'offline_sync_service.dart';
import '../screens/privacy_settings.dart';

class ScanService {
  final _supabase = Supabase.instance.client;
  final _offlineSync = OfflineSyncService();

  // Save scan result to database. If it fails (typically no connectivity),
  // the scan is queued locally instead of being lost, and will sync
  // automatically once a connection is available.
  Future<bool> saveScan({
    required String diseaseName,
    required String severity,
    required double confidence,
    required double infectedArea,
    String? imageUrl,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      print('No user logged in');
      return false;
    }

    // ✅ AI: capture coarse location for outbreak awareness. Rounded to
    // ~1km precision (2 decimal places) before it ever leaves the
    // device — we never store or transmit exact coordinates, and
    // get_nearby_disease_points() only ever returns already-rounded
    // positions, never a user identity.
    final location = await _getRoundedLocation();

    try {
      print('Saving scan for user: $userId');

      await _supabase.from('scans').insert({
        'user_id': userId,
        'disease_name': diseaseName,
        'severity': severity,
        'confidence': confidence,
        'infected_area': infectedArea,
        'image_url': imageUrl,
        if (location != null) 'latitude': location.$1,
        if (location != null) 'longitude': location.$2,
      });

      print('Scan saved successfully');
      return true;
    } catch (e) {
      // ✅ AI: offline (or other transient failure) — queue locally rather
      // than losing the diagnosis. The result is still shown to the
      // farmer immediately; only the backend save is deferred.
      print('Could not save scan remotely, queueing offline: $e');
      await _offlineSync.queueScan(
        diseaseName: diseaseName,
        severity: severity,
        confidence: confidence,
        infectedArea: infectedArea,
        latitude: location?.$1,
        longitude: location?.$2,
      );
      return true;
    }
  }

  /// Public wrapper so screens (e.g. the Outbreak Watch map) can center
  /// on the farmer's own approximate location without duplicating the
  /// permission/rounding logic.
  Future<(double, double)?> getCurrentRoundedLocation() =>
      _getRoundedLocation();

  /// Gets the device's current location, rounded to ~1km precision for
  /// privacy, or null if location isn't available/permitted, or if the
  /// farmer has turned off location sharing in Privacy Settings. Never
  /// throws — a scan should still save even if location fails.
  Future<(double, double)?> _getRoundedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sharingEnabled =
          prefs.getBool(kLocationSharingPrefKey) ?? true;
      if (!sharingEnabled) return null;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) return null;

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      // ✅ FIX: bumped from LocationAccuracy.low to .high — the ~1km
      // rounding below already handles privacy, so there's no reason to
      // also degrade the raw GPS reading itself. "low" accuracy can be
      // off by hundreds of meters to multiple km on its own, which was
      // stacking with the rounding and making positions noticeably wrong.
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Round to 2 decimal places (~1.1km) — coarse enough to protect
      // individual farm privacy, precise enough for regional clustering.
      final roundedLat = (position.latitude * 100).round() / 100;
      final roundedLng = (position.longitude * 100).round() / 100;
      return (roundedLat, roundedLng);
    } catch (e) {
      print('Location unavailable, saving scan without it: $e');
      return null;
    }
  }

  // Get all scans for current user
  Future<List<Map<String, dynamic>>> getScans() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        print('No user logged in');
        return [];
      }

      print('Fetching scans for user: $userId');

      final response = await _supabase
          .from('scans')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('Scans fetched: ${response.length}');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching scans: $e');
      return [];
    }
  }

  // Get scan count
  Future<int> getScanCount() async {
    final scans = await getScans();
    return scans.length;
  }

  // Get disease count
  Future<int> getDiseaseCount() async {
    final scans = await getScans();
    return scans
        .where((s) => s['disease_name'].toString().toLowerCase() != 'healthy')
        .length;
  }

  // Get healthy count
  Future<int> getHealthyCount() async {
    final scans = await getScans();
    return scans
        .where((s) => s['disease_name'].toString().toLowerCase() == 'healthy')
        .length;
  }

  // Delete a scan
  Future<void> deleteScan(String scanId) async {
    try {
      await _supabase.from('scans').delete().eq('id', scanId);
      print('Scan deleted: $scanId');
    } catch (e) {
      print('Error deleting scan: $e');
    }
  }

  // ============================================
  // ✅ AI: Outbreak awareness
  // ============================================

  /// Fetches individual disease report positions from OTHER farmers
  /// within [radiusKm] over the last [days] days, using the device's
  /// current location. Positions are real (rounded to ~1km precision at
  /// scan time) — never exact — and user identity is never included.
  Future<List<Map<String, dynamic>>> getNearbyOutbreaks({
    double radiusKm = 15,
    int days = 14,
  }) async {
    final location = await _getRoundedLocation();
    if (location == null) {
      throw Exception(
          'Location unavailable — enable location access to see nearby outbreaks.');
    }

    final response = await _supabase.rpc('get_nearby_disease_points', params: {
      'p_lat': location.$1,
      'p_lng': location.$2,
      'p_radius_km': radiusKm,
      'p_days': days,
    });

    return List<Map<String, dynamic>>.from(response);
  }
}