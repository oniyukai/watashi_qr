import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/locale/app_localizations.dart';
import 'package:watashi_qr/common/app_theme.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/menu_settings/page_about_view.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_view.dart';
import 'package:watashi_qr/common/prefs.dart';
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
    AppLocale.load(context);
    final trailingIcon = Icon((Directionality.of(context) == TextDirection.ltr)
        ? Icons.chevron_right
        : Icons.chevron_left
    );
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          child: Consumer<PrefsProvider>(
            builder: (context, prefs, child) => ListView(
              children: [
                ListTileText(text: AppLocale.preferencesAppearanceTitle.s, isSection: true),
                ListTilePicker(
                  text: AppLocale.preferencesColor.s,
                  selectedOption: prefs.get(PrefsEnum.selectedColor),
                  optionMap: ColorOption.optionMap,
                  onChanged: (value) => prefs.update(PrefsEnum.selectedColor, value),
                ),
                ListTilePicker(
                  text: AppLocale.preferencesThemeLabel.s,
                  selectedOption: prefs.get(PrefsEnum.selectedTheme),
                  optionMap: ThemeOption.optionMap,
                  onChanged: (value) => prefs.update(PrefsEnum.selectedTheme, value),
                ),
                ListTilePicker(
                  text: AppLocale.preferencesLanguagesTitle.s,
                  dialogText: AppLocale.preferencesLanguagesChange.s,
                  selectedOption: prefs.get(PrefsEnum.selectedLanguage),
                  optionMap: LocaleOption.optionMap,
                  onChanged: (value) => prefs.update(PrefsEnum.selectedLanguage, value),
                ),

                ListTileText(text: AppLocale.preferencesScanTitle.s, isSection: true),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchScanAutoOpenWebsiteLabel.s,
                  iconData: Icons.open_in_browser,
                  initialValue: prefs.get(PrefsEnum.isAutoOpenWebsite),
                  enabled: !prefs.get(PrefsEnum.isContinuousScan),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isAutoOpenWebsite, value);
                  },
                ),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchScanContinuousScanLabel.s,
                  iconData: Icons.fast_forward,
                  initialValue: prefs.get(PrefsEnum.isContinuousScan),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isContinuousScan, value);
                  },
                ),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchScanVibrateLabel.s,
                  iconData: Icons.vibration,
                  initialValue: prefs.get(PrefsEnum.isVibrateOnScan),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isVibrateOnScan, value);
                  },
                ),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchScanBipLabel.s,
                  iconData: Icons.volume_up,
                  initialValue: prefs.get(PrefsEnum.isBipOnScan),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isBipOnScan, value);
                  },
                ),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchScanScreenRotationLabel.s,
                  iconData: Icons.screen_rotation,
                  initialValue: prefs.get(PrefsEnum.isScreenRotation),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isScreenRotation, value);
                  },
                ),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchScanBarcodeCopiedLabel.s,
                  iconData: Icons.content_copy,
                  initialValue: prefs.get(PrefsEnum.isBarcodeCopied),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isBarcodeCopied, value);
                  },
                ),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchScanUseFrontcameraLabel.s,
                  iconData: Icons.camera_front,
                  initialValue: prefs.get(PrefsEnum.isUseFrontcamera),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isUseFrontcamera, value);
                  },
                ),

                ListTileText(text: AppLocale.preferencesBarcodeGenerationTitle.s, isSection: true),
                ListTilePicker(
                  text: AppLocale.qrCodeErrorCorrectionLevelLabel.s,
                  dialogText: AppLocale.qrCodeErrorCorrectionLevelSettingsLabel.s,
                  selectedOption: prefs.get(PrefsEnum.selectedQRErrorLevel),
                  optionMap: HistoryErrorLevel.optionMap,
                  onChanged: (value) => prefs.update(
                    PrefsEnum.selectedQRErrorLevel, value
                  ),
                ),

                ListTileText(text: AppLocale.titleHistory.s, isSection: true),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchScanAddBarcodeToTheHistoryLabel.s,
                  iconData: Icons.qr_code_scanner,
                  initialValue: prefs.get(PrefsEnum.isScanAddHistory),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isScanAddHistory, value);
                  },
                ),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel.s,
                  iconData: Icons.edit,
                  initialValue: prefs.get(PrefsEnum.isCreateAddHistory),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isCreateAddHistory, value);
                  },
                ),
                ListTileSwitch(
                  text: AppLocale.preferencesSwitchHistorySaveDuplicatesLabel.s,
                  iconData: Icons.filter_2,
                  initialValue: prefs.get(PrefsEnum.isSaveDuplicates),
                  onToggle: (bool value) {
                    prefs.update(PrefsEnum.isSaveDuplicates, value);
                  },
                ),

                ListTileText(text: AppLocale.preferencesSearchTitle.s, isSection: true),
                ListTilePicker(
                  text: AppLocale.preferencesSearchEngine.s,
                  selectedOption: prefs.get(PrefsEnum.selectedSearchEngine),
                  optionMap: SearchEngine.optionMap,
                  onChanged: (value) => prefs.update(PrefsEnum.selectedSearchEngine, value),
                ),
                ListTileText(
                  text: AppLocale.customSearchUrls.s,
                  trailing: trailingIcon,
                  onTap:() => context.routeTo(PageCustomurlsView),
                ),

                ListTileText(text: AppLocale.preferencesAboutTitle.s, isSection: true),
                ListTileText(
                    text: StaticString.appName,
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