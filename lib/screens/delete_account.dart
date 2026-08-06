// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final _authService = AuthService();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _confirmCheck1 = false;
  bool _confirmCheck2 = false;
  bool _confirmCheck3 = false;
  bool _isDeleting = false;

  bool get _canDelete =>
      _confirmCheck1 &&
      _confirmCheck2 &&
      _confirmCheck3 &&
      _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBA1A1A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleDelete() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isDeleting = true);

    try {
      await _authService.deleteAccount(
        password: _passwordController.text,
      );

      if (mounted) {
        setState(() => _isDeleting = false);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              l10n.accountDeletedTitle,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
                color: const Color(0xFFBA1A1A),
              ),
            ),
            content: Text(
              l10n.accountDeletedMessage,
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA1A1A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  l10n.okLogout,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } on AuthException catch (_) {
      // signInWithPassword (the re-verification step) failed — wrong password.
      if (mounted) {
        setState(() => _isDeleting = false);
        _showError(l10n.incorrectPassword);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        _showError('Failed to delete account: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          // Dot grid background
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
          ),

          // Top red blob
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFBA1A1A).withOpacity(0.04),
              ),
            ),
          ),

          // Bottom red blob
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFBA1A1A).withOpacity(0.03),
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
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF0D631B).withOpacity(0.1),
                              border: Border.all(
                                color: const Color(0xFF0D631B).withOpacity(0.2),
                              ),
                            ),
                            child: const Icon(Icons.person,
                                color: Color(0xFF0D631B), size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Warning hero card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFBA1A1A),
                                Color(0xFFE53935),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFBA1A1A).withOpacity(0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Warning icon
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.deleteAccount,
                                style: GoogleFonts.manrope(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.deleteAccountWarningTitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.85),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // What will be deleted
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _deletionItem(
                                        Icons.person, l10n.deletionItemProfile),
                                    _deletionItem(Icons.document_scanner,
                                        l10n.deletionItemScans),
                                    _deletionItem(Icons.analytics,
                                        l10n.deletionItemDiagnosis),
                                    _deletionItem(Icons.settings,
                                        l10n.deletionItemSettings),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Confirmation checkboxes
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFFBA1A1A).withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.pleaseConfirm,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _checkItem(
                                value: _confirmCheck1,
                                onChanged: (val) => setState(
                                    () => _confirmCheck1 = val ?? false),
                                text: l10n.confirmDeleteCheck1,
                              ),
                              const SizedBox(height: 12),
                              _checkItem(
                                value: _confirmCheck2,
                                onChanged: (val) => setState(
                                    () => _confirmCheck2 = val ?? false),
                                text: l10n.confirmDeleteCheck2,
                              ),
                              const SizedBox(height: 12),
                              _checkItem(
                                value: _confirmCheck3,
                                onChanged: (val) => setState(
                                    () => _confirmCheck3 = val ?? false),
                                text: l10n.confirmDeleteCheck3,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Password confirmation
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFFBA1A1A).withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.verifyYourIdentity,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l10n.enterPasswordToConfirm,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                onChanged: (_) => setState(() {}),
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: l10n.enterYourPassword,
                                  hintStyle: GoogleFonts.inter(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.5),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFFBA1A1A),
                                    size: 20,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF2F4F2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFBFCABA)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFBFCABA)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFBA1A1A), width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Delete button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _canDelete && !_isDeleting
                                ? _handleDelete
                                : null,
                            icon: _isDeleting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.delete_forever,
                                    size: 22,
                                  ),
                            label: Text(
                              _isDeleting
                                  ? l10n.processing
                                  : l10n.deleteMyAccount,
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _canDelete
                                  ? const Color(0xFFBA1A1A)
                                  : const Color(0xFFBA1A1A).withOpacity(0.4),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Cancel button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/dashboard'),
                            icon: const Icon(Icons.arrow_back, size: 20),
                            label: Text(
                              l10n.cancelKeepAccount,
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D631B),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              side: const BorderSide(
                                color: Color(0xFF0D631B),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Footer note
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBA1A1A).withOpacity(0.04),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFBA1A1A).withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline,
                                  color: Color(0xFFBA1A1A), size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  l10n.needHelpInstead,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFFBA1A1A)
                                        .withOpacity(0.8),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
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

  Widget _deletionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.7), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white.withOpacity(0.85),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkItem({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFBA1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
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