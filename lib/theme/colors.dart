import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF22C55E);
  static const Color accent = Color(0xFFF59E0B);

  static const _Light light = _Light();
  static const _Dark dark = _Dark();
  static const _Glass glass = _Glass();

  static _SurfaceColors of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;
}

abstract class _SurfaceColors {
  Color get background;
  Color get surface;
  Color get textPrimary;
  Color get textSecondary;
  Color get divider;
}

class _Light implements _SurfaceColors {
  const _Light();

  static const Color brandYellow = Color(0xFFF9EEA6);
  static const Color brandYellowHover = Color(0xFFF7ECAC);
  static const Color brandYellowTint = Color(0xFFFCF7D8);
  static const Color skyTeal1 = Color(0xFF9EBEBB);
  static const Color skyTeal2 = Color(0xFFA3C2BF);
  static const Color tealDeep = Color(0xFF5C8690);
  static const Color tealMuted = Color(0xFF58838D);
  static const Color mapPastelGreen = Color(0xFFD0EDCA);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFFFEFD);
  static const Color textPrimaryValue = Color(0xFF171110);
  static const Color textSecondaryValue = Color(0xFF809C9D);
  static const Color dividerSoft = Color(0x0F000000);

  @override
  Color get background => surfaceWhite;

  @override
  Color get surface => offWhite;

  @override
  Color get textPrimary => textPrimaryValue;

  @override
  Color get textSecondary => textSecondaryValue;

  @override
  Color get divider => dividerSoft;
}

class _Dark implements _SurfaceColors {
  const _Dark();

  static const Color backgroundValue = Color(0xFF0F0D0C);
  static const Color surfaceValue = Color(0xFF1B1715);
  static const Color textPrimaryValue = Color(0xFFFFFFFF);
  static const Color textSecondaryValue = Color(0xFFE6E6E6);
  static const Color outline = Color(0x38FFFFFF);
  static const Color dividerSoft = Color(0x14FFFFFF);

  @override
  Color get background => backgroundValue;

  @override
  Color get surface => surfaceValue;

  @override
  Color get textPrimary => textPrimaryValue;

  @override
  Color get textSecondary => textSecondaryValue;

  @override
  Color get divider => dividerSoft;
}

class _Glass {
  const _Glass();

  static const Color bg = Color.fromRGBO(255, 255, 255, 0.12);
  static const Color bgDark = Color.fromRGBO(255, 255, 255, 0.08);
  static const Color border = Color.fromRGBO(255, 255, 255, 0.35);
  static const Color borderDark = Color.fromRGBO(255, 255, 255, 0.22);
}
