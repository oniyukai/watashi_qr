import 'package:barcode/barcode.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:mobile_scanner/mobile_scanner.dart' show BarcodeFormat;
import 'package:watashi_qr/pages/widgets/my_icon.dart';
part 'history_item.g.dart';

@HiveType(typeId: 0)
class HistoryItem extends HiveObject {
  @HiveField(0)
  int unixTime;

  @HiveField(1)
  String contents;

  @HiveField(2)
  String format;

  @HiveField(3)
  String type;

  @HiveField(4)
  String errorLevel;

  @HiveField(5)
  String origin;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  String notes;

  HistoryItem({
    required this.unixTime,
    required this.contents,
    required this.format,
    required this.type,
    required this.errorLevel,
    required this.origin,
    required this.isFavorite,
    required this.notes,
  });

  HistoryFormat? get getFormat => HistoryFormat.values.fromName(format);
  MyIconData get getFormatIconData => getFormat?.myIconData ?? MyIconData(Icons.help_center_outlined);

  HistoryType? get getType => HistoryType.values.fromName(type);
  MyIconData get getTypeIconData => getType?.myIconData ?? MyIconData(Icons.help_center);

  Map<String, dynamic> toJson() {
    return {
      'unixTime': unixTime,
      'contents': contents,
      'format': format,
      'type': type,
      'errorLevel': errorLevel,
      'origin': origin,
      'isFavorite': isFavorite,
      'notes': notes,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      unixTime: json['unixTime'] ?? 1,
      contents: json['contents'] ?? 'ERROR: null?',
      format: json['format'] ?? HistoryFormat.qrCode.name,
      type: json['type'] ?? HistoryType.text.name,
      errorLevel: json['errorLevel'] ?? HistoryErrorLevel.none.name,
      origin: json['origin'] ?? HistoryOrigin.C.name,
      isFavorite: json['isFavorite'] ?? false,
      notes: json['notes'] ?? '',
    );
  }
}


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

  final MyIconData myIconData;
  const HistoryFormat(this.myIconData);

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


enum HistoryType { // !! 改變name會影響之後HistoryItem儲存的值
  text(MyIconData(Icons.format_size)),
  website(MyIconData(Icons.web)),
  contact(MyIconData(Icons.contacts_outlined)),
  mail(MyIconData(Icons.mail_outline)),
  sms(MyIconData(Icons.sms_outlined)),
  phone(MyIconData(Icons.call)),
  location(MyIconData(Icons.location_on)),
  event(MyIconData(Icons.event)),
  wifi(MyIconData(Icons.wifi)),
  product(MyIconData(Icons.sell_outlined)),
  industrial(MyIconData(Icons.build_circle_outlined));

  final MyIconData myIconData;
  const HistoryType(this.myIconData);

  static String localeStrFromName(String n, Language localeStr) => <HistoryType, String>{
    text: localeStr.qrCodeTypeNameText,
    website: localeStr.qrCodeTypeNameWebSite,
    contact: localeStr.qrCodeTypeNameContact,
    mail: localeStr.qrCodeTypeNameMail,
    sms: localeStr.qrCodeTypeNameSms,
    phone: localeStr.qrCodeTypeNamePhone,
    location: localeStr.qrCodeTypeNameLocation,
    event: localeStr.qrCodeTypeNameEvent,
    wifi: localeStr.qrCodeTypeNameWifi,
    product: localeStr.barCodeTypeProduct,
    industrial: localeStr.barCodeTypeIndustrial,
  }[values.fromName(n)] ?? '?$n';

  factory HistoryType.fromDistinguish(HistoryFormat? format, String contents) {
    final String upperContents = contents.toUpperCase();
    switch (format) {
      case HistoryFormat.qrCode:
      case HistoryFormat.dataMatrix:
      case HistoryFormat.aztec:
      case HistoryFormat.pdf417:
        if (upperContents.startsWith('BEGIN:VCARD\n')) {
          return contact;
        } else if (upperContents.startsWith('MAILTO:') || upperContents.startsWith('MATMSG:')) {
          return mail;
        } else if (upperContents.startsWith('SMSTO:')) {
          return sms;
        } else if (upperContents.startsWith('TEL:')) {
          return phone;
        } else if (upperContents.startsWith('GEO:')) {
          return location;
        } else if (upperContents.startsWith('BEGIN:VEVENT\n')) {
          return event;
        } else if (upperContents.startsWith('WIFI:')) {
          return wifi;
        } else if (isURL(contents, {
          'protocols': ['http', 'https'],
          'require_tld': true,
          'require_protocol': true,
          'allow_underscores': false,
        })) {
          return website;
        } else {
          return text;
        }
      case HistoryFormat.ean13:
      case HistoryFormat.ean8:
      case HistoryFormat.upcE:
      case HistoryFormat.upcA:
        return product;
      case HistoryFormat.code128:
      case HistoryFormat.code93:
      case HistoryFormat.code39:
      case HistoryFormat.codebar:
      case HistoryFormat.itf:
        return industrial;
      default:
        return text;
    }
  }
}


enum HistoryErrorLevel { // !! 改變name會影響之後HistoryItem儲存的值
  L(BarcodeQRCorrectionLevel.low),
  M(BarcodeQRCorrectionLevel.medium),
  Q(BarcodeQRCorrectionLevel.quartile),
  H(BarcodeQRCorrectionLevel.high),
  none;

  final BarcodeQRCorrectionLevel? barcodeQRCorrectionLevel;
  const HistoryErrorLevel([this.barcodeQRCorrectionLevel]);

  static HistoryErrorLevel? fromName(String n) => values.fromName(n);
  static String? localeStrFromName(String n, Language localeStr) => optionMap(localeStr)[n];

  static Map<String, String> optionMap(Language localeStr) => <String, String>{
    L.name: localeStr.qrCodeErrorCorrectionLevelNameLow,
    M.name: localeStr.qrCodeErrorCorrectionLevelNameMedium,
    Q.name: localeStr.qrCodeErrorCorrectionLevelNameQuartile,
    H.name: localeStr.qrCodeErrorCorrectionLevelNameHigh,
  };
}


enum HistoryOrigin { // !! 改變name會影響之後HistoryItem儲存的值
  S, C; // from scanner, creator
}