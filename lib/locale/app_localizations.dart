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
  bool isSupported(Locale locale) => const <String>['en', 'ja', 'zh'].contains(locale.languageCode);

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

enum LocaleOption {
  sys,
  en(Locale('en')),
  ja(Locale('ja')),
  zh(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')),
  zhTw(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'));

  final Locale? locale;
  const LocaleOption([this.locale]);

  static Locale localeFromName(String n) => values.byName(n).locale ?? WidgetsBinding.instance.platformDispatcher.locale;

  static Map<String, String> optionMap(Language localeStr) => <String, String>{
    sys.name: localeStr.preferencesDefault,
    en.name: Language.localeLanguageEn,
    ja.name: Language.localeLanguageJa,
    zh.name: Language.localeLanguageZh,
    zhTw.name: Language.localeLanguageZhTw,
  };

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate>[
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static List<Locale> supportedLocales = LocaleOption.values
      .where((option) => option.locale != null)
      .map((option) => option.locale!).toList();
}

// 如果要修改語言設定的代碼大致只需要本頁即可