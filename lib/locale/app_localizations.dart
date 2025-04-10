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

enum LocaleOptions {
  sys, en, ja, zh, zhTw;
  factory LocaleOptions.byName(String n) => LocaleOptions.values.byName(n);
}

class AppLocale {
  const AppLocale._();

  static Map<String, String> optionsMap(Language localeStr) => <String, String>{
    LocaleOptions.sys.name: localeStr.preferencesDefault,
    LocaleOptions.en.name: Language.localeLanguageEn,
    LocaleOptions.ja.name: Language.localeLanguageJa,
    LocaleOptions.zh.name: Language.localeLanguageZh,
    LocaleOptions.zhTw.name: Language.localeLanguageZhTw,
  };

  static Locale currentLocale (String selectedLanguage) => <LocaleOptions, Locale>{
    LocaleOptions.sys: WidgetsBinding.instance.platformDispatcher.locale,
    LocaleOptions.en: const Locale('en'),
    LocaleOptions.ja: const Locale('ja'),
    LocaleOptions.zh: const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
    LocaleOptions.zhTw: const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
  }[LocaleOptions.byName(selectedLanguage)] ?? Locale('en'); // ??... 不該會去用到

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