import 'package:flutter/material.dart';

class ColorConstant {
  static const Color transparent = Colors.transparent;
  static const Color primary = Colors.indigo;
  static Color extraLightPrimary =
      Colors.indigo[50] ?? const Color(0xFFE8EAF6); // Fallback color for safety
  static const Color black = Colors.black87;
  static const Color grey = Colors.grey;
  static Color lightGrey =
      Colors.grey[350] ?? const Color(0xFFD6D6D6); // Fallback color for safety
  static Color extraLightGrey =
      Colors.grey[200] ?? const Color(0xFFEEEEEE); // Fallback color for safety
  static const Color white = Colors.white;
}
