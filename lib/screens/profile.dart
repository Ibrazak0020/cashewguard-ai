// ignore_for_file: unnecessary_to_list_in_spreads, unnecessary_import, deprecated_member_use

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/scan_service.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _scanService = ScanService();
  final _picker = ImagePicker();

  int _totalScans = 0;
  int _diseaseCount = 0;
  int _healthyCount = 0;
  bool _isLoading = true;
  bool _isUploadingAvatar = false;

  // Holds newly picked image bytes for immediate display
  Uint8List? _localAvatarBytes;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _refreshUser();
  }

  Future<void> _refreshUser() async {
    await _authService.refreshUser();
    if (mounted) setState(() {}); // rebuild with fresh metadata
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final scans = await _scanService.getScans();
      setState(() {
        _totalScans = scans.length;
        _diseaseCount = scans
            .where(
                (s) => s['disease_name'].toString().toLowerCase() != 'healthy')
            .length;
        _healthyCount = scans
            .where(
                (s) => s['disease_name'].toString().toLowerCase() == 'healthy')
            .length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Pick image and upload to Supabase
  Future<void> _changeAvatar() async {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFBFCABA),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.changeProfilePhoto,
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF191C1B),
                ),
              ),
              const SizedBox(height: 20),
              _sheetOption(
                icon: Icons.camera_alt,
                label: l10n.takeAPhoto,
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              _sheetOption(
                icon: Icons.photo_library,
                label: l10n.chooseFromGallery,
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_authService.avatarUrl.isNotEmpty) ...[
                const SizedBox(height: 12),
                _sheetOption(
                  icon: Icons.delete_outline,
                  label: l10n.removePhoto,
                  color: const Color(0xFFBA1A1A),
                  onTap: () {
                    Navigator.pop(ctx);
                    _removeAvatar();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();

      // Show image immediately while uploading
      setState(() {
        _localAvatarBytes = bytes;
        _isUploadingAvatar = true;
      });

      await _authService.uploadAvatar(bytes);

      if (mounted) {
        setState(() => _isUploadingAvatar = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.photoUpdatedSuccess),
            backgroundColor: const Color(0xFF0D631B),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update photo: $e'),
            backgroundColor: const Color(0xFFBA1A1A),
          ),
        );
      }
    }
  }

  Future<void> _removeAvatar() async {
    try {
      setState(() => _isUploadingAvatar = true);
      await _authService.uploadAvatar(Uint8List(0));
    } catch (_) {}
    setState(() {
      _localAvatarBytes = null;
      _isUploadingAvatar = false;
    });
  }

  // ✅ Build avatar widget — shows local bytes, remote URL, or default icon
  Widget _buildAvatar() {
    ImageProvider? imageProvider;

    if (_localAvatarBytes != null) {
      imageProvider = MemoryImage(_localAvatarBytes!);
    } else if (_authService.avatarUrl.isNotEmpty) {
      // Add cache-bust to force refresh after upload
      imageProvider = NetworkImage(
          '${_authService.avatarUrl}?t=${DateTime.now().millisecondsSinceEpoch}');
    }

    return Stack(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: imageProvider == null
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  )
                : null,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D631B).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: imageProvider != null
                ? Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    width: 110,
                    height: 110,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 56,
                    ),
                  )
                : const Icon(Icons.person, color: Colors.white, size: 56),
          ),
        ),

        // Edit button
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: _isUploadingAvatar ? null : _changeAvatar,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF0D631B),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: _isUploadingAvatar
                  ? const Padding(
                      padding: EdgeInsets.all(7),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.edit, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = const Color(0xFF0D631B),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0D631B).withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0D631B)
                                        .withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.arrow_back,
                                  color: Color(0xFF0D631B), size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'CashewGuard AI',
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D631B),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.notifications_outlined,
                              color: Color(0xFF40493D), size: 24),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _changeAvatar,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF0D631B).withOpacity(0.1),
                                border: Border.all(
                                  color:
                                      const Color(0xFF0D631B).withOpacity(0.2),
                                ),
                              ),
                              child: ClipOval(
                                child: _localAvatarBytes != null
                                    ? Image.memory(_localAvatarBytes!,
                                        fit: BoxFit.cover)
                                    : _authService.avatarUrl.isNotEmpty
                                        ? Image.network(
                                            _authService.avatarUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.person,
                                                    color: Color(0xFF0D631B),
                                                    size: 20),
                                          )
                                        : const Icon(Icons.person,
                                            color: Color(0xFF0D631B), size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadStats,
                    color: const Color(0xFF0D631B),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          // ✅ Profile hero with real avatar
                          Column(
                            children: [
                              _buildAvatar(),
                              const SizedBox(height: 16),
                              Text(
                                _authService.userFullName,
                                style: GoogleFonts.manrope(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _authService.userEmail,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Farm stats
                          _isLoading
                              ? const CircularProgressIndicator(
                                  color: Color(0xFF0D631B))
                              : Row(
                                  children: [
                                    Expanded(
                                      child: _statCard(
                                          '$_totalScans',
                                          l10n.totalScans,
                                          Icons.document_scanner),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _statCard(
                                          '$_diseaseCount',
                                          l10n.diseasesFoundMultiline,
                                          Icons.coronavirus),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _statCard('$_healthyCount',
                                          l10n.healthyLeavesStat, Icons.eco),
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 24),

                          // Account Management
                          _menuGroup(
                            title: l10n.accountManagement,
                            items: [
                              _MenuItem(
                                icon: Icons.person_outline,
                                title: l10n.editProfile,
                                subtitle: l10n.updateYourInfo,
                                onTap: () async {
                                  await Navigator.pushNamed(
                                      context, '/edit-profile');
                                  if (mounted) setState(() {});
                                },
                              ),
                              _MenuItem(
                                icon: Icons.lock_reset,
                                title: l10n.changePassword,
                                subtitle: l10n.enhanceSecurity,
                                onTap: () => Navigator.pushNamed(
                                    context, '/change-password'),
                              ),
                              _MenuItem(
                                icon: Icons.settings,
                                title: l10n.accountSettings,
                                subtitle: l10n.manageLinkedServices,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/settings'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // App Preferences
                          _menuGroup(
                            title: l10n.appPreferencesSection,
                            items: [
                              _MenuItem(
                                icon: Icons.notifications_active,
                                title: l10n.notifications,
                                subtitle: l10n.notificationsSubtitle,
                                badge: '3 New',
                                onTap: () => Navigator.pushNamed(
                                    context, '/notifications'),
                              ),
                              _MenuItem(
                                icon: Icons.info_outline,
                                title: l10n.aboutApp,
                                subtitle: l10n.aboutAppSubtitle,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/about'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Logout button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      l10n.logout,
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFBA1A1A),
                                      ),
                                    ),
                                    content: Text(
                                      l10n.areYouSureLogout,
                                      style: GoogleFonts.inter(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text(
                                          l10n.cancel,
                                          style: GoogleFonts.manrope(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await NotificationService()
                                              .unregisterDeviceToken(); // ✅ AI: new line
                                          await _authService.logout();
                                          if (context.mounted) {
                                            Navigator.pop(ctx);
                                            Navigator.pushReplacementNamed(
                                                context, '/login');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFBA1A1A),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                        ),
                                        child: Text(
                                          l10n.logout,
                                          style: GoogleFonts.manrope(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.logout,
                                  color: Color(0xFFBA1A1A)),
                              label: Text(
                                l10n.logout,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFBA1A1A),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFBA1A1A),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            '${l10n.loggedInAs}${_authService.userEmail}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom nav
          Positioned(
            bottom: 16,
            left: 20,
            right: 20,
            child: _buildBottomNav(context, l10n),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D631B).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF0D631B), size: 22),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D631B),
              )),
          Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )),
        ],
      ),
    );
  }

  Widget _menuGroup({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D631B).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFECEEEC)),
          ...items.map((item) => _menuItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _menuItem(_MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF0D631B).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: const Color(0xFF0D631B), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      )),
                  Text(item.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                ],
              ),
            ),
            if (item.badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D631B),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(item.badge!,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, color: Color(0xFF40493D), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, AppLocalizations l10n) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D631B).withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
              context, Icons.dashboard, l10n.dashboard, '/dashboard', false),
          _navItem(
              context, Icons.center_focus_strong, l10n.scan, '/scan', false),
          _navItem(
              context, Icons.library_books, l10n.library, '/treatment', false),
          _navItem(context, Icons.person, l10n.profile, '/profile', true),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label,
      String route, bool isActive) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color:
                  isActive ? const Color(0xFF0D631B) : const Color(0xFF40493D),
              size: 24),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? const Color(0xFF0D631B)
                    : const Color(0xFF40493D),
              )),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF0D631B),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.onTap,
  });
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E7D32).withOpacity(0.07)
      ..style = PaintingStyle.fill;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
