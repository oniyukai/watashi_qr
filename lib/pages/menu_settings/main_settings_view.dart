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
  Widget build(context) {
    return SafeArea(
      child: Scrollbar(
        controller: _scrollController,
        child: Consumer<PrefsProvider>(
          builder: (context, prefs, child) => ListView(
            children: [
              ListTileText(text: DictKey.settingGroupAppearance.s, isSection: true),
              ListTilePicker(
                text: DictKey.settingOptionColor.s,
                selectedOption: prefs.get(.selectedColor),
                optionMap: ColorOption.optionMap,
                onChanged: (value) => prefs.update(.selectedColor, value),
              ),
              ListTilePicker(
                text: DictKey.settingOptionTheme.s,
                selectedOption: prefs.get(.selectedTheme),
                optionMap: ThemeOption.optionMap,
                onChanged: (value) => prefs.update(.selectedTheme, value),
              ),
              ListTilePicker(
                text: DictKey.settingGroupLanguages.s,
                dialogText: DictKey.settingOptionLanguagesChange.s,
                selectedOption: prefs.get(.selectedLanguage),
                optionMap: LocaleOption.optionMap,
                onChanged: (value) => prefs.update(.selectedLanguage, value),
              ),

              ListTileText(text: DictKey.settingGroupScan.s, isSection: true),
              ListTileSwitch(
                text: DictKey.settingOptionScanAutoOpenWebsite.s,
                iconData: Icons.open_in_browser,
                initialValue: prefs.get(.isAutoOpenWebsite),
                enabled: !prefs.get(.isContinuousScan),
                onToggle: (value) => prefs.update(.isAutoOpenWebsite, value),
              ),
              ListTileSwitch(
                text: DictKey.settingOptionScanContinuousScan.s,
                iconData: Icons.fast_forward,
                initialValue: prefs.get(.isContinuousScan),
                onToggle: (value) => prefs.update(.isContinuousScan, value),
              ),
              ListTileSwitch(
                text: DictKey.settingOptionScanVibrate.s,
                iconData: Icons.vibration,
                initialValue: prefs.get(.isVibrateOnScan),
                onToggle: (value) => prefs.update(.isVibrateOnScan, value),
              ),
              ListTileSwitch(
                text: DictKey.settingOptionScanBip.s,
                iconData: Icons.volume_up,
                initialValue: prefs.get(.isBipOnScan),
                onToggle: (value) => prefs.update(.isBipOnScan, value),
              ),
              ListTileSwitch(
                text: DictKey.settingOptionScanLockOrient.s,
                iconData: Icons.screen_rotation,
                initialValue: prefs.get(.isScreenRotation),
                onToggle: (value) => prefs.update(.isScreenRotation, value),
              ),
              ListTileSwitch(
                text: DictKey.settingOptionScanAutoCopy.s,
                iconData: Icons.content_copy,
                initialValue: prefs.get(.isBarcodeCopied),
                onToggle: (value) => prefs.update(.isBarcodeCopied, value),
              ),
              ListTileSwitch(
                text: DictKey.settingOptionScanUseFrontCamera.s,
                iconData: Icons.camera_front,
                initialValue: prefs.get(.isUseFrontCamera),
                onToggle: (value) => prefs.update(.isUseFrontCamera, value),
              ),

              ListTileText(text: DictKey.settingGroupGeneration.s, isSection: true),
              ListTilePicker(
                text: DictKey.settingOptionQrErrorCorrectionLevel.s,
                dialogText: DictKey.settingDialogQrErrorCorrectionLevelTitle.s,
                selectedOption: prefs.get(.selectedQRErrorLevel),
                optionMap: HistoryErrorLevel.optionMap,
                onChanged: (value) => prefs.update(.selectedQRErrorLevel, value),
              ),

              ListTileText(text: DictKey.navTitleHistory.s, isSection: true),
              ListTileSwitch(
                text: DictKey.settingOptionHistoryAddScan.s,
                iconData: Icons.qr_code_scanner,
                initialValue: prefs.get(.isScanAddHistory),
                onToggle: (value) => prefs.update(.isScanAddHistory, value),
              ),
              ListTileSwitch(
                text: DictKey.settingOptionHistoryAddCreate.s,
                iconData: Icons.edit,
                initialValue: prefs.get(.isCreateAddHistory),
                onToggle: (value) => prefs.update(.isCreateAddHistory, value),
              ),
              ListTileSwitch(
                text: DictKey.settingOptionHistoryAddWithDuplicates.s,
                iconData: Icons.filter_2,
                initialValue: prefs.get(.isSaveDuplicates),
                onToggle: (value) => prefs.update(.isSaveDuplicates, value),
              ),

              ListTileText(text: DictKey.settingGroupSearch.s, isSection: true),
              ListTilePicker(
                text: DictKey.settingOptionSearchEngine.s,
                selectedOption: prefs.get(.selectedSearchEngine),
                optionMap: SearchEngine.optionMap,
                onChanged: (value) => prefs.update(.selectedSearchEngine, value),
              ),
              ListTileText(
                text: DictKey.settingOptionCustomSearch.s,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.routeTo(PageCustomurlsView),
              ),

              ListTileText(text: DictKey.settingGroupAbout.s, isSection: true),
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
