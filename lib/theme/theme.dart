import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light(Locale locale) {
    const brightness = Brightness.light;
    final surfaces = AppColors.of(brightness);
    final textTheme = AppTypography.blended(surfaces.textPrimary, locale);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        background: surfaces.background,
        surface: surfaces.surface,
      ),
      scaffoldBackgroundColor: surfaces.background,
      fontFamily: textTheme.bodyMedium?.fontFamily,
      textTheme: textTheme,
      elevatedButtonTheme: _elevatedButtonTheme(brightness),
      filledButtonTheme: _filledButtonTheme(brightness),
      chipTheme: _chipTheme(brightness, locale),
      cardTheme: _cardTheme(brightness),
      inputDecorationTheme: _searchFieldDecoration(brightness),
      bottomNavigationBarTheme: _bottomNavTheme(brightness),
      navigationRailTheme: _navRailTheme(brightness),
    );
  }

  static ThemeData dark(Locale locale) {
    const brightness = Brightness.dark;
    final surfaces = AppColors.of(brightness);
    final textTheme = AppTypography.blended(surfaces.textPrimary, locale);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        background: surfaces.background,
        surface: surfaces.surface,
      ),
      scaffoldBackgroundColor: surfaces.background,
      textTheme: textTheme,
      elevatedButtonTheme: _elevatedButtonTheme(brightness),
      filledButtonTheme: _filledButtonTheme(brightness),
      chipTheme: _chipTheme(brightness, locale),
      cardTheme: _cardTheme(brightness),
      inputDecorationTheme: _searchFieldDecoration(brightness),
      bottomNavigationBarTheme: _bottomNavTheme(brightness),
      navigationRailTheme: _navRailTheme(brightness),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        elevation: 0,
        backgroundColor:
            isDark ? AppColors.secondary : _Light.brandYellow,
        foregroundColor: isDark ? Colors.black : _Light.textPrimaryValue,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 0,
        backgroundColor: isDark ? AppColors.primary : _Light.skyTeal1,
        foregroundColor: isDark ? Colors.white : _Light.textPrimaryValue,
      ),
    );
  }

  static ChipThemeData _chipTheme(Brightness brightness, Locale locale) {
    final isDark = brightness == Brightness.dark;
    return ChipThemeData(
      backgroundColor: isDark ? _Glass.bgDark : _Glass.bg,
      labelStyle: TextStyle(
        fontFamily: AppTypography.blended(Colors.white, locale).bodyMedium?.fontFamily,
        color: isDark ? Colors.white : _Light.textPrimaryValue,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: isDark ? _Glass.borderDark : _Glass.border,
          width: 1.5,
        ),
      ),
    );
  }

  static CardTheme _cardTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return CardTheme(
      elevation: 0,
      color: isDark ? _Glass.bgDark : _Glass.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDark ? _Glass.borderDark : _Glass.border,
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.all(16),
    );
  }

  static InputDecorationTheme _searchFieldDecoration(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? _Glass.bgDark : _Glass.bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(
          color: isDark ? _Glass.borderDark : _Glass.border,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(
          color: isDark ? _Glass.borderDark : _Glass.border,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(
          color: isDark ? AppColors.accent : _Light.brandYellowHover,
          width: 1.8,
        ),
      ),
    );
  }

  static BottomNavigationBarThemeData _bottomNavTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: isDark ? Colors.white : AppColors.primary,
      unselectedItemColor: isDark ? Colors.white70 : Colors.black54,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  static NavigationRailThemeData _navRailTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return NavigationRailThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedIconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.primary),
      unselectedIconTheme: IconThemeData(color: isDark ? Colors.white54 : Colors.black45),
      useIndicator: true,
      indicatorColor: isDark ? AppColors.primary.withOpacity(0.16) : _Light.brandYellowTint,
    );
  }
}
