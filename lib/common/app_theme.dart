import 'package:flutter/material.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:watashi_qr/locale/app_language.dart';

enum ThemeOption {
  sys,
  light(.light),
  dark(.dark);

  final Brightness? brightness;

  const ThemeOption([this.brightness]);

  static Map<ThemeOption, String> get optionMap => <ThemeOption, String>{
    sys: DictKey.settingOptionThemeSystem.s,
    light: DictKey.settingOptionThemeLight.s,
    dark: DictKey.settingOptionThemeDark.s,
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

  static Map<ColorOption, String> get optionMap => <ColorOption, String>{
    sys: DictKey.settingOptionColorMaterialYou.s,
    blue: DictKey.settingOptionColorBlue.s,
    orange: DictKey.settingOptionColorOrange.s,
    green: DictKey.settingOptionColorGreen.s,
    red: DictKey.settingOptionColorRed.s,
    purple: DictKey.settingOptionColorPurple.s,
  };
}

ThemeData appTheme (
  BuildContext context,
  ColorScheme? lightDynamic,
  ColorScheme? darkDynamic,)
{
  final ThemeOption selectedTheme = context.readPrefs.get(.selectedTheme);
  final ColorOption selectedColor = context.readPrefs.get(.selectedColor);
  final Brightness brightness = selectedTheme.brightness ?? MediaQuery.platformBrightnessOf(context);
  final MaterialColor seedColor = selectedColor.color ?? Colors.blue; // <- sys顏色不支援時會用到
  late final ColorScheme colorScheme;

  if (selectedColor == .sys && brightness == .light && lightDynamic != null) {
    colorScheme = lightDynamic;
  } else if (selectedColor == .sys && brightness == .dark && darkDynamic != null) {
    colorScheme = darkDynamic;
  } else {
    colorScheme = .fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: .all(colorScheme.secondaryContainer),
      radius: const .circular(10.0),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    cardTheme: const CardThemeData(
      clipBehavior: .antiAlias,
    ),
  );
}
