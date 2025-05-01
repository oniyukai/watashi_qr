import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:watashi_qr/locale/language.dart';
import 'en.dart';
import 'ja.dart';
import 'zh_hans.dart';
import 'zh_hant.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Language> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => const <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  Future<Language> load(Locale locale) async {
    return switch (locale.languageCode) {
      'en' => En(),
      'ja' => Ja(),
      'zh' => (locale.scriptCode == 'Hans') ? ZhHans() : ZhHant(),
      _ => En(),
    };
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Language> old) => false;
}

enum LocaleOption {
  sys,
  en(Locale('en')),
  ja(Locale('ja')),
  zhHans(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')),
  zhHant(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'));

  final Locale? locale;
  const LocaleOption([this.locale]);

  static Locale localeFromName(String n) => values.asNameMap()[n]?.locale ?? WidgetsBinding.instance.platformDispatcher.locale;

  static Map<String, String> optionMap(Language localeStr) => <String, String>{
    sys.name: localeStr.preferencesDefault,
    en.name: Language.localeLanguageEn,
    ja.name: Language.localeLanguageJa,
    zhHans.name: Language.localeLanguageZhHans,
    zhHant.name: Language.localeLanguageZhHant,
  };

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    AppLocalizationsDelegate(),
    ...GlobalMaterialLocalizations.delegates,
  ];

  static Iterable<Locale> supportedLocales = LocaleOption.values
      .where((option) => option.locale != null)
      .map((option) => option.locale!);
}

// 如果要修改語言設定的代碼大致只需要本頁即可