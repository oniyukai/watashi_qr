import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watashi_qr/common/drift_database.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_basic.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/menu_scanner/main_scanner_view.dart';

class PageImageScan extends StatefulWidget
    with RouterBridge<PageImageScanArgs> {
  const PageImageScan({super.key});

  @override
  State<PageImageScan> createState() => _PageImageScanState();
}

class PageImageScanArgs {
  XFile? xFile;

  PageImageScanArgs({this.xFile});
}

class _PageImageScanState extends State<PageImageScan> {
  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
  );
  final CropController _cropController = CropController();
  late final PageImageScanArgs _args = widget.getArgs(context)!;
  AppLifecycleListener? _lifecycleListener;
  bool _isInCycleCrop = true;
  CropStatus _cropStatus = CropStatus.nothing;
  Uint8List? _imageBytes;
  BarcodeCapture? _barcodeCapture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_postFrameCallback);
    _lifecycleListener = AppLifecycleListener(
      onStateChange: (state) {
        if (state == AppLifecycleState.resumed && !_isInCycleCrop) {
          _isInCycleCrop = true;
          unawaited(_scheduleCycleCrop());
        } else if (_isInCycleCrop) {
          _isInCycleCrop = false;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _isInCycleCrop = false;
    _scannerController.dispose();
    _lifecycleListener?.dispose();
  }

  Future<void> _postFrameCallback(Duration timeStamp) async {
    _args.xFile ??= (await FilePicker.pickFile(type: FileType.image))?.xFile;
    if (_args.xFile == null) {
      Navigator.pop(context);
      return;
    }
    final Uint8List bytes = await _args.xFile!.readAsBytes();
    setState(() => _imageBytes = bytes);
  }

  Future<void> _scheduleCycleCrop() async {
    if (_cropStatus != CropStatus.ready || !_isInCycleCrop) return;
    await Future.delayed(const Duration(milliseconds: 512));
    if (!mounted || _cropStatus != CropStatus.ready || !_isInCycleCrop) return;
    _cropController.crop();
  }

  Future<void> _onCropped(CropResult croppedData) async {
    if (croppedData is CropFailure) {
      Utils.showToast('${croppedData.cause}');
    } else if (croppedData is CropSuccess) {
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File(
        p.join(tempDir.path, 'temp_cropped_image.png'),
      );
      await tempFile.writeAsBytes(croppedData.croppedImage);
      final BarcodeCapture? barcodeCapture = await _scannerController
          .analyzeImage(tempFile.path);
      if (!mounted) return;
      setState(() => _barcodeCapture = barcodeCapture);
    }
  }

  Future<void> _pressCheck() async {
    final (rawValue, format) = MainScannerView.decodeCapture(_barcodeCapture!);
    if (rawValue == null || rawValue.trim().isEmpty) return;
    final HistoryFormat? historyFormat = HistoryFormat.fromScannerFormat(
      format,
    );
    final bool isScanAddHistory = context.readPrefs.get(.isScanAddHistory);
    HistoryItem item = HistoryItem(
      uuid: '',
      createdAt: DateTime.now(),
      contents: rawValue,
      format: historyFormat?.name ?? format.name,
      type: HistoryType.fromDistinguish(historyFormat, rawValue).name,
      errorLevel: HistoryErrorLevel.none.name,
      origin: HistoryOrigin.S.name,
      isFavorite: false,
      notes: '',
    );
    if (isScanAddHistory) item = await DriftService.appDb.dao.insert(item);
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
    _isInCycleCrop = false;
    await context.routeOf<PageItemView>().toPass(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DictKey.navTitleScanner.s),
        actions: [
          if (_barcodeCapture?.barcodes.isNotEmpty ?? false)
            IconButton(icon: const Icon(Icons.check), onPressed: _pressCheck),
        ],
      ),
      body: _imageBytes == null
          ? null
          : Crop(
              key: ValueKey(Utils.isPortrait(context)),
              controller: _cropController,
              image: _imageBytes!,
              interactive: true,
              onCropped: _onCropped,
              baseColor: Colors.transparent,
              initialRectBuilder: InitialRectBuilder.withSizeAndRatio(
                size: 0.75,
              ),
              onStatusChanged: (cropStatus) {
                _cropStatus = cropStatus;
                unawaited(_scheduleCycleCrop());
              },
            ),
    );
  }
}
