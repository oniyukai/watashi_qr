import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watashi_qr/common/app_theme.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/locale/app_localizations.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_view.dart';

class PrefDef<RUN extends Object, STO extends Object> {
  final RUN defaultValue;
  late final STO Function(Object fromRUN) toSTO;
  late final RUN Function(Object fromSTO) toRUN;

  Type get typeRUN => RUN;
  Type get typeSTO => STO;

  PrefDef._(
    this.defaultValue, [
    STO Function(RUN fromRUN)? toSTO_,
    RUN? Function(STO fromSTO)? toRUN_,])
  {
    assert(const [bool, int, double, String, List<String>].contains(STO), 'STO<${STO.runtimeType}> unsupported.');
    if (RUN == STO) {
      toSTO = toSTO_ != null
          ? (fromRUN) => toSTO_(fromRUN as RUN)
          : (fromRUN) => fromRUN as STO;
      toRUN = toRUN_ != null
          ? (fromSTO) => toRUN_(fromSTO as STO) ?? defaultValue
          : (fromSTO) => fromSTO as RUN;
    } else {
      assert(toSTO_ != null && toRUN_ != null, 'When <$RUN>!=<$STO>: toSTO_ & toRUN_ are required.');
      toSTO = (fromRUN) => toSTO_!(fromRUN as RUN);
      toRUN = (fromSTO) => toRUN_!(fromSTO as STO) ?? defaultValue;
    }
  }

  static PrefDef<T, T> _same<T extends Object>(T defaultValue) => PrefDef<T, T>._(defaultValue);
}

enum PrefsEnum {
  selectedColor,
  selectedTheme,
  selectedLanguage,
  isAutoOpenWebsite,
  isContinuousScan,
  isVibrateOnScan,
  isBipOnScan,
  isScreenRotation,
  isBarcodeCopied,
  isUseFrontCamera,
  selectedQRErrorLevel,
  isScanAddHistory,
  isCreateAddHistory,
  isSaveDuplicates,
  selectedSearchEngine,
  customSearchUrls,
  scannerWindowWidthPortrait,
  scannerWindowHeightPortrait,
  scannerWindowWidthLandscape,
  scannerWindowHeightLandscape,
  scannerZoomLevel;

  static final Map<PrefsEnum, PrefDef> _prefDefCache = {};

  PrefDef get _getPrefDef => _prefDefCache.putIfAbsent(this, () {
    final prefDef = switch (this) {
      selectedColor =>  PrefDef<ColorOption, String>._(
          .sys,
          (fromRUN) => fromRUN.name,
          (fromSTO) => ColorOption.values.fromName(fromSTO),
      ),
      selectedTheme => PrefDef<ThemeOption, String>._(
          .sys,
          (fromRUN) => fromRUN.name,
          (fromSTO) => ThemeOption.values.fromName(fromSTO),
      ),
      selectedLanguage => PrefDef<LocaleOption, String>._(
          .sys,
          (fromRUN) => fromRUN.name,
          (fromSTO) => LocaleOption.values.fromName(fromSTO),
      ),
      isAutoOpenWebsite => PrefDef._same(false),
      isContinuousScan => PrefDef._same(false),
      isVibrateOnScan => PrefDef._same(true),
      isBipOnScan => PrefDef._same(false),
      isScreenRotation => PrefDef._same(false),
      isBarcodeCopied => PrefDef._same(false),
      isUseFrontCamera => PrefDef._same(false),
      selectedQRErrorLevel => PrefDef<HistoryErrorLevel, String>._(
          .L,
          (fromRUN) => fromRUN.name,
          (fromSTO) => HistoryErrorLevel.values.fromName(fromSTO),
      ),
      isScanAddHistory => PrefDef._same(true),
      isCreateAddHistory => PrefDef._same(true),
      isSaveDuplicates => PrefDef._same(true),
      selectedSearchEngine => PrefDef<SearchEngine, String>._(
          .google,
          (fromRUN) => fromRUN.name,
          (fromSTO) => SearchEngine.values.fromName(fromSTO),
      ),
      customSearchUrls => PrefDef<List<CustomSearchUrl>, List<String>>._(
          <CustomSearchUrl>[],
          (fromRUN) => fromRUN.map((run) => jsonEncode(run)).toList(),
          (fromSTO) => fromSTO.map((sto) => CustomSearchUrl.fromString(sto)).toList(),
      ),
      scannerWindowWidthPortrait => PrefDef._same(-1.0),
      scannerWindowHeightPortrait => PrefDef._same(-1.0),
      scannerWindowWidthLandscape => PrefDef._same(-1.0),
      scannerWindowHeightLandscape => PrefDef._same(-1.0),
      scannerZoomLevel => PrefDef._same(0.0),
    };
    return prefDef;
  });

  T defaultValue<T>() => _getPrefDef.defaultValue as T;

  /// 不依賴BuildContext, 不即時請謹慎使用
  T get<T>() {
    final PrefDef<Object, Object> prefDef = _getPrefDef;
    final Object? fromSTO = PrefsProvider._instance.get(name);
    if (fromSTO.runtimeType == prefDef.typeSTO && fromSTO != null) return prefDef.toRUN(fromSTO) as T;
    return prefDef.defaultValue as T;
  }
}

class PrefsProvider extends ChangeNotifier {
  static late final SharedPreferences _instance;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  final Map<PrefsEnum, Object> _prefsRunsMap = {};

  PrefsProvider() {
    for (final PrefsEnum key in PrefsEnum.values) {
      final PrefDef<Object, Object> prefDef = key._getPrefDef;
      final Object? fromSTO = _instance.get(key.name);
      if (fromSTO.runtimeType == prefDef.typeSTO && fromSTO != null) _prefsRunsMap[key] = prefDef.toRUN(fromSTO);
    }
  }

  /// 依賴BuildContext
  T get<T>(PrefsEnum key) {
    final PrefDef<Object, Object> prefDef = key._getPrefDef;
    final Object value = _prefsRunsMap[key] ?? prefDef.defaultValue;
    assert(value.runtimeType == prefDef.typeRUN);
    return value as T;
  }

  Future<void> update(PrefsEnum key, Object value, [bool notify = true]) async {
    final PrefDef<Object, Object> prefDef = key._getPrefDef;
    if (value.runtimeType != prefDef.typeRUN) {
      throw ArgumentError('Error type: value<${value.runtimeType}> != $key<${prefDef.typeRUN}>');
    }
    final Object fromSTO = prefDef.toSTO(value);
    if (fromSTO is bool) {
      await _instance.setBool(key.name, fromSTO);
    } else if (fromSTO is int) {
      await _instance.setInt(key.name, fromSTO);
    } else if (fromSTO is double) {
      await _instance.setDouble(key.name, fromSTO);
    } else if (fromSTO is String) {
      await _instance.setString(key.name, fromSTO);
    } else if (fromSTO is List<String>) {
      await _instance.setStringList(key.name, fromSTO);
    } else {
      throw ArgumentError('Unsupported type $key: ${fromSTO.runtimeType}');
    }
    _prefsRunsMap[key] = value;
    if (notify) notifyListeners();
  }
}

extension Context on BuildContext {
  PrefsProvider get readPrefs => Provider.of<PrefsProvider>(this, listen: false); //same mean: read<PrefsProvider>();
  PrefsProvider get watchPrefs => Provider.of<PrefsProvider>(this, listen: true); //same mean: watch<PrefsProvider>();
}
