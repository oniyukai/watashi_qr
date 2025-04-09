import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/locale/language.dart';

// 其實這個組件應該不會用到
class ScannerError extends StatelessWidget {
  const ScannerError({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = localeStr.cameraPermissionDenied; // 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error),
            ),
            Text(
              errorMessage,
            ),
            Text(
              error.errorDetails?.message ?? '',
            ),
          ],
        ),
      ),
    );
  }
}