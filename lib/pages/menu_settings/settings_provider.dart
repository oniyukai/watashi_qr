import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watashi_qr/locale/language.dart';

class SettingsProvider extends ChangeNotifier {

  late SharedPreferences _prefs;

  String? _selectedColor;
  String get selectedColor => _selectedColor ?? 'sys';
  String? _selectedTheme;
  String get selectedTheme => _selectedTheme ?? 'sys';
  String? _selectedLanguage;
  String get selectedLanguage => _selectedLanguage ?? 'sys';

  bool? _isAutoOpenWebsiteEnabled;
  bool get isAutoOpenWebsiteEnabled => _isAutoOpenWebsiteEnabled ?? false;
  bool? _isContinuousScanEnabled;
  bool get isContinuousScanEnabled => _isContinuousScanEnabled ?? false;
  bool? _isVibrateOnScan;
  bool get isVibrateOnScan => _isVibrateOnScan ?? true;
  bool? _isBipOnScan;
  bool get isBipOnScan => _isBipOnScan ?? false;
  bool? _isScreenRotationEnabled;
  bool get isScreenRotationEnabled => _isScreenRotationEnabled ?? false;
  bool? _isBarcodeCopiedEnabled;
  bool get isBarcodeCopiedEnabled => _isBarcodeCopiedEnabled ?? false;
  bool? _isUseFrontcameraEnabled;
  bool get isUseFrontcameraEnabled => _isUseFrontcameraEnabled ?? false;

  String? _qrCodeErrorLevel;
  String get qrCodeErrorLevel => _qrCodeErrorLevel ?? 'L';

  bool? _isHistoryEnabled;
  bool get isHistoryEnabled => _isHistoryEnabled ?? true;
  bool? _isBarCodeGenerationHistoryEnabled;
  bool get isBarCodeGenerationHistoryEnabled => _isBarCodeGenerationHistoryEnabled ?? true;
  bool? _isHistoryDuplicatedEnabled;
  bool get isHistoryDuplicatedEnabled => _isHistoryDuplicatedEnabled ?? true;

  String? _selectedSearchEngine;
  String get selectedSearchEngine => _selectedSearchEngine ?? 'google';
  List<String>? _customSearchUrls;
  List<String> get customSearchUrls => _customSearchUrls ?? <String>[];

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    _selectedColor = _prefs.getString(Language.preferencesColorKey);
    _selectedTheme = _prefs.getString(Language.preferencesThemeKey);
    _selectedLanguage = _prefs.getString(Language.preferencesLanguagesKey);
    _isAutoOpenWebsiteEnabled = _prefs.getBool(Language.preferencesSwitchScanAutoOpenWebsiteKey);
    _isContinuousScanEnabled = _prefs.getBool(Language.preferencesWwitchScanContinuousScanKey);
    _isVibrateOnScan = _prefs.getBool(Language.preferencesSwitchScanVibrateKey);
    _isBipOnScan = _prefs.getBool(Language.preferencesSwitchScanBipKey);
    _isScreenRotationEnabled = _prefs.getBool(Language.preferencesSwitchScanScreenRotationKey);
    _isBarcodeCopiedEnabled = _prefs.getBool(Language.preferencesSwitchScanBarcodeCopiedKey);
    _isUseFrontcameraEnabled = _prefs.getBool(Language.preferencesSwitchScanUseFrontcameraKey);
    _qrCodeErrorLevel = _prefs.getString(Language.preferencesBarcodeGenerationErrorCorrectionLevelKey);
    _isHistoryEnabled = _prefs.getBool(Language.preferencesSwitchScanAddBarcodeToTheHistoryKey);
    _isBarCodeGenerationHistoryEnabled = _prefs.getBool(Language.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryKey);
    _isHistoryDuplicatedEnabled = _prefs.getBool(Language.preferencesSwitchHistorySaveDuplicatesKey);
    _selectedSearchEngine = _prefs.getString(Language.preferencesSearchEngineKey);
    _customSearchUrls = _prefs.getStringList(Language.preferencesCustomSearchUrlsKey);

    notifyListeners();
  }

  Future<void> updateSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
    await loadSettings();
  }
}