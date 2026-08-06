import 'package:flutter/material.dart';

class R {
  // Screen width
  static double w(BuildContext context) => MediaQuery.of(context).size.width;

  // Screen height
  static double h(BuildContext context) => MediaQuery.of(context).size.height;

  // Responsive font size
  static double fs(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 390).clamp(0.8, 1.2);
  }

  // Responsive padding
  static double p(BuildContext context, double size) {
    final height = MediaQuery.of(context).size.height;
    return size * (height / 844).clamp(0.6, 1.0);
  }

  // Responsive icon size
  static double icon(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 390).clamp(0.7, 1.0);
  }

  // Is small screen — less than 700 height
  static bool isSmall(BuildContext context) =>
      MediaQuery.of(context).size.height < 700;

  // Is medium screen
  static bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.height >= 700 &&
      MediaQuery.of(context).size.height < 900;

  // Is large screen
  static bool isLarge(BuildContext context) =>
      MediaQuery.of(context).size.height >= 900;

  // Safe padding for SizedBox heights
  static double sh(BuildContext context, double size) {
    if (isSmall(context)) return size * 0.6;
    if (isMedium(context)) return size * 0.8;
    return size;
  }
}
