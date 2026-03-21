import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class QatPalette extends ThemeExtension<QatPalette> {
  const QatPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.cardBorder,
    required this.cardBorderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.ok,
    required this.okSoft,
    required this.warning,
    required this.warningSoft,
    required this.emergency,
    required this.emergencySoft,
    required this.info,
    required this.infoSoft,
  });

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color cardBorder;
  final Color cardBorderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color ok;
  final Color okSoft;
  final Color warning;
  final Color warningSoft;
  final Color emergency;
  final Color emergencySoft;
  final Color info;
  final Color infoSoft;

  static const normal = QatPalette(
    background: Color(0xFFF5FAF6),
    surface: Colors.white,
    surfaceMuted: Color(0xFFE7F2E8),
    cardBorder: Color(0xFFD5E4D6),
    cardBorderStrong: Color(0xFFA8C0AB),
    textPrimary: Color(0xFF102118),
    textSecondary: Color(0xFF4E6254),
    textTertiary: Color(0xFF64756A),
    ok: Color(0xFF2F7D4B),
    okSoft: Color(0xFFE4F4E8),
    warning: Color(0xFFB78122),
    warningSoft: Color(0xFFFFF4DD),
    emergency: Color(0xFFC63F36),
    emergencySoft: Color(0xFFFCE9E7),
    info: Color(0xFF245A76),
    infoSoft: Color(0xFFE4F1F8),
  );

  static const accessibility = QatPalette(
    background: Color(0xFFF9FAFB),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF1F4F6),
    cardBorder: Color(0xFF637079),
    cardBorderStrong: Color(0xFF23313A),
    textPrimary: Color(0xFF0A0F14),
    textSecondary: Color(0xFF162229),
    textTertiary: Color(0xFF2D3B44),
    ok: Color(0xFF0D5F23),
    okSoft: Color(0xFFE7F6EA),
    warning: Color(0xFF915F05),
    warningSoft: Color(0xFFFFF1CF),
    emergency: Color(0xFF9E1F16),
    emergencySoft: Color(0xFFFFECE8),
    info: Color(0xFF0E4B6B),
    infoSoft: Color(0xFFE8F3FA),
  );

  @override
  QatPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? cardBorder,
    Color? cardBorderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? ok,
    Color? okSoft,
    Color? warning,
    Color? warningSoft,
    Color? emergency,
    Color? emergencySoft,
    Color? info,
    Color? infoSoft,
  }) {
    return QatPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      cardBorder: cardBorder ?? this.cardBorder,
      cardBorderStrong: cardBorderStrong ?? this.cardBorderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      ok: ok ?? this.ok,
      okSoft: okSoft ?? this.okSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      emergency: emergency ?? this.emergency,
      emergencySoft: emergencySoft ?? this.emergencySoft,
      info: info ?? this.info,
      infoSoft: infoSoft ?? this.infoSoft,
    );
  }

  @override
  QatPalette lerp(ThemeExtension<QatPalette>? other, double t) {
    if (other is! QatPalette) {
      return this;
    }
    return QatPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardBorderStrong:
          Color.lerp(cardBorderStrong, other.cardBorderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      ok: Color.lerp(ok, other.ok, t)!,
      okSoft: Color.lerp(okSoft, other.okSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      emergency: Color.lerp(emergency, other.emergency, t)!,
      emergencySoft: Color.lerp(emergencySoft, other.emergencySoft, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoSoft: Color.lerp(infoSoft, other.infoSoft, t)!,
    );
  }
}

class QatUiConfig extends ThemeExtension<QatUiConfig> {
  const QatUiConfig({
    required this.accessibilityMode,
    required this.reducedMotion,
    required this.screenHorizontalPadding,
    required this.screenVerticalPadding,
    required this.sectionSpacing,
    required this.cardPadding,
    required this.buttonHeight,
    required this.iconSize,
    required this.heroButtonSize,
    required this.cardRadius,
    required this.disclosureRadius,
  });

  final bool accessibilityMode;
  final bool reducedMotion;
  final double screenHorizontalPadding;
  final double screenVerticalPadding;
  final double sectionSpacing;
  final double cardPadding;
  final double buttonHeight;
  final double iconSize;
  final double heroButtonSize;
  final double cardRadius;
  final double disclosureRadius;

  static const normal = QatUiConfig(
    accessibilityMode: false,
    reducedMotion: false,
    screenHorizontalPadding: 20,
    screenVerticalPadding: 18,
    sectionSpacing: 22,
    cardPadding: 18,
    buttonHeight: 56,
    iconSize: 22,
    heroButtonSize: 172,
    cardRadius: 24,
    disclosureRadius: 18,
  );

  static const accessibility = QatUiConfig(
    accessibilityMode: true,
    reducedMotion: true,
    screenHorizontalPadding: 24,
    screenVerticalPadding: 22,
    sectionSpacing: 28,
    cardPadding: 24,
    buttonHeight: 68,
    iconSize: 28,
    heroButtonSize: 196,
    cardRadius: 28,
    disclosureRadius: 22,
  );

  @override
  QatUiConfig copyWith({
    bool? accessibilityMode,
    bool? reducedMotion,
    double? screenHorizontalPadding,
    double? screenVerticalPadding,
    double? sectionSpacing,
    double? cardPadding,
    double? buttonHeight,
    double? iconSize,
    double? heroButtonSize,
    double? cardRadius,
    double? disclosureRadius,
  }) {
    return QatUiConfig(
      accessibilityMode: accessibilityMode ?? this.accessibilityMode,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      screenHorizontalPadding:
          screenHorizontalPadding ?? this.screenHorizontalPadding,
      screenVerticalPadding:
          screenVerticalPadding ?? this.screenVerticalPadding,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      cardPadding: cardPadding ?? this.cardPadding,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      iconSize: iconSize ?? this.iconSize,
      heroButtonSize: heroButtonSize ?? this.heroButtonSize,
      cardRadius: cardRadius ?? this.cardRadius,
      disclosureRadius: disclosureRadius ?? this.disclosureRadius,
    );
  }

  @override
  QatUiConfig lerp(ThemeExtension<QatUiConfig>? other, double t) {
    if (other is! QatUiConfig) {
      return this;
    }
    return QatUiConfig(
      accessibilityMode: t < 0.5 ? accessibilityMode : other.accessibilityMode,
      reducedMotion: t < 0.5 ? reducedMotion : other.reducedMotion,
      screenHorizontalPadding:
          lerpDouble(screenHorizontalPadding, other.screenHorizontalPadding, t)!,
      screenVerticalPadding:
          lerpDouble(screenVerticalPadding, other.screenVerticalPadding, t)!,
      sectionSpacing: lerpDouble(sectionSpacing, other.sectionSpacing, t)!,
      cardPadding: lerpDouble(cardPadding, other.cardPadding, t)!,
      buttonHeight: lerpDouble(buttonHeight, other.buttonHeight, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
      heroButtonSize: lerpDouble(heroButtonSize, other.heroButtonSize, t)!,
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
      disclosureRadius:
          lerpDouble(disclosureRadius, other.disclosureRadius, t)!,
    );
  }
}

extension QatThemeContext on BuildContext {
  QatPalette get qatPalette => Theme.of(this).extension<QatPalette>()!;
  QatUiConfig get qatUi => Theme.of(this).extension<QatUiConfig>()!;
}

class _NoAnimationTransitionsBuilder extends PageTransitionsBuilder {
  const _NoAnimationTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

const _fontFamily = 'AtkinsonHyperlegible';

ThemeData buildQatTheme({
  required bool accessibilityMode,
  required bool reducedMotion,
}) {
  final base = ThemeData.light().textTheme.apply(fontFamily: _fontFamily);
  final palette = accessibilityMode ? QatPalette.accessibility : QatPalette.normal;
  final ui = (accessibilityMode ? QatUiConfig.accessibility : QatUiConfig.normal)
      .copyWith(reducedMotion: reducedMotion);

  return ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    extensions: [palette, ui],
    scaffoldBackgroundColor: palette.background,
    pageTransitionsTheme: reducedMotion
        ? const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: _NoAnimationTransitionsBuilder(),
              TargetPlatform.iOS: _NoAnimationTransitionsBuilder(),
              TargetPlatform.macOS: _NoAnimationTransitionsBuilder(),
              TargetPlatform.linux: _NoAnimationTransitionsBuilder(),
              TargetPlatform.windows: _NoAnimationTransitionsBuilder(),
            },
          )
        : const PageTransitionsTheme(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: accessibilityMode ? palette.textPrimary : palette.ok,
      brightness: Brightness.light,
    ).copyWith(
      primary: accessibilityMode ? palette.textPrimary : palette.ok,
      secondary: palette.info,
      surface: palette.surface,
      error: palette.emergency,
      onSurface: palette.textPrimary,
    ),
    textTheme: base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: palette.textPrimary,
        fontSize: accessibilityMode ? 54 : 42,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: base.displayMedium?.copyWith(
        color: palette.textPrimary,
        fontSize: accessibilityMode ? 42 : 36,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: base.displaySmall?.copyWith(
        color: palette.textPrimary,
        fontSize: accessibilityMode ? 34 : 30,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: palette.textPrimary,
        fontSize: accessibilityMode ? 36 : 30,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: palette.textPrimary,
        fontSize: accessibilityMode ? 32 : 26,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: palette.textPrimary,
        fontSize: accessibilityMode ? 28 : 22,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: palette.textPrimary,
        fontWeight: accessibilityMode ? FontWeight.w800 : FontWeight.w700,
        fontSize: accessibilityMode ? 24 : 22,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: palette.textPrimary,
        fontWeight: accessibilityMode ? FontWeight.w800 : FontWeight.w700,
        fontSize: accessibilityMode ? 20 : 16,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: palette.textPrimary,
        fontWeight: accessibilityMode ? FontWeight.w700 : FontWeight.w600,
        fontSize: accessibilityMode ? 18 : 14,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: palette.textPrimary,
        height: accessibilityMode ? 1.6 : 1.5,
        fontSize: accessibilityMode ? 20 : 16,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: palette.textSecondary,
        height: accessibilityMode ? 1.6 : 1.45,
        fontSize: accessibilityMode ? 18 : 14,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: palette.textTertiary,
        height: accessibilityMode ? 1.55 : 1.4,
        fontSize: accessibilityMode ? 16 : 12,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: palette.textPrimary,
        fontSize: accessibilityMode ? 18 : 14,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
        fontSize: accessibilityMode ? 16 : 12,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
        fontSize: accessibilityMode ? 15 : 11,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: palette.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: palette.textPrimary,
      titleTextStyle: base.titleLarge?.copyWith(
        color: palette.textPrimary,
        fontWeight: FontWeight.w800,
        fontSize: accessibilityMode ? 22 : 20,
      ),
    ),
    cardTheme: CardThemeData(
      color: palette.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ui.cardRadius),
        side: BorderSide(
          color: accessibilityMode ? palette.cardBorderStrong : palette.cardBorder,
          width: accessibilityMode ? 2 : 1,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      backgroundColor: palette.surfaceMuted,
      selectedColor: palette.okSoft,
      side: BorderSide(
        color: accessibilityMode ? palette.cardBorderStrong : palette.cardBorder,
      ),
      labelStyle: base.labelLarge?.copyWith(
        color: palette.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surface,
      labelStyle: TextStyle(color: palette.textSecondary),
      hintStyle: TextStyle(color: palette.textSecondary),
      contentPadding: EdgeInsets.symmetric(
        horizontal: accessibilityMode ? 22 : 18,
        vertical: accessibilityMode ? 22 : 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ui.disclosureRadius),
        borderSide: BorderSide(
          color: accessibilityMode ? palette.cardBorderStrong : palette.cardBorder,
          width: accessibilityMode ? 2 : 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ui.disclosureRadius),
        borderSide: BorderSide(
          color: accessibilityMode ? palette.cardBorderStrong : palette.cardBorder,
          width: accessibilityMode ? 2 : 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ui.disclosureRadius),
        borderSide: BorderSide(
          color: accessibilityMode ? palette.textPrimary : palette.ok,
          width: accessibilityMode ? 3 : 1.4,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accessibilityMode ? palette.textPrimary : palette.ok,
        foregroundColor: Colors.white,
        minimumSize: Size(0, ui.buttonHeight),
        padding: EdgeInsets.symmetric(
          horizontal: accessibilityMode ? 24 : 18,
          vertical: accessibilityMode ? 20 : 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ui.disclosureRadius),
        ),
        textStyle: base.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, ui.buttonHeight),
        foregroundColor: palette.textPrimary,
        side: BorderSide(
          color: accessibilityMode ? palette.cardBorderStrong : palette.cardBorder,
          width: accessibilityMode ? 2 : 1,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: accessibilityMode ? 24 : 18,
          vertical: accessibilityMode ? 20 : 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ui.disclosureRadius),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedItemColor: accessibilityMode ? palette.textPrimary : palette.ok,
      unselectedItemColor: palette.textSecondary,
      backgroundColor: palette.surface,
      showUnselectedLabels: true,
    ),
    dividerColor: accessibilityMode ? palette.cardBorderStrong : palette.cardBorder,
  );
}
