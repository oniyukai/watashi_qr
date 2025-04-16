import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/pages/menu_history/item_view.dart';
import 'package:flutter/services.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/pages/menu_scanner/scan_image_page.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';

class MainScannerPage extends StatefulWidget {
  const MainScannerPage({super.key});

  @override
  State<MainScannerPage> createState() => _MainScannerPageState();
}

class _MainScannerPageState extends State<MainScannerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SharedPreferences _prefs = Utils.prefs;
  final _prefScanWindowWidthPortraitKey = PreferenceKey.scannerWindowWidthPortrait.name;
  final _prefScanWindowHeightPortraitKey = PreferenceKey.scannerWindowHeightPortrait.name;
  final _prefScanWindowWidthLandscapeKey = PreferenceKey.scannerWindowWidthLandscape.name;
  final _prefScanWindowHeightLandscapeKey = PreferenceKey.scannerWindowHeightLandscape.name;
  final _prefScanZoomLevelKey = PreferenceKey.scannerZoomLevel.name;
  late MobileScannerController _mobileScannerController;
  late bool _isUseFrontcamera;
  late double _zoomLevel;
  late double _minScanWindowSize;
  late double _maxScanWindowSize;
  late double _defaultScanWindowSize;
  late Size _screenSize;
  late Rect scanWindow;
  late double _scanWindowWidth;
  late double _scanWindowHeight;
  bool _isFlashOn = false;
  bool _isOnDetecting = false;
  late Offset _initialPosition;
  late double _initialWidth;
  late double _initialHeight;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Utils.lockCurrentOrientation(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _minScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.2;
    _maxScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.75;
    _defaultScanWindowSize = _maxScanWindowSize * 0.5;
    _isUseFrontcamera = context.settingsProvider.isUseFrontcamera;
    _loadPrefsValues();
    _initializeScanner();
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

  Future<void> _initializeScanner() async {
    try {
      _mobileScannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.unrestricted,
        facing: _isUseFrontcamera ? CameraFacing.front : CameraFacing.back,
        torchEnabled: _isFlashOn,
      );
      // _mobileScannerController.setZoomScale(_zoomLevel); // todo debug: Controller uninitialize

      setState(() {});
    } catch (e) {
      Utils.showToast('_initializeScanner: $e');
    }
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
      _mobileScannerController.toggleTorch();
    } catch (e) {
      Utils.showToast('_toggleFlash: $e');
    }
  }

  Future<void> _mobileScannerOnDetect(BarcodeCapture capture) async {
    if (_isOnDetecting) return;
    _isOnDetecting = true;
    await _mobileScannerController.stop();
    _isFlashOn = false;
    final barcodeFormat = capture.barcodes.first.format;
    final String? contents = capture.barcodes.first.rawValue;
    if (contents==null || contents.isEmpty) {
      Utils.showToast(Language.of(context).scanErrorLabel);
      _isOnDetecting = false;
      _mobileScannerController.start();
      return;
    }

    // 自動打開網站
    final bool isAutoOpenWebsite = context.settingsProvider.isAutoOpenWebsite;
    // 連續掃描
    final bool isContinuousScan = context.settingsProvider.isContinuousScan;
    // 掃描震動
    final bool isVibrateOnScan = context.settingsProvider.isVibrateOnScan;
    if (isVibrateOnScan) Utils.deviceVibrate();
    // 播放音效
    final bool isBipOnScan = context.settingsProvider.isBipOnScan;
    if (isBipOnScan) Utils.audioPlayBeep(_audioPlayer);
    // 複製到剪貼簿
    final bool isBarcodeCopied = context.settingsProvider.isBarcodeCopied;
    if (isBarcodeCopied) Clipboard.setData(ClipboardData(text: contents));

    final bool isScanAddHistory = context.settingsProvider.isScanAddHistory;
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
      await context.routeOf<ItemView>().arguments(item).to();
      Utils.lockCurrentOrientation(context);
    }
    _isOnDetecting = false;
    _mobileScannerController.start();
  }

  @override
  void dispose() {
    _mobileScannerController.dispose();
    _audioPlayer.dispose();
    Utils.unlockCurrentOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = Utils.isPortrait(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(MaterialCommunityIcons.arrow_expand),
          onPressed: _resetScanWindow,
        ),
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
                _toggleFlash();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () async {
              await _mobileScannerController.stop();
              _isFlashOn = false;
              Utils.unlockCurrentOrientation();
              await context.routeTo(ScanImagePage);
              Utils.lockCurrentOrientation(context);
              _mobileScannerController.start();
            },
          ),
        ],
      ),
      body: Stack(
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
                  child: MobileScanner(
                    controller: _mobileScannerController,
                    scanWindow: scanWindow,
                    errorBuilder: (context, error, child) => ScannerError(error: error),
                    onDetect: (capture) => _mobileScannerOnDetect(capture),
                  ),
                ),
              );
            },
          ),
          _buildScannerOverlay(),
          Align(
            alignment: isPortrait ? Alignment.bottomCenter : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: isPortrait ? 64 : null,
                width: isPortrait ? null : 64,
                child: RotatedBox(
                  quarterTurns: isPortrait ? 0 : 3,
                  child: Slider(
                    value: _zoomLevel,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (double value) {
                      setState(() {
                        _zoomLevel = value;
                        _mobileScannerController.setZoomScale(value);
                      });
                    },
                    onChangeEnd: (double value) => _saveZoomLevel(value),
                  ),
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
                  double widthDelta = (details.globalPosition.dx - _initialPosition.dx) * 2;
                  double heightDelta = (details.globalPosition.dy - _initialPosition.dy) * 2;

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

class ScannerError extends StatelessWidget {
  const ScannerError({super.key, required this.error});
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