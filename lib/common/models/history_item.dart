import 'package:barcode/barcode.dart';
import 'package:hive/hive.dart';
import 'package:watashi_qr/locale/language.dart';
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
      format: json['format'] ?? 'NONE',
      type: json['type'] ?? 'NONE',
      errorLevel: json['errorLevel'] ?? HistoryErrorLevel.none.name,
      origin: json['origin'] ?? HistoryOrigin.C.name,
      isFavorite: json['isFavorite'] ?? false,
      notes: json['notes'] ?? '',
    );
  }
}

// enum HistoryFormat { // !! 改變name會影響之後HistoryItem儲存的值
//   qrCode,  //'QR_CODE'
//   dataMatrix,  // 'DATA_MATRIX'
//   aztec,  // 'AZTEC'
//   pdf417,  // 'PDF_417'
//   ean13,  // 'EAN_13'
//   ean8,  // 'EAN_8'
//   upcA,  // 'UPC_A'
//   upcE,  // 'UPC_E'
//   code128,  // 'Code_128'
//   code93,  // 'Code_93'
//   code39,  // 'Code_39'
//   codebar,  // 'CODABAR'
//   itf;  // 'IFT'
// }
//
// enum HistoryType { // !! 改變name會影響之後HistoryItem儲存的值
//   text,  // TEXT
//   website,  // WEBSITE
//   contact,  // CONTACT
//   mail,  // MAIL
//   sms,  // SMS
//   phone,  // PHONE
//   location,  // LOCATION
//   agend,  // AGEND
//   wifi,  // WIFI
//   product,  // PRODUCT
//   industrial,  // INDUSTRIAL
// }

enum HistoryErrorLevel { // !! 改變name會影響之後HistoryItem儲存的值
  L(BarcodeQRCorrectionLevel.low),
  M(BarcodeQRCorrectionLevel.medium),
  Q(BarcodeQRCorrectionLevel.quartile),
  H(BarcodeQRCorrectionLevel.low),
  none;

  final BarcodeQRCorrectionLevel? barcodeQRCorrectionLevel;
  const HistoryErrorLevel([this.barcodeQRCorrectionLevel]);

  static String? localeStrFromName(String n, Language localeStr) => <HistoryErrorLevel, String>{
    L: localeStr.qrCodeErrorCorrectionLevelNameLow,
    M: localeStr.qrCodeErrorCorrectionLevelNameMedium,
    Q: localeStr.qrCodeErrorCorrectionLevelNameQuartile,
    H: localeStr.qrCodeErrorCorrectionLevelNameHigh,
  }[values.byName(n)];

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