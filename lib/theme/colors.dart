import 'package:flutter/material.dart';

/// يمثل ألوان العلامة التجارية ويمكن تحديثه زمن التشغيل.
class AppBrand {
  static Color primary = const Color(0xFF4F46E5);
  static Color secondary = const Color(0xFF22C55E);
  static Color accent = const Color(0xFFF59E0B);
  static Color glassBgLight = const Color(0x1FFFFFFF);
  static Color glassBgDark = const Color(0x14FFFFFF);
  static Color glassBorderLight = const Color(0x59FFFFFF);
  static Color glassBorderDark = const Color(0x38FFFFFF);
  static Color brandYellow = const Color(0xFFF9EEA6);
  static Color brandYellowHover = const Color(0xFFF7ECAC);
  static Color brandYellowTint = const Color(0xFFFCF7D8);
}

class AppColors {
  const AppColors._();

  static _SurfaceColors of(Brightness brightness) =>
      brightness == Brightness.dark ? const _DarkSurfaces() : const _LightSurfaces();

  static Color get primary => AppBrand.primary;
  static Color get secondary => AppBrand.secondary;
  static Color get accent => AppBrand.accent;
}

abstract class _SurfaceColors {
  const _SurfaceColors();

  Color get background;
  Color get surface;
  Color get textPrimary;
  Color get textSecondary;
  Color get dividerSoft;
  Color get outline;
  Color get glassBg;
  Color get glassBorder;
  Color get ctaBackground;
  Color get ctaForeground;
  Color get ctaHover;
}

class _LightSurfaces extends _SurfaceColors {
  const _LightSurfaces();

  @override
  Color get background => const Color(0xFFFFFFFF);

  @override
  Color get surface => const Color(0xFFF8FAFC);

  @override
  Color get textPrimary => const Color(0xFF171110);

  @override
  Color get textSecondary => const Color(0xFF809C9D);

  @override
  Color get dividerSoft => const Color(0x0F000000);

  @override
  Color get outline => const Color(0x1A000000);

  @override
  Color get glassBg => AppBrand.glassBgLight;

  @override
  Color get glassBorder => AppBrand.glassBorderLight;

  @override
  Color get ctaBackground => AppBrand.brandYellow;

  @override
  Color get ctaForeground => const Color(0xFF171110);

  @override
  Color get ctaHover => AppBrand.brandYellowHover;
}

class _DarkSurfaces extends _SurfaceColors {
  const _DarkSurfaces();

  @override
  Color get background => const Color(0xFF0F0D0C);

  @override
  Color get surface => const Color(0xFF1B1715);

  @override
  Color get textPrimary => const Color(0xFFFFFFFF);

  @override
  Color get textSecondary => const Color(0xFFE6E6E6);

  @override
  Color get dividerSoft => const Color(0x14FFFFFF);

  @override
  Color get outline => const Color(0x38FFFFFF);

  @override
  Color get glassBg => AppBrand.glassBgDark;

  @override
  Color get glassBorder => AppBrand.glassBorderDark;

  @override
  Color get ctaBackground => AppBrand.brandYellow;

  @override
  Color get ctaForeground => const Color(0xFF000000);

  @override
  Color get ctaHover => AppBrand.brandYellowTint;
}
