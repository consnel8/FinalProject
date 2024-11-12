import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.0.0.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///  theme: AppTheme.light,
///  darkTheme: AppTheme.dark,
///  :
/// );
sealed class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor( // Custom
      primary: Color(0xff4e342a),
      primaryContainer: Color(0xffdcedc8),
      primaryLightRef: Color(0xff4e342a),
      secondary: Color(0xfff8bbd0),
      secondaryContainer: Color(0xfff485b1),
      secondaryLightRef: Color(0xfff8bbd0),
      tertiary: Color(0xffffe082),
      tertiaryContainer: Color(0xff95f0ff),
      tertiaryLightRef: Color(0xffffe082),
      appBarColor: Color(0xfff485b1),
      error: Color(0xffba1a1a),
      errorContainer: Color(0xffffdad6),
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
      primary: Color(0xffdfeecd),
      primaryContainer: Color(0xff5f473e),
      primaryLightRef: Color(0xff4e342a),
      secondary: Color(0xfff590b8),
      secondaryContainer: Color(0xfff8c1d4),
      secondaryLightRef: Color(0xfff8bbd0),
      tertiary: Color(0xff9ff1ff),
      tertiaryContainer: Color(0xffffe38e),
      tertiaryLightRef: Color(0xffffe082),
      appBarColor: Color(0xfff590b8),
      error: null,
      errorContainer: null,
    ).defaultError.toDark(10, true),
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
