import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:flutter/services.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/menu_nav_bar.dart';
import 'package:watashi_qr/pages/menu_scanner/page_image_scan.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';

class MainScannerView extends StatefulWidget {
  const MainScannerView({super.key});

  @override
  State<MainScannerView> createState() => _MainScannerViewState();
}

class _MainScannerViewState extends State<MainScannerView> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SharedPreferences _prefs = Utils.prefs;
  final _prefScanWindowWidthPortraitKey = PreferenceKey.scannerWindowWidthPortrait.name;
  final _prefScanWindowHeightPortraitKey = PreferenceKey.scannerWindowHeightPortrait.name;
  final _prefScanWindowWidthLandscapeKey = PreferenceKey.scannerWindowWidthLandscape.name;
  final _prefScanWindowHeightLandscapeKey = PreferenceKey.scannerWindowHeightLandscape.name;
  final _prefScanZoomLevelKey = PreferenceKey.scannerZoomLevel.name;
  late double _zoomLevel;
  late double _minScanWindowSize;
  late double _maxScanWindowSize;
  late double _defaultScanWindowSize;
  late Size _screenSize;
  late Rect scanWindow;
  late double _scanWindowWidth;
  late double _scanWindowHeight;
  bool _isFlashOn = false;
  bool _isDetectDisable = false;
  bool _isPageInitialized = false;
  late Offset _initialPosition;
  late double _initialWidth;
  late double _initialHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _minScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.2;
    _maxScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.75;
    _defaultScanWindowSize = _maxScanWindowSize * 0.5;
    _loadPrefsValues();
    if (context.watch<MenuNavBarProvider>().currentIndex == 0 && !_isDetectDisable) {
      if (!_isPageInitialized) { // 關閉後開啟app偵測沒反應, 以下以修正該問題
        await Utils.mobileScannerController.start();
        await Utils.mobileScannerController.stop();
      }
      Utils.lockCurrentOrientation(context);
      Utils.mobileScannerControllerStart(context);
    } else {
      Utils.mobileScannerController.stop();
      Utils.unlockCurrentOrientation();
      _isFlashOn = false;
      setState(() {});
    }
    if (!_isPageInitialized) _isPageInitialized = true;
  }

  @override
  void dispose() {
    Utils.mobileScannerController.dispose();
    _audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _isFlashOn = false;
        setState((){});
        break;
      case AppLifecycleState.resumed:
        if (context.read<MenuNavBarProvider>().currentIndex == 0
            && !_isDetectDisable
            && _isPageInitialized) {
          Utils.mobileScannerController.setZoomScale(_zoomLevel);
        }
        break;
      case AppLifecycleState.inactive:
    }
  }

  Future<void> _loadPrefsValues() async {
    final isPortrait = Utils.isPortrait(context);
    setState(() {
      _zoomLevel = _prefs.getDouble(_prefScanZoomLevelKey) ?? 0.0; // 0.0為預設值
      _scanWindowWidth = _prefs.getDouble(isPortrait
          ? _prefScanWindowWidthPortraitKey
          : _prefScanWindowWidthLandscapeKey)
          ?? _defaultScanWindowSize;
      _scanWindowHeight = _prefs.getDouble(isPortrait
          ? _prefScanWindowHeightPortraitKey
          : _prefScanWindowHeightLandscapeKey)
          ?? _defaultScanWindowSize;
    });
  }

  Future<void> _saveZoomLevel(double zoomLevel) async {
    await _prefs.setDouble(_prefScanZoomLevelKey, zoomLevel);
  }

  Future<void> _saveScanWindow() async {
    final isPortrait = Utils.isPortrait(context);
    await _prefs.setDouble(isPortrait
        ? _prefScanWindowWidthPortraitKey
        : _prefScanWindowWidthLandscapeKey, _scanWindowWidth
    );
    await _prefs.setDouble(isPortrait
        ? _prefScanWindowHeightPortraitKey
        : _prefScanWindowHeightLandscapeKey, _scanWindowHeight
    );
    _updateScanWindow();
    setState(() {});
  }

  void _resetScanWindow() {
    setState(() {
      _scanWindowWidth = _defaultScanWindowSize;
      _scanWindowHeight = _defaultScanWindowSize;
    });
    _saveScanWindow();
  }

  void _updateScanWindow() {
    scanWindow = Rect.fromCenter(
      center: _screenSize.center(Offset.zero),
      width: _scanWindowWidth,
      height: _scanWindowHeight,
    );
  }

  void _toggleFlash() {
    try {
      Utils.mobileScannerController.toggleTorch();
    } catch (e) {
      Utils.showToast('_toggleFlash: $e');
    }
  }

  Future<void> _mobileScannerOnDetect(BarcodeCapture capture) async {
    if (_isDetectDisable) return;
    _isDetectDisable = true;
    await Utils.mobileScannerController.stop();
    setState(() {
      _isFlashOn = false;
    });
    final barcodeFormat = capture.barcodes.first.format;
    final String? contents = capture.barcodes.first.rawValue;
    if (contents==null || contents.isEmpty) {
      Utils.showToast(Language.of(context).scanErrorLabel);
      _isDetectDisable = false;
      Utils.mobileScannerControllerStart(context);
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
    Utils.mobileScannerControllerStart(context);
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
              _screenSize = Size(constraints.maxWidth, constraints.maxHeight);
              _updateScanWindow();
              return const SizedBox.shrink();
            },
          ),
          NativeDeviceOrientationReader(
            builder: (context) {
              NativeDeviceOrientation orientation = NativeDeviceOrientationReader.orientation(context);

              int rotationAngle = 0;
              switch (orientation) {
                case NativeDeviceOrientation.portraitUp:
                  rotationAngle = 0;
                  break;
                case NativeDeviceOrientation.portraitDown:
                  rotationAngle = 180;
                  break;
                case NativeDeviceOrientation.landscapeLeft:
                  rotationAngle = -90;
                  break;
                case NativeDeviceOrientation.landscapeRight:
                  rotationAngle = 90;
                  break;
                default:
                  rotationAngle = 0;
              }

              return Center(
                child: RotatedBox(
                  quarterTurns: rotationAngle ~/ 90,
                  child: MobileScanner(  // todo: updata mobile_scanner to v7.x.x with breaking changes
                    controller: Utils.mobileScannerController,
                    scanWindow: scanWindow,
                    errorBuilder: (context, error, child) => _ScannerError(error: error),
                    onDetect: (capture) => _mobileScannerOnDetect(capture),
                  ),
                ),
              );
            },
          ),
          _buildScannerOverlay(),
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
                    onPressed: () => setState(() {
                      _isFlashOn = !_isFlashOn;
                      _toggleFlash();
                    }),
                  ),
                  IconButton(
                    splashRadius: 16,
                    icon: const Icon(Icons.photo),
                    onPressed: () async {
                      _isDetectDisable = true;
                      await Utils.mobileScannerController.stop();
                      Utils.unlockCurrentOrientation();
                      await context.routeTo(PageImageScan);
                      Utils.lockCurrentOrientation(context);
                      Utils.mobileScannerControllerStart(context);
                      setState(() {
                        _isFlashOn = false;
                      });
                      _isDetectDisable = false;
                    },
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
                  onChanged: (double value) {
                    setState(() {
                      _zoomLevel = value;
                      Utils.mobileScannerController.setZoomScale(value);
                    });
                  },
                  onChangeEnd: (double value) => _saveZoomLevel(value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final cornerSize = 32.0; // 角落的大小
        final cornerThickness = 2.0; // 角落的粗細
        final maskColor = Colors.black54; // 半透明遮罩顏色
        final cornerColor = Theme.of(context).colorScheme.primary;
        return Stack(
          children: [
            // Top Mask
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: (screenHeight - _scanWindowHeight) / 2,
              child: Container(
                color: maskColor,
              ),
            ),
            // Left Mask
            Positioned(
              top: (screenHeight - _scanWindowHeight) / 2,
              left: 0,
              width: (screenWidth - _scanWindowWidth) / 2,
              height: _scanWindowHeight,
              child: Container(
                color: maskColor,
              ),
            ),
            // Right Mask
            Positioned(
              top: (screenHeight - _scanWindowHeight) / 2,
              right: 0,
              width: (screenWidth - _scanWindowWidth) / 2,
              height: _scanWindowHeight,
              child: Container(
                color: maskColor,
              ),
            ),
            // Bottom Mask
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: (screenHeight - _scanWindowHeight) / 2,
              child: Container(
                color: maskColor,
              ),
            ),
            // Top Left Corner
            Positioned(
              top: (screenHeight - _scanWindowHeight) / 2,
              left: (screenWidth - _scanWindowWidth) / 2,
              child: Container(
                width: cornerSize,
                height: cornerThickness,
                color: cornerColor,
              ),
            ),
            Positioned(
              top: (screenHeight - _scanWindowHeight) / 2,
              left: (screenWidth - _scanWindowWidth) / 2,
              child: Container(
                width: cornerThickness,
                height: cornerSize,
                color: cornerColor,
              ),
            ),
            // Top Right Corner
            Positioned(
              top: (screenHeight - _scanWindowHeight) / 2,
              right: (screenWidth - _scanWindowWidth) / 2,
              child: Container(
                width: cornerSize,
                height: cornerThickness,
                color: cornerColor,
              ),
            ),
            Positioned(
              top: (screenHeight - _scanWindowHeight) / 2,
              right: (screenWidth - _scanWindowWidth) / 2,
              child: Container(
                width: cornerThickness,
                height: cornerSize,
                color: cornerColor,
              ),
            ),
            // Bottom Left Corner
            Positioned(
              bottom: (screenHeight - _scanWindowHeight) / 2,
              left: (screenWidth - _scanWindowWidth) / 2,
              child: Container(
                width: cornerSize,
                height: cornerThickness,
                color: cornerColor,
              ),
            ),
            Positioned(
              bottom: (screenHeight - _scanWindowHeight) / 2,
              left: (screenWidth - _scanWindowWidth) / 2,
              child: Container(
                width: cornerThickness,
                height: cornerSize,
                color: cornerColor,
              ),
            ),
            // Bottom Right Corner
            Positioned(
              bottom: (screenHeight - _scanWindowHeight) / 2,
              right: (screenWidth - _scanWindowWidth) / 2,
              child: Container(
                width: cornerSize,
                height: cornerThickness,
                color: cornerColor,
              ),
            ),
            Positioned(
              bottom: (screenHeight - _scanWindowHeight) / 2,
              right: (screenWidth - _scanWindowWidth) / 2,
              child: Container(
                width: cornerThickness,
                height: cornerSize,
                color: cornerColor,
              ),
            ),
            // Draggable Icon
            Positioned(
              bottom: (screenHeight - _scanWindowHeight) / 2,
              right: (screenWidth - _scanWindowWidth) / 2,
              child: GestureDetector(
                onPanStart: (details) {
                  _initialWidth = _scanWindowWidth;
                  _initialHeight = _scanWindowHeight;
                  _initialPosition = details.globalPosition;
                },
                onPanUpdate: (details) {
                  final double widthDelta = (details.globalPosition.dx - _initialPosition.dx) * 2;
                  final double heightDelta = (details.globalPosition.dy - _initialPosition.dy) * 2;

                  setState(() {
                    _scanWindowWidth = (_initialWidth + widthDelta).clamp(_minScanWindowSize, _maxScanWindowSize);
                    _scanWindowHeight = (_initialHeight + heightDelta).clamp(_minScanWindowSize, _maxScanWindowSize);
                    _updateScanWindow(); // 更新 scanWindow 的位置
                  });
                },
                onPanEnd: (details) => _saveScanWindow(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      MaterialCommunityIcons.arrow_expand,
                      color: cornerColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.error});
  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final String errorMessage = switch (error.errorCode) {
      MobileScannerErrorCode.controllerUninitialized => 'Controller not ready.',
      MobileScannerErrorCode.permissionDenied => Language.of(context).cameraPermissionDenied,
      MobileScannerErrorCode.unsupported => 'Scanning is unsupported on this device',
      _ => 'Generic Error',
    };

    return Center(
      child: Text('$errorMessage\n\n${error.errorDetails?.message ?? ''}'),
    );
  }
}