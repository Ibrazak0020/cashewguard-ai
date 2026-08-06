import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ✅ Must be a top-level function (not a class method) — this is how
// Firebase requires background message handlers to be registered.
// It runs in a separate isolate when a push arrives while the app is
// fully closed or backgrounded, so it can't touch app state directly.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No-op: FCM automatically displays the system notification for
  // background/terminated messages that include a "notification" payload
  // (which our edge function always sends). Nothing extra needed here
  // unless you want to do background data processing later.
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Call once at app startup (in main.dart), before any notifications are
  /// shown or scheduled.
  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings: initSettings);
    _initialized = true;

    // ✅ FCM: show a heads-up local notification when a push arrives while
    // the app is in the foreground — FCM does NOT auto-display these like
    // it does for background/terminated, so we do it ourselves via the
    // local notifications plugin we already have set up.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;
      showNotification(
        id: message.hashCode,
        title: notification.title ?? 'CashewGuard AI',
        body: notification.body ?? '',
      );
    });
  }

  /// Requests notification permission — required on Android 13+ and iOS.
  /// Safe to call multiple times; the OS handles already-granted state.
  /// Also requests FCM's own permission (needed on iOS, harmless elsewhere).
  Future<void> requestPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Shows an immediate notification with the given title/body. Used for
  /// the weather spraying advisory once weather data has been fetched, and
  /// for displaying foreground FCM pushes.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'weather_advisory_channel',
      'Weather Advisories',
      channelDescription:
          'Notifications about weather conditions affecting spraying and treatment timing.',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  // ============================================
  // FCM: device token registration
  // ============================================

  /// Registers this device's FCM token with Supabase so the server can
  /// send it push notifications, and keeps it up to date if FCM rotates
  /// the token later. Call this once after a successful login.
  Future<void> registerDeviceToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      // ignore: avoid_print
      print('🔔 FCM token: $token');
      if (token != null) {
        await _saveToken(token);
        // ignore: avoid_print
        print('🔔 Token saved to Supabase successfully');
      } else {
        // ignore: avoid_print
        print(
            '🔔 FCM returned a null token — check google-services.json / Play Services');
      }

      // Keep the stored token fresh if FCM issues a new one later.
      FirebaseMessaging.instance.onTokenRefresh.listen(_saveToken);
    } catch (e, stack) {
      // ignore: avoid_print
      print('🔔 registerDeviceToken FAILED: $e');
      // ignore: avoid_print
      print(stack);
    }
  }

  Future<void> _saveToken(String token) async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      // ignore: avoid_print
      print('🔔 _saveToken skipped — no logged-in user id');
      return;
    }

    try {
      await client.from('device_tokens').upsert(
        {
          'user_id': userId,
          'fcm_token': token,
        },
        onConflict: 'fcm_token',
      );
    } catch (e) {
      // ignore: avoid_print
      print('🔔 Supabase upsert FAILED: $e');
      rethrow;
    }
  }

  /// Removes this device's token so it stops receiving pushes — call on
  /// logout so a shared/reused device doesn't keep getting another
  /// person's notifications.
  Future<void> unregisterDeviceToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await Supabase.instance.client
          .from('device_tokens')
          .delete()
          .eq('fcm_token', token);
    } catch (_) {
      // Best-effort cleanup — not worth blocking logout over.
    }
  }
}
