import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme englishTextTheme(Color color) {
    final base = GoogleFonts.urbanistTextTheme();
    return base.apply(bodyColor: color, displayColor: color).copyWith(
      displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  static TextTheme arabicTextTheme(Color color) {
    final base = GoogleFonts.readexProTextTheme();
    return base.apply(bodyColor: color, displayColor: color).copyWith(
      displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  static TextTheme blended(Color color, Locale locale) {
    if (locale.languageCode == 'ar') {
      return arabicTextTheme(color);
    }
    return englishTextTheme(color);
  }
}
