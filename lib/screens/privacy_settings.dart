import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Shared key so ScanService can check whether the farmer has opted out
/// of contributing their (privacy-rounded) scan location to Outbreak
/// Watch. Defaults to true (opted in) if never set.
const String kLocationSharingPrefKey = 'location_sharing_enabled';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  bool _locationSharing = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationSharing = prefs.getBool(kLocationSharingPrefKey) ?? true;
      _loading = false;
    });
  }

  Future<void> _setLocationSharing(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kLocationSharingPrefKey, value);
    setState(() => _locationSharing = value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
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
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
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
                                color: primaryColor.withValues(alpha: 0.08),
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
                        'Privacy Settings',
                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _loading
                      ? Center(
                          child:
                              CircularProgressIndicator(color: primaryColor))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel('Location & Outbreak Watch',
                                  subTextColor),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: cardColor.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: cardColor.withValues(alpha: 0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withValues(alpha: 0.06),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              color: primaryColor, size: 22),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Share scan location',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    color: textColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  'Lets Outbreak Watch include your scans in nearby disease reports',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color: subTextColor,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Switch(
                                            value: _locationSharing,
                                            onChanged: _setLocationSharing,
                                            activeThumbColor: primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                        height: 1,
                                        indent: 20,
                                        endIndent: 20,
                                        color: isDark
                                            ? const Color(0xFF3A3C3A)
                                            : const Color(0xFFECEEEC)),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.shield_outlined,
                                              color: primaryColor, size: 18),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              'Your exact location is never shown to other farmers. Locations are rounded to roughly 1km before being stored, and Outbreak Watch only ever displays aggregate counts — never who reported what.',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: subTextColor,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              _sectionLabel('Legal', subTextColor),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: cardColor.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: cardColor.withValues(alpha: 0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withValues(alpha: 0.06),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _linkRow(
                                      icon: Icons.privacy_tip_outlined,
                                      label: 'Privacy Policy',
                                      textColor: textColor,
                                      iconColor: primaryColor,
                                      onTap: () => Navigator.pushNamed(
                                          context, '/privacy'),
                                    ),
                                    Divider(
                                        height: 1,
                                        indent: 20,
                                        endIndent: 20,
                                        color: isDark
                                            ? const Color(0xFF3A3C3A)
                                            : const Color(0xFFECEEEC)),
                                    _linkRow(
                                      icon: Icons.gavel_outlined,
                                      label: 'Terms of Service',
                                      textColor: textColor,
                                      iconColor: primaryColor,
                                      onTap: () => Navigator.pushNamed(
                                          context, '/terms'),
                                    ),
                                  ],
                                ),
                              ),
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

  Widget _sectionLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _linkRow({
    required IconData icon,
    required String label,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: textColor.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.07)
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