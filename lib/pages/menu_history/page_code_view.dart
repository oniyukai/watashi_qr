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
  late final HistoryItem _historyItem = widget.getArgs(context)!;
  late final HistoryFormat? _historyFormat = _historyItem.getFormat;
  late final HistoryErrorLevel _historyErrorLevel = _initErrorLevel();
  late String? _validatorMsg = barcodeValidator(_historyItem.contents, _historyFormat!);

  HistoryErrorLevel _initErrorLevel() {
    final HistoryErrorLevel? historyErrorLevel = _historyItem.getErrorLevel;
    return (historyErrorLevel == .none || historyErrorLevel == null)
        ? context.readPrefs.get<HistoryErrorLevel>(.selectedQRErrorLevel)
        : historyErrorLevel;
  }

  Future<void> _pressExport(String fileSuffix) async {
    try {
      final Directory? initialDir = await getDownloadsDirectory();
      final String? dir = await FilePicker.platform.getDirectoryPath(initialDirectory:initialDir?.path);
      if (dir == null) {
        Utils.showToast('${DictKey.commonUiCancel.s}\nUnable to get storage directory.');
        return;
      }
      const double width = 1024.0;
      final File file = File(p.join(dir, 'barcode.$fileSuffix'));
      switch (fileSuffix) {
        case StaticString.svgSuffix:
          await file.writeAsString(_getBarcodeSvg(width));
        case StaticString.pngSuffix:
          await file.writeAsBytes(img.encodePng(_getBarcodeImage(width)));
        case StaticString.jpgSuffix:
          await file.writeAsBytes(img.encodeJpg(_getBarcodeImage(width)));
        default: throw 'Unsupported file format: $fileSuffix';
      }
      Utils.showToast(DictKey.actionStatusImageSaveOk.s);
    } catch (e) {
      Utils.showToast('${DictKey.actionStatusImageSaveError.s}\n$e', true);
    }
  }

  Future<void> _pressShare() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File(p.join(tempDir.path, 'barcode.png'));
      await file.writeAsBytes(img.encodePng(_getBarcodeImage(1024.0)));
      await Utils.share(ShareParams(files: [XFile(file.path)]));
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  @override
  Widget build(context) {
    final bool isPortrait = Utils.isPortrait(context);
    final double longestSide = MediaQuery.of(context).size.longestSide;
    return Scaffold(
      appBar: AppBar(
        title: Text(HistoryFormat.localeStrFromName(_historyItem.format)),
        actions: _historyFormat != null && _validatorMsg == null ? [
          MyMenuButton(
            icon: const Icon(Icons.save),
            items: [
              for (final String suffix in const [StaticString.pngSuffix, StaticString.jpgSuffix, StaticString.svgSuffix])
                MyMenuItem(text: suffix.toUpperCase(), onTap: () => _pressExport(suffix)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _pressShare,
          ),
        ] : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 16.0),
          child: Flex(
            direction: isPortrait ? .vertical : .horizontal,
            children: [
              if (_historyFormat != null) Expanded(
                flex: isPortrait ? 0 : 1,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const .all(24.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double width = isPortrait
                            ? min(constraints.biggest.shortestSide * 0.8, longestSide * 0.5)
                            : constraints.biggest.shortestSide;
                        Widget? svgWidget;
                        try {
                          if (_validatorMsg == null) svgWidget = SvgPicture.string(_getBarcodeSvg(width));
                        } catch (e) {
                          _validatorMsg = e.toString();
                        }
                        return Center(
                          child: svgWidget ?? Text(_validatorMsg!, style: const TextStyle(color: Colors.grey))
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
                    if (_historyFormat == .qrCode) Text(
                      '${DictKey.settingOptionQrErrorCorrectionLevel.s}: '
                      '${HistoryErrorLevel.localeStrFromName(_historyErrorLevel.name)}',
                      textAlign: .center,
                    ),
                    Text(_historyFormat?.description ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getBarcodeSvg(double width) =>
      _getBarcode().toSvg(_historyItem.contents, width: width, height: _getHeight(width));

  img.Image _getBarcodeImage(double width) {
    final img.Image image = img.Image(width: width.round(), height: _getHeight(width).round());
    img.fill(image, color: img.ColorRgb8(255, 255, 255));
    drawBarcode(image, _getBarcode(), _historyItem.contents, font: img.arial48);
    return image;
  }

  Barcode _getBarcode() => _historyFormat == .qrCode || _historyFormat == null
      ? Barcode.qrCode(errorCorrectLevel: _historyErrorLevel.barcodeQRCorrectionLevel ?? .low)
      : _historyFormat.barcodeFunc();

  double _getHeight(double width) => switch (_historyFormat) {
    .qrCode || .dataMatrix || .aztec || null => width,
    .pdf417 || .ean13 || .ean8 ||
    .upcA || .upcE || .code128 ||
    .code93 || .code39 || .codabar ||
    .itf => width/2.718,
  };
}
