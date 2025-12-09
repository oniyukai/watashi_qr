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
  aztec(.aztec),
  pdf417(.pdf417),
  ean13(.barcode),
  ean8(.barcode),
  upcA(.barcode),
  upcE(.barcode),
  code128(.barcode),
  code93(.barcode),
  code39(.barcode),
  codabar(.barcode),
  itf(.barcode);

  const HistoryFormat(this.myIconData);

  final MyIconData myIconData;

  ValueGetter<Barcode> get barcodeFunc => switch (this) {
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
    codabar => Barcode.codabar,
    itf => Barcode.itf,
  };

  static HistoryFormat? fromScannerFormat(BarcodeFormat barcodeFormat) => switch (barcodeFormat) {
    .qrCode => qrCode,
    .dataMatrix => dataMatrix,
    .aztec => aztec,
    .pdf417 => pdf417,
    .ean13 => ean13,
    .ean8 => ean8,
    .upcA => upcA,
    .upcE => upcE,
    .code128 => code128,
    .code93 => code93,
    .code39 => code39,
    .codabar => codabar,
    .itf => itf,
    .unknown || .all => null,
  };

  static String localeStrFromName(String n) => switch (values.fromName(n)) {
    qrCode => AppLocale.barcodeQrCodeLabel,
    dataMatrix => AppLocale.barcodeDataMatrixLabel,
    aztec => AppLocale.barcodeAztecLabel,
    pdf417 => AppLocale.barcodePdf417Label,
    ean13 => AppLocale.barcodeEan13Label,
    ean8 => AppLocale.barcodeEan8Label,
    upcA => AppLocale.barcodeUpcALabel,
    upcE => AppLocale.barcodeUpcELabel,
    code128 => AppLocale.barcodeCode128Label,
    code93 => AppLocale.barcodeCode93Label,
    code39 => AppLocale.barcodeCode39Label,
    codabar => AppLocale.barcodeCodabarLabel,
    itf => AppLocale.barcodeItfLabel,
    null => null,
  }?.s ?? '"$n"';

  String get composition => switch (this) {
    qrCode => AppLocale.barcodeTextCompositionLabel,
    dataMatrix => AppLocale.barcodeTextNoSpecialCompositionLabel,
    aztec => AppLocale.barcodeTextNoSpecialCompositionLabel,
    pdf417 => AppLocale.barcodeTextCompositionLabel,
    ean13 => AppLocale.barcode12Digits1CheckCompositionLabel,
    ean8 => AppLocale.barcode7Digits1CheckCompositionLabel,
    upcA => AppLocale.barcode11Digits1CheckCompositionLabel,
    upcE => AppLocale.barcode7Digits1CheckCompositionLabel,
    code128 => AppLocale.barcodeTextNoSpecialCompositionLabel,
    code93 => AppLocale.barcodeTextUpperNoSpecialCompositionLabel,
    code39 => AppLocale.barcodeTextUpperNoSpecialCompositionLabel,
    codabar => AppLocale.barcodeDigitsCompositionLabel,
    itf => AppLocale.barcodeEvenDigitsCompositionLabel,
  }.s;

  String? get description => switch (this) {
    ean13 => AppLocale.barcodeEan13DescriptionLabel,
    ean8 => AppLocale.barcodeEan8DescriptionLabel,
    upcA => AppLocale.barcodeUpcADescriptionLabel,
    upcE => AppLocale.barcodeUpcEDescriptionLabel,
    code128 => AppLocale.barcodeCode128DescriptionLabel,
    code93 => AppLocale.barcodeCode93DescriptionLabel,
    code39 => AppLocale.barcodeCode39DescriptionLabel,
    codabar => AppLocale.barcodeCodabarDescriptionLabel,
    itf => AppLocale.barcodeItfDescriptionLabel,
    qrCode || dataMatrix || aztec || pdf417 => null,
  }?.s;
}
