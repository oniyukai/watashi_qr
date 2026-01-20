import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:watashi_qr/pages/widget/barcode_field.dart';
import 'package:watashi_qr/pages/widget/my_menu_button.dart';
import 'package:watashi_qr/pages/widget/expandable_card.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:barcode_image/barcode_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageCodeView extends StatefulWidget with RouterBridge<HistoryItem> {
  const PageCodeView({super.key});

  @override
  State<PageCodeView> createState() => _PageCodeViewState();
}

class _PageCodeViewState extends State<PageCodeView> {
  late final HistoryItem _historyItem = widget.argumentOf(context)!;
  late final HistoryFormat? _historyFormat = _historyItem.getFormat;
  late final HistoryErrorLevel _historyErrorLevel = _initErrorLevel();

  HistoryErrorLevel _initErrorLevel() {
    final HistoryErrorLevel? historyErrorLevel = HistoryErrorLevel.fromName(_historyItem.errorLevel);
    return (historyErrorLevel == .none || historyErrorLevel == null)
        ? context.readPrefs.get<HistoryErrorLevel>(.selectedQRErrorLevel)
        : historyErrorLevel;
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = Utils.isPortrait(context);
    final validatorMsg = barcodeValidator(_historyItem.contents, _historyFormat);
    final longestSide = MediaQuery.of(context).size.longestSide;
    return Scaffold(
      appBar: AppBar(
        title: Text(HistoryFormat.localeStrFromName(_historyItem.format)),
        actions: (validatorMsg == null) ? [
          MyMenuButton(
            icon: const Icon(Icons.save),
            items: [
              MyMenuItem(text: StaticString.pngLabel),
              MyMenuItem(text: StaticString.jpgLabel),
              MyMenuItem(text: StaticString.svgLabel),
            ],
            onSelectedEnd: (int option) => _exportImage(const <String>[
              StaticString.pngLabel, StaticString.jpgLabel, StaticString.svgLabel
            ][option]),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareImage(), // 匯出PNG
          ),
        ] : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Flex(
            direction: isPortrait ? Axis.vertical : Axis.horizontal,
            children: [
              Expanded(
                flex: isPortrait ? 0 : 1,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double width = isPortrait
                            ? min(constraints.biggest.shortestSide * 0.8, longestSide * 0.5)
                            : constraints.biggest.shortestSide;
                        return Center(
                          child: (validatorMsg == null)
                              ? _getSvgPicture(width)
                              : Text(validatorMsg, style: TextStyle(color: Colors.grey)
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              isPortrait ? const SizedBox(height: 24) : const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: ListView(
                  children: [
                    ExpandableCard(
                      title: HistoryType.localeStrFromName(_historyItem.type),
                      myIconData: _historyItem.getTypeIconData,
                      initialExpanded: true,
                      expandedChild: SelectableText(_historyItem.contents),
                    ),
                    const SizedBox(height: 8),
                    if (_historyFormat == HistoryFormat.qrCode || _historyFormat == null)
                      Center(child: Text('${AppLocale.qrCodeErrorCorrectionLevelLabel.s}: '
                          '${HistoryErrorLevel.localeStrFromName(_historyErrorLevel.name)}')),
                    Text(_historyFormat?.description ?? ''),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSvgPicture(double width) {
    try {
      return SvgPicture.string(_getBarcodeSvg(width));
    } catch (e) {
      return Text(e.toString(), style: TextStyle(color: Colors.grey));
    }
  }

  Future<void> _exportImage(String option) async {
    try {
      final Directory? directory = await getDownloadsDirectory();
      final String? directoryPath = await FilePicker.platform.getDirectoryPath(initialDirectory:directory?.path);
      if (directoryPath == null) {
        Utils.showToast('${AppLocale.cancelLabel.s}\nUnable to get storage directory.');
        return;
      }
      final String filePath = p.join(directoryPath, 'barcode.$option');
      final file = File(filePath);

      if (option == StaticString.svgLabel) {
        final String svg = _getBarcodeSvg(1024);
        await file.writeAsString(svg);
      } else {
        final barcodeImage = _getBarcodeImage();
        file.writeAsBytesSync(option==StaticString.pngLabel ? img.encodePng(barcodeImage) : img.encodeJpg(barcodeImage));
      }

      Utils.showToast(AppLocale.snackBarMessageSaveBitmapOk.s);
    } catch (e) {
      Utils.showToast('${AppLocale.snackBarMessageSaveBitmapError.s}\n$e', true);
    }
  }

  Future<void> _shareImage() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = p.join(tempDir.path, 'barcode.png');
      final File file = File(filePath);
      final barcodeImage = _getBarcodeImage();
      file.writeAsBytesSync(img.encodePng(barcodeImage));
      await Utils.share(ShareParams(files: [XFile(filePath)]));
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  img.Image _getBarcodeImage(){
    final barcodeImage = img.Image(width: 1024, height: _getHeight(1024.0).toInt());
    img.fill(barcodeImage, color: img.ColorRgb8(255, 255, 255));
    drawBarcode(barcodeImage, _getBarcode(), _historyItem.contents, font: img.arial48);
    return barcodeImage;
  }

  String _getBarcodeSvg(double width) {
    final Barcode barcode = _getBarcode();
    final double height = _getHeight(width);
    return barcode.toSvg(_historyItem.contents, width: width, height: height);
  }

  double _getHeight(double width) {
    switch (_historyFormat) {
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
      case HistoryFormat.codabar:
      case HistoryFormat.itf:
        return width/2.718;
      default:
        return width;
    }
  }

  Barcode _getBarcode() {
    final level = _historyErrorLevel.barcodeQRCorrectionLevel ?? BarcodeQRCorrectionLevel.low;
    return (_historyFormat == null || _historyFormat == HistoryFormat.qrCode)
        ? Barcode.qrCode(errorCorrectLevel: level)
        : _historyFormat.barcodeFunc();
  }
}
