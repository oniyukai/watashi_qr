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
    detectionSpeed: .unrestricted,
    autoStart: false,
  );
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _enableDetect = true;
  bool _isLastTimeOnView = false;
  Rect _scanWindow = .zero;
  late double _zoomLevel = context.readPrefs.get(.scannerZoomLevel);
  late bool _isScreenRotation;
  late bool _isUseFrontCamera;
  late double _defaultScanWindowSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    _scannerController.dispose();
    _audioPlayer.dispose();
    _setOrientationLock(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewEntryExitEvent(context.watch<MenuNavBarProvider>().onScanner);
  }

  Future<void> _viewEntryExitEvent(bool onScanner) async {
    if (_enableDetect && onScanner) {
      _setOrientationLock(_isScreenRotation = context.readPrefs.get(.isScreenRotation));
      _loadOrientationLengthStartScan();
      _isLastTimeOnView = true;
    } else if (_isLastTimeOnView) {
      _scannerController.stop();
      _setOrientationLock(false);
      _isLastTimeOnView = false;
    }
  }

  Future<void> _loadOrientationLengthStartScan() async {
    final bool isPortrait = Utils.isPortrait(context);
    final double width = context.readPrefs.get(isPortrait
        ? .scannerWindowWidthPortrait
        : .scannerWindowWidthLandscape
    );
    final double height = context.readPrefs.get(isPortrait
        ? .scannerWindowHeightPortrait
        : .scannerWindowHeightLandscape
    );
    _defaultScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.4;
    _scanWindow = Rect.fromCenter(
      center: _scanWindow.center,
      width: width >= 0 ? width : _defaultScanWindowSize,
      height: height >= 0 ? height : _defaultScanWindowSize,
    );
    _isUseFrontCamera = context.readPrefs.get(.isUseFrontCamera);
    await _scannerController.start(cameraDirection: _isUseFrontCamera ? .front : .back);
    await _scannerController.setZoomScale(_zoomLevel);
  }

  Future<void> _setOrientationLock(bool toLock) async {
    if (toLock) {
      await Utils.lockCurrentOrientation(context);
    } else if (_isScreenRotation) {
      await Utils.unlockCurrentOrientation();
    }
  }

  @override
  void didChangeAppLifecycleState(state) {
    super.didChangeAppLifecycleState(state);
    if (!_scannerController.value.isInitialized) return;
    if (state == .resumed && _enableDetect && context.read<MenuNavBarProvider>().onScanner) {
      _scannerController.setZoomScale(_zoomLevel);
    }
  }

  Future<void> _scannerOnDetect(BarcodeCapture capture) async {
    if (!_enableDetect) return;
    _enableDetect = false;
    final bool isVibrateOnScan = context.readPrefs.get(.isVibrateOnScan);
    final bool isBipOnScan = context.readPrefs.get(.isBipOnScan);
    final bool isBarcodeCopied = context.readPrefs.get(.isBarcodeCopied);
    final bool isScanAddHistory = context.readPrefs.get(.isScanAddHistory);
    final bool isContinuousScan = context.readPrefs.get(.isContinuousScan);
    final bool isAutoOpenWebsite = context.readPrefs.get(.isAutoOpenWebsite);
    final BarcodeFormat scannerFormat = capture.barcodes.first.format;
    final String? contents = capture.barcodes.first.rawValue;
    if (contents == null || contents.isEmpty) {
      Utils.showToast(DictKey.scanErrorLabel.s);
      _enableDetect = true;
      return;
    }
    if (isVibrateOnScan) Utils.deviceVibrate();
    if (isBipOnScan) Utils.audioPlayBeep(_audioPlayer);
    if (isBarcodeCopied) Clipboard.setData(ClipboardData(text: contents));
    final HistoryFormat? format = HistoryFormat.fromScannerFormat(scannerFormat);
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
    if (isContinuousScan) {
      Utils.showToast(item.contents);
      await Future<void>.delayed(const Duration(milliseconds: 800));
    } else if (isAutoOpenWebsite && item.getType == .website) {
      await Utils.openUrlInBrowser(item.contents);
      await Future<void>.delayed(const Duration(milliseconds: 1600));
    } else {
      await context.routeOf<PageItemView>().toPass(item);
    }
    _enableDetect = true;
  }

  void _updateScanWindow(double width, double height) {
    setState(() => _scanWindow = Rect.fromCenter(
      center: _scanWindow.center,
      width: width,
      height: height,
    ));
  }

  Future<void> _saveScanWindow() async {
    final bool isPortrait = Utils.isPortrait(context);
    context.readPrefs.update(isPortrait
        ? .scannerWindowWidthPortrait
        : .scannerWindowWidthLandscape,
      _scanWindow.width, false,
    );
    await context.readPrefs.update(isPortrait
        ? .scannerWindowHeightPortrait
        : .scannerWindowHeightLandscape,
      _scanWindow.height, false,
    );
  }

  Future<void> _resetScanWindow() async {
    _updateScanWindow(_defaultScanWindowSize, _defaultScanWindowSize);
    await _saveScanWindow();
  }

  Future<void> _goPageImageScan() async {
    _viewEntryExitEvent(_enableDetect = false);
    await context.routeOf<PageImageScan>()
        .toPass((PageImageScanArgs(controller: _scannerController)));
    await _viewEntryExitEvent(_enableDetect = true);
  }

  Future<void> _setZoomLevel(double zoomLevel) async {
    setState(() => _zoomLevel = zoomLevel);
    await _scannerController.setZoomScale(zoomLevel);
  }

  Future<void> _saveZoomLevel(double zoomLevel) async {
    await context.readPrefs.update(.scannerZoomLevel, zoomLevel, false);
  }

  @override
  Widget build(context) {
    DictKey.load(context);
    final bool isPortrait = Utils.isPortrait(context);
    return SafeArea(
      child: Stack(
        fit: .expand,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              _scanWindow = Rect.fromCenter(
                center: Size(constraints.maxWidth, constraints.maxHeight).center(.zero),
                width: _scanWindow.width,
                height: _scanWindow.height,
              );
              return Stack(
                fit: .expand,
                children: [
                  Transform.scale(
                    scaleX: _isUseFrontCamera ? -1 : 1,
                    child: MobileScanner(
                      scanWindow: _scanWindow,
                      controller: _scannerController,
                      errorBuilder: scannerErrorBuilder,
                      onDetect: _scannerOnDetect,
                    ),
                  ),
                  Transform.scale( //todo debug: 字體水平相反
                    scaleX: _isUseFrontCamera ? -1 : 1,
                    child: BarcodeOverlay( //todo debug: 套件該組件並沒有處理完轉向問題 v7.1.4問題更嚴重了
                      controller: _scannerController,
                      boxFit: .cover,
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
            alignment: isPortrait ? .topLeft : .topRight,
            child: Card(
              margin: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(MaterialCommunityIcons.arrow_expand),
                onPressed: _resetScanWindow,
              ),
            ),
          ),
          Align(
            alignment: isPortrait ? .topRight : .bottomRight,
            child: Card(
              margin: const EdgeInsets.all(16.0),
              child: Flex(
                direction: isPortrait ? .horizontal : .vertical,
                mainAxisSize: .min,
                children: [
                  FlashlightButton(_scannerController),
                  IconButton(
                    splashRadius: 16,
                    icon: const Icon(Icons.photo),
                    onPressed: _goPageImageScan,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: isPortrait ? .bottomCenter : .centerLeft,
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
