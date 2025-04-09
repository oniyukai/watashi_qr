import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/language.dart';

class AppTheme {
  AppTheme._();

  static Map<String, String> themeOptionsMap(Language localeStr) {
    return {
      'sys': localeStr.preferencesSwitchSystemThemeLabel,
      'light': localeStr.preferencesSwitchLightThemeLabel,
      'dark': localeStr.preferencesSwitchDarkThemeLabel,
    };
  }

  static Map<String, String> colorOptionsMap(Language localeStr) {
    return {
      'sys': localeStr.preferencesColorMaterialYou,
      'blue': localeStr.preferencesColorBlue,
      'orange': localeStr.preferencesColorOrange,
      'green': localeStr.preferencesColorGreen,
      'red': localeStr.preferencesColorRed,
      'purple': localeStr.preferencesColorPurple,
    };
  }

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

    switch(selectedTheme){
      case 'sys':
        brightness = View.of(context).platformDispatcher.platformBrightness;
        break;
      case 'light':
        brightness = Brightness.light;
        break;
      case 'dark':
        brightness = Brightness.dark;
        break;
      default: // <--不該會去用到
        brightness = Brightness.light;
    }

    switch(selectedColor){
      case 'blue':
        seedColor = Colors.blue;
        break;
      case 'orange':
        seedColor = Colors.orange;
        break;
      case 'green':
        seedColor = Colors.green;
        break;
      case 'red':
        seedColor = Colors.red;
        break;
      case 'purple':
        seedColor = Colors.purple;
        break;
      default: // <--sys顏色不支援時會用到
        seedColor = Colors.blue;
    }

    if (selectedColor=='sys' && lightDynamic!=null && brightness==Brightness.light){
      colorScheme = lightDynamic;
    } else if (selectedColor=='sys' && darkDynamic!=null && brightness==Brightness.dark){
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