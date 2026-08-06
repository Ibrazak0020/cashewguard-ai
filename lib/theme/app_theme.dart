// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Light mode colors
  static const primary = Color(0xFF0D631B);
  static const secondary = Color(0xFF006E1C);
  static const surface = Color(0xFFF8FAF8);
  static const background = Color(0xFFF8FAF8);
  static const onSurface = Color(0xFF191C1B);
  static const onSurfaceVariant = Color(0xFF40493D);
  static const error = Color(0xFFBA1A1A);
  static const onPrimary = Colors.white;
  static const outlineVariant = Color(0xFFBFCABA);
  static const surfaceContainer = Color(0xFFECEEEC);
  static const surfaceContainerLow = Color(0xFFF2F4F2);

  // Dark mode colors
  static const darkPrimary = Color(0xFF88D982);
  static const darkSurface = Color(0xFF1A1C1A);
  static const darkBackground = Color(0xFF1A1C1A);
  static const darkOnSurface = Color(0xFFE2E3E0);
  static const darkOnSurfaceVariant = Color(0xFFC4C7C1);
  static const darkSurfaceContainer = Color(0xFF2A2C2A);
  static const darkSurfaceContainerLow = Color(0xFF222422);
  static const darkOutlineVariant = Color(0xFF3A3C3A);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outlineVariant,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardColor: Colors.white,
      dividerColor: AppColors.surfaceContainer,
      textTheme: GoogleFonts.manropeTextTheme().copyWith(
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return AppColors.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surfaceContainer;
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: Color(0xFF78DC77),
        surface: AppColors.darkSurface,
        error: Color(0xFFFFB4AB),
        onPrimary: Color(0xFF003909),
        onSurface: AppColors.darkOnSurface,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        outline: AppColors.darkOutlineVariant,
        surfaceContainerLow: AppColors.darkSurfaceContainerLow,
        surfaceContainer: AppColors.darkSurfaceContainer,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurfaceContainer,
      dividerColor: AppColors.darkOutlineVariant,
      textTheme: GoogleFonts.manropeTextTheme().copyWith(
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.darkOnSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.darkOnSurfaceVariant,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.darkPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: const Color(0xFF003909),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkOutlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkOutlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: AppColors.darkOnSurfaceVariant),
        hintStyle: GoogleFonts.inter(color: AppColors.darkOnSurfaceVariant),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF003909);
          }
          return AppColors.darkOnSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary;
          }
          return AppColors.darkSurfaceContainer;
        }),
      ),
    );
  }
}

// Helper function to get colors based on current theme
Color getPrimaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.primary;
}

Color getBackgroundColor(BuildContext context) {
  return Theme.of(context).scaffoldBackgroundColor;
}

Color getSurfaceColor(BuildContext context) {
  return Theme.of(context).colorScheme.surface;
}

Color getOnSurfaceColor(BuildContext context) {
  return Theme.of(context).colorScheme.onSurface;
}

Color getOnSurfaceVariantColor(BuildContext context) {
  return Theme.of(context).colorScheme.onSurfaceVariant;
}

Color getCardColor(BuildContext context) {
  return Theme.of(context).cardColor;
}

Color getSurfaceContainerColor(BuildContext context) {
  return Theme.of(context).colorScheme.surfaceContainer;
}

// Dot grid painter that responds to theme
class DotGridPainter extends CustomPainter {
  final Color color;
  final double opacity;

  const DotGridPainter({
    this.color = const Color(0xFF2E7D32),
    this.opacity = 0.07,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
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

// Reusable glass card decoration that responds to theme
BoxDecoration glassDecoration(BuildContext context, {double radius = 24}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: isDark
        ? const Color(0xFF2A2C2A).withOpacity(0.8)
        : Colors.white.withOpacity(0.8),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.white.withOpacity(0.2),
    ),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        blurRadius: 30,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
