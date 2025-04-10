import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watashi_qr/common/app_theme.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/locale/app_localizations.dart';

enum PreferenceKeys {
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
}

enum SearchEngineKeys { google, bing, wikipedia, }

class SettingsProvider extends ChangeNotifier {

  late SharedPreferences _prefs;

  String? _selectedColor;
  String get selectedColor => _selectedColor ?? ColorOptions.sys.name;
  String? _selectedTheme;
  String get selectedTheme => _selectedTheme ?? ThemeOptions.sys.name;
  String? _selectedLanguage;
  String get selectedLanguage => _selectedLanguage ?? LocaleOptions.sys.name;

  bool? _isAutoOpenWebsite;
  bool get isAutoOpenWebsiteEnabled => _isAutoOpenWebsite ?? false;
  bool? _isContinuousScan;
  bool get isContinuousScanEnabled => _isContinuousScan ?? false;
  bool? _isVibrateOnScan;
  bool get isVibrateOnScan => _isVibrateOnScan ?? true;
  bool? _isBipOnScan;
  bool get isBipOnScan => _isBipOnScan ?? false;
  bool? _isScreenRotation;
  bool get isScreenRotationEnabled => _isScreenRotation ?? false;
  bool? _isBarcodeCopied;
  bool get isBarcodeCopiedEnabled => _isBarcodeCopied ?? false;
  bool? _isUseFrontcamera;
  bool get isUseFrontcameraEnabled => _isUseFrontcamera ?? false;

  String? _selectedQRErrorLevel;
  String get qrCodeErrorLevel => _selectedQRErrorLevel ?? ErrorLevels.L.name;

  bool? _isScanAddHistory;
  bool get isHistoryEnabled => _isScanAddHistory ?? true;
  bool? _isCreateAddHistory;
  bool get isBarCodeGenerationHistoryEnabled => _isCreateAddHistory ?? true;
  bool? _isSaveDuplicates;
  bool get isHistoryDuplicatedEnabled => _isSaveDuplicates ?? true;

  String? _selectedSearchEngine;
  String get selectedSearchEngine => _selectedSearchEngine ?? SearchEngineKeys.google.name;
  List<String>? _customSearchUrls;
  List<String> get customSearchUrls => _customSearchUrls ?? <String>[];

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    _selectedColor = _prefs.getString(PreferenceKeys.selectedColor.name);
    _selectedTheme = _prefs.getString(PreferenceKeys.selectedTheme.name);
    _selectedLanguage = _prefs.getString(PreferenceKeys.selectedLanguage.name);
    _isAutoOpenWebsite = _prefs.getBool(PreferenceKeys.isAutoOpenWebsite.name);
    _isContinuousScan = _prefs.getBool(PreferenceKeys.isContinuousScan.name);
    _isVibrateOnScan = _prefs.getBool(PreferenceKeys.isVibrateOnScan.name);
    _isBipOnScan = _prefs.getBool(PreferenceKeys.isBipOnScan.name);
    _isScreenRotation = _prefs.getBool(PreferenceKeys.isScreenRotation.name);
    _isBarcodeCopied = _prefs.getBool(PreferenceKeys.isBarcodeCopied.name);
    _isUseFrontcamera = _prefs.getBool(PreferenceKeys.isUseFrontcamera.name);
    _selectedQRErrorLevel = _prefs.getString(PreferenceKeys.selectedQRErrorLevel.name);
    _isScanAddHistory = _prefs.getBool(PreferenceKeys.isScanAddHistory.name);
    _isCreateAddHistory = _prefs.getBool(PreferenceKeys.isCreateAddHistory.name);
    _isSaveDuplicates = _prefs.getBool(PreferenceKeys.isSaveDuplicates.name);
    _selectedSearchEngine = _prefs.getString(PreferenceKeys.selectedSearchEngine.name);
    _customSearchUrls = _prefs.getStringList(PreferenceKeys.customSearchUrls.name);

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

extension Context on BuildContext {
  SettingsProvider get settingsProvider => Provider.of<SettingsProvider>(this, listen: false);
}