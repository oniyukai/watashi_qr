import 'package:flutter/material.dart';
import 'package:watashi_locale/watashi_locale.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/locale/map_en.dart';
import 'package:watashi_qr/locale/map_ja.dart';
import 'package:watashi_qr/locale/map_zh_hans.dart';
import 'package:watashi_qr/locale/map_zh_hant.dart';

enum LocaleOption {
  sys(null, []),
  en(Locale('en'), [mapEn]),
  ja(Locale('ja'), [mapJa, mapEn]),
  zhHans(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'), [mapZhHans, mapZhHant, mapEn]),
  zhHant(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'), [mapZhHant, mapEn]);

  final Locale? _locale;
  final List<DictInstance> maps;

  const LocaleOption(this._locale, this.maps);

  Locale get locale => _locale ?? WidgetsBinding.instance.platformDispatcher.locale;

  static Map<LocaleOption, String> get optionMap => <LocaleOption, String>{
    sys: DictKey.settingOptionLanguagesDefault.s,
    en: StaticString.localeLanguageEn,
    ja: StaticString.localeLanguageJa,
    zhHans: StaticString.localeLanguageZhHans,
    zhHant: StaticString.localeLanguageZhHant,
  };

  static final dictDelegate = WatashiDictDelegate(
    defaultCandidate: DictLocaleCandidate(LocaleOption.en, LocaleOption.en._locale, LocaleOption.en.maps),
    localeCandidates: LocaleOption.values.map((e) => DictLocaleCandidate(e, e._locale, e.maps)),
    dictKeys: DictKey.values.toSet(),
    dictWrap: (e) => e,
  );
}
