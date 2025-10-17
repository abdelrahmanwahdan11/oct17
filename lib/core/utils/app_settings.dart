import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class BrandPalette {
  BrandPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.glassBgLight,
    required this.glassBgDark,
    required this.glassBorderLight,
    required this.glassBorderDark,
    required this.brandYellow,
    required this.brandYellowHover,
    required this.brandYellowTint,
  });

  factory BrandPalette.defaults() => BrandPalette(
        primary: const Color(0xFF4F46E5),
        secondary: const Color(0xFF22C55E),
        accent: const Color(0xFFF59E0B),
        glassBgLight: const Color(0x1FFFFFFF),
        glassBgDark: const Color(0x14FFFFFF),
        glassBorderLight: const Color(0x59FFFFFF),
        glassBorderDark: const Color(0x38FFFFFF),
        brandYellow: const Color(0xFFF9EEA6),
        brandYellowHover: const Color(0xFFF7ECAC),
        brandYellowTint: const Color(0xFFFCF7D8),
      );

  final Color primary;
  final Color secondary;
  final Color accent;
  final Color glassBgLight;
  final Color glassBgDark;
  final Color glassBorderLight;
  final Color glassBorderDark;
  final Color brandYellow;
  final Color brandYellowHover;
  final Color brandYellowTint;

  BrandPalette copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? glassBgLight,
    Color? glassBgDark,
    Color? glassBorderLight,
    Color? glassBorderDark,
    Color? brandYellow,
    Color? brandYellowHover,
    Color? brandYellowTint,
  }) {
    return BrandPalette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      glassBgLight: glassBgLight ?? this.glassBgLight,
      glassBgDark: glassBgDark ?? this.glassBgDark,
      glassBorderLight: glassBorderLight ?? this.glassBorderLight,
      glassBorderDark: glassBorderDark ?? this.glassBorderDark,
      brandYellow: brandYellow ?? this.brandYellow,
      brandYellowHover: brandYellowHover ?? this.brandYellowHover,
      brandYellowTint: brandYellowTint ?? this.brandYellowTint,
    );
  }

  static Color _parseColor(String? raw, Color fallback) {
    if (raw == null) {
      return fallback;
    }
    final value = raw.trim();
    if (value.isEmpty) {
      return fallback;
    }
    final lower = value.toLowerCase();
    if (lower.startsWith('rgba')) {
      final match = RegExp(r'rgba\(([^)]+)\)').firstMatch(lower);
      if (match != null) {
        final parts = match.group(1)!.split(',').map((part) => part.trim()).toList();
        if (parts.length == 4) {
          final r = int.tryParse(parts[0]) ?? 0;
          final g = int.tryParse(parts[1]) ?? 0;
          final b = int.tryParse(parts[2]) ?? 0;
          final a = double.tryParse(parts[3]) ?? 1.0;
          return Color.fromRGBO(r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255), a.clamp(0.0, 1.0));
        }
      }
    }
    if (lower.startsWith('rgb')) {
      final match = RegExp(r'rgb\(([^)]+)\)').firstMatch(lower);
      if (match != null) {
        final parts = match.group(1)!.split(',').map((part) => part.trim()).toList();
        if (parts.length == 3) {
          final r = int.tryParse(parts[0]) ?? 0;
          final g = int.tryParse(parts[1]) ?? 0;
          final b = int.tryParse(parts[2]) ?? 0;
          return Color.fromRGBO(r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255), 1);
        }
      }
    }
    var hex = value;
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    if (hex.startsWith('0x')) {
      hex = hex.substring(2);
    }
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    }
    return fallback;
  }

  static String _colorToString(Color color) {
    final hex = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    if (hex.startsWith('FF')) {
      return '#${hex.substring(2)}';
    }
    return '#$hex';
  }

  factory BrandPalette.fromJson(Map<String, dynamic> json) {
    final defaults = BrandPalette.defaults();
    Color parse(String key, Color fallback) => _parseColor(json[key] as String?, fallback);
    return BrandPalette(
      primary: parse('primary', defaults.primary),
      secondary: parse('secondary', defaults.secondary),
      accent: parse('accent', defaults.accent),
      glassBgLight: parse('glass_bg_light', defaults.glassBgLight),
      glassBgDark: parse('glass_bg_dark', defaults.glassBgDark),
      glassBorderLight: parse('glass_border_light', defaults.glassBorderLight),
      glassBorderDark: parse('glass_border_dark', defaults.glassBorderDark),
      brandYellow: parse('brand_yellow', defaults.brandYellow),
      brandYellowHover: parse('brand_yellow_hover', defaults.brandYellowHover),
      brandYellowTint: parse('brand_yellow_tint', defaults.brandYellowTint),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': _colorToString(primary),
      'secondary': _colorToString(secondary),
      'accent': _colorToString(accent),
      'glass_bg_light': _colorToString(glassBgLight),
      'glass_bg_dark': _colorToString(glassBgDark),
      'glass_border_light': _colorToString(glassBorderLight),
      'glass_border_dark': _colorToString(glassBorderDark),
      'brand_yellow': _colorToString(brandYellow),
      'brand_yellow_hover': _colorToString(brandYellowHover),
      'brand_yellow_tint': _colorToString(brandYellowTint),
    };
  }
}

class AppSettings extends ChangeNotifier {
  AppSettings();

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale_code';
  static const _brandKey = 'brand_palette_json';

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('ar');
  BrandPalette _brand = BrandPalette.defaults();
  bool _initialized = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  BrandPalette get brand => _brand;
  bool get initialized => _initialized;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTheme = prefs.getInt(_themeKey);
    if (storedTheme != null && storedTheme >= 0 && storedTheme < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[storedTheme];
    }

    final storedLocale = prefs.getString(_localeKey);
    if (storedLocale != null && storedLocale.isNotEmpty) {
      _locale = Locale(storedLocale);
    }

    final cachedBrand = prefs.getString(_brandKey);
    if (cachedBrand != null && cachedBrand.isNotEmpty) {
      try {
        _brand = BrandPalette.fromJson(json.decode(cachedBrand) as Map<String, dynamic>);
      } catch (_) {
        _brand = BrandPalette.defaults();
      }
    } else {
      try {
        final asset = await rootBundle.loadString('assets/brand/brand_colors.json');
        _brand = BrandPalette.fromJson(json.decode(asset) as Map<String, dynamic>);
      } catch (_) {
        _brand = BrandPalette.defaults();
      }
    }

    _initialized = true;
    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<void> updateLocale(Locale locale) async {
    if (_locale == locale) {
      return;
    }
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> updateBrand(BrandPalette brand) async {
    _brand = brand;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_brandKey, json.encode(brand.toJson()));
  }
}
