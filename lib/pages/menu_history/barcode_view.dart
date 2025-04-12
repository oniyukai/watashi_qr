import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/pages/menu_settings/appabout_page.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:watashi_qr/pages/widgets/custom_menu_button.dart';
import 'package:watashi_qr/pages/widgets/expandable_card.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:barcode_image/barcode_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarcodeView extends StatefulWidget with RouterBridge<HistoryItem> {
  const BarcodeView({super.key});

  @override
  State<BarcodeView> createState() => _BarcodeViewState();
}

class _BarcodeViewState extends State<BarcodeView> {
  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    final historyItem = widget.argumentOf(context);
    if (historyItem == null) return AppAboutPage();
    final BarcodeQRCorrectionLevel? level = historyItem.getErrorLevel?.barcodeQRCorrectionLevel;
    final itemDescription = HistoryFormat.description(historyItem.getFormat, localeStr);
    return Scaffold(
      appBar: AppBar(
        title: Text(HistoryFormat.localeStrFromName(historyItem.format, localeStr)),
        actions: [
          CustomMenuButton(
            icon: const Icon(Icons.save),
            labelList: [Language.pngLabel, Language.jpgLabel, Language.svgLabel],
            onSelectedEnd: (int option) => _exportImage(
              option: const <String>['png', 'jpg', 'svg'][option],
              contents: historyItem.contents,
              format: historyItem.getFormat,
              level: level,
              localeStr: localeStr,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareImage(
              contents: historyItem.contents,
              format: historyItem.getFormat,
              level: level,
            ), // 匯出PNG
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Utils.isPortrait(context)
            ? Column(
              children: [
                _barcodeSvgCard(historyItem, Utils.isPortrait(context), level),
                const SizedBox(height: 24),
                _expandedListView(localeStr, historyItem, itemDescription),
              ],
            )
            : Row(
              children: [
                _barcodeSvgCard(historyItem, Utils.isPortrait(context), level),
                const SizedBox(width: 24),
                _expandedListView(localeStr, historyItem, itemDescription),
              ],
            ),
        ),
      ),
    );
  }

  Widget _barcodeSvgCard(HistoryItem historyItem, bool isPortrait, BarcodeQRCorrectionLevel? level) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double length = isPortrait ? constraints.maxWidth : constraints.maxHeight;
            length = isPortrait ? length*0.8 : length;
            length = min(length, (!isPortrait ? constraints.maxWidth : constraints.maxHeight)/1.618);
            return Center(
              child: SvgPicture.string(
                _getBarcodeSvg(
                  contents: historyItem.contents,
                  format: historyItem.getFormat,
                  level: level,
                  length: length,
                ),
              ),
            );
          },
        ),
      )
    );
  }

  Widget _expandedListView(Language localeStr, HistoryItem historyItem, String? itemDescription) {
    return Expanded(
      child: ListView(
        children: [
          ExpandableCard(
            title: HistoryType.localeStrFromName(historyItem.type, localeStr),
            icon: historyItem.getTypeIconData,
            initialExpanded: true,
            expandedChild: SelectableText(historyItem.contents),
          ),
          const SizedBox(height: 8),
          if (historyItem.format == HistoryFormat.qrCode.name)
            Center(child: Text('${localeStr.qrCodeErrorCorrectionLevelLabel}: ${
                HistoryErrorLevel.localeStrFromName(historyItem.errorLevel, localeStr)
                ?? HistoryErrorLevel.localeStrFromName(context.settingsProvider.selectedQRErrorLevel, localeStr)
            }'),),
          if (itemDescription!=null) Text(itemDescription),
          const SizedBox(height: 16),
        ],
      )
    );
  }

  Future<void> _exportImage({
    required String option,
    required String contents,
    required HistoryFormat? format,
    required BarcodeQRCorrectionLevel? level,
    required Language localeStr
  }) async {
    try {
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      final Directory? directory = await getExternalStorageDirectory();
      late String initialDirectory;
      if (directory != null) initialDirectory = directory.path;
      final String? directoryPath = await FilePicker.platform.getDirectoryPath(initialDirectory:initialDirectory);
      if (directoryPath == null) {
        Utils.showToast('${localeStr.cancelLabel}\nUnable to get storage directory.');
        return;
      }
      final String filePath = '$directoryPath/barcode.$option';
      final file = File(filePath);

      if (option == 'svg') {
        final String svg = _getBarcodeSvg(
            contents: contents,
            format: format,
            level: level
        );
        await file.writeAsString(svg);
      } else {
        final barcodeImage = _getBarcodeImage(contents, format, level);
        file.writeAsBytesSync(option=='png' ? img.encodePng(barcodeImage) : img.encodeJpg(barcodeImage));
      }

      Utils.showToast(localeStr.snackBarMessageSaveBitmapOk);
    } catch (e) {
      Utils.showToast('${localeStr.snackBarMessageSaveBitmapError}\n$e', 8);
    }
  }

  Future<void> _shareImage({
    required String contents,
    required HistoryFormat? format,
    required BarcodeQRCorrectionLevel? level,
  }) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/barcode.png';
      final File file = File(filePath);
      final barcodeImage = _getBarcodeImage(contents, format, level);
      file.writeAsBytesSync(img.encodePng(barcodeImage));
      await Share.shareXFiles([XFile(filePath)]);
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  img.Image _getBarcodeImage(String contents, HistoryFormat? format, BarcodeQRCorrectionLevel? level){
    final barcodeImage = img.Image(width: 1024, height: _getHeight(format, 1024.0).toInt());
    img.fill(barcodeImage, color: img.ColorRgb8(255, 255, 255));
    drawBarcode(barcodeImage, _getBarcode(format, level), contents, font: img.arial48);
    return barcodeImage;
  }

  String _getBarcodeSvg({
    required String contents,
    required HistoryFormat? format,
    required BarcodeQRCorrectionLevel? level,
    double length = 1024,
  }) {
    final Barcode barcode = _getBarcode(format, level);
    final double height = _getHeight(format, length);
    return barcode.toSvg(contents, width: length, height: height);
  }

  double _getHeight(HistoryFormat? format, double width) {
    switch (format) {
      case HistoryFormat.qrCode:
      case HistoryFormat.aztec:
      case HistoryFormat.dataMatrix:
        return width;
      case HistoryFormat.pdf417:
      case HistoryFormat.ean13:
      case HistoryFormat.ean8:
      case HistoryFormat.upcA:
      case HistoryFormat.upcE:
      case HistoryFormat.code128:
      case HistoryFormat.code93:
      case HistoryFormat.code39:
      case HistoryFormat.codebar:
      case HistoryFormat.itf:
        return width/2.718;
      default:
        return width;
    }
  }

  Barcode _getBarcode(HistoryFormat? format, BarcodeQRCorrectionLevel? level){
    level = level ?? HistoryErrorLevel.L.barcodeQRCorrectionLevel!;

    switch (format) {
      case HistoryFormat.qrCode: return Barcode.qrCode(errorCorrectLevel: level);
      case HistoryFormat.aztec: return Barcode.aztec();
      case HistoryFormat.dataMatrix: return Barcode.dataMatrix();
      case HistoryFormat.pdf417: return Barcode.pdf417();
      case HistoryFormat.ean13: return Barcode.ean13();
      case HistoryFormat.ean8: return Barcode.ean8();
      case HistoryFormat.upcA: return Barcode.upcA();
      case HistoryFormat.upcE: return Barcode.upcE();
      case HistoryFormat.code128: return Barcode.code128();
      case HistoryFormat.code93: return Barcode.code93();
      case HistoryFormat.code39: return Barcode.code39();
      case HistoryFormat.codebar: return Barcode.codabar();
      case HistoryFormat.itf: return Barcode.itf();
      default: return Barcode.qrCode(errorCorrectLevel: level);
    }
  }

}