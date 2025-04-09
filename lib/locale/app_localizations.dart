import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:watashi_qr/locale/language.dart';
import 'language_en.dart';
import 'language_ja.dart';
import 'language_zh.dart';
import 'language_zh_tw.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Language> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final selectedLanguage = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    if (selectedLanguage == 'sys') return true;
    return const <String>['en', 'ja', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<Language> load(Locale locale) => _load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<Language> old) => false;

  static Future<Language> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ja':
        return LanguageJa();
      case 'zh':
        return (locale.scriptCode == 'Hans') ? LanguageZh() : LanguageZhTw();
      default:
        return LanguageEn();
    }
  }
}

class AppLocale {
  const AppLocale._();

  static Map<String, String> optionsMap(Language localeStr) {
    return <String, String>{
      'sys': localeStr.preferencesDefault,
      'en': Language.localeLanguageEn,
      'ja': Language.localeLanguageJa,
      'zh': Language.localeLanguageZh,
      'zh-tw': Language.localeLanguageZhTw,
    };
  }

  static Locale currentLocale (String selectedLanguage){
    switch (selectedLanguage) {
      case 'sys':
        return WidgetsBinding.instance.platformDispatcher.locale;
      case 'en':
        return const Locale('en');
      case 'ja':
        return const Locale('ja');
      case 'zh':
        return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN');
      case 'zh-tw':
        return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW');
      default:
        return const Locale('en'); // <--不該會去用到
    }
  }

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate>[
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
  ];

}

// 如果要修改語言設定的代碼大致只需要本頁即可