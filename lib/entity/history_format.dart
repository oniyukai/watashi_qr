import 'package:flutter/material.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';
import 'package:barcode/barcode.dart';
import 'package:mobile_scanner/mobile_scanner.dart' show BarcodeFormat;

enum HistoryFormat { // !! 改變name會影響之後HistoryItem儲存的值
  qrCode(MyIconData(Icons.qr_code)),
  dataMatrix(MyIconData.dataMatrix),
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
    BarcodeFormat.qrCode: qrCode,
    BarcodeFormat.dataMatrix: dataMatrix,
    BarcodeFormat.aztec: aztec,
    BarcodeFormat.pdf417: pdf417,
    BarcodeFormat.ean13: ean13,
    BarcodeFormat.ean8: ean8,
    BarcodeFormat.upcA: upcA,
    BarcodeFormat.upcE: upcE,
    BarcodeFormat.code128: code128,
    BarcodeFormat.code93: code93,
    BarcodeFormat.code39: code39,
    BarcodeFormat.codebar: codebar,
    BarcodeFormat.itf: itf,
  }[barcodeFormat];

  static String localeStrFromName(String n, Language localeStr) => <HistoryFormat, String>{
    qrCode: localeStr.barcodeQrCodeLabel,
    dataMatrix: localeStr.barcodeDataMatrixLabel,
    aztec: localeStr.barcodeAztecLabel,
    pdf417: localeStr.barcodePdf417Label,
    ean13: localeStr.barcodeEan13Label,
    ean8: localeStr.barcodeEan8Label,
    upcA: localeStr.barcodeUpcALabel,
    upcE: localeStr.barcodeUpcELabel,
    code128: localeStr.barcodeCode128Label,
    code93: localeStr.barcodeCode93Label,
    code39: localeStr.barcodeCode39Label,
    codebar: localeStr.barcodeCodabarLabel,
    itf: localeStr.barcodeItfLabel,
  }[values.fromName(n)] ?? '"$n"';

  String composition(Language localeStr) => <HistoryFormat, String>{
    qrCode: localeStr.barcodeTextCompositionLabel,
    dataMatrix: localeStr.barcodeTextNoSpecialCompositionLabel,
    aztec: localeStr.barcodeTextNoSpecialCompositionLabel,
    pdf417: localeStr.barcodeTextCompositionLabel,
    ean13: localeStr.barcode12Digits1CheckCompositionLabel,
    ean8: localeStr.barcode7Digits1CheckCompositionLabel,
    upcA: localeStr.barcode11Digits1CheckCompositionLabel,
    upcE: localeStr.barcode7Digits1CheckCompositionLabel,
    code128: localeStr.barcodeTextNoSpecialCompositionLabel,
    code93: localeStr.barcodeTextUpperNoSpecialCompositionLabel,
    code39: localeStr.barcodeTextUpperNoSpecialCompositionLabel,
    codebar: localeStr.barcodeDigitsCompositionLabel,
    itf: localeStr.barcodeEvenDigitsCompositionLabel,
  }[this] ?? localeStr.barcodeTextCompositionLabel;

  String? description(Language localeStr) => <HistoryFormat, String>{
    ean13: localeStr.barcodeEan13DescriptionLabel,
    ean8: localeStr.barcodeEan8DescriptionLabel,
    upcA: localeStr.barcodeUpcADescriptionLabel,
    upcE: localeStr.barcodeUpcEDescriptionLabel,
    code128: localeStr.barcodeCode128DescriptionLabel,
    code93: localeStr.barcodeCode93DescriptionLabel,
    code39: localeStr.barcodeCode39DescriptionLabel,
    codebar: localeStr.barcodeCodabarDescriptionLabel,
    itf: localeStr.barcodeItfDescriptionLabel,
  }[this];
}