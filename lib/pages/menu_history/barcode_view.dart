import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
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
    final itemDescription = Utils.formatNameDescription(historyItem.formatName, localeStr);
    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.formatNameStr(historyItem.formatName, localeStr)),
        actions: [
          CustomMenuButton(
            icon: const Icon(Icons.save),
            labelList: [Language.pngLabel, Language.jpgLabel, Language.svgLabel],
            onSelectedEnd: (int option) => _exportImage(
              option: const <String>['png', 'jpg', 'svg'][option],
              contents: historyItem.contents,
              formatName: historyItem.formatName,
              errorCorrectionLevel: historyItem.errorCorrectionLevel,
              localeStr: localeStr,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareImage(
              contents: historyItem.contents,
              formatName: historyItem.formatName,
              errorCorrectionLevel: historyItem.errorCorrectionLevel,
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
                _barcodeSvgCard(historyItem, Utils.isPortrait(context)),
                const SizedBox(height: 24),
                _expandedListView(localeStr, historyItem, itemDescription),
              ],
            )
            : Row(
              children: [
                _barcodeSvgCard(historyItem, Utils.isPortrait(context)),
                const SizedBox(width: 24),
                _expandedListView(localeStr, historyItem, itemDescription),
              ],
            ),
        ),
      ),
    );
  }

  Widget _barcodeSvgCard(HistoryItem historyItem, bool isPortrait) {
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
                  formatName: historyItem.formatName,
                  errorCorrectionLevel: historyItem.errorCorrectionLevel,
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
            title: Utils.formatTypeStr(historyItem.type, localeStr),
            icon: Utils.formatTypeIcon(historyItem.type),
            initialExpanded: true,
            expandedChild: SelectableText(historyItem.contents),
          ),
          const SizedBox(height: 8),
          if (historyItem.formatName=='QR_CODE')
            Center(child: Text('${localeStr.qrCodeErrorCorrectionLevelLabel}: ${
                Utils.qrCodeECLOptionsMap(localeStr)[historyItem.errorCorrectionLevel]
                  ?? Utils.qrCodeECLOptionsMap(localeStr)[context.read<SettingsProvider>().qrCodeErrorLevel]
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
    required String formatName,
    required String errorCorrectionLevel,
    required Language localeStr
  }) async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      Directory? directory = await getExternalStorageDirectory();
      late String initialDirectory;
      if (directory != null) initialDirectory = directory.path;
      String? directoryPath = await FilePicker.platform.getDirectoryPath(initialDirectory:initialDirectory);
      if (directoryPath == null) {
        Utils.showToast('${localeStr.cancelLabel}\nUnable to get storage directory.');
        return;
      }
      String filePath = '$directoryPath/barcode.$option';
      final file = File(filePath);

      if (option == 'svg') {
        final String svg = _getBarcodeSvg(
            contents: contents,
            formatName: formatName,
            errorCorrectionLevel: errorCorrectionLevel
        );
        await file.writeAsString(svg);
      } else {
        final barcodeImage = _getBarcodeImage(contents, formatName, errorCorrectionLevel);
        file.writeAsBytesSync(option=='png' ? img.encodePng(barcodeImage) : img.encodeJpg(barcodeImage));
      }

      Utils.showToast(localeStr.snackBarMessageSaveBitmapOk);
    } catch (e) {
      Utils.showToast('${localeStr.snackBarMessageSaveBitmapError}\n$e', 8);
    }
  }

  Future<void> _shareImage({
    required String contents,
    required String formatName,
    required String errorCorrectionLevel,
  }) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/barcode.png';
      final File file = File(filePath);
      final barcodeImage = _getBarcodeImage(contents, formatName, errorCorrectionLevel);
      file.writeAsBytesSync(img.encodePng(barcodeImage));
      await Share.shareXFiles([XFile(filePath)]);
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  img.Image _getBarcodeImage(String contents, String formatName, String errorCorrectionLevel){
    final barcodeImage = img.Image(width: 1024, height: _getHeight(formatName, 1024.0).toInt());
    img.fill(barcodeImage, color: img.ColorRgb8(255, 255, 255));
    drawBarcode(barcodeImage, _getBarcode(formatName, errorCorrectionLevel), contents, font: img.arial48);
    return barcodeImage;
  }

  String _getBarcodeSvg({
    required String contents,
    required String formatName,
    required String errorCorrectionLevel,
    double length = 1024,
  }) {
    Barcode barcode = _getBarcode(formatName, errorCorrectionLevel);
    double height = _getHeight(formatName, length);
    return barcode.toSvg(contents, width: length, height: height);
  }

  double _getHeight(String formatName, double width) {
    switch (formatName) {
      case 'QR_CODE':
      case 'AZTEC':
      case 'DATA_MATRIX':
        return width;
      case 'PDF_417':
      case 'EAN_13':
      case 'EAN_8':
      case 'UPC_A':
      case 'UPC_E':
      case 'Code_128':
      case 'Code_93':
      case 'Code_39':
      case 'CODABAR':
      case 'IFT':
        return width/2.718;
      default:
        return width;
    }
  }

  Barcode _getBarcode(String formatName, String errorCorrectionLevel){
    BarcodeQRCorrectionLevel level;
    if (errorCorrectionLevel == 'NONE') {
      errorCorrectionLevel = context.read<SettingsProvider>().qrCodeErrorLevel;
    }
    switch (errorCorrectionLevel) {
      case 'L':
        level = BarcodeQRCorrectionLevel.low;
        break;
      case 'M':
        level = BarcodeQRCorrectionLevel.medium;
        break;
      case 'Q':
        level = BarcodeQRCorrectionLevel.quartile;
        break;
      case 'H':
        level = BarcodeQRCorrectionLevel.high;
        break;
      default:
        level = BarcodeQRCorrectionLevel.low;
    }
    switch (formatName) {
      case 'QR_CODE': return Barcode.qrCode(errorCorrectLevel: level);
      case 'AZTEC': return Barcode.aztec();
      case 'DATA_MATRIX': return Barcode.dataMatrix();
      case 'PDF_417': return Barcode.pdf417();
      case 'EAN_13': return Barcode.ean13();
      case 'EAN_8': return Barcode.ean8();
      case 'UPC_A': return Barcode.upcA();
      case 'UPC_E': return Barcode.upcE();
      case 'Code_128': return Barcode.code128();
      case 'Code_93': return Barcode.code93();
      case 'Code_39': return Barcode.code39();
      case 'CODABAR': return Barcode.codabar();
      case 'IFT': return Barcode.itf();
      default: return Barcode.qrCode(errorCorrectLevel: level);
    }
  }

}