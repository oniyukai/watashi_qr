import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/locale/app_localizations.dart';
import 'package:watashi_qr/common/app_theme.dart';
import 'package:watashi_qr/pages/menu_settings/appabout_page.dart';
import 'package:watashi_qr/pages/menu_settings/customurls_page.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/pages/widgets/settings_page_widgets.dart';

class MainSettingsPage extends StatefulWidget {
  const MainSettingsPage({super.key});

  @override
  State<MainSettingsPage> createState() => _MainSettingsPage();
}

class _MainSettingsPage extends State<MainSettingsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    final trailingIcon = Icon((Directionality.of(context) == TextDirection.ltr)
        ? Icons.chevron_right
        : Icons.chevron_left
    );
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          child: Consumer<SettingsProvider>(
            builder: (context, settings, child) => ListView(
              children: [
                ListTileText(str: localeStr.preferencesAppearanceTitle, isSection: true),
                ListTilePicker(
                  str: localeStr.preferencesColor,
                  selectedOption: settings.selectedColor,
                  optionsMap: AppTheme.colorOptionsMap(localeStr),
                  onChanged: (value) => settings.updateSetting(PreferenceKeys.selectedColor.name, value),
                ),
                ListTilePicker(
                  str: localeStr.preferencesThemeLabel,
                  selectedOption: settings.selectedTheme,
                  optionsMap: AppTheme.themeOptionsMap(localeStr),
                  onChanged: (value) => settings.updateSetting(PreferenceKeys.selectedTheme.name, value),
                ),
                ListTilePicker(
                  str: localeStr.preferencesLanguagesTitle,
                  dialogTitleStr: localeStr.preferencesLanguagesChange,
                  selectedOption: settings.selectedLanguage,
                  optionsMap: AppLocale.optionsMap(localeStr),
                  onChanged: (value) => settings.updateSetting(PreferenceKeys.selectedLanguage.name, value),
                ),

                ListTileText(str: localeStr.preferencesScanTitle, isSection: true),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanAutoOpenWebsiteLabel,
                  icon: Icons.open_in_browser,
                  initialValue: settings.isAutoOpenWebsiteEnabled,
                  enabled: !settings.isContinuousScanEnabled,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isAutoOpenWebsite.name, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanContinuousScanLabel,
                  icon: Icons.fast_forward,
                  initialValue: settings.isContinuousScanEnabled,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isContinuousScan.name, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanVibrateLabel,
                  icon: Icons.vibration,
                  initialValue: settings.isVibrateOnScan,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isVibrateOnScan.name, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanBipLabel,
                  icon: Icons.volume_up,
                  initialValue: settings.isBipOnScan,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isBipOnScan.name, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanScreenRotationLabel,
                  icon: Icons.screen_rotation,
                  initialValue: settings.isScreenRotationEnabled,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isScreenRotation.name, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanBarcodeCopiedLabel,
                  icon: Icons.content_copy,
                  initialValue: settings.isBarcodeCopiedEnabled,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isBarcodeCopied.name, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanUseFrontcameraLabel,
                  icon: Icons.flip_camera_android,
                  initialValue: settings.isUseFrontcameraEnabled,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isUseFrontcamera.name, value);
                  },
                ),

                ListTileText(str: localeStr.preferencesBarcodeGenerationTitle, isSection: true),
                ListTilePicker(
                  str: localeStr.qrCodeErrorCorrectionLevelLabel,
                  dialogTitleStr: localeStr.qrCodeErrorCorrectionLevelSettingsLabel,
                  selectedOption: settings.qrCodeErrorLevel,
                  optionsMap: Utils.qrECLOptionsMap(localeStr),
                  onChanged: (value) => settings.updateSetting(
                    PreferenceKeys.selectedQRErrorLevel.name, value
                  ),
                ),

                ListTileText(str: localeStr.titleHistory, isSection: true),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanAddBarcodeToTheHistoryLabel,
                  icon: Icons.qr_code_scanner,
                  initialValue: settings.isHistoryEnabled,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isScanAddHistory.name, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel,
                  icon: Icons.edit,
                  initialValue: settings.isBarCodeGenerationHistoryEnabled,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isCreateAddHistory.name, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchHistorySaveDuplicatesLabel,
                  icon: Icons.filter_2,
                  initialValue: settings.isHistoryDuplicatedEnabled,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKeys.isSaveDuplicates.name, value);
                  },
                ),

                ListTileText(str: localeStr.preferencesSearchTitle, isSection: true),
                ListTilePicker(
                  str: localeStr.preferencesSearchEngine,
                  selectedOption: settings.selectedSearchEngine,
                  optionsMap: <String, String>{
                    SearchEngineKeys.google.name: Language.googleLabel,
                    SearchEngineKeys.bing.name: Language.bingLabel,
                    SearchEngineKeys.wikipedia.name: Language.wikipediaLabel,
                  },
                  onChanged: (value) => settings.updateSetting(PreferenceKeys.selectedSearchEngine.name, value),
                ),
                ListTileText(
                  str: localeStr.customSearchUrls,
                  trailing: trailingIcon,
                  onTap:() => context.routeTo(CustomurlsPage),
                ),

                ListTileText(str: localeStr.preferencesAboutTitle, isSection: true),
                ListTileText(
                  str: Language.appName,
                  trailing: trailingIcon,
                  onTap:() => context.routeTo(AppAboutPage)
                ),
              ],
            )
          )
        )
      ),
    );
  }
}