import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/common/hive_storage.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/pages/menu_history/item_view.dart';
import 'package:flutter/services.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_scanner/scan_image_page.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:watashi_qr/pages/widgets/scanner_error.dart';

class MainScannerPage extends StatefulWidget {
  const MainScannerPage({super.key});

  @override
  State<MainScannerPage> createState() => _MainScannerPageState();
}

class _MainScannerPageState extends State<MainScannerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  static const String _prefScanWindowWidthPortraitKey = 'scan_window_width_portrait';
  static const String _prefScanWindowHeightPortraitKey = 'scan_window_height_portrait';
  static const String _prefScanWindowWidthLandscapeKey = 'scan_window_width_landscape';
  static const String _prefScanWindowHeightLandscapeKey = 'scan_window_height_landscape';
  static const String _prefZoomLevelKey = 'zoom_level';
  bool _isFlashOn = false;
  bool _hasCameraPermission = false;
  bool _isOnDetecting = false;
  late MobileScannerController _mobileScannerController;
  late bool _isFrontCamera;
  late double _zoomLevel;
  late double _minScanWindowSize;
  late double _maxScanWindowSize;
  late double _defaultScanWindowSize;
  Offset _initialPosition = Offset.zero;
  Rect scanWindow = Rect.zero;
  late Size _screenSize;
  late double _scanWindowWidth;
  late double _scanWindowHeight;
  late double _initialWidth;
  late double _initialHeight;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SettingsProvider>().loadSettings(); // 首頁載入時等下load
      Utils.lockCurrentOrientation(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _minScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.2;
    _maxScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.75;
    _defaultScanWindowSize = _maxScanWindowSize * 0.5;
    _isFrontCamera = context.read<SettingsProvider>().isUseFrontcameraEnabled;
    _loadZoomLevel();
    _loadScanWindow();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    setState(() {
      _hasCameraPermission = status.isGranted;
    });

    if (!_hasCameraPermission) {
      _requestCameraPermission();
    } else {
      _initializeScanner();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasCameraPermission = status.isGranted;
    });
    if (_hasCameraPermission) _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    try {
      _mobileScannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.unrestricted,
        facing: _isFrontCamera ? CameraFacing.front : CameraFacing.back,
        torchEnabled: _isFlashOn,
      );
      _mobileScannerController.setZoomScale(_zoomLevel); // todo debug: 進入時並沒有載入

      setState(() {});
    } catch (e) {
      Utils.showToast('_initializeCamera: $e');
    }
  }

  Future<void> _loadZoomLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _zoomLevel = prefs.getDouble(_prefZoomLevelKey) ?? 0.0; // 0.0為預設值
    });
  }

  Future<void> _saveZoomLevel(double zoomLevel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefZoomLevelKey, zoomLevel);
  }

  Future<void> _loadScanWindow() async {
    final prefs = await SharedPreferences.getInstance();
    final isPortrait = Utils.isPortrait(context);
    _scanWindowWidth = prefs.getDouble(isPortrait
        ? _prefScanWindowWidthPortraitKey
        : _prefScanWindowWidthLandscapeKey)
        ?? _defaultScanWindowSize;
    _scanWindowHeight = prefs.getDouble(isPortrait
        ? _prefScanWindowHeightPortraitKey
        : _prefScanWindowHeightLandscapeKey)
        ?? _defaultScanWindowSize;
    _updateScanWindow();
    setState(() {});
  }

  Future<void> _saveScanWindow() async {
    final prefs = await SharedPreferences.getInstance();
    final isPortrait = Utils.isPortrait(context);
    await prefs.setDouble(isPortrait
        ? _prefScanWindowWidthPortraitKey
        : _prefScanWindowWidthLandscapeKey, _scanWindowWidth
    );
    await prefs.setDouble(isPortrait
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
    if (contents==null || contents.isEmpty) return;

    // 自動打開網站
    final bool isAutoOpenWebsiteEnabled = context.read<SettingsProvider>().isAutoOpenWebsiteEnabled;
    // 連續掃描
    final bool isContinuousScanEnabled = context.read<SettingsProvider>().isContinuousScanEnabled;
    // 掃描震動
    final bool isVibrateOnScan = context.read<SettingsProvider>().isVibrateOnScan;
    if (isVibrateOnScan) Utils.deviceVibrate();
    // 播放音效
    final bool isBipOnScan = context.read<SettingsProvider>().isBipOnScan;
    if (isBipOnScan) Utils.audioPlayBeep(_audioPlayer);
    // 複製到剪貼簿
    final bool isBarcodeCopiedEnabled = context.read<SettingsProvider>().isBarcodeCopiedEnabled;
    if (isBarcodeCopiedEnabled) Clipboard.setData(ClipboardData(text: contents));

    final bool isHistoryEnabled = context.read<SettingsProvider>().isHistoryEnabled;
    final formatName = Utils.formatMobileScannerType(barcodeFormat);
    final HistoryItem item = HistoryItem(
      unixTime: Utils.getNowUnixTime(),
      contents: contents,
      formatName: formatName,
      type: Utils.determineType(formatName, contents),
      errorCorrectionLevel: 'NONE',
      origin: 'S',
      isFavorite: false,
      notes: '',
    );
    if (isHistoryEnabled) HiveStorage.addItem(item, context:context);

    if (isContinuousScanEnabled) {
      Utils.showToast(item.contents);
    } else if (isAutoOpenWebsiteEnabled && item.type == 'WEBSITE') {
      Utils.unlockCurrentOrientation();
      await Utils.openUrlInBrowser(item.contents);
      Utils.lockCurrentOrientation(context);
    } else {
      Utils.unlockCurrentOrientation();
      await context.routeOf<ItemView>().arguments(item).to();
      Utils.lockCurrentOrientation(context);
    }
    _isOnDetecting = false;
    await _mobileScannerController.start();
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
    final localeStr = Language.of(context)!;
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
              await _mobileScannerController.start();
            },
          ),
        ],
      ),
      body: _hasCameraPermission
          ? Stack(
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

              // 設定旋轉角度
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
      )
          : Center(child: Text(localeStr.cameraPermissionDenied)),
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
