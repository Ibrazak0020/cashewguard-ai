import 'package:flutter/material.dart';

class TH {
  // Primary color — green in light, light green in dark
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  // Background color
  static Color bg(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  // Card color
  static Color card(BuildContext context) => Theme.of(context).cardColor;

  // Main text color
  static Color text(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  // Secondary text color
  static Color subText(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  // Surface container color
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainer;

  // Divider color
  static Color divider(BuildContext context) => Theme.of(context).dividerColor;

  // Check if dark mode
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // Dot grid color
  static Color dotGrid(BuildContext context) =>
      isDark(context) ? const Color(0xFF88D982) : const Color(0xFF2E7D32);
}
