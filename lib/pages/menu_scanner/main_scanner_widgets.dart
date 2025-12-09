import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/locale/app_language.dart';

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({required this.error, super.key});
  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final String errorMessage = switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied => AppLocale.cameraPermissionDenied.s,
      _ => error.errorCode.message,
    };

    return Center(
      child: Text('$errorMessage\n\n${error.errorDetails?.message ?? ''}'),
    );
  }
}


class FlashlightButton extends StatelessWidget {
  const FlashlightButton({required this.controller, super.key});
  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        final IconData iconData = switch (state.torchState) {
          TorchState.auto => Icons.flash_auto,
          TorchState.on => Icons.flash_on,
          _ => Icons.flash_off,
        };
        final void Function()? onPressed = (
            !state.isInitialized ||
            !state.isRunning ||
            state.torchState == TorchState.unavailable
        ) ? null : controller.toggleTorch;

        return IconButton(
          icon: Icon(iconData),
          onPressed: onPressed,
        );
      },
    );
  }
}


class MyScanWindowOverlay extends StatefulWidget {
  const MyScanWindowOverlay({
    super.key,
    required this.controller,
    required this.scanWindow,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  final MobileScannerController controller;
  final Rect scanWindow;
  final void Function(double width, double height) onPanUpdate; //Function請使用setState()來更新scanWindow
  final void Function() onPanEnd;

  @override
  State<MyScanWindowOverlay> createState() => _MyScanWindowOverlayState();
}

class _MyScanWindowOverlayState extends State<MyScanWindowOverlay> {
  late double _initialWidth;
  late double _initialHeight;
  late Offset _initialPosition;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        if (widget.scanWindow.isEmpty ||
            widget.scanWindow.isInfinite ||
            !value.isInitialized ||
            !value.isRunning ||
            value.error != null ||
            value.size.isEmpty) {
          return const SizedBox.shrink();
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double screenWidth = constraints.maxWidth;
            final double screenHeight = constraints.maxHeight;
            final double scanWindowWidth = widget.scanWindow.width;
            final double scanWindowHeight = widget.scanWindow.height;
            final double minScanWindowSize = MediaQuery.of(context).size.shortestSide * 0.175;
            final double maxScanWindowSize = min(screenWidth, screenHeight) * 0.85;
            final Color overlayColor = Colors.black54; // 遮罩顏色
            final Color cornerColor = Theme.of(context).colorScheme.primary; // 角落顏色
            final double cornerSize = 32.0; // 角落大小
            final double cornerWidth = 2.0; // 角落粗細

            return Stack(
              children: [
                ScanWindowOverlay(
                  controller: widget.controller,
                  scanWindow: widget.scanWindow,
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  color: overlayColor,
                ),
                // Top Left Corner
                Positioned(
                  top: (screenHeight - scanWindowHeight) / 2,
                  left: (screenWidth - scanWindowWidth) / 2,
                  child: Container(
                    width: cornerSize,
                    height: cornerWidth,
                    color: cornerColor,
                  ),
                ),
                Positioned(
                  top: (screenHeight - scanWindowHeight) / 2,
                  left: (screenWidth - scanWindowWidth) / 2,
                  child: Container(
                    width: cornerWidth,
                    height: cornerSize,
                    color: cornerColor,
                  ),
                ),
                // Top Right Corner
                Positioned(
                  top: (screenHeight - scanWindowHeight) / 2,
                  right: (screenWidth - scanWindowWidth) / 2,
                  child: Container(
                    width: cornerSize,
                    height: cornerWidth,
                    color: cornerColor,
                  ),
                ),
                Positioned(
                  top: (screenHeight - scanWindowHeight) / 2,
                  right: (screenWidth - scanWindowWidth) / 2,
                  child: Container(
                    width: cornerWidth,
                    height: cornerSize,
                    color: cornerColor,
                  ),
                ),
                // Bottom Left Corner
                Positioned(
                  bottom: (screenHeight - scanWindowHeight) / 2,
                  left: (screenWidth - scanWindowWidth) / 2,
                  child: Container(
                    width: cornerSize,
                    height: cornerWidth,
                    color: cornerColor,
                  ),
                ),
                Positioned(
                  bottom: (screenHeight - scanWindowHeight) / 2,
                  left: (screenWidth - scanWindowWidth) / 2,
                  child: Container(
                    width: cornerWidth,
                    height: cornerSize,
                    color: cornerColor,
                  ),
                ),
                // Bottom Right Corner
                Positioned(
                  bottom: (screenHeight - scanWindowHeight) / 2,
                  right: (screenWidth - scanWindowWidth) / 2,
                  child: Container(
                    width: cornerSize,
                    height: cornerWidth,
                    color: cornerColor,
                  ),
                ),
                Positioned(
                  bottom: (screenHeight - scanWindowHeight) / 2,
                  right: (screenWidth - scanWindowWidth) / 2,
                  child: Container(
                    width: cornerWidth,
                    height: cornerSize,
                    color: cornerColor,
                  ),
                ),
                // Draggable Icon
                Positioned(
                  bottom: (screenHeight - scanWindowHeight) / 2,
                  right: (screenWidth - scanWindowWidth) / 2,
                  child: GestureDetector(
                    onPanStart: (details) {
                      _initialWidth = scanWindowWidth;
                      _initialHeight = scanWindowHeight;
                      _initialPosition = details.globalPosition;
                    },
                    onPanUpdate: (details) {
                      final double widthDelta = (details.globalPosition.dx - _initialPosition.dx) * 2;
                      final double heightDelta = (details.globalPosition.dy - _initialPosition.dy) * 2;
                      final double width = (_initialWidth + widthDelta).clamp(minScanWindowSize, maxScanWindowSize);
                      final double height = (_initialHeight + heightDelta).clamp(minScanWindowSize, maxScanWindowSize);
                      widget.onPanUpdate(width, height);
                    },
                    onPanEnd: (details) => widget.onPanEnd(),
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
      },
    );
  }
}
