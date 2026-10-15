import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:watashi_qr/common/drift_database.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_basic.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_creator/page_barcode_form.dart';
import 'package:watashi_qr/pages/menu_creator/page_qrcode_form.dart';
import 'package:watashi_qr/pages/menu_history/page_code_view.dart';
import 'package:watashi_qr/pages/widget/barcode_field.dart';
import 'package:watashi_qr/pages/widget/expandable_card.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

class MainCreatorView extends StatefulWidget {
  const MainCreatorView({super.key});

  static Future<void> createRouteTo(
    BuildContext context,
    String contents,
    HistoryFormat format,
  ) async {
    final String? validatorMsg = barcodeValidator(contents, format);
    if (validatorMsg != null) {
      Utils.showToast(validatorMsg);
      return;
    }
    final bool isCreateAddHistory = context.readPrefs.get(.isCreateAddHistory);
    final HistoryErrorLevel selectedQRErrorLevel =
        format == HistoryFormat.qrCode
        ? context.readPrefs.get(.selectedQRErrorLevel)
        : HistoryErrorLevel.none;
    HistoryItem item = HistoryItem(
      uuid: '',
      createdAt: DateTime.now(),
      contents: contents,
      format: format.name,
      type: HistoryType.fromDistinguish(format, contents).name,
      errorLevel: selectedQRErrorLevel.name,
      origin: HistoryOrigin.C.name,
      isFavorite: false,
      notes: '',
    );
    if (isCreateAddHistory) item = await DriftService.appDb.dao.insert(item);
    await context.routeOf<PageCodeView>().toPass(item);
  }

  @override
  State<MainCreatorView> createState() => _MainCreatorViewState();
}

class _MainCreatorViewState extends State<MainCreatorView> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _createQrFromClipboard() async {
    final ClipboardData? clipboardData = await Clipboard.getData(
      Clipboard.kTextPlain,
    );
    final String? contents = clipboardData?.text;
    if (contents == null || contents.isEmpty) {
      Utils.showToast(DictKey.creatorUiClipboardEmpty.s);
      return;
    }
    await MainCreatorView.createRouteTo(
      context,
      contents,
      HistoryFormat.qrCode,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DictKey.load(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scrollbar(
        controller: _scrollController,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
          controller: _scrollController,
          children: [
            ExpandableCard(
              title: DictKey.navTitleCreateQrCode.s,
              myIconData: HistoryFormat.qrCode.myIconData,
              expandedChild: Column(
                children: [
                  ItemTile(
                    title: DictKey.navLabelCreateFromClipboard.s,
                    myIconData: const MyIconData(Icons.content_copy),
                    onTap: _createQrFromClipboard,
                  ),
                  for (final HistoryType type in HistoryType.values)
                    if (!const <HistoryType>[
                      HistoryType.product,
                      HistoryType.industrial,
                    ].contains(type))
                      ItemTile(
                        title: HistoryType.localeFromName(type.name),
                        myIconData: MyIconData(type.iconData),
                        onTap: () =>
                            context.routeOf<PageQrcodeForm>().toPass(type),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ExpandableCard(
              title: DictKey.navTitleCreateBarCode.s,
              myIconData: MyIconData.barcode,
              expandedChild: Column(
                children: [
                  for (final HistoryFormat format in HistoryFormat.values)
                    if (!const <HistoryFormat>[HistoryFormat.qrCode]
                        .contains(format))
                      ItemTile(
                        title: HistoryFormat.localeFromName(format.name),
                        myIconData: format.myIconData,
                        description: format.composition,
                        onTap: () =>
                            context.routeOf<PageBarcodeForm>().toPass(format),
                      ),
                ],
              ),
            ),
            // const SizedBox(height: 16),
            // Center( // todo?: 有緣或許有分享到該程式的功能
            //   child: Text(AppLocale.shareToThisAppLabel.s,
            //       softWrap: true,
            //       style: theme.textTheme.bodyMedium
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
