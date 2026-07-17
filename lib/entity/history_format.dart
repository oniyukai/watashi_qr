import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart' show BarcodeFormat;
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

/// !! 改變name會影響之後HistoryItem儲存的值
enum HistoryFormat {
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

  static HistoryFormat? fromScannerFormat(BarcodeFormat barcodeFormat) =>
      switch (barcodeFormat) {
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
        .itf || .itf2of5 || .itf2of5WithChecksum || .itf14 => itf,
        .maxiCode ||
        .microQrCode ||
        .dataBar ||
        .dataBarExpanded ||
        .dataBarLimited ||
        .unknown ||
        .all => null,
      };

  static String localeStrFromName(String n) =>
      switch (values.fromName(n)) {
        qrCode => DictKey.barcodeFormatQrCode,
        dataMatrix => DictKey.barcodeFormatDataMatrix,
        aztec => DictKey.barcodeFormatAztec,
        pdf417 => DictKey.barcodeFormatPdf417,
        ean13 => DictKey.barcodeFormatEan13,
        ean8 => DictKey.barcodeFormatEan8,
        upcA => DictKey.barcodeFormatUpcA,
        upcE => DictKey.barcodeFormatUpcE,
        code128 => DictKey.barcodeFormatCode128,
        code93 => DictKey.barcodeFormatCode93,
        code39 => DictKey.barcodeFormatCode39,
        codabar => DictKey.barcodeFormatCodabar,
        itf => DictKey.barcodeFormatItf,
        null => null,
      }?.s ??
      '"$n"';

  String get composition => switch (this) {
    qrCode => DictKey.barcodeCompositionText,
    dataMatrix => DictKey.barcodeCompositionTextSimple,
    aztec => DictKey.barcodeCompositionTextSimple,
    pdf417 => DictKey.barcodeCompositionText,
    ean13 => DictKey.barcodeComposition12Digits1Check,
    ean8 => DictKey.barcodeComposition7Digits1Check,
    upcA => DictKey.barcodeComposition11Digits1Check,
    upcE => DictKey.barcodeComposition7Digits1Check,
    code128 => DictKey.barcodeCompositionTextSimple,
    code93 => DictKey.barcodeCompositionTextUpperSimple,
    code39 => DictKey.barcodeCompositionTextUpperSimple,
    codabar => DictKey.barcodeCompositionDigits,
    itf => DictKey.barcodeCompositionEvenLengthNumbers,
  }.s;

  String get description => switch (this) {
    qrCode => DictKey.barcodeDescriptionQrCode,
    dataMatrix => DictKey.barcodeDescriptionDataMatrix,
    aztec => DictKey.barcodeDescriptionAztec,
    pdf417 => DictKey.barcodeDescriptionPdf417,
    ean13 => DictKey.barcodeDescriptionEan13,
    ean8 => DictKey.barcodeDescriptionEan8,
    upcA => DictKey.barcodeDescriptionUpcA,
    upcE => DictKey.barcodeDescriptionUpcE,
    code128 => DictKey.barcodeDescriptionCode128,
    code93 => DictKey.barcodeDescriptionCode93,
    code39 => DictKey.barcodeDescriptionCode39,
    codabar => DictKey.barcodeDescriptionCodabar,
    itf => DictKey.barcodeDescriptionItf,
  }.s;
}
