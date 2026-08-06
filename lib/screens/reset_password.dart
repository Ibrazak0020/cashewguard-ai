// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;
  bool _isResending = false;
  int _resendCooldown = 60;
  Timer? _timer;

  // Tracks whether the OTP has been verified yet — controls whether we
  // show the code-entry step or the new-password step.
  bool _otpVerified = false;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 1) {
        timer.cancel();
        setState(() => _resendCooldown = 0);
      } else {
        setState(() => _resendCooldown--);
      }
    });
  }

  void _showSnack(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor:
            isError ? const Color(0xFFBA1A1A) : const Color(0xFF0D631B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (index == 5 && value.isNotEmpty) {
      final otp = _otpControllers.map((c) => c.text).join();
      if (otp.length == 6) _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      _showSnack('Please enter the full 6-digit code.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final authService = AuthService();
      final response = await authService.verifyPasswordResetOtp(
        email: widget.email,
        token: otp,
      );

      if (response.user != null) {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _otpVerified = true;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isSubmitting = false);
          _showSnack('Verification failed. Please check the code.');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSnack('Invalid or expired code. Please try again.');
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCooldown > 0 || _isResending) return;
    setState(() => _isResending = true);
    try {
      final authService = AuthService();
      await authService.sendPasswordResetOtp(email: widget.email);
      if (mounted) {
        setState(() => _isResending = false);
        _showSnack('A new code has been sent.', isError: false);
        for (final c in _otpControllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
        _startCooldown();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isResending = false);
        _showSnack('Failed to resend code: ${e.toString()}');
      }
    }
  }

  Future<void> _submitNewPassword() async {
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirm.isEmpty) {
      _showSnack('Please fill in both password fields.');
      return;
    }
    if (newPass.length < 6) {
      _showSnack('Password must be at least 6 characters.');
      return;
    }
    if (newPass != confirm) {
      _showSnack('Passwords do not match.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final authService = AuthService();
      await authService.updatePassword(newPass);
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSnack('Password updated. Please sign in.', isError: false);
        Navigator.popUntil(context,
            (route) => route.settings.name == '/login' || route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSnack('Failed to update password: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D631B).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Color(0xFF0D631B), size: 20),
                ),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              Text(
                _otpVerified ? l10n.setNewPassword : l10n.enterResetCode,
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                    height: 1.5,
                  ),
                  children: _otpVerified
                      ? [TextSpan(text: l10n.chooseNewPasswordSubtitle)]
                      : [
                          TextSpan(text: l10n.weSentCodeTo),
                          TextSpan(
                            text: widget.email,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D631B),
                            ),
                          ),
                        ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(24),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D631B).withValues(alpha: 0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: _otpVerified
                    ? _buildPasswordStep(l10n)
                    : _buildOtpStep(l10n),
              ),
              if (!_otpVerified) ...[
                const SizedBox(height: 24),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        l10n.didntGetCode,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: (_resendCooldown > 0 || _isResending)
                            ? null
                            : _resendOtp,
                        child: Text(
                          _resendCooldown > 0
                              ? 'Resend in ${_resendCooldown}s'
                              : (_isResending ? 'Sending...' : l10n.resendCode),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: (_resendCooldown > 0 || _isResending)
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : const Color(0xFF0D631B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFFFE082),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFFF9A825),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.checkSpamFolder,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: const Color(0xFF6B5200),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpStep(AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 44,
              height: 56,
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFF2F4F2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFBFCABA)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFBFCABA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: Color(0xFF0D631B), width: 2),
                  ),
                ),
                onChanged: (value) => _onDigitChanged(index, value),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D631B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999)),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(l10n.verifyCode,
                    style: GoogleFonts.manrope(
                        fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.newPassword,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        _passwordField(_newPasswordController, _obscureNew,
            () => setState(() => _obscureNew = !_obscureNew)),
        const SizedBox(height: 20),
        Text(
          l10n.confirmPassword,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        _passwordField(_confirmPasswordController, _obscureConfirm,
            () => setState(() => _obscureConfirm = !_obscureConfirm)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitNewPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D631B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999)),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(l10n.updatePassword,
                    style: GoogleFonts.manrope(
                        fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _passwordField(
      TextEditingController controller, bool obscure, VoidCallback onToggle) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.inter(
          fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: GoogleFonts.inter(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        prefixIcon:
            const Icon(Icons.lock_outline, color: Color(0xFF0D631B), size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFFF2F4F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFBFCABA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFBFCABA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0D631B), width: 2),
        ),
      ),
    );
  }
}
