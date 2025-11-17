import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/common/database_services.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/menu_nav_bar.dart';
import 'package:watashi_qr/pages/menu_scanner/main_scanner_widgets.dart';
import 'package:watashi_qr/pages/menu_scanner/page_image_scan.dart';
import 'package:watashi_qr/common/prefs.dart';

class MainScannerView extends StatefulWidget {
  const MainScannerView({super.key});

  @override
  State<MainScannerView> createState() => _MainScannerViewState();
}

class _MainScannerViewState extends State<MainScannerView> with WidgetsBindingObserver {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
    autoStart: false,
  );
  final AudioPlayer _audioPlayer = AudioPlayer();
  late double _defaultScanWindowSize;
  late double _zoomLevel;
  Rect _scanWindow = Rect.zero;
  bool _isDetectDisable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> dispose() async {
    _scannerController.dispose();
    _audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _defaultScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.4;
    _loadPrefsValues();

    if (context.watch<MenuNavBarProvider>().onScanner && !_isDetectDisable) {
      Utils.lockCurrentOrientation(context);
      _startScan();
    } else {
      _scannerController.stop();
      Utils.unlockCurrentOrientation();
    }
  }

  void _loadPrefsValues() async {
    final isPortrait = Utils.isPortrait(context);
    final double width = context.readPrefs.get(isPortrait
        ? PrefsEnum.scannerWindowWidthPortrait
        : PrefsEnum.scannerWindowWidthLandscape
    );
    final double height = context.readPrefs.get(isPortrait
        ? PrefsEnum.scannerWindowHeightPortrait
        : PrefsEnum.scannerWindowHeightLandscape
    );
    _zoomLevel = context.readPrefs.get(PrefsEnum.scannerZoomLevel);
    _scanWindow = Rect.fromCenter(
      center: _scanWindow.center,
      width: width >= 0 ? width : _defaultScanWindowSize,
      height: height >= 0 ? height : _defaultScanWindowSize,
    );
  }

  Future<void> _startScan() async {
    final cameraFacing = context.readPrefs.get(PrefsEnum.isUseFrontcamera) ? CameraFacing.front : CameraFacing.back;
    await _scannerController.start(cameraDirection: cameraFacing);
    await _scannerController.setZoomScale(_zoomLevel);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!_scannerController.value.isInitialized) return;
    if (state == AppLifecycleState.resumed &&
        context.read<MenuNavBarProvider>().onScanner && !_isDetectDisable
    ) {
      _scannerController.setZoomScale(_zoomLevel);
    }
  }

  Future<void> _scannerOnDetect(BarcodeCapture capture) async {
    if (_isDetectDisable) return;
    _isDetectDisable = true;
    final bool isContinuousScan = context.readPrefs.get(PrefsEnum.isContinuousScan);
    final bool isVibrateOnScan = context.readPrefs.get(PrefsEnum.isVibrateOnScan);
    final bool isBipOnScan = context.readPrefs.get(PrefsEnum.isBipOnScan);
    final bool isBarcodeCopied = context.readPrefs.get(PrefsEnum.isBarcodeCopied);
    final bool isScanAddHistory = context.readPrefs.get(PrefsEnum.isScanAddHistory);
    final bool isAutoOpenWebsite = context.readPrefs.get(PrefsEnum.isAutoOpenWebsite);

    final barcodeFormat = capture.barcodes.first.format;
    final String? contents = capture.barcodes.first.rawValue;
    if (contents==null || contents.isEmpty) {
      Utils.showToast(AppLocale.scanErrorLabel.s);
      _isDetectDisable = false;
      return;
    }
    if (isVibrateOnScan) Utils.deviceVibrate();
    if (isBipOnScan) Utils.audioPlayBeep(_audioPlayer);
    if (isBarcodeCopied) Clipboard.setData(ClipboardData(text: contents));
    final format = HistoryFormat.fromScannerFormat(barcodeFormat);
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
    if (isScanAddHistory) DatabaseServices.addItem(item, context);
    if (isContinuousScan) {
      Utils.showToast(item.contents);
      await Future<void>.delayed(const Duration(milliseconds: 800));
    } else if (isAutoOpenWebsite && item.type == HistoryType.website.name) {
      await Utils.openUrlInBrowser(item.contents);
      await Future<void>.delayed(const Duration(milliseconds: 1600));
    } else {
      await context.routeOf<PageItemView>().arguments(item).to();
    }
    _isDetectDisable = false;
  }

  void _updateScanWindow(double width, double height) {
    setState(() => _scanWindow = Rect.fromCenter(
      center: _scanWindow.center,
      width: width,
      height: height,
    ));
  }

  Future<void> _saveScanWindow() async {
    final isPortrait = Utils.isPortrait(context);
    context.readPrefs.update(isPortrait
        ? PrefsEnum.scannerWindowWidthPortrait
        : PrefsEnum.scannerWindowWidthLandscape,
      _scanWindow.width,
    );
    context.readPrefs.update(isPortrait
        ? PrefsEnum.scannerWindowHeightPortrait
        : PrefsEnum.scannerWindowHeightLandscape,
      _scanWindow.height,
    );
  }

  Future<void> _resetScanWindow() async {
    setState(() => _scanWindow = Rect.fromCenter(
      center: _scanWindow.center,
      width: _defaultScanWindowSize,
      height: _defaultScanWindowSize
    ));
    await _saveScanWindow();
  }

  Future<void> _goScanImage() async {
    _isDetectDisable = true;
    await context.routeOf<PageImageScan>()
        .arguments((PageImageScanArgs(controller: _scannerController)))
        .to();
    _isDetectDisable = false;
  }

  Future<void> _setZoomLevel(double zoomLevel) async {
    setState(() => _zoomLevel = zoomLevel);
    _scannerController.setZoomScale(zoomLevel);
  }

  Future<void> _saveZoomLevel(double zoomLevel) async {
    await context.readPrefs.update(PrefsEnum.scannerZoomLevel, zoomLevel);
  }

  @override
  Widget build(BuildContext context) {
    AppLocale.load(context);
    final isPortrait = Utils.isPortrait(context);
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              _scanWindow = Rect.fromCenter(
                center: Size(constraints.maxWidth, constraints.maxHeight).center(Offset.zero),
                width: _scanWindow.width,
                height: _scanWindow.height,
              );
              return Stack(
                fit: StackFit.expand,
                children: [
                  Transform.scale(
                    scaleX: context.readPrefs.get(PrefsEnum.isUseFrontcamera) ? -1 : 1,
                    child: MobileScanner(
                      scanWindow: _scanWindow,
                      controller: _scannerController,
                      errorBuilder: (context, error) => ScannerErrorWidget(error: error),
                      onDetect: _scannerOnDetect,
                    ),
                  ),
                  Transform.scale( //todo debug: 字體水平相反
                    scaleX: context.readPrefs.get(PrefsEnum.isUseFrontcamera) ? -1 : 1,
                    child: BarcodeOverlay( //todo debug: 套件該組件並沒有處理完轉向問題
                      controller: _scannerController,
                      boxFit: BoxFit.cover,
                      color: Theme.of(context).colorScheme.tertiary.withValues(alpha:0.5),
                    ),
                  ),
                  MyScanWindowOverlay(
                    controller: _scannerController,
                    scanWindow: _scanWindow,
                    onPanUpdate: _updateScanWindow,
                    onPanEnd: _saveScanWindow,
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: isPortrait ? Alignment.topLeft : Alignment.topRight,
            child: Card(
              margin: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(MaterialCommunityIcons.arrow_expand),
                onPressed: _resetScanWindow,
              ),
            ),
          ),
          Align(
            alignment: isPortrait ? Alignment.topRight : Alignment.bottomRight,
            child: Card(
              margin: const EdgeInsets.all(16.0),
              child: Flex(
                direction: isPortrait ? Axis.horizontal : Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlashlightButton(controller: _scannerController),
                  IconButton(
                    splashRadius: 16,
                    icon: const Icon(Icons.photo),
                    onPressed: _goScanImage,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: isPortrait ? Alignment.bottomCenter : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: isPortrait ? null : 100,
              height: isPortrait ? 100 : null,
              child: RotatedBox(
                quarterTurns: isPortrait ? 0 : 3,
                child: Slider(
                  value: _zoomLevel,
                  min: 0.0,
                  max: 1.0,
                  onChanged: _setZoomLevel,
                  onChangeEnd: _saveZoomLevel,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}