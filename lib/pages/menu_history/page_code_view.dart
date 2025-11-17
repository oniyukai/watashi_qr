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
  late HistoryItem _historyItem;
  late HistoryFormat? _historyFormat;
  late HistoryErrorLevel? _historyErrorLevel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument = widget.argumentOf(context);
    if (argument == null) throw 'widget.argumentOf(context) cannot be null.';
    _historyItem = argument;
    _historyFormat = _historyItem.getFormat;
    _historyErrorLevel = HistoryErrorLevel.fromName(_historyItem.errorLevel);
    if (_historyErrorLevel == HistoryErrorLevel.none || _historyErrorLevel == null) {
      _historyErrorLevel = context.readPrefs.get(PrefsEnum.selectedQRErrorLevel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = Utils.isPortrait(context);
    final validatorMsg = barcodeValidator(_historyItem.contents, _historyFormat);
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
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double length = isPortrait ? constraints.maxWidth : constraints.maxHeight;
                      length = isPortrait ? length*0.8 : length;
                      length = min(length, (!isPortrait ? constraints.maxWidth : constraints.maxHeight)/1.618);
                      return Center(
                        child: (validatorMsg == null)
                            ? _getSvgPicture(length) //todo debug: 不如預期地能夠限制長邊比例
                            : Text(validatorMsg, style: TextStyle(color: Colors.grey)
                        ),
                      );
                    },
                  ),
                ),
              ),
              isPortrait ? const SizedBox(height: 24) : const SizedBox(width: 24),
              Expanded(
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
                          '${HistoryErrorLevel.localeStrFromName(_historyErrorLevel?.name)}')),
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

  Widget _getSvgPicture(double length) {
    try {
      return SvgPicture.string(_getBarcodeSvg(length));
    } catch (e) {
      return Text(e.toString(), style: TextStyle(color: Colors.grey));
    }
  }

  Future<void> _exportImage(String option) async {
    try {
      final Directory? directory = await getDownloadsDirectory();
      final String? directoryPath = await FilePicker.platform.getDirectoryPath(initialDirectory:directory?.path);
      if (directoryPath == null) {
        return Utils.showToast('${AppLocale.cancelLabel.s}\nUnable to get storage directory.');
      }
      final String filePath = p.join(directoryPath, 'barcode.$option');
      final file = File(filePath);

      if (option == StaticString.svgLabel) {
        final String svg = _getBarcodeSvg();
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

  String _getBarcodeSvg([double length = 1024]) {
    final Barcode barcode = _getBarcode();
    final double height = _getHeight(length);
    return barcode.toSvg(_historyItem.contents, width: length, height: height);
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
      case HistoryFormat.codebar:
      case HistoryFormat.itf:
        return width/2.718;
      default:
        return width;
    }
  }

  Barcode _getBarcode() {
    final level = _historyErrorLevel?.barcodeQRCorrectionLevel ?? BarcodeQRCorrectionLevel.low;
    return (_historyFormat == null || _historyFormat == HistoryFormat.qrCode)
        ? Barcode.qrCode(errorCorrectLevel: level)
        : _historyFormat!.barcodeFunc();
  }
}