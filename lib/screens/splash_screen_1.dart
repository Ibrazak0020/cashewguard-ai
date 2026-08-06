// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Increased to 5 seconds so user can read content
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _checkLoginStatus();
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      Provider.of<ThemeProvider>(context, listen: false).loadSavedLocale();
      Navigator.pushReplacementNamed(context, '/dashboard');
      return;
    }

    // Not logged in — check if this is a brand-new user who hasn't picked
    // a language yet.
    final prefs = await SharedPreferences.getInstance();
    final hasPickedLanguage = prefs.getBool('language_selected_once') ?? false;

    if (hasPickedLanguage) {
      Navigator.pushReplacementNamed(context, '/splash2');
    } else {
      Navigator.pushReplacementNamed(context, '/language-select');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF4CAF50),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background circles
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: size.width * 0.6,
                  height: size.width * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: -60,
                child: Container(
                  width: size.width * 0.5,
                  height: size.width * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),

              // Main content
              Center(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: isSmallScreen ? 80 : 100,
                            height: isSmallScreen ? 80 : 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.asset(
                                'assets/images/cashewguard_logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 24),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'CashewGuard AI',
                              style: GoogleFonts.manrope(
                                fontSize: isSmallScreen ? 26 : 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Intelligent Crop Stewardship',
                              style: GoogleFonts.inter(
                                fontSize: isSmallScreen ? 13 : 16,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 32 : 48),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              'VERSION 1.0.0',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.8),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 48 : 80),
                          SizedBox(
                            width: 120,
                            child: LinearProgressIndicator(
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading...',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom credit
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Text(
                    'Abiola Ajimobi Technical University',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
