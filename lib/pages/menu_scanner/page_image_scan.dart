import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';

class PageImageScan extends StatefulWidget with RouterBridge<PageImageScanArgs> {
  const PageImageScan({super.key});

  @override
  State<PageImageScan> createState() => _PageImageScanState();
}

class PageImageScanArgs {
  final MobileScannerController controller;
  final XFile? xFile;
  PageImageScanArgs({required this.controller, this.xFile});
}

class _PageImageScanState extends State<PageImageScan> {
  final CropController _cropController = CropController();
  Uint8List? _imageBytes;
  BarcodeCapture? _barcodeCapture;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _loadImage();
    });
  }

  Future<void> _loadImage() async {
    XFile? xFile = widget.argumentOf(context)?.xFile
        ?? await ImagePicker().pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      final bytes = await xFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _cropController.image = bytes;  // <-- don't setState this
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _onCropped(CropResult croppedData) async {
    if (croppedData is CropSuccess) {
      final MobileScannerController? controller = widget.argumentOf(context)?.controller;
      final Uint8List croppedImage = croppedData.croppedImage;

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.png');
      await tempFile.writeAsBytes(croppedImage);

      final BarcodeCapture? barcodeCapture = await controller?.analyzeImage(tempFile.path);

      if (mounted) {
        setState(() {
          _barcodeCapture = barcodeCapture;
        });
      }
    } else if (croppedData is CropFailure) {
      Utils.showToast('${croppedData.cause}');
    }
  }

  Future<void> checkAndGoView() async {
    final barcodeFormat = _barcodeCapture?.barcodes.first.format;
    final String? contents = _barcodeCapture?.barcodes.first.rawValue;
    if (barcodeFormat==null || contents==null || contents.isEmpty) return;

    final format = HistoryFormat.fromScannerFormat(barcodeFormat);
    final bool isScanAddHistory = context.readSettings.isScanAddHistory;
    final HistoryItem item = HistoryItem(
      unixTime: Utils.nowUnixTime,
      contents: contents,
      format: format?.name ?? barcodeFormat.name,
      type: HistoryType.fromDistinguish(format, contents).name,
      errorLevel: HistoryErrorLevel.none.name,
      origin: HistoryOrigin.S.name,
      isFavorite: false,
      notes: '',
    );
    if (isScanAddHistory) HiveService.addItem(item, context:context);
    await context.routeOf<PageItemView>().arguments(item).to();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localeStr.titleScan),
        actions: [
          if (_barcodeCapture?.barcodes.isNotEmpty == true) IconButton(
            icon: const Icon(Icons.check),
            onPressed: checkAndGoView,
          ),
        ],
      ),
      body: (_imageBytes == null) ? null
          : Crop(
        controller: _cropController,
        image: _imageBytes!,
        initialRectBuilder: InitialRectBuilder.withSizeAndRatio(size: 0.75),
        onCropped: _onCropped,
        onHistoryChanged: (_) => _cropController.crop(),
        baseColor: Colors.transparent,
        key: ValueKey(Utils.isPortrait(context)),
        interactive: true,
      ),
    );
  }
}
