import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watashi_qr/common/app_theme.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/app_localizations.dart';
import 'package:watashi_qr/locale/language.dart';

enum PreferenceKey {
  selectedColor,
  selectedTheme,
  selectedLanguage,
  isAutoOpenWebsite,
  isContinuousScan,
  isVibrateOnScan,
  isBipOnScan,
  isScreenRotation,
  isBarcodeCopied,
  isUseFrontcamera,
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
  scannerZoomLevel,
}

enum SearchEngine {
  google(Language.googleUrl),
  bing(Language.bingUrl),
  wikipedia(Language.wikipediaUrl);

  final String url;
  const SearchEngine(this.url);

  static String urlByName(String n) => values.asNameMap()[n]?.url ?? google.url;

  static Map<String, String> optionMap(Language localeStr) => <String, String>{
    google.name: Language.googleLabel,
    bing.name: Language.bingLabel,
    wikipedia.name: Language.wikipediaLabel,
  };
}

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs = Utils.prefs;

  String? _selectedColor;
  String get selectedColor => _selectedColor ?? ColorOption.sys.name;
  String? _selectedTheme;
  String get selectedTheme => _selectedTheme ?? ThemeOption.sys.name;
  String? _selectedLanguage;
  String get selectedLanguage => _selectedLanguage ?? LocaleOption.sys.name;

  bool? _isAutoOpenWebsite;
  bool get isAutoOpenWebsite => _isAutoOpenWebsite ?? false;
  bool? _isContinuousScan;
  bool get isContinuousScan => _isContinuousScan ?? false;
  bool? _isVibrateOnScan;
  bool get isVibrateOnScan => _isVibrateOnScan ?? true;
  bool? _isBipOnScan;
  bool get isBipOnScan => _isBipOnScan ?? false;
  bool? _isScreenRotation;
  bool get isScreenRotation => _isScreenRotation ?? false;
  bool? _isBarcodeCopied;
  bool get isBarcodeCopied => _isBarcodeCopied ?? false;
  bool? _isUseFrontcamera;
  bool get isUseFrontcamera => _isUseFrontcamera ?? false;

  String? _selectedQRErrorLevel;
  String get selectedQRErrorLevel => _selectedQRErrorLevel ?? HistoryErrorLevel.L.name;

  bool? _isScanAddHistory;
  bool get isScanAddHistory => _isScanAddHistory ?? true;
  bool? _isCreateAddHistory;
  bool get isCreateAddHistory => _isCreateAddHistory ?? true;
  bool? _isSaveDuplicates;
  bool get isSaveDuplicates => _isSaveDuplicates ?? true;

  String? _selectedSearchEngine;
  String get selectedSearchEngine => _selectedSearchEngine ?? SearchEngine.google.name;
  List<String>? _customSearchUrls;
  List<String> get customSearchUrls => _customSearchUrls ?? <String>[];

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    _selectedColor = _prefs.getString(PreferenceKey.selectedColor.name);
    _selectedTheme = _prefs.getString(PreferenceKey.selectedTheme.name);
    _selectedLanguage = _prefs.getString(PreferenceKey.selectedLanguage.name);
    _isAutoOpenWebsite = _prefs.getBool(PreferenceKey.isAutoOpenWebsite.name);
    _isContinuousScan = _prefs.getBool(PreferenceKey.isContinuousScan.name);
    _isVibrateOnScan = _prefs.getBool(PreferenceKey.isVibrateOnScan.name);
    _isBipOnScan = _prefs.getBool(PreferenceKey.isBipOnScan.name);
    _isScreenRotation = _prefs.getBool(PreferenceKey.isScreenRotation.name);
    _isBarcodeCopied = _prefs.getBool(PreferenceKey.isBarcodeCopied.name);
    _isUseFrontcamera = _prefs.getBool(PreferenceKey.isUseFrontcamera.name);
    _selectedQRErrorLevel = _prefs.getString(PreferenceKey.selectedQRErrorLevel.name);
    _isScanAddHistory = _prefs.getBool(PreferenceKey.isScanAddHistory.name);
    _isCreateAddHistory = _prefs.getBool(PreferenceKey.isCreateAddHistory.name);
    _isSaveDuplicates = _prefs.getBool(PreferenceKey.isSaveDuplicates.name);
    _selectedSearchEngine = _prefs.getString(PreferenceKey.selectedSearchEngine.name);
    _customSearchUrls = _prefs.getStringList(PreferenceKey.customSearchUrls.name);

    notifyListeners();
  }

  Future<void> updateSetting(PreferenceKey key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key.name, value);
    } else if (value is bool) {
      await _prefs.setBool(key.name, value);
    } else if (value is int) {
      await _prefs.setInt(key.name, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key.name, value);
    }
    await loadSettings();
  }
}

extension Context on BuildContext {
  SettingsProvider get settingsProvider => Provider.of<SettingsProvider>(this, listen: false); //same mean: read<SettingsProvider>();
}