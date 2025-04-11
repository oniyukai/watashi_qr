import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/language.dart';

enum ThemeOption {
  sys,
  light(Brightness.light),
  dark(Brightness.dark);

  final Brightness? brightness;
  const ThemeOption([this.brightness]);

  static Map<String, String> optionMap(Language localeStr) => <String, String>{
    sys.name: localeStr.preferencesSwitchSystemThemeLabel,
    light.name: localeStr.preferencesSwitchLightThemeLabel,
    dark.name: localeStr.preferencesSwitchDarkThemeLabel,
  };
}

enum ColorOption {
  sys,
  blue(Colors.blue),
  orange(Colors.orange),
  green(Colors.green),
  red(Colors.red),
  purple(Colors.purple);

  final MaterialColor? color;
  const ColorOption([this.color]);

  static Map<String, String> optionMap(Language localeStr) => <String, String>{
    sys.name: localeStr.preferencesColorMaterialYou,
    blue.name: localeStr.preferencesColorBlue,
    orange.name: localeStr.preferencesColorOrange,
    green.name: localeStr.preferencesColorGreen,
    red.name: localeStr.preferencesColorRed,
    purple.name: localeStr.preferencesColorPurple,
  };
}

ThemeData appTheme
    (BuildContext context,
    String selectedTheme,
    String selectedColor,
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic){
  final Brightness brightness = ThemeOption.values.byName(selectedTheme).brightness
      ?? View.of(context).platformDispatcher.platformBrightness;
  final MaterialColor seedColor = ColorOption.values.byName(selectedColor).color
      ?? Colors.blue; // <--sys顏色不支援時會用到
  late final ColorScheme colorScheme;

  if (selectedColor==ColorOption.sys.name && lightDynamic!=null && brightness==Brightness.light){
    colorScheme = lightDynamic;
  } else if (selectedColor==ColorOption.sys.name && darkDynamic!=null && brightness==Brightness.dark){
    colorScheme = darkDynamic;
  } else {
    colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(colorScheme.primary.withValues(alpha:0.5)),
      radius: Radius.circular(10.0),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      indicatorColor: colorScheme.primary.withValues(alpha:0.25),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      indicatorColor: colorScheme.primary.withValues(alpha:0.25),
    ),
  );
}