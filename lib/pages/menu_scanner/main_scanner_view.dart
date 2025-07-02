import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/menu_nav_bar.dart';
import 'package:watashi_qr/pages/menu_scanner/main_scanner_widgets.dart';
import 'package:watashi_qr/pages/menu_scanner/page_image_scan.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';

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
  final SharedPreferences _prefs = Utils.prefs;
  final _prefScanWindowWidthPortraitKey = PreferenceKey.scannerWindowWidthPortrait.name;
  final _prefScanWindowHeightPortraitKey = PreferenceKey.scannerWindowHeightPortrait.name;
  final _prefScanWindowWidthLandscapeKey = PreferenceKey.scannerWindowWidthLandscape.name;
  final _prefScanWindowHeightLandscapeKey = PreferenceKey.scannerWindowHeightLandscape.name;
  final _prefScanZoomLevelKey = PreferenceKey.scannerZoomLevel.name;
  late double _defaultScanWindowSize;
  late double _zoomLevel;
  Rect _scanWindow = Rect.zero;
  bool _isFlashOn = false;
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
    _defaultScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.375;
    _loadPrefsValues();
    if (context.watch<MenuNavBarProvider>().currentIndex == 0 && !_isDetectDisable) {
      Utils.lockCurrentOrientation(context);
      _startScan(context);
    } else {
      _scannerController.stop();
      Utils.unlockCurrentOrientation();
      setState(() => _isFlashOn = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        setState(() => _isFlashOn = false);
        break;
      case AppLifecycleState.resumed:
        if (context.read<MenuNavBarProvider>().currentIndex == 0
            && !_isDetectDisable) {
          _scannerController.setZoomScale(_zoomLevel);
        }
        break;
      case AppLifecycleState.inactive:
    }
  }

  void _loadPrefsValues() async {
    final isPortrait = Utils.isPortrait(context);
    final width = _prefs.getDouble(isPortrait
        ? _prefScanWindowWidthPortraitKey
        : _prefScanWindowWidthLandscapeKey)
        ?? _defaultScanWindowSize;
    final height = _prefs.getDouble(isPortrait
        ? _prefScanWindowHeightPortraitKey
        : _prefScanWindowHeightLandscapeKey)
        ?? _defaultScanWindowSize;
    _zoomLevel = _prefs.getDouble(_prefScanZoomLevelKey) ?? 0.0; // 0.0為預設值
    _scanWindow = Rect.fromCenter(
        center: _scanWindow.center,
        width: width,
        height: height
    );
  }

  Future<void> _startScan(BuildContext context) async {
    await _scannerController.start(
        cameraDirection: context.readSettings.isUseFrontcamera ? CameraFacing.front : CameraFacing.back
    );
    await _scannerController.setZoomScale(
        _prefs.getDouble(PreferenceKey.scannerZoomLevel.name) ?? 0.0
    );
  }

  Future<void> _scannerOnDetect(BarcodeCapture capture) async {
    if (_isDetectDisable) return;
    _isDetectDisable = true;
    await _scannerController.stop();
    setState(() => _isFlashOn = false);
    final barcodeFormat = capture.barcodes.first.format;
    final String? contents = capture.barcodes.first.rawValue;
    if (contents==null || contents.isEmpty) {
      Utils.showToast(Language.of(context).scanErrorLabel);
      _isDetectDisable = false;
      _startScan(context);
      return;
    }

    // 自動打開網站
    final bool isAutoOpenWebsite = context.readSettings.isAutoOpenWebsite;
    // 連續掃描
    final bool isContinuousScan = context.readSettings.isContinuousScan;
    // 掃描震動
    final bool isVibrateOnScan = context.readSettings.isVibrateOnScan;
    if (isVibrateOnScan) Utils.deviceVibrate();
    // 播放音效
    final bool isBipOnScan = context.readSettings.isBipOnScan;
    if (isBipOnScan) Utils.audioPlayBeep(_audioPlayer);
    // 複製到剪貼簿
    final bool isBarcodeCopied = context.readSettings.isBarcodeCopied;
    if (isBarcodeCopied) Clipboard.setData(ClipboardData(text: contents));

    final bool isScanAddHistory = context.readSettings.isScanAddHistory;
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
    if (isScanAddHistory) HiveService.addItem(item, context:context);

    if (isContinuousScan) {
      Utils.showToast(item.contents);
    } else if (isAutoOpenWebsite && item.type == HistoryType.website.name) {
      Utils.unlockCurrentOrientation();
      await Utils.openUrlInBrowser(item.contents);
      Utils.lockCurrentOrientation(context);
    } else {
      Utils.unlockCurrentOrientation();
      await context.routeOf<PageItemView>().arguments(item).to();
      Utils.lockCurrentOrientation(context);
    }
    _isDetectDisable = false;
    _startScan(context);
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
    await _prefs.setDouble(isPortrait
        ? _prefScanWindowWidthPortraitKey
        : _prefScanWindowWidthLandscapeKey, _scanWindow.width
    );
    await _prefs.setDouble(isPortrait
        ? _prefScanWindowHeightPortraitKey
        : _prefScanWindowHeightLandscapeKey, _scanWindow.height
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

  void _toggleFlash(){
    try {
      _scannerController.toggleTorch();
      setState(() => _isFlashOn = !_isFlashOn);
    } catch (e) {
      Utils.showToast('_toggleFlash: $e');
    }
  }

  Future<void> _goScanImage() async {
    _isDetectDisable = true;
    await _scannerController.stop();
    Utils.unlockCurrentOrientation();
    await context.routeOf<PageImageScan>()
        .arguments((PageImageScanArgs(controller: _scannerController)))
        .to();
    Utils.lockCurrentOrientation(context);
    _startScan(context);
    setState(() {
      _isFlashOn = false;
      _isDetectDisable = false;
    });
  }

  Future<void> _setZoomLevel(double zoomLevel) async {
    setState(() => _zoomLevel = zoomLevel);
    _scannerController.setZoomScale(zoomLevel);
  }

  Future<void> _saveZoomLevel(double zoomLevel) async {
    await _prefs.setDouble(_prefScanZoomLevelKey, zoomLevel);
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = Utils.isPortrait(context);

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final screenCenter = Size(constraints.maxWidth, constraints.maxHeight).center(Offset.zero);
              _scanWindow = Rect.fromCenter( // todo debug: 轉向時中心xy沒轉向
                center: screenCenter,
                width: _scanWindow.width,
                height: _scanWindow.height,
              );
              return const SizedBox.shrink();
            },
          ),
          Transform.scale(
            scaleX: context.readSettings.isUseFrontcamera ? -1 : 1,
            child: MobileScanner(
              scanWindow: _scanWindow,
              controller: _scannerController,
              errorBuilder: (context, error) => ScannerErrorWidget(error: error),
              onDetect: _scannerOnDetect,
            ),
          ),
          Transform.scale(
            scaleX: context.readSettings.isUseFrontcamera ? -1 : 1,
            child: BarcodeOverlay(
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
                  IconButton(
                    icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
                    onPressed: context.readSettings.isUseFrontcamera ? null : _toggleFlash,
                  ),
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