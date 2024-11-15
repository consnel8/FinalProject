import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

sealed class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor( // Custom
      primary: Color(0xFF3A3A3A),
      primaryContainer: Color(0xffdcedc8),
      primaryLightRef: Color(0xFF3A3A3A),
      secondary: Color(0xfff8bbd0),
      secondaryContainer: Color(0xfff485b1),
      secondaryLightRef: Color(0xfff8bbd0),
      tertiary: Color(0xffffe082),
      tertiaryContainer: Color(0xff95f0ff),
      tertiaryLightRef: Color(0xffffe082),
      appBarColor: Color(0xfff485b1),
      error: Color(0xffba1a1a),
      errorContainer: Color(0xffba1a1a),
    ),
    surface: Color(0xFF3A3A3A),
    scaffoldBackground: Color(0xFFF4EDE6),
    // dialogBackground: Color(0xFF3A3A3A),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Color(0xFF000000)
      ),
      bodySmall: TextStyle(
          color: Color(0xFF000000)
      ),
      bodyLarge: TextStyle(
          color: Color(0xFF000000)
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFF4EDE6),
      ),
      headlineLarge: TextStyle(
        color: Color(0xFFF4EDE6),
      ),
      headlineSmall: TextStyle(
        color: Color(0xFFF4EDE6),
      ),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color(0xffb3cf81),
      primaryContainer: Color(0xFFF4EDE6),
      primaryLightRef: Color(0xFFF4EDE6),
      secondary: Color(0xffc66e95),
      secondaryContainer: Color(0xffe17aa0),
      secondaryLightRef: Color(0xffe17aa0),
      tertiary: Color(0xff5eb5bf),
      tertiaryContainer: Color(0xffe4ca74),
      tertiaryLightRef: Color(0xffe4ca74),
      appBarColor: Color(0xffda6995),
      error: Color(0xffba1a1a),
      errorContainer: Color(0xffba1a1a),
    ).defaultError.toDark(10, true),
    surface: Color(0xFF3A3A3A),
    scaffoldBackground: Color(0xFF3A3A3A),
    // dialogBackground: Color(0xFF3A3A3A),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
            color: Color(0xFFF4EDE6),
        ),
      headlineMedium: TextStyle(
        color: Color(0xFFF4EDE6),
        ),
      headlineLarge: TextStyle(
        color: Color(0xFFF4EDE6),
      ),
      headlineSmall: TextStyle(
        color: Color(0xFFF4EDE6),
      ),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
