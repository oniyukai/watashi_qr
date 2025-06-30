import 'package:flutter/material.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_creator/page_barcode_form.dart';
import 'package:watashi_qr/pages/menu_creator/page_qrcode_form.dart';
import 'package:watashi_qr/pages/menu_history/page_code_view.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';
import 'package:watashi_qr/pages/widget/expandable_card.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:flutter/services.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

class MainCreatorView extends StatefulWidget {
  const MainCreatorView({super.key});

  @override
  State<MainCreatorView> createState() => _MainCreatorViewState();
}

class _MainCreatorViewState extends State<MainCreatorView> {
  final ScrollController _scrollController = ScrollController();
  final Set<HistoryType> _historyTypes = const <HistoryType>{
    HistoryType.text,
    HistoryType.website,
    HistoryType.contact,
    HistoryType.mail,
    HistoryType.sms,
    HistoryType.phone,
    HistoryType.location,
    HistoryType.event,
    HistoryType.wifi,
  };

  final Set<HistoryFormat> _historyFormats = const <HistoryFormat>{
    HistoryFormat.dataMatrix,
    HistoryFormat.aztec,
    HistoryFormat.pdf417,
    HistoryFormat.ean13,
    HistoryFormat.ean8,
    HistoryFormat.upcA,
    HistoryFormat.upcE,
    HistoryFormat.code128,
    HistoryFormat.code93,
    HistoryFormat.code39,
    HistoryFormat.codebar,
    HistoryFormat.itf,
  };

  Future<void> _createQrFromClipboard(Language localeStr) async {
    final ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final String? contents = clipboardData?.text;
    if (contents == null || contents.isEmpty) {
      Utils.showToast('${localeStr.clipboardEmpty}\n${localeStr.qrCodeTextGeneratorHintTextInputEditText}');
    } else if (contents.length > 2953) {
      Utils.showToast('${localeStr.errorBarcodeWrongLengthMessage}< 2953');
    } else {
      final String selectedQRErrorLevel = context.readSettings.selectedQRErrorLevel;
      final bool isCreateAddHistory = context.readSettings.isCreateAddHistory;
      final HistoryItem item = HistoryItem(
        unixTime: Utils.nowUnixTime,
        contents: contents,
        format: HistoryFormat.qrCode.name,
        type: HistoryType.fromDistinguish(HistoryFormat.qrCode, contents).name,
        errorLevel: selectedQRErrorLevel,
        origin: HistoryOrigin.C.name,
        isFavorite: false,
        notes: '',
      );
      if (isCreateAddHistory) HiveService.addItem(item, context:context);
      context.routeOf<PageCodeView>().arguments(item).to();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            controller: _scrollController,
            children: [
              const SizedBox(height: 16),
              ExpandableCard(
                title: localeStr.titleQrCodeCreator,
                myIconData: HistoryFormat.qrCode.myIconData,
                expandedChild: Column(
                  children: [
                    ItemTile(
                      title: localeStr.createQrFromClipboard,
                      myIconData: MyIconData(Icons.content_copy),
                      onTap: () => _createQrFromClipboard(localeStr),
                    ),
                    ..._historyTypes.map((type) => ItemTile(
                      title: HistoryType.localeStrFromName(type.name, localeStr),
                      myIconData: type.myIconData,
                      onTap: () => context.routeOf<PageQrcodeForm>()
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
                myIconData: MyIconData.barcode,
                expandedChild: Column(
                  children: _historyFormats.map((format) => ItemTile(
                    title: HistoryFormat.localeStrFromName(format.name, localeStr),
                    myIconData: format.myIconData,
                    description: format.composition(localeStr),
                    onTap: () => context.routeOf<PageBarcodeForm>()
                        .arguments(format)
                        .to(),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Center( // todo?: 有緣或許有分享到該程式的功能
              //   child: Text(localeStr.shareToThisAppLabel,
              //       softWrap: true,
              //       style: theme.textTheme.bodyMedium
              //   ),
              // ),
              // const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}