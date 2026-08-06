// ignore_for_file: deprecated_member_use
import '../services/cache_service.dart';
import '../services/pdf_service.dart';
import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../l10n/app_localizations.dart';

const List<String> kSupportedLanguages = [
  'English',
  'Yoruba',
  'Hausa',
  'Igbo',
  'Nigerian Pidgin',
  'French',
];

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final _authService = AuthService();
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Listen to theme provider at the top level
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // Colors that change with theme
    final bgColor = isDark ? const Color(0xFF1A1C1A) : const Color(0xFFF8FAF8);
    final cardColor = isDark ? const Color(0xFF2A2C2A) : Colors.white;
    final textColor =
        isDark ? const Color(0xFFE2E3E0) : const Color(0xFF191C1B);
    final subTextColor =
        isDark ? const Color(0xFFC4C7C1) : const Color(0xFF40493D);
    final primaryColor =
        isDark ? const Color(0xFF88D982) : const Color(0xFF0D631B);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _DotGridPainter(
                color:
                    isDark ? const Color(0xFF88D982) : const Color(0xFF2E7D32),
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
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
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.arrow_back,
                                  color: primaryColor, size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.settings,
                            style: GoogleFonts.manrope(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: ClipOval(
                          child: _authService.avatarUrl.isNotEmpty
                              ? Image.network(
                                  '${_authService.avatarUrl}?t=${DateTime.now().millisecondsSinceEpoch ~/ 60000}',
                                  fit: BoxFit.cover,
                                  width: 36,
                                  height: 36,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.person,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                )
                              : Icon(Icons.person,
                                  color: primaryColor, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(24),
                            border:
                                Border.all(color: cardColor.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isDark
                                        ? [
                                            const Color(0xFF2E7D32),
                                            const Color(0xFF88D982),
                                          ]
                                        : [
                                            const Color(0xFF2E7D32),
                                            const Color(0xFF4CAF50),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.person,
                                    color: Colors.white, size: 34),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _authService.userFullName,
                                    style: GoogleFonts.manrope(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    _authService.userEmail,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: subTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel(l10n.general, subTextColor),
                        const SizedBox(height: 8),
                        _settingsGroup(
                          cardColor: cardColor,
                          primaryColor: primaryColor,
                          children: [
                            _settingsRow(
                              icon: Icons.manage_accounts,
                              label: l10n.editProfile,
                              textColor: textColor,
                              iconColor: primaryColor,
                              onTap: () async {
                                await Navigator.pushNamed(
                                    context, '/edit-profile');
                                if (mounted) setState(() {});
                              },
                            ),
                            _divider(isDark),
                            _settingsRow(
                              icon: Icons.lock_reset,
                              label: l10n.changePassword,
                              textColor: textColor,
                              iconColor: primaryColor,
                              onTap: () => Navigator.pushNamed(
                                  context, '/change-password'),
                            ),
                            _divider(isDark),
                            _settingsRow(
                              icon: Icons.shield_outlined,
                              label: l10n.privacySettings,
                              textColor: textColor,
                              iconColor: primaryColor,
                              // ✅ AI: wired to the new Privacy Settings screen
                              onTap: () => Navigator.pushNamed(
                                  context, '/privacy-settings'),
                            ),
                            _divider(isDark),
                            _settingsToggleRow(
                              icon: Icons.notifications_active,
                              label: l10n.notifications,
                              value: _notificationsEnabled,
                              primaryColor: primaryColor,
                              textColor: textColor,
                              onChanged: (val) =>
                                  setState(() => _notificationsEnabled = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel(l10n.appPreferencesSection, subTextColor),
                        const SizedBox(height: 8),
                        _settingsGroup(
                          cardColor: cardColor,
                          primaryColor: primaryColor,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Icon(
                                    isDark
                                        ? Icons.dark_mode
                                        : Icons.dark_mode_outlined,
                                    color: primaryColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Dark Mode',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: isDark,
                                    onChanged: (val) {
                                      themeProvider.toggleDarkMode(val);
                                    },
                                    activeColor: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            _divider(isDark),
                            _settingsRow(
                              icon: Icons.language,
                              label: 'Language',
                              textColor: textColor,
                              iconColor: primaryColor,
                              trailing: Text(
                                _authService.userLanguage,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: primaryColor.withOpacity(0.7),
                                ),
                              ),
                              onTap: () => _showLanguagePicker(
                                l10n,
                                cardColor,
                                primaryColor,
                                textColor,
                                subTextColor,
                              ),
                            ),
                            _divider(isDark),
                            _settingsRow(
                              icon: Icons.info_outline,
                              label: l10n.aboutApp,
                              textColor: textColor,
                              iconColor: primaryColor,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/about'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel(l10n.privacySettings, subTextColor),
                        const SizedBox(height: 8),
                        _settingsGroup(
                          cardColor: cardColor,
                          primaryColor: primaryColor,
                          children: [
                            _settingsRow(
                              icon: Icons.download_outlined,
                              label: 'Export Scan Data',
                              textColor: textColor,
                              iconColor: primaryColor,
                              onTap: () async {
                                final authService = AuthService();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Generating PDF report...',
                                          style: GoogleFonts.inter(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: primaryColor,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                                try {
                                  final pdfService = PdfService();
                                  final user = authService.currentUser;
                                  await pdfService.exportToPdf(
                                    userName:
                                        user?.userMetadata?['full_name'] ??
                                            'User',
                                    userEmail: user?.email ?? '',
                                  );
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to generate PDF: $e',
                                          style: GoogleFonts.inter(
                                              color: Colors.white),
                                        ),
                                        backgroundColor:
                                            const Color(0xFFBA1A1A),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                            _divider(isDark),
                            _settingsRow(
                              icon: Icons.delete_sweep_outlined,
                              label: 'Clear cache',
                              textColor: textColor,
                              iconColor: primaryColor,
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      'Clear cache',
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to clear the cache?',
                                      style: GoogleFonts.inter(
                                        color: subTextColor,
                                        height: 1.5,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: Text(
                                          l10n.cancel,
                                          style: GoogleFonts.manrope(
                                            color: subTextColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                        ),
                                        child: Text(
                                          'Clear',
                                          style: GoogleFonts.manrope(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm != true) return;
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Clearing cache...',
                                            style: GoogleFonts.inter(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: primaryColor,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                                final cacheService = CacheService();
                                final success = await cacheService.clearCache();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            success
                                                ? Icons.check_circle
                                                : Icons.error,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            success
                                                ? 'Cache cleared successfully'
                                                : 'Failed to clear cache',
                                            style: GoogleFonts.inter(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: success
                                          ? primaryColor
                                          : const Color(0xFFBA1A1A),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel('Account Actions', subTextColor),
                        const SizedBox(height: 8),
                        _settingsGroup(
                          cardColor: cardColor,
                          primaryColor: primaryColor,
                          children: [
                            _settingsRow(
                              icon: Icons.logout,
                              label: l10n.logout,
                              textColor: textColor,
                              iconColor: subTextColor,
                              showArrow: false,
                              onTap: () async {
                                await _authService.logout();
                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                }
                              },
                            ),
                            _divider(isDark),
                            _settingsRow(
                              icon: Icons.delete_forever,
                              label: 'Delete Account',
                              textColor: const Color(0xFFBA1A1A),
                              iconColor: const Color(0xFFBA1A1A),
                              trailing: const Icon(Icons.warning_amber,
                                  color: Color(0xFFBA1A1A), size: 20),
                              showArrow: false,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/delete'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Text(
                            'CashewGuard AI  •  v2.0.0',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              color: subTextColor.withOpacity(0.4),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(
    AppLocalizations l10n,
    Color cardColor,
    Color primaryColor,
    Color textColor,
    Color subTextColor,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.7,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFCABA),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Language',
                    style: GoogleFonts.manrope(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Language selection is coming soon.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: subTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...kSupportedLanguages.map((lang) {
                    final isSelected = _authService.userLanguage == lang;
                    return GestureDetector(
                      onTap: () async {
                        Navigator.pop(ctx);
                        final themeProvider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        await themeProvider.setLanguage(lang);
                        if (mounted) setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor.withOpacity(0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? primaryColor.withOpacity(0.3)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                lang,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected ? primaryColor : textColor,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle,
                                  color: primaryColor, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String? label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label ?? '',
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _settingsGroup({
    required List<Widget> children,
    required Color cardColor,
    required Color primaryColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(children: children),
      ),
    );
  }

  Widget _settingsRow({
    required IconData icon,
    required String? label,
    required VoidCallback onTap,
    required Color textColor,
    required Color iconColor,
    Widget? trailing,
    bool showArrow = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label ?? '',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (showArrow && trailing == null)
              Icon(Icons.chevron_right,
                  color: textColor.withOpacity(0.5), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _settingsToggleRow({
    required IconData icon,
    required String? label,
    required bool value,
    required Color primaryColor,
    required Color textColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.transparent,
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label ?? '',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: isDark ? const Color(0xFF3A3C3A) : const Color(0xFFECEEEC),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final Color color;

  const _DotGridPainter({this.color = const Color(0xFF2E7D32)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.07)
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