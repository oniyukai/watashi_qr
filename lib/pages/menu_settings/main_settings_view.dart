import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/locale/app_localizations.dart';
import 'package:watashi_qr/common/app_theme.dart';
import 'package:watashi_qr/pages/menu_settings/page_about_view.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_view.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_widgets.dart';

class MainSettingsView extends StatefulWidget {
  const MainSettingsView({super.key});

  @override
  State<MainSettingsView> createState() => _MainSettingsPage();
}

class _MainSettingsPage extends State<MainSettingsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
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
                  optionMap: ColorOption.optionMap(localeStr),
                  onChanged: (value) => settings.updateSetting(PreferenceKey.selectedColor, value),
                ),
                ListTilePicker(
                  str: localeStr.preferencesThemeLabel,
                  selectedOption: settings.selectedTheme,
                  optionMap: ThemeOption.optionMap(localeStr),
                  onChanged: (value) => settings.updateSetting(PreferenceKey.selectedTheme, value),
                ),
                ListTilePicker(
                  str: localeStr.preferencesLanguagesTitle,
                  dialogTitleStr: localeStr.preferencesLanguagesChange,
                  selectedOption: settings.selectedLanguage,
                  optionMap: LocaleOption.optionMap(localeStr),
                  onChanged: (value) => settings.updateSetting(PreferenceKey.selectedLanguage, value),
                ),

                ListTileText(str: localeStr.preferencesScanTitle, isSection: true),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanAutoOpenWebsiteLabel,
                  icon: Icons.open_in_browser,
                  initialValue: settings.isAutoOpenWebsite,
                  enabled: !settings.isContinuousScan,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isAutoOpenWebsite, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanContinuousScanLabel,
                  icon: Icons.fast_forward,
                  initialValue: settings.isContinuousScan,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isContinuousScan, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanVibrateLabel,
                  icon: Icons.vibration,
                  initialValue: settings.isVibrateOnScan,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isVibrateOnScan, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanBipLabel,
                  icon: Icons.volume_up,
                  initialValue: settings.isBipOnScan,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isBipOnScan, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanScreenRotationLabel,
                  icon: Icons.screen_rotation,
                  initialValue: settings.isScreenRotation,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isScreenRotation, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanBarcodeCopiedLabel,
                  icon: Icons.content_copy,
                  initialValue: settings.isBarcodeCopied,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isBarcodeCopied, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanUseFrontcameraLabel,
                  icon: Icons.flip_camera_android,
                  initialValue: settings.isUseFrontcamera,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isUseFrontcamera, value);
                  },
                ),

                ListTileText(str: localeStr.preferencesBarcodeGenerationTitle, isSection: true),
                ListTilePicker(
                  str: localeStr.qrCodeErrorCorrectionLevelLabel,
                  dialogTitleStr: localeStr.qrCodeErrorCorrectionLevelSettingsLabel,
                  selectedOption: settings.selectedQRErrorLevel,
                  optionMap: HistoryErrorLevel.optionMap(localeStr),
                  onChanged: (value) => settings.updateSetting(
                    PreferenceKey.selectedQRErrorLevel, value
                  ),
                ),

                ListTileText(str: localeStr.titleHistory, isSection: true),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchScanAddBarcodeToTheHistoryLabel,
                  icon: Icons.qr_code_scanner,
                  initialValue: settings.isScanAddHistory,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isScanAddHistory, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel,
                  icon: Icons.edit,
                  initialValue: settings.isCreateAddHistory,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isCreateAddHistory, value);
                  },
                ),
                ListTileSwitch(
                  str: localeStr.preferencesSwitchHistorySaveDuplicatesLabel,
                  icon: Icons.filter_2,
                  initialValue: settings.isSaveDuplicates,
                  onToggle: (bool value) {
                    settings.updateSetting(PreferenceKey.isSaveDuplicates, value);
                  },
                ),

                ListTileText(str: localeStr.preferencesSearchTitle, isSection: true),
                ListTilePicker(
                  str: localeStr.preferencesSearchEngine,
                  selectedOption: settings.selectedSearchEngine,
                  optionMap: SearchEngine.optionMap(localeStr),
                  onChanged: (value) => settings.updateSetting(PreferenceKey.selectedSearchEngine, value),
                ),
                ListTileText(
                  str: localeStr.customSearchUrls,
                  trailing: trailingIcon,
                  onTap:() => context.routeTo(PageCustomurlsView),
                ),

                ListTileText(str: localeStr.preferencesAboutTitle, isSection: true),
                ListTileText(
                  str: Language.appName,
                  trailing: trailingIcon,
                  onTap:() => context.routeTo(PageAboutView)
                ),
              ],
            )
          )
        )
      ),
    );
  }
}