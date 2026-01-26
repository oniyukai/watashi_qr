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
    dataMatrix => Barcode.dataMatrix,
    aztec => Barcode.aztec,
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
    qrCode => DictKey.barcodeQrCodeLabel,
    dataMatrix => DictKey.barcodeDataMatrixLabel,
    aztec => DictKey.barcodeAztecLabel,
    pdf417 => DictKey.barcodePdf417Label,
    ean13 => DictKey.barcodeEan13Label,
    ean8 => DictKey.barcodeEan8Label,
    upcA => DictKey.barcodeUpcALabel,
    upcE => DictKey.barcodeUpcELabel,
    code128 => DictKey.barcodeCode128Label,
    code93 => DictKey.barcodeCode93Label,
    code39 => DictKey.barcodeCode39Label,
    codabar => DictKey.barcodeCodabarLabel,
    itf => DictKey.barcodeItfLabel,
    null => null,
  }?.s ?? '"$n"';

  String get composition => switch (this) {
    qrCode => DictKey.barcodeTextCompositionLabel,
    dataMatrix => DictKey.barcodeTextNoSpecialCompositionLabel,
    aztec => DictKey.barcodeTextNoSpecialCompositionLabel,
    pdf417 => DictKey.barcodeTextCompositionLabel,
    ean13 => DictKey.barcode12Digits1CheckCompositionLabel,
    ean8 => DictKey.barcode7Digits1CheckCompositionLabel,
    upcA => DictKey.barcode11Digits1CheckCompositionLabel,
    upcE => DictKey.barcode7Digits1CheckCompositionLabel,
    code128 => DictKey.barcodeTextNoSpecialCompositionLabel,
    code93 => DictKey.barcodeTextUpperNoSpecialCompositionLabel,
    code39 => DictKey.barcodeTextUpperNoSpecialCompositionLabel,
    codabar => DictKey.barcodeDigitsCompositionLabel,
    itf => DictKey.barcodeEvenDigitsCompositionLabel,
  }.s;

  String? get description => switch (this) {
    ean13 => DictKey.barcodeEan13DescriptionLabel,
    ean8 => DictKey.barcodeEan8DescriptionLabel,
    upcA => DictKey.barcodeUpcADescriptionLabel,
    upcE => DictKey.barcodeUpcEDescriptionLabel,
    code128 => DictKey.barcodeCode128DescriptionLabel,
    code93 => DictKey.barcodeCode93DescriptionLabel,
    code39 => DictKey.barcodeCode39DescriptionLabel,
    codabar => DictKey.barcodeCodabarDescriptionLabel,
    itf => DictKey.barcodeItfDescriptionLabel,
    qrCode || dataMatrix || aztec || pdf417 => null,
  }?.s;
}
