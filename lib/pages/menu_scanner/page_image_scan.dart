import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/common/database_services.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/common/prefs.dart';

class PageImageScan extends StatefulWidget with RouterBridge<PageImageScanArgs> {
  const PageImageScan({super.key});

  @override
  State<PageImageScan> createState() => _PageImageScanState();
}

class PageImageScanArgs {
  final MobileScannerController controller;
  XFile? xFile;
  PageImageScanArgs({required this.controller, this.xFile});
}

class _PageImageScanState extends State<PageImageScan> with WidgetsBindingObserver {
  final CropController _cropController = CropController();
  late final PageImageScanArgs _args = widget.argumentOf(context)!;
  bool _isInCycleCrop = true;
  Uint8List? _imageBytes;
  BarcodeCapture? _barcodeCapture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_postFrameCallback);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _isInCycleCrop = false;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(state) {
    super.didChangeAppLifecycleState(state);
    if (state == .resumed && !_isInCycleCrop) {
      _isInCycleCrop = true;
    } else if (_isInCycleCrop) {
      _isInCycleCrop = false;
    }
  }

  Future<void> _postFrameCallback(Duration timeStamp) async {
    _args.xFile ??= await ImagePicker().pickImage(source: .gallery);
    if (_args.xFile == null) {
      Navigator.pop(context);
      return;
    }
    final Uint8List bytes = await _args.xFile!.readAsBytes();
    setState(() => _imageBytes = bytes);
  }

  Future<void> _onCropped(CropResult croppedData) async {
    if (croppedData is CropFailure) {
      Utils.showToast('${croppedData.cause}');
    } else if (croppedData is CropSuccess) {
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File(p.join(tempDir.path, 'temp_cropped_image.png'));
      await tempFile.writeAsBytes(croppedData.croppedImage);
      final BarcodeCapture? barcodeCapture = await _args.controller.analyzeImage(tempFile.path);
      if (!mounted) return;
      if ((_barcodeCapture?.barcodes.isNotEmpty == true) != (barcodeCapture?.barcodes.isNotEmpty == true)) {
        setState(() => _barcodeCapture = barcodeCapture);
      }
      _barcodeCapture = barcodeCapture;
    }
  }

  Future<void> _pressCheck() async {
    final BarcodeFormat scannerFormat = _barcodeCapture!.barcodes.first.format;
    final String? contents = _barcodeCapture!.barcodes.first.rawValue;
    if (contents == null || contents.isEmpty) return;
    final HistoryFormat? format = HistoryFormat.fromScannerFormat(scannerFormat);
    final bool isScanAddHistory = context.readPrefs.get(.isScanAddHistory);
    final HistoryItem item = HistoryItem(
      unixTime: Utils.nowUnixTime,
      contents: contents,
      format: format?.name ?? scannerFormat.name,
      type: HistoryType.fromDistinguish(format, contents).name,
      errorLevel: HistoryErrorLevel.none.name,
      origin: HistoryOrigin.S.name,
      isFavorite: false,
      notes: '',
    );
    if (isScanAddHistory) item.id = DatabaseServices.addItem(item);
    _isInCycleCrop = false;
    await context.routeOf<PageItemView>().arguments(item).to();
    Navigator.pop(context);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.titleScan.s),
        actions: [
          if (_barcodeCapture?.barcodes.isNotEmpty == true) IconButton(
            icon: const Icon(Icons.check),
            onPressed: _pressCheck,
          ),
        ],
      ),
      body: _imageBytes == null ? null
          : Crop(
        key: ValueKey(Utils.isPortrait(context)),
        controller: _cropController,
        image: _imageBytes!,
        interactive: true,
        onCropped: _onCropped,
        baseColor: Colors.transparent,
        initialRectBuilder: InitialRectBuilder.withSizeAndRatio(size: 0.75),
        onStatusChanged: (cropStatus) async {
          if (cropStatus != .ready || !_isInCycleCrop) return;
          await Future.delayed(const Duration(milliseconds: 512), _cropController.crop);
        },
      ),
    );
  }
}
