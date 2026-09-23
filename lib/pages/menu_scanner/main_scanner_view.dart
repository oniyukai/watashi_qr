import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/common/database_services.dart';
import 'package:watashi_qr/common/prefs.dart';
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

class MainScannerView extends StatefulWidget {
  const MainScannerView({super.key});

  static (String?, BarcodeFormat) decodeCapture(BarcodeCapture capture) {
    final BarcodeBytes? rawBytes = capture.barcodes.first.rawDecodedBytes;
    String? rawValue = capture.barcodes.first.rawValue;
    if (rawValue?.trim().isNotEmpty ?? false) {
    } else if (rawBytes is DecodedBarcodeBytes) {
      rawValue = utf8.decode(rawBytes.bytes, allowMalformed: true);
    } else if (rawBytes is DecodedVisionBarcodeBytes &&
        rawBytes.bytes != null) {
      rawValue = utf8.decode(rawBytes.bytes!, allowMalformed: true);
    }
    return (rawValue, capture.barcodes.first.format);
  }

  @override
  State<MainScannerView> createState() => _MainScannerViewState();
}

class _MainScannerViewState extends State<MainScannerView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isOnViewPage = true;
  bool _isDetectBusy = false;
  bool _isOpenScanner = false;
  bool _isLockOrient = false;
  bool _isLastTimeOnView = false;
  Rect _scanWindow = Rect.zero;
  late double _zoomLevel = context.readPrefs.get(.scannerZoomLevel);
  late double _defaultScanWindowSize;
  MobileScannerController? _scannerController;

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
    _setOrientationLock(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewEntryExitEvent(
      context.watch<MenuNavBarProvider>().onScanner && _isOnViewPage,
    );
  }

  Future<void> _viewEntryExitEvent(bool onView) async {
    _setScanWindow();
    if (onView && !_isLastTimeOnView) {
      _isLastTimeOnView = true;
      final bool isLockOrient = context.readPrefs.get(.isLockOrient);
      _setScannerOpen(true);
      await _setOrientationLock(isLockOrient);
    } else if (!onView && _isLastTimeOnView) {
      _isLastTimeOnView = false;
      _setScannerOpen(false);
      await _setOrientationLock(false);
    }
  }

  void _setScanWindow() {
    final bool isPortrait = Utils.isPortrait(context);
    final double width = context.readPrefs.get(
      isPortrait ? .scannerWindowWidthPortrait : .scannerWindowWidthLandscape,
    );
    final double height = context.readPrefs.get(
      isPortrait ? .scannerWindowHeightPortrait : .scannerWindowHeightLandscape,
    );
    _defaultScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.4;
    _scanWindow = Rect.fromCenter(
      center: _scanWindow.center,
      width: width >= 0 ? width : _defaultScanWindowSize,
      height: height >= 0 ? height : _defaultScanWindowSize,
    );
  }

  void _setScannerOpen(bool toOpen) {
    if (_isOpenScanner == toOpen) return;
    _isOpenScanner = toOpen;
    if (mounted) setState(() {});
  }

  Future<void> _setOrientationLock(bool toLock) async {
    if (_isLockOrient == toLock) return;
    if (toLock) {
      await Utils.lockOrientation(
        context: context,
        orientation: (await NativeDeviceOrientationCommunicator().orientation())
            .deviceOrientation,
      );
    } else if (_isLockOrient) {
      await Utils.unlockOrientation();
    }
    _isLockOrient = toLock;
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isDetectBusy) return;
    _isDetectBusy = true;
    try {
      await _sendBarcode(MainScannerView.decodeCapture(capture));
    } catch (e) {
      Utils.showToast('${DictKey.analysisScanError.s} $e');
      await Future.delayed(const Duration(milliseconds: 1600));
    } finally {
      _isDetectBusy = false;
    }
  }

  Future<void> _sendBarcode((String?, BarcodeFormat) barcodeValue) async {
    final (rawValue, format) = barcodeValue;
    final bool isVibrateOnScan = context.readPrefs.get(.isVibrateOnScan);
    final bool isBipOnScan = context.readPrefs.get(.isBipOnScan);
    final bool isBarcodeCopied = context.readPrefs.get(.isBarcodeCopied);
    final bool isScanAddHistory = context.readPrefs.get(.isScanAddHistory);
    final bool isContinuousScan = context.readPrefs.get(.isContinuousScan);
    final bool isAutoOpenWebsite = context.readPrefs.get(.isAutoOpenWebsite);
    if (rawValue == null) throw Exception('rawValue == null.');
    if (rawValue.trim().isEmpty) throw Exception('rawValue is empty.');
    if (isVibrateOnScan) Utils.deviceVibrate();
    if (isBipOnScan) Utils.audioPlayBeep(_audioPlayer);
    if (isBarcodeCopied) Clipboard.setData(ClipboardData(text: rawValue));
    final HistoryFormat? historyFormat = HistoryFormat.fromScannerFormat(
      format,
    );
    final HistoryItem item = HistoryItem(
      unixTime: Utils.nowUnixTime,
      contents: rawValue,
      format: historyFormat?.name ?? format.name,
      type: HistoryType.fromDistinguish(historyFormat, rawValue).name,
      errorLevel: HistoryErrorLevel.none.name,
      origin: HistoryOrigin.S.name,
      isFavorite: false,
      notes: '',
    );
    if (isScanAddHistory) item.id = DatabaseServices.addItem(item);
    if (isContinuousScan) {
      Utils.showToast(item.contents);
      await Future.delayed(const Duration(milliseconds: 1600));
      return;
    }
    await _viewEntryExitEvent(_isOnViewPage = false);
    if (isAutoOpenWebsite && item.getType == HistoryType.website) {
      await Utils.openUrlInBrowser(item.contents);
      await Future.delayed(const Duration(milliseconds: 1600));
    } else {
      await context.routeOf<PageItemView>().toPass(item);
    }
    await _viewEntryExitEvent(_isOnViewPage = true);
  }

  void _updateScanWindow(double width, double height) {
    _scanWindow = Rect.fromCenter(
      center: _scanWindow.center,
      width: width,
      height: height,
    );
    setState(() {});
  }

  Future<void> _saveScanWindow() async {
    final bool isPortrait = Utils.isPortrait(context);
    await Future.wait([
      context.readPrefs.update(
        isPortrait ? .scannerWindowWidthPortrait : .scannerWindowWidthLandscape,
        _scanWindow.width,
        false,
      ),
      context.readPrefs.update(
        isPortrait
            ? .scannerWindowHeightPortrait
            : .scannerWindowHeightLandscape,
        _scanWindow.height,
        false,
      ),
    ]);
  }

  Future<void> _resetScanWindow() {
    _updateScanWindow(_defaultScanWindowSize, _defaultScanWindowSize);
    return _saveScanWindow();
  }

  Future<void> _goPageImageScan() async {
    await _viewEntryExitEvent(_isOnViewPage = false);
    await context.routeOf<PageImageScan>().toPass((PageImageScanArgs()));
    await _viewEntryExitEvent(_isOnViewPage = true);
  }

  Future<void> _setZoomLevel(double zoomLevel) async {
    setState(() => _zoomLevel = zoomLevel);
    await _scannerController?.setZoomScale(zoomLevel);
  }

  Future<void> _saveZoomLevel(double zoomLevel) {
    return context.readPrefs.update(.scannerZoomLevel, zoomLevel, false);
  }

  @override
  Widget build(BuildContext context) {
    DictKey.load(context);
    final bool isPortrait = Utils.isPortrait(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        _scanWindow = Rect.fromCenter(
          center: Size(
            constraints.maxWidth,
            constraints.maxHeight,
          ).center(Offset.zero),
          width: _scanWindow.width,
          height: _scanWindow.height,
        );
        return Stack(
          children: [
            if (_isOpenScanner)
              CameraWindow(
                scanWindow: _scanWindow,
                facing: context.readPrefs.get(.isUseFrontCamera)
                    ? CameraFacing.front
                    : CameraFacing.back,
                initialZoom: _zoomLevel,
                onDetect: _onDetect,
                onOpen: (controller) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() => _scannerController = controller);
                  });
                },
              ),
            if (_scannerController != null)
              MyScanWindowOverlay(
                controller: _scannerController!,
                scanWindow: _scanWindow,
                onPanUpdate: _updateScanWindow,
                onPanEnd: _saveScanWindow,
              ),
            Align(
              alignment: isPortrait
                  ? AlignmentGeometry.bottomCenter
                  : AlignmentGeometry.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(32.0),
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
            SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: isPortrait
                        ? AlignmentGeometry.topLeft
                        : AlignmentGeometry.topRight,
                    child: Card(
                      margin: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: const Icon(MaterialCommunityIcons.arrow_expand),
                        onPressed: _resetScanWindow,
                      ),
                    ),
                  ),
                  Align(
                    alignment: isPortrait
                        ? AlignmentGeometry.topRight
                        : AlignmentGeometry.bottomRight,
                    child: Card(
                      margin: const EdgeInsets.all(16.0),
                      child: Flex(
                        direction: isPortrait ? Axis.horizontal : Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_scannerController != null)
                            FlashlightButton(_scannerController!),
                          IconButton(
                            splashRadius: 16,
                            icon: const Icon(Icons.photo),
                            onPressed: _goPageImageScan,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
