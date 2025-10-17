import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme _withWeights(TextTheme base, Color color) {
    return base
        .apply(bodyColor: color, displayColor: color)
        .copyWith(
          displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w700),
          displayMedium: base.displayMedium?.copyWith(fontWeight: FontWeight.w600),
          displaySmall: base.displaySmall?.copyWith(fontWeight: FontWeight.w600),
          headlineLarge: base.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
          headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
          headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w500),
          titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        );
  }

  static TextTheme englishTextTheme(Color color) {
    final base = GoogleFonts.urbanistTextTheme();
    return _withWeights(base, color);
  }

  static TextTheme arabicTextTheme(Color color) {
    final base = GoogleFonts.readexProTextTheme();
    return _withWeights(base, color);
  }

  static TextTheme blended(Color color, Locale locale) {
    return locale.languageCode == 'ar'
        ? arabicTextTheme(color)
        : englishTextTheme(color);
  }
}
