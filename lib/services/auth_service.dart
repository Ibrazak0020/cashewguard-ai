import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles all authentication actions against Supabase Auth.
///
/// NOTE: This file was reconstructed to match the method signatures your
/// CreateAccount screen already calls (`register(fullName, email, password)`
/// returning something with `.user`). If your original auth_service.dart had
/// additional methods (e.g. signOut, getCurrentUser, password reset, social
/// login), merge those back in — they were not visible when this was written.
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Creates a new Supabase Auth user. Because "Confirm email" is enabled on
  /// your project and your "Confirm signup" template uses {{ .Token }},
  /// Supabase automatically generates a 6-digit OTP and sends it through
  /// your Resend SMTP relay right after this call succeeds.
  Future<AuthResponse> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    return response;
  }

  /// Logs the user in. If their email hasn't been verified yet, Supabase
  /// throws an AuthException with a message containing "Email not confirmed".
  /// We catch that and rethrow a clearly-tagged exception so the UI layer
  /// can detect it and redirect to the verify-email screen instead of
  /// showing a generic error.
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('email not confirmed') ||
          msg.contains('email_not_confirmed')) {
        throw AuthException('EMAIL_NOT_VERIFIED');
      }
      rethrow;
    }
  }

  /// Verifies the 6-digit OTP the user received by email after signup.
  /// On success, the user's email is marked confirmed and a session is
  /// returned (the user is effectively logged in at this point).
  Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
  }) async {
    final response = await _client.auth.verifyOTP(
      type: OtpType.signup,
      email: email,
      token: token,
    );
    return response;
  }

  /// Sends a password-reset OTP to the given email. Supabase requires the
  /// "Reset Password" email template to use {{ .Token }} for this to be a
  /// 6-digit code rather than a magic link (same setup as your signup flow).
  Future<void> sendPasswordResetOtp({required String email}) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Verifies the password-reset OTP. On success this establishes a
  /// temporary session, which is required before calling updatePassword().
  Future<AuthResponse> verifyPasswordResetOtp({
    required String email,
    required String token,
  }) async {
    final response = await _client.auth.verifyOTP(
      type: OtpType.recovery,
      email: email,
      token: token,
    );
    return response;
  }

  /// Updates the currently logged-in user's password. Supabase requires
  /// the user to have a valid session already (they do, since they must be
  /// logged in to reach the change-password screen) — no old password
  /// re-check happens here unless you add one yourself.
  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Requests a fresh OTP be sent to the given email (e.g. if the first
  /// code expired or the user tapped "Resend code").
  Future<void> resendOtp({required String email}) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Alias for signOut — profile.dart calls this name.
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  /// Permanently deletes the current user's account. Actual deletion
  /// requires the service_role key, which must never live in the Flutter
  /// app — so this re-verifies the password locally, then calls the
  /// `delete-account` Edge Function to do the destructive part server-side.
  ///
  /// Throws an AuthException with a wrong-password-style message if the
  /// re-verification sign-in fails, or a generic Exception if the Edge
  /// Function call itself fails.
  Future<void> deleteAccount({required String password}) async {
    final email = userEmail;
    if (email.isEmpty) {
      throw Exception('No authenticated user.');
    }

    // Re-verify identity before doing anything destructive. This throws
    // AuthException if the password is wrong.
    await _client.auth.signInWithPassword(email: email, password: password);

    final response = await _client.functions.invoke('delete-account');

    if (response.status != 200) {
      final data = response.data;
      final message = data is Map && data['error'] != null
          ? data['error'].toString()
          : 'Account deletion failed (status ${response.status}).';
      throw Exception(message);
    }

    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  String get userEmail => currentUser?.email ?? '';

  /// Re-syncs the local session with the server so freshly-updated user
  /// metadata (e.g. avatar_url just after upload) is reflected immediately.
  Future<void> refreshUser() async {
    try {
      await _client.auth.refreshSession();
    } catch (_) {
      // No active session to refresh — safe to ignore.
    }
  }

  /// Uploads a new avatar to Supabase Storage and updates the user's
  /// metadata with the resulting public URL. Passing an empty byte array
  /// clears the avatar (used by the "Remove Photo" option).
  ///
  /// ASSUMPTION: storage bucket is named "avatars" and is public. If your
  /// bucket has a different name, update the string below.
  Future<void> uploadAvatar(Uint8List bytes) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No authenticated user.');
    }

    if (bytes.isEmpty) {
      await _client.auth.updateUser(
        UserAttributes(data: {'avatar_url': ''}),
      );
      return;
    }

    const bucket = 'avatars';
    final fileName = '${user.id}.jpg';

    await _client.storage.from(bucket).uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    final publicUrl = _client.storage.from(bucket).getPublicUrl(fileName);

    await _client.auth.updateUser(
      UserAttributes(data: {'avatar_url': publicUrl}),
    );
  }

  /// Convenience getter used by dashboard/profile screens: falls back to
  /// email if no full_name was set in user metadata at signup.
  String get userFullName {
    final user = currentUser;
    final metadata = user?.userMetadata;
    final fullName = metadata is Map<String, dynamic>
        ? metadata['full_name']?.toString()
        : null;
    if (fullName != null && fullName.isNotEmpty) return fullName;
    return user?.email ?? 'Cashew Farmer';
  }

  /// Convenience getter used by dashboard/profile screens for the user's
  /// profile photo URL. Returns '' if none has been set.
  String get avatarUrl {
    final user = currentUser;
    final metadata = user?.userMetadata;
    return metadata is Map<String, dynamic>
        ? (metadata['avatar_url']?.toString() ?? '')
        : '';
  }

  /// Convenience getter used by the edit-profile screen. Returns '' if no
  /// phone number has been set.
  String get userPhone {
    final metadata = currentUser?.userMetadata;
    return metadata is Map<String, dynamic>
        ? (metadata['phone']?.toString() ?? '')
        : '';
  }

  /// Convenience getter for the user's selected app language. Defaults to
  /// 'English' if none has been set. NOTE: this only stores the preference —
  /// actual UI translation is not implemented yet. All app text will still
  /// display in English regardless of this value until full localization
  /// (flutter_localizations + .arb translation files) is added.
  String get userLanguage {
    final metadata = currentUser?.userMetadata;
    return metadata is Map<String, dynamic>
        ? (metadata['language']?.toString().isNotEmpty == true
            ? metadata['language'].toString()
            : 'English')
        : 'English';
  }

  Future<void> updateLanguage(String language) async {
    await _client.auth.updateUser(
      UserAttributes(data: {'language': language}),
    );
  }

  /// Updates the user's full name and phone number in Supabase Auth's user
  /// metadata. Email is intentionally excluded — changing it requires a
  /// separate re-verification flow, which is why edit_profile.dart makes
  /// that field read-only.
  Future<void> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    await _client.auth.updateUser(
      UserAttributes(data: {
        'full_name': fullName,
        'phone': phone,
      }),
    );
  }

  /// Default notification toggle states for a user who hasn't set any
  /// preferences yet. Keys must match notifications_screen.dart's `_items`.
  static const Map<String, bool> _defaultNotificationPrefs = {
    'disease_alerts': true,
    'scan_reminders': true,
    'treatment_reminders': true,
    'weekly_reports': false,
    'app_updates': true,
  };

  /// ASSUMPTION: preferences are stored in Supabase Auth user metadata
  /// (under 'notification_prefs') rather than a dedicated table, since no
  /// settings table was mentioned. Fine for simple on/off toggles; if you
  /// ever need to query/report on these across users, a `user_settings`
  /// table would be a better fit — let me know and I'll switch this over.
  Map<String, bool> get notificationPrefs {
    final metadata = currentUser?.userMetadata;
    final stored = metadata is Map<String, dynamic>
        ? metadata['notification_prefs']
        : null;

    final result = Map<String, bool>.from(_defaultNotificationPrefs);
    if (stored is Map) {
      stored.forEach((key, value) {
        if (value is bool) result[key.toString()] = value;
      });
    }
    return result;
  }

  Future<void> updateNotificationPrefs(Map<String, bool> prefs) async {
    await _client.auth.updateUser(
      UserAttributes(data: {'notification_prefs': prefs}),
    );
  }
}
