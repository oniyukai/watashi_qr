import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/locale/app_language.dart';

Widget scannerErrorBuilder(BuildContext context, MobileScannerException error) {
  final String errorMessage = switch (error.errorCode) {
    .permissionDenied => AppLocale.cameraPermissionDenied.s,
    _ => error.errorCode.message,
  };
  return Center(
    child: Text('$errorMessage\n\n${error.errorDetails?.message ?? ''}'),
  );
}


class FlashlightButton extends StatelessWidget {
  final MobileScannerController controller;

  const FlashlightButton({required this.controller, super.key});

  @override
  Widget build(context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        final IconData iconData = switch (state.torchState) {
          .auto => Icons.flash_auto,
          .on => Icons.flash_on,
          .off => Icons.flash_off,
          .unavailable => Icons.no_flash,
        };
        final Future<void> Function()? onPressed = (
            state.isInitialized &&
            state.isRunning &&
            state.torchState != .unavailable
        ) ? controller.toggleTorch : null;
        return IconButton(
          icon: Icon(iconData),
          onPressed: onPressed,
        );
      },
    );
  }
}


class MyScanWindowOverlay extends StatefulWidget {
  final MobileScannerController controller;
  final Rect scanWindow;
  final void Function(double width, double height) onPanUpdate; //Function請使用setState()來更新scanWindow
  final VoidCallback onPanEnd;

  const MyScanWindowOverlay({
    super.key,
    required this.controller,
    required this.scanWindow,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  State<MyScanWindowOverlay> createState() => _MyScanWindowOverlayState();
}

class _MyScanWindowOverlayState extends State<MyScanWindowOverlay> {
  late double _startWidth;
  late double _startHeight;
  late Offset _startPosition;

  @override
  Widget build(context) {
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
          builder: (context, constraints) {
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
                // Darker Surrounding Mask
                ScanWindowOverlay(
                  controller: widget.controller,
                  scanWindow: widget.scanWindow,
                  borderColor: Colors.transparent,
                  borderWidth: 0.0,
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
                      _startWidth = scanWindowWidth;
                      _startHeight = scanWindowHeight;
                      _startPosition = details.globalPosition;
                    },
                    onPanUpdate: (details) {
                      final double widthDelta = (details.globalPosition.dx - _startPosition.dx) * 2;
                      final double heightDelta = (details.globalPosition.dy - _startPosition.dy) * 2;
                      final double width = (_startWidth + widthDelta).clamp(minScanWindowSize, maxScanWindowSize);
                      final double height = (_startHeight + heightDelta).clamp(minScanWindowSize, maxScanWindowSize);
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
