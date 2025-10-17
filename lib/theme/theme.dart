import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light(Locale locale) {
    const brightness = Brightness.light;
    final surfaces = AppColors.of(brightness);
    final textTheme = AppTypography.blended(surfaces.textPrimary, locale);
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      background: surfaces.background,
      surface: surfaces.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: surfaces.textPrimary,
      onBackground: surfaces.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: surfaces.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaces.surface.withOpacity(0.92),
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: surfaces.textPrimary,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: surfaces.glassBg,
        surfaceTintColor: AppColors.primary.withOpacity(0.08),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: surfaces.glassBorder, width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaces.glassBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: surfaces.glassBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: surfaces.glassBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
          minimumSize: const MaterialStatePropertyAll(Size.fromHeight(56)),
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          backgroundColor: MaterialStatePropertyAll(surfaces.ctaBackground),
          foregroundColor: MaterialStatePropertyAll(surfaces.ctaForeground),
          overlayColor: MaterialStatePropertyAll(surfaces.ctaHover.withOpacity(0.3)),
          textStyle: MaterialStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: surfaces.glassBg,
        elevation: 0,
        indicatorColor: AppBrand.brandYellowTint.withOpacity(0.6),
        iconTheme: MaterialStatePropertyAll(IconThemeData(color: surfaces.textSecondary)),
        labelTextStyle: MaterialStatePropertyAll(
          textTheme.labelMedium?.copyWith(color: surfaces.textPrimary),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: AppBrand.brandYellowTint.withOpacity(0.6),
        selectedIconTheme: IconThemeData(color: AppColors.primary),
        selectedLabelTextStyle: textTheme.labelMedium,
        unselectedIconTheme: IconThemeData(color: surfaces.textSecondary),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(color: surfaces.textSecondary),
        useIndicator: true,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaces.glassBg,
        labelStyle: TextStyle(color: surfaces.textPrimary),
        side: BorderSide(color: surfaces.glassBorder, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      dividerColor: surfaces.dividerSoft,
      iconTheme: IconThemeData(color: surfaces.textSecondary),
    );
  }

  static ThemeData dark(Locale locale) {
    const brightness = Brightness.dark;
    final surfaces = AppColors.of(brightness);
    final textTheme = AppTypography.blended(surfaces.textPrimary, locale);
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      background: surfaces.background,
      surface: surfaces.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: surfaces.textPrimary,
      onBackground: surfaces.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: surfaces.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: surfaces.textPrimary,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: surfaces.glassBg,
        surfaceTintColor: AppColors.primary.withOpacity(0.12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: surfaces.glassBorder, width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaces.glassBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: surfaces.glassBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: surfaces.glassBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
          minimumSize: const MaterialStatePropertyAll(Size.fromHeight(56)),
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          backgroundColor: MaterialStatePropertyAll(surfaces.ctaBackground),
          foregroundColor: MaterialStatePropertyAll(surfaces.ctaForeground),
          overlayColor: MaterialStatePropertyAll(surfaces.ctaHover.withOpacity(0.4)),
          textStyle: MaterialStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: surfaces.glassBg,
        elevation: 0,
        indicatorColor: AppBrand.brandYellowTint.withOpacity(0.4),
        iconTheme: MaterialStatePropertyAll(IconThemeData(color: surfaces.textSecondary)),
        labelTextStyle: MaterialStatePropertyAll(
          textTheme.labelMedium?.copyWith(color: surfaces.textPrimary),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: AppBrand.brandYellowTint.withOpacity(0.4),
        selectedIconTheme: IconThemeData(color: AppColors.primary),
        selectedLabelTextStyle: textTheme.labelMedium,
        unselectedIconTheme: IconThemeData(color: surfaces.textSecondary),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(color: surfaces.textSecondary),
        useIndicator: true,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaces.glassBg,
        labelStyle: TextStyle(color: surfaces.textPrimary),
        side: BorderSide(color: surfaces.glassBorder, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      dividerColor: surfaces.dividerSoft,
      iconTheme: IconThemeData(color: surfaces.textSecondary),
    );
  }
}
