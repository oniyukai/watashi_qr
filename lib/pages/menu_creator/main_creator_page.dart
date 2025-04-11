import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:watashi_qr/common/hive_storage.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_creator/barcode_form.dart';
import 'package:watashi_qr/pages/menu_creator/qrcode_form.dart';
import 'package:watashi_qr/pages/menu_history/barcode_view.dart';
import 'package:watashi_qr/pages/widgets/list_tile_item.dart';
import 'package:watashi_qr/pages/widgets/expandable_card.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:flutter/services.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';

class MainCreatorPage extends StatefulWidget {
  const MainCreatorPage({super.key});

  @override
  State<MainCreatorPage> createState() => _MainCreatorPageState();
}

class _MainCreatorPageState extends State<MainCreatorPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              controller: _scrollController,
              children: [
                const SizedBox(height: 16),
                ExpandableCard(
                  title: localeStr.titleQrCodeCreator,
                  icon: Icons.qr_code,
                  expandedChild: Column(
                    children: [
                      ListTileItem(
                        title: localeStr.createQrFromClipboard,
                        icon: Icons.content_copy,
                        onTap: () => _createQrFromClipboard(localeStr),
                      ),
                      ..._qrcodeTypes.map((type) => ListTileItem(
                        title:Utils.formatTypeStr(type, localeStr),
                        icon:Utils.formatTypeIcon(type),
                        onTap: () => context.routeOf<QrcodeForm>()
                            .arguments(type)
                            .to(),
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ExpandableCard(
                  title: localeStr.titleBarCodeCreator,
                  icon: MaterialCommunityIcons.barcode,
                  expandedChild: Column(
                    children: _barcodeTypes.map((type) => ListTileItem(
                      title:Utils.formatNameStr(type, localeStr),
                      icon:Utils.formatNameIcon(type),
                      description:Utils.formatNameComposition(type, localeStr),
                      onTap: () => context.routeOf<BarcodeForm>()
                          .arguments(type)
                          .to(),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                // Center( 已被刪除的功能
                //   child: Text(localeStr.shareToThisAppLabel,
                //       softWrap: true,
                //       style: theme.textTheme.bodyMedium
                //   ),
                // ),
                // const SizedBox(height: 16),
              ],
            ),
          )
        ),
      ),
    );
  }

  Future<void> _createQrFromClipboard(Language localeStr) async {
    final ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final String qrCodeErrorLevel = context.settingsProvider.selectedQRErrorLevel;
    final bool isBarCodeGenerationHistoryEnabled = context.settingsProvider.isCreateAddHistory;

    if (clipboardData != null) {
      final String? text = clipboardData.text;
      if (text != null) {
        final HistoryItem item = HistoryItem(
          unixTime: Utils.nowUnixTime,
          contents: text,
          format: 'QR_CODE',
          type: Utils.determineType('QR_CODE', text),
          errorLevel: qrCodeErrorLevel,
          origin: HistoryOrigin.C.name,
          isFavorite: false,
          notes: '',
        );
        if (isBarCodeGenerationHistoryEnabled) HiveStorage.addItem(item, context:context);
        context.routeOf<BarcodeView>().arguments(item).to();
      } else {
        Utils.showToast('${localeStr.clipboardEmpty}\n${localeStr.qrCodeTextGeneratorHintTextInputEditText}');
      }
    } else {
      Utils.showToast(localeStr.error);
    }
  }

  final List<String> _qrcodeTypes = const <String>[
    'TEXT',
    'WEBSITE',
    'CONTACT',
    'MAIL',
    'SMS',
    'PHONE',
    'LOCATION',
    'AGEND',
    'WIFI',
  ];

  final List<String> _barcodeTypes = const <String>[
    'DATA_MATRIX',
    'AZTEC',
    'PDF_417',
    'EAN_13',
    'EAN_8',
    'UPC_A',
    'UPC_E',
    'Code_128',
    'Code_93',
    'Code_39',
    'CODABAR',
    'IFT',
  ];

}