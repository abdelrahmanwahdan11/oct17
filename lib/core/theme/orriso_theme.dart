import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OrrisoPalette {
  OrrisoPalette._();

  static const Color bgTop = Color(0xFFF2F4F7);
  static const Color bgBottom = Color(0xFFD9DDE3);
  static const Color surfaceGlass = Color(0xA6FFFFFF);
  static const Color surfaceDark = Color(0xFF111111);
  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xA61F1F1F);
  static const Color accentGreen = Color(0xFF82B78C);
  static const Color accentBlue = Color(0xFF3A8BC7);
  static const Color accentOrange = Color(0xFFF2B27B);
  static const Color accentTeal = Color(0xFF69C2B5);
}

class OrrisoTheme {
  OrrisoTheme._();

  static ThemeData light(Locale locale) {
    final baseText = GoogleFonts.urbanistTextTheme();
    final typography = baseText.apply(
      bodyColor: OrrisoPalette.textPrimary,
      displayColor: OrrisoPalette.textPrimary,
    );

    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      scaffoldBackgroundColor: OrrisoPalette.bgTop,
      fontFamily: typography.bodyMedium?.fontFamily,
      textTheme: typography.copyWith(
        displayLarge: typography.displayLarge?.copyWith(fontSize: 28, height: 1.15),
        headlineLarge: typography.headlineLarge?.copyWith(fontSize: 22, height: 1.2),
        titleMedium: typography.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: typography.bodyLarge?.copyWith(height: 1.35),
        bodyMedium: typography.bodyMedium?.copyWith(height: 1.35),
        bodySmall: typography.bodySmall?.copyWith(height: 1.35),
      ),
      primaryColor: OrrisoPalette.accentGreen,
      colorScheme: ColorScheme.light(
        primary: OrrisoPalette.accentGreen,
        secondary: OrrisoPalette.accentBlue,
        surface: OrrisoPalette.surfaceGlass,
        background: OrrisoPalette.bgTop,
        onSurface: OrrisoPalette.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: OrrisoPalette.textPrimary,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      inputDecorationTheme: _inputDecorationTheme(Brightness.light),
      elevatedButtonTheme: _elevatedButtonTheme(Brightness.light),
      textButtonTheme: _textButtonTheme(Brightness.light),
      outlinedButtonTheme: _outlinedButtonTheme(Brightness.light),
      cardTheme: _cardTheme(Brightness.light),
      dividerColor: Colors.black.withOpacity(0.06),
    );
  }

  static ThemeData dark(Locale locale) {
    final baseText = GoogleFonts.urbanistTextTheme(ThemeData.dark().textTheme);
    final typography = baseText.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );

    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      fontFamily: typography.bodyMedium?.fontFamily,
      textTheme: typography.copyWith(
        displayLarge: typography.displayLarge?.copyWith(fontSize: 28, height: 1.15),
        headlineLarge: typography.headlineLarge?.copyWith(fontSize: 22, height: 1.2),
      ),
      primaryColor: OrrisoPalette.accentGreen,
      colorScheme: ColorScheme.dark(
        primary: OrrisoPalette.accentGreen,
        secondary: OrrisoPalette.accentBlue,
        surface: OrrisoPalette.surfaceDark.withOpacity(0.75),
        background: const Color(0xFF0A0A0A),
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      inputDecorationTheme: _inputDecorationTheme(Brightness.dark),
      elevatedButtonTheme: _elevatedButtonTheme(Brightness.dark),
      textButtonTheme: _textButtonTheme(Brightness.dark),
      outlinedButtonTheme: _outlinedButtonTheme(Brightness.dark),
      cardTheme: _cardTheme(Brightness.dark),
      dividerColor: Colors.white.withOpacity(0.08),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1);
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? Colors.white.withOpacity(0.08) : OrrisoPalette.surfaceGlass,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: borderColor, width: 1.3),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: borderColor, width: 1.3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: OrrisoPalette.accentBlue, width: 1.8),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Brightness brightness) {
    final foreground = brightness == Brightness.dark ? Colors.black : Colors.white;
    final background = brightness == Brightness.dark ? Colors.white : OrrisoPalette.surfaceDark;
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(0),
        minimumSize: const MaterialStatePropertyAll(Size.fromHeight(48)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
        backgroundColor: MaterialStatePropertyAll(background),
        foregroundColor: MaterialStatePropertyAll(foreground),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(Brightness brightness) {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const MaterialStatePropertyAll(OrrisoPalette.accentBlue),
        textStyle: MaterialStatePropertyAll(
          GoogleFonts.urbanist(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(Brightness brightness) {
    final borderColor = brightness == Brightness.dark
        ? Colors.white.withOpacity(0.5)
        : Colors.black.withOpacity(0.25);
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const MaterialStatePropertyAll(Size.fromHeight(48)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
        side: MaterialStatePropertyAll(BorderSide(color: borderColor, width: 1.2)),
        foregroundColor: const MaterialStatePropertyAll(OrrisoPalette.accentBlue),
      ),
    );
  }

  static CardTheme _cardTheme(Brightness brightness) {
    final borderColor = brightness == Brightness.dark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.08);
    return CardTheme(
      color: brightness == Brightness.dark
          ? Colors.white.withOpacity(0.08)
          : OrrisoPalette.surfaceGlass,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: borderColor, width: 1.2),
      ),
      elevation: 0,
    );
  }
}

class GlassSurface extends StatelessWidget {
  const GlassSurface({super.key, required this.child, this.padding, this.margin, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24);
    final content = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          margin: margin,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: radius,
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
    if (onTap != null) {
      return InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}

class GlassPill extends StatelessWidget {
  const GlassPill({super.key, required this.child, this.active = false, this.onTap});

  final Widget child;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(active ? 0.24 : 0.14)
        : Colors.white.withOpacity(active ? 0.75 : 0.55);
    final border = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.25)
        : Colors.black.withOpacity(0.06);
    final pill = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: surface,
        border: Border.all(color: border, width: 1.1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: active
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
        child: child,
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: pill,
      );
    }
    return pill;
  }
}
