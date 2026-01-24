import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/locale/map_en.dart';
import 'package:watashi_qr/locale/map_ja.dart';
import 'package:watashi_qr/locale/map_zh_hans.dart';
import 'package:watashi_qr/locale/map_zh_hant.dart';
import 'package:collection/collection.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<LocaleInstance> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(locale) => LocaleOption._supportedLanguages.contains(locale.languageCode);

  @override
  Future<LocaleInstance> load(locale) async {
    const LocaleOption baseOption = .en;

    final List<double Function(LocaleOption)> calculations = [
      (opt) {
        double score = 0.1;
        if (opt._locale!.languageCode == locale.languageCode && locale.languageCode.isNotEmpty) score += 8.0;
        if (opt._locale.scriptCode == locale.scriptCode && locale.scriptCode?.isNotEmpty == true) score += 4.0;
        if (opt._locale.countryCode == locale.countryCode && locale.countryCode?.isNotEmpty == true) score += 2.0;
        return score;
      },
      (opt) => 1.0 / opt.mapList.length + opt.mapList.first.entries.where((a) => a.value != null).length / AppLocale.values.length,
    ];
    Iterable<LocaleOption> competitors = LocaleOption.values.where((a) => a._locale != null && a.mapList.isNotEmpty);
    for (final double Function(LocaleOption) calc in calculations) {
      if (competitors.length <= 1) break;
      final List<LocaleOption> winners = [];
      double bestScore = double.negativeInfinity;
      for (final LocaleOption option in competitors) {
        final double score = calc(option);
        if (score < bestScore) continue;
        if (score > bestScore) winners.clear();
        winners.add(option);
        bestScore = score;
      }
      competitors = winners.isNotEmpty ? winners : const [baseOption];
    }
    final List<LocaleInstance> mapList = (competitors.firstOrNull ?? baseOption).mapList;
    return {
      for (final AppLocale key in AppLocale.values)
        key: mapList.firstWhereOrNull((map) => map[key] != null)?[key],
    };
  }

  @override
  bool shouldReload(old) => false;
}

enum LocaleOption {
  sys(null, []),
  en(Locale('en'), [mapEn]),
  ja(Locale('ja'), [mapJa, mapEn]),
  zhHans(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'), [mapZhHans, mapZhHant, mapEn]),
  zhHant(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'), [mapZhHant, mapEn]);

  final Locale? _locale;
  final List<LocaleInstance> mapList;

  const LocaleOption(this._locale, this.mapList);

  Locale get locale => _locale ?? WidgetsBinding.instance.platformDispatcher.locale;

  static Map<LocaleOption, String> get optionMap => <LocaleOption, String>{
    sys: AppLocale.preferencesDefault.s,
    en: StaticString.localeLanguageEn,
    ja: StaticString.localeLanguageJa,
    zhHans: StaticString.localeLanguageZhHans,
    zhHant: StaticString.localeLanguageZhHant,
  };

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizationsDelegate(),
    ...GlobalMaterialLocalizations.delegates,
  ];

  static final Iterable<Locale> supportedLocales = [
    for (final LocaleOption option in values)
      if (option._locale != null)
        option._locale
  ];

  static final Set<String> _supportedLanguages = {
    for (final LocaleOption option in values)
      if (option._locale != null)
        option._locale.languageCode,
  };
}

// 如果要修改語言設定的代碼大致只需要本頁即可
