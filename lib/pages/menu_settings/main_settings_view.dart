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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocale.load(context);
    return SafeArea(
      child: Scrollbar(
        controller: _scrollController,
        child: Consumer<PrefsProvider>(
          builder: (context, prefs, child) => ListView(
            children: [
              ListTileText(text: AppLocale.preferencesAppearanceTitle.s, isSection: true),
              ListTilePicker(
                text: AppLocale.preferencesColor.s,
                selectedOption: prefs.get(.selectedColor),
                optionMap: ColorOption.optionMap,
                onChanged: (value) => prefs.update(.selectedColor, value),
              ),
              ListTilePicker(
                text: AppLocale.preferencesThemeLabel.s,
                selectedOption: prefs.get(.selectedTheme),
                optionMap: ThemeOption.optionMap,
                onChanged: (value) => prefs.update(.selectedTheme, value),
              ),
              ListTilePicker(
                text: AppLocale.preferencesLanguagesTitle.s,
                dialogText: AppLocale.preferencesLanguagesChange.s,
                selectedOption: prefs.get(.selectedLanguage),
                optionMap: LocaleOption.optionMap,
                onChanged: (value) => prefs.update(.selectedLanguage, value),
              ),

              ListTileText(text: AppLocale.preferencesScanTitle.s, isSection: true),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchScanAutoOpenWebsiteLabel.s,
                iconData: Icons.open_in_browser,
                initialValue: prefs.get(.isAutoOpenWebsite),
                enabled: !prefs.get(.isContinuousScan),
                onToggle: (value) => prefs.update(.isAutoOpenWebsite, value),
              ),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchScanContinuousScanLabel.s,
                iconData: Icons.fast_forward,
                initialValue: prefs.get(.isContinuousScan),
                onToggle: (value) => prefs.update(.isContinuousScan, value),
              ),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchScanVibrateLabel.s,
                iconData: Icons.vibration,
                initialValue: prefs.get(.isVibrateOnScan),
                onToggle: (value) => prefs.update(.isVibrateOnScan, value),
              ),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchScanBipLabel.s,
                iconData: Icons.volume_up,
                initialValue: prefs.get(.isBipOnScan),
                onToggle: (value) => prefs.update(.isBipOnScan, value),
              ),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchScanScreenRotationLabel.s,
                iconData: Icons.screen_rotation,
                initialValue: prefs.get(.isScreenRotation),
                onToggle: (value) => prefs.update(.isScreenRotation, value),
              ),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchScanBarcodeCopiedLabel.s,
                iconData: Icons.content_copy,
                initialValue: prefs.get(.isBarcodeCopied),
                onToggle: (value) => prefs.update(.isBarcodeCopied, value),
              ),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchScanUseFrontCameraLabel.s,
                iconData: Icons.camera_front,
                initialValue: prefs.get(.isUseFrontCamera),
                onToggle: (value) => prefs.update(.isUseFrontCamera, value),
              ),

              ListTileText(text: AppLocale.preferencesBarcodeGenerationTitle.s, isSection: true),
              ListTilePicker(
                text: AppLocale.qrCodeErrorCorrectionLevelLabel.s,
                dialogText: AppLocale.qrCodeErrorCorrectionLevelSettingsLabel.s,
                selectedOption: prefs.get(.selectedQRErrorLevel),
                optionMap: HistoryErrorLevel.optionMap,
                onChanged: (value) => prefs.update(.selectedQRErrorLevel, value),
              ),

              ListTileText(text: AppLocale.titleHistory.s, isSection: true),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchScanAddBarcodeToTheHistoryLabel.s,
                iconData: Icons.qr_code_scanner,
                initialValue: prefs.get(.isScanAddHistory),
                onToggle: (value) => prefs.update(.isScanAddHistory, value),
              ),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel.s,
                iconData: Icons.edit,
                initialValue: prefs.get(.isCreateAddHistory),
                onToggle: (value) => prefs.update(.isCreateAddHistory, value),
              ),
              ListTileSwitch(
                text: AppLocale.preferencesSwitchHistorySaveDuplicatesLabel.s,
                iconData: Icons.filter_2,
                initialValue: prefs.get(.isSaveDuplicates),
                onToggle: (value) => prefs.update(.isSaveDuplicates, value),
              ),

              ListTileText(text: AppLocale.preferencesSearchTitle.s, isSection: true),
              ListTilePicker(
                text: AppLocale.preferencesSearchEngine.s,
                selectedOption: prefs.get(.selectedSearchEngine),
                optionMap: SearchEngine.optionMap,
                onChanged: (value) => prefs.update(.selectedSearchEngine, value),
              ),
              ListTileText(
                text: AppLocale.customSearchUrls.s,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.routeTo(PageCustomurlsView),
              ),

              ListTileText(text: AppLocale.preferencesAboutTitle.s, isSection: true),
              ListTileText(
                text: StaticString.appName,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.routeTo(PageAboutView),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
