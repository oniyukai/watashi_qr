import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_history/item_view.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';

class ScanImagePage extends StatefulWidget with RouterBridge<XFile> {
  const ScanImagePage({super.key});

  @override
  State<ScanImagePage> createState() => _ScanImagePageState();
}

class _ScanImagePageState extends State<ScanImagePage> {
  XFile? _imageFile;
  BarcodeCapture? _barcodeCapture;
  final CropController _cropController = CropController();
  bool _isScanning = false;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImage();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadImage() async {
    final XFile? argument = widget.argumentOf(context);

    if (argument != null) {
      setState(() {
        _imageFile = argument;
      });
    } else {
      setState(() {
      });
      await _pickImage();
    }

    if (_imageFile != null) {
      final bytes = await File(_imageFile!.path).readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _cropController.image = bytes;
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final XFile? file =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _imageFile = file;
        _barcodeCapture = null;
      });
    }
  }

  Future<void> _analyzeCroppedImage(CropResult croppedData) async {
    setState(() {
      _isScanning = true;
    });
    try {
      if (croppedData is CropSuccess) {
        final Uint8List croppedImage = croppedData.croppedImage;

        // Save the cropped image to a temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/temp_image.png');
        await tempFile.writeAsBytes(croppedImage);

        // Analyze the cropped image using mobile_scanner
        final BarcodeCapture? barcodeCapture =
        await Utils.mobileScannerController.analyzeImage(tempFile.path);

        if (mounted) {
          setState(() {
            _barcodeCapture = barcodeCapture;
          });
        }
      } else if (croppedData is CropFailure) {
        Utils.showToast('${croppedData.cause}');
      }
    } catch (e) {
      Utils.showToast(e.toString());
    } finally {
      setState(() {
        _isScanning = false;
      });
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
    await context.routeOf<ItemView>().arguments(item).to();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localeStr.titleScan),
        actions: [
          if (_barcodeCapture?.barcodes.isNotEmpty == true && !_isScanning) IconButton(
            icon: const Icon(Icons.check),
            onPressed: checkAndGoView,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return (_imageFile != null && _imageBytes != null)
                      ? Crop(
                    controller: _cropController,
                    image: _imageBytes!,
                    initialRectBuilder: InitialRectBuilder.withSizeAndRatio(size: 0.75),
                    onCropped: (image) => _analyzeCroppedImage(image),
                    onHistoryChanged: (_) => _cropController.crop(),
                    baseColor: Colors.transparent,
                    key: ValueKey(constraints.maxWidth),
                  )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
