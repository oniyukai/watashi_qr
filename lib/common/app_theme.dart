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
    sys: DictKey.preferencesSwitchSystemThemeLabel.s,
    light: DictKey.preferencesSwitchLightThemeLabel.s,
    dark: DictKey.preferencesSwitchDarkThemeLabel.s,
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
    sys: DictKey.preferencesColorMaterialYou.s,
    blue: DictKey.preferencesColorBlue.s,
    orange: DictKey.preferencesColorOrange.s,
    green: DictKey.preferencesColorGreen.s,
    red: DictKey.preferencesColorRed.s,
    purple: DictKey.preferencesColorPurple.s,
  };
}

ThemeData appTheme (
  BuildContext context,
  ColorScheme? lightDynamic,
  ColorScheme? darkDynamic,)
{
  final ThemeOption selectedTheme = context.readPrefs.get(.selectedTheme);
  final ColorOption selectedColor = context.readPrefs.get(.selectedColor);
  final Brightness brightness = selectedTheme.brightness ?? View.of(context).platformDispatcher.platformBrightness;
  final MaterialColor seedColor = selectedColor.color ?? Colors.blue; // <--sys顏色不支援時會用到
  late final ColorScheme colorScheme;

  if (selectedColor == .sys && brightness == .light && lightDynamic != null) {
    colorScheme = lightDynamic;
  } else if (selectedColor == .sys && brightness == .dark && darkDynamic != null) {
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
      radius: const Radius.circular(10.0),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    cardTheme: const CardThemeData(
      clipBehavior: .antiAlias,
    ),
  );
}
