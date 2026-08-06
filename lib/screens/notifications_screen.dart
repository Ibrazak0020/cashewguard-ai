// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _authService = AuthService();
  late Map<String, bool> _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = Map<String, bool>.from(_authService.notificationPrefs);
  }

  // Notification items config — titles/subtitles now resolved at build time
  // via AppLocalizations, since this needs BuildContext.
  List<Map<String, dynamic>> _items(AppLocalizations l10n) => [
        {
          'key': 'disease_alerts',
          'title': l10n.diseaseAlertsTitle,
          'subtitle': l10n.diseaseAlertsSubtitle,
          'icon': Icons.coronavirus_outlined,
        },
        {
          'key': 'scan_reminders',
          'title': l10n.scanRemindersTitle,
          'subtitle': l10n.scanRemindersSubtitle,
          'icon': Icons.center_focus_strong,
        },
        {
          'key': 'treatment_reminders',
          'title': l10n.treatmentRemindersTitle,
          'subtitle': l10n.treatmentRemindersSubtitle,
          'icon': Icons.healing_outlined,
        },
        {
          'key': 'weekly_reports',
          'title': l10n.weeklyReportsTitle,
          'subtitle': l10n.weeklyReportsSubtitle,
          'icon': Icons.bar_chart,
        },
        {
          'key': 'app_updates',
          'title': l10n.appUpdatesTitle,
          'subtitle': l10n.appUpdatesSubtitle,
          'icon': Icons.system_update_outlined,
        },
      ];

  Future<void> _savePrefs() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await _authService.updateNotificationPrefs(_prefs);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.notificationPrefsSaved),
            backgroundColor: const Color(0xFF0D631B),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences: $e'),
            backgroundColor: const Color(0xFFBA1A1A),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = _items(l10n);
    final enabledCount = _prefs.values.where((v) => v).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
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
                                    .withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Color(0xFF0D631B), size: 20),
                        ),
                      ),
                      Text(
                        l10n.notifications,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D631B),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Summary card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF0D631B).withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF0D631B)
                                  .withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D631B)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.notifications_active,
                                    color: Color(0xFF0D631B), size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.notificationsEnabledCount(
                                          enabledCount, items.length),
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0D631B),
                                      ),
                                    ),
                                    Text(
                                      l10n.changesSavedAutomatically,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF0D631B)
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Notification toggles
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0D631B)
                                    .withValues(alpha: 0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: items.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              final key = item['key'] as String;
                              final isEnabled = _prefs[key] ?? false;
                              final isLast = index == items.length - 1;

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: isEnabled
                                                ? const Color(0xFF0D631B)
                                                    .withValues(alpha: 0.1)
                                                : const Color(0xFFECEEEC),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Icon(
                                            item['icon'] as IconData,
                                            color: isEnabled
                                                ? const Color(0xFF0D631B)
                                                : const Color(0xFF40493D),
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['title'] as String,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xFF191C1B),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item['subtitle'] as String,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xFF40493D),
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Switch(
                                          value: isEnabled,
                                          onChanged: (val) {
                                            setState(() => _prefs[key] = val);
                                            _savePrefs();
                                          },
                                          activeColor: const Color(0xFF0D631B),
                                          activeTrackColor:
                                              const Color(0xFF0D631B)
                                                  .withValues(alpha: 0.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isLast)
                                    const Divider(
                                        height: 1,
                                        color: Color(0xFFECEEEC),
                                        indent: 20,
                                        endIndent: 20),
                                ],
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Turn all off button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                for (final key in _prefs.keys) {
                                  _prefs[key] = false;
                                }
                              });
                              _savePrefs();
                            },
                            icon: const Icon(Icons.notifications_off, size: 20),
                            label: Text(
                              l10n.turnOffAllNotifications,
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFBA1A1A),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              side: const BorderSide(
                                  color: Color(0xFFBA1A1A), width: 1.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
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
