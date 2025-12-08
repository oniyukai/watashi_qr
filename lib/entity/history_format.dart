import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';
import 'package:barcode/barcode.dart';
import 'package:mobile_scanner/mobile_scanner.dart' show BarcodeFormat;

enum HistoryFormat { // !! 改變name會影響之後HistoryItem儲存的值
  qrCode(MyIconData(Icons.qr_code)),
  dataMatrix(MyIconData(MaterialCommunityIcons.data_matrix)),
  aztec(MyIconData.aztec),
  pdf417(MyIconData.pdf417),
  ean13(MyIconData.barcode),
  ean8(MyIconData.barcode),
  upcA(MyIconData.barcode),
  upcE(MyIconData.barcode),
  code128(MyIconData.barcode),
  code93(MyIconData.barcode),
  code39(MyIconData.barcode),
  codebar(MyIconData.barcode),
  itf(MyIconData.barcode);

  const HistoryFormat(this.myIconData);

  final MyIconData myIconData;

  Barcode Function() get barcodeFunc => switch (this) {
    qrCode => Barcode.qrCode,
    aztec => Barcode.aztec,
    dataMatrix=> Barcode.dataMatrix,
    pdf417 => Barcode.pdf417,
    ean13 => Barcode.ean13,
    ean8 => Barcode.ean8,
    upcA => Barcode.upcA,
    upcE => Barcode.upcE,
    code128 => Barcode.code128,
    code93 => Barcode.code93,
    code39 => Barcode.code39,
    codebar => Barcode.codabar,
    itf => Barcode.itf,
  };

  static HistoryFormat? fromScannerFormat(BarcodeFormat barcodeFormat) => const <BarcodeFormat, HistoryFormat>{
    .qrCode: qrCode,
    .dataMatrix: dataMatrix,
    .aztec: aztec,
    .pdf417: pdf417,
    .ean13: ean13,
    .ean8: ean8,
    .upcA: upcA,
    .upcE: upcE,
    .code128: code128,
    .code93: code93,
    .code39: code39,
    .codebar: codebar,
    .itf: itf,
  }[barcodeFormat];

  static String localeStrFromName(String n) => <HistoryFormat, String>{
    qrCode: AppLocale.barcodeQrCodeLabel.s,
    dataMatrix: AppLocale.barcodeDataMatrixLabel.s,
    aztec: AppLocale.barcodeAztecLabel.s,
    pdf417: AppLocale.barcodePdf417Label.s,
    ean13: AppLocale.barcodeEan13Label.s,
    ean8: AppLocale.barcodeEan8Label.s,
    upcA: AppLocale.barcodeUpcALabel.s,
    upcE: AppLocale.barcodeUpcELabel.s,
    code128: AppLocale.barcodeCode128Label.s,
    code93: AppLocale.barcodeCode93Label.s,
    code39: AppLocale.barcodeCode39Label.s,
    codebar: AppLocale.barcodeCodabarLabel.s,
    itf: AppLocale.barcodeItfLabel.s,
  }[values.fromName(n)] ?? '"$n"';

  String get composition => switch (this) {
    qrCode => AppLocale.barcodeTextCompositionLabel.s,
    dataMatrix => AppLocale.barcodeTextNoSpecialCompositionLabel.s,
    aztec => AppLocale.barcodeTextNoSpecialCompositionLabel.s,
    pdf417 => AppLocale.barcodeTextCompositionLabel.s,
    ean13 => AppLocale.barcode12Digits1CheckCompositionLabel.s,
    ean8 => AppLocale.barcode7Digits1CheckCompositionLabel.s,
    upcA => AppLocale.barcode11Digits1CheckCompositionLabel.s,
    upcE => AppLocale.barcode7Digits1CheckCompositionLabel.s,
    code128 => AppLocale.barcodeTextNoSpecialCompositionLabel.s,
    code93 => AppLocale.barcodeTextUpperNoSpecialCompositionLabel.s,
    code39 => AppLocale.barcodeTextUpperNoSpecialCompositionLabel.s,
    codebar => AppLocale.barcodeDigitsCompositionLabel.s,
    itf => AppLocale.barcodeEvenDigitsCompositionLabel.s,
  };

  String? get description => <HistoryFormat, String>{
    ean13: AppLocale.barcodeEan13DescriptionLabel.s,
    ean8: AppLocale.barcodeEan8DescriptionLabel.s,
    upcA: AppLocale.barcodeUpcADescriptionLabel.s,
    upcE: AppLocale.barcodeUpcEDescriptionLabel.s,
    code128: AppLocale.barcodeCode128DescriptionLabel.s,
    code93: AppLocale.barcodeCode93DescriptionLabel.s,
    code39: AppLocale.barcodeCode39DescriptionLabel.s,
    codebar: AppLocale.barcodeCodabarDescriptionLabel.s,
    itf: AppLocale.barcodeItfDescriptionLabel.s,
  }[this];
}