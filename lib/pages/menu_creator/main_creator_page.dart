import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_creator/barcode_form.dart';
import 'package:watashi_qr/pages/menu_creator/qrcode_form.dart';
import 'package:watashi_qr/pages/menu_history/code_view.dart';
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
  final List<HistoryType> _historyTypes = const <HistoryType>[
    HistoryType.text,
    HistoryType.website,
    HistoryType.contact,
    HistoryType.mail,
    HistoryType.sms,
    HistoryType.phone,
    HistoryType.location,
    HistoryType.agend,
    HistoryType.wifi,
  ];

  final List<HistoryFormat> _historyFormats = const <HistoryFormat>[
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
  ];

  Future<void> _createQrFromClipboard(Language localeStr) async {
    final ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final String selectedQRErrorLevel = context.readSettings.selectedQRErrorLevel;
    final bool isCreateAddHistory = context.readSettings.isCreateAddHistory;
    if (clipboardData != null && clipboardData.text != null && clipboardData.text!.isNotEmpty) {
      final String contents = clipboardData.text!;
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
      context.routeOf<CodeView>().arguments(item).to();
    } else {
      Utils.showToast('${localeStr.clipboardEmpty}\n${localeStr.qrCodeTextGeneratorHintTextInputEditText}');
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
                icon: Icons.qr_code,
                expandedChild: Column(
                  children: [
                    ListTileItem(
                      title: localeStr.createQrFromClipboard,
                      icon: Icons.content_copy,
                      onTap: () => _createQrFromClipboard(localeStr),
                    ),
                    ..._historyTypes.map((type) => ListTileItem(
                      title: HistoryType.localeStrFromName(type.name, localeStr),
                      icon: type.iconData,
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
                  children: _historyFormats.map((format) => ListTileItem(
                    title: HistoryFormat.localeStrFromName(format.name, localeStr),
                    icon: format.iconData,
                    description: HistoryFormat.composition(format, localeStr),
                    onTap: () => context.routeOf<BarcodeForm>()
                        .arguments(format)
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
        ),
      ),
    );
  }
}