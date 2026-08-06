// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A scan result that couldn't be saved to Supabase yet (no connection),
/// waiting locally until sync succeeds.
class PendingScan {
  final String diseaseName;
  final String severity;
  final double confidence;
  final double infectedArea;
  final double? latitude;
  final double? longitude;
  final String queuedAt;

  PendingScan({
    required this.diseaseName,
    required this.severity,
    required this.confidence,
    required this.infectedArea,
    this.latitude,
    this.longitude,
    required this.queuedAt,
  });

  Map<String, dynamic> toJson() => {
        'disease_name': diseaseName,
        'severity': severity,
        'confidence': confidence,
        'infected_area': infectedArea,
        'latitude': latitude,
        'longitude': longitude,
        'queued_at': queuedAt,
      };

  factory PendingScan.fromJson(Map<String, dynamic> json) => PendingScan(
        diseaseName: json['disease_name'] as String,
        severity: json['severity'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        infectedArea: (json['infected_area'] as num).toDouble(),
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        queuedAt: json['queued_at'] as String,
      );
}

class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  factory OfflineSyncService() => _instance;
  OfflineSyncService._internal();

  static const _storageKey = 'pending_scans_queue';
  bool _listening = false;
  bool _syncing = false;

  /// Call once at app startup. Watches for connectivity changes and
  /// automatically attempts to sync any queued scans when a connection
  /// becomes available. Also tries an immediate sync in case there's
  /// already a queue waiting from a previous offline session.
  void startListening() {
    if (_listening) return;
    _listening = true;

    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        syncPendingScans();
      }
    });

    // Attempt a sync right away in case scans were queued last session.
    syncPendingScans();
  }

  /// Saves a scan result locally when it couldn't be saved to Supabase
  /// (typically due to no connectivity).
  Future<void> queueScan({
    required String diseaseName,
    required String severity,
    required double confidence,
    required double infectedArea,
    double? latitude,
    double? longitude,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];

    final pending = PendingScan(
      diseaseName: diseaseName,
      severity: severity,
      confidence: confidence,
      infectedArea: infectedArea,
      latitude: latitude,
      longitude: longitude,
      queuedAt: DateTime.now().toIso8601String(),
    );

    existing.add(jsonEncode(pending.toJson()));
    await prefs.setStringList(_storageKey, existing);
    print('📦 Scan queued for later sync (${existing.length} pending)');
  }

  /// Returns how many scans are currently waiting to sync.
  Future<int> pendingCount() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_storageKey) ?? []).length;
  }

  /// Attempts to push every queued scan to Supabase. Successfully synced
  /// entries are removed from the queue; failures stay queued for the
  /// next attempt. Safe to call repeatedly — skips if already running.
  Future<void> syncPendingScans() async {
    if (_syncing) return;
    _syncing = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final queue = prefs.getStringList(_storageKey) ?? [];
      if (queue.isEmpty) return;

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return; // not logged in yet — try again later

      final stillPending = <String>[];
      int synced = 0;

      for (final raw in queue) {
        try {
          final pending = PendingScan.fromJson(jsonDecode(raw));
          await Supabase.instance.client.from('scans').insert({
            'user_id': userId,
            'disease_name': pending.diseaseName,
            'severity': pending.severity,
            'confidence': pending.confidence,
            'infected_area': pending.infectedArea,
            if (pending.latitude != null) 'latitude': pending.latitude,
            if (pending.longitude != null) 'longitude': pending.longitude,
          });
          synced++;
        } catch (e) {
          // Still no connection, or some other transient error — keep it
          // queued and try again on the next connectivity event.
          stillPending.add(raw);
        }
      }

      await prefs.setStringList(_storageKey, stillPending);
      if (synced > 0) {
        print(
            '✅ Synced $synced queued scan(s), ${stillPending.length} still pending');
      }
    } finally {
      _syncing = false;
    }
  }
}
