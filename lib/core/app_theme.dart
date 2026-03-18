import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QatColors {
  static const background = Color(0xFFF5FAF6);
  static const surface = Colors.white;
  static const surfaceMuted = Color(0xFFE7F2E8);
  static const cardBorder = Color(0xFFD5E4D6);
  static const textPrimary = Color(0xFF102118);
  static const textSecondary = Color(0xFF4E6254);
  static const ok = Color(0xFF2F7D4B);
  static const okSoft = Color(0xFFE4F4E8);
  static const warning = Color(0xFFB78122);
  static const warningSoft = Color(0xFFFFF4DD);
  static const emergency = Color(0xFFC63F36);
  static const emergencySoft = Color(0xFFFCE9E7);
  static const info = Color(0xFF245A76);
  static const infoSoft = Color(0xFFE4F1F8);
}

ThemeData buildQatTheme() {
  final base = ThemeData.light().textTheme;
  final display = GoogleFonts.dmSerifDisplayTextTheme(base);
  final body = GoogleFonts.interTextTheme(base);

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: QatColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: QatColors.ok,
      brightness: Brightness.light,
    ).copyWith(
      primary: QatColors.ok,
      secondary: QatColors.info,
      surface: QatColors.surface,
      error: QatColors.emergency,
    ),
    textTheme: body.copyWith(
      displayLarge: display.displayLarge?.copyWith(color: QatColors.textPrimary),
      displayMedium:
          display.displayMedium?.copyWith(color: QatColors.textPrimary),
      displaySmall:
          display.displaySmall?.copyWith(color: QatColors.textPrimary),
      headlineLarge:
          display.headlineLarge?.copyWith(color: QatColors.textPrimary),
      headlineMedium:
          display.headlineMedium?.copyWith(color: QatColors.textPrimary),
      headlineSmall:
          display.headlineSmall?.copyWith(color: QatColors.textPrimary),
      titleLarge: body.titleLarge?.copyWith(
        color: QatColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: body.titleMedium?.copyWith(
        color: QatColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        color: QatColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        color: QatColors.textSecondary,
        height: 1.45,
      ),
      bodySmall: body.bodySmall?.copyWith(
        color: QatColors.textSecondary,
      ),
      labelLarge: body.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: QatColors.textPrimary,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: QatColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: QatColors.textPrimary,
      titleTextStyle: body.titleLarge?.copyWith(
        color: QatColors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
    ),
    cardTheme: CardThemeData(
      color: QatColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: QatColors.cardBorder),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      backgroundColor: QatColors.surfaceMuted,
      selectedColor: QatColors.okSoft,
      side: const BorderSide(color: QatColors.cardBorder),
      labelStyle: body.labelLarge?.copyWith(
        color: QatColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: QatColors.surface,
      labelStyle: const TextStyle(color: QatColors.textSecondary),
      hintStyle: const TextStyle(color: QatColors.textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: QatColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: QatColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: QatColors.ok, width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: QatColors.ok,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: body.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: QatColors.textPrimary,
        side: const BorderSide(color: QatColors.cardBorder),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedItemColor: QatColors.ok,
      unselectedItemColor: QatColors.textSecondary,
      backgroundColor: QatColors.surface,
      showUnselectedLabels: true,
    ),
    dividerColor: QatColors.cardBorder,
  );
}
