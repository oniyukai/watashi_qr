import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/language.dart';

enum ThemeOptions {
  sys, light, dark;
  factory ThemeOptions.byName(String n) => ThemeOptions.values.byName(n);
}

enum ColorOptions {
  sys, blue, orange, green, red, purple;
  factory ColorOptions.byName(String n) => ColorOptions.values.byName(n);
}

class AppTheme {
  const AppTheme._();

  static Map<String, String> themeOptionsMap(Language localeStr) => <String, String>{
    ThemeOptions.sys.name: localeStr.preferencesSwitchSystemThemeLabel,
    ThemeOptions.light.name: localeStr.preferencesSwitchLightThemeLabel,
    ThemeOptions.dark.name: localeStr.preferencesSwitchDarkThemeLabel,
  };

  static Map<String, String> colorOptionsMap(Language localeStr) => <String, String>{
    ColorOptions.sys.name: localeStr.preferencesColorMaterialYou,
    ColorOptions.blue.name: localeStr.preferencesColorBlue,
    ColorOptions.orange.name: localeStr.preferencesColorOrange,
    ColorOptions.green.name: localeStr.preferencesColorGreen,
    ColorOptions.red.name: localeStr.preferencesColorRed,
    ColorOptions.purple.name: localeStr.preferencesColorPurple,
  };

  static ThemeData theme(
    BuildContext context,
    String selectedTheme,
    String selectedColor,
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic
  ) {
    late final Brightness brightness;
    late final MaterialColor seedColor;
    late final ColorScheme colorScheme;

    brightness = <ThemeOptions, Brightness>{
      ThemeOptions.sys: View.of(context).platformDispatcher.platformBrightness,
      ThemeOptions.light: Brightness.light,
      ThemeOptions.dark: Brightness.dark,
    }[ThemeOptions.byName(selectedTheme)] ?? Brightness.light; // ??... 不該會去用到

    seedColor = const <ColorOptions, MaterialColor>{
      ColorOptions.blue: Colors.blue,
      ColorOptions.orange: Colors.orange,
      ColorOptions.green: Colors.green,
      ColorOptions.red: Colors.red,
      ColorOptions.purple: Colors.purple,
    }[ColorOptions.byName(selectedColor)] ?? Colors.blue; // <--sys顏色不支援時會用到

    if (selectedColor==ColorOptions.sys.name && lightDynamic!=null && brightness==Brightness.light){
      colorScheme = lightDynamic;
    } else if (selectedColor==ColorOptions.sys.name && darkDynamic!=null && brightness==Brightness.dark){
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

}