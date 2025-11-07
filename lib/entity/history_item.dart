import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

@Entity()
class HistoryItem {
  @Id() int id = 0;
  int unixTime;
  String contents;
  String format;
  String type;
  String errorLevel;
  String origin;
  bool isFavorite;
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

  @Transient() HistoryFormat? get getFormat => HistoryFormat.values.fromName(format);
  @Transient() MyIconData get getFormatIconData => getFormat?.myIconData ?? MyIconData(Icons.help_center_outlined);
  @Transient() HistoryType? get getType => HistoryType.values.fromName(type);
  @Transient() MyIconData get getTypeIconData => getType?.myIconData ?? MyIconData(Icons.help_center);

  @Transient()
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      unixTime: json['unixTime'] ?? 1,
      contents: json['contents'] ?? 'NULL<String>',
      format: json['format'] ?? HistoryFormat.qrCode.name,
      type: json['type'] ?? HistoryType.text.name,
      errorLevel: json['errorLevel'] ?? HistoryErrorLevel.none.name,
      origin: json['origin'] ?? HistoryOrigin.C.name,
      isFavorite: json['isFavorite'] ?? false,
      notes: json['notes'] ?? '',
    );
  }

  @Transient()
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
}

// @HiveType(typeId: 0)
// class HistoryItem_ extends HiveObject {
//   @HiveField(0)
//   int unixTime;
//
//   @HiveField(1)
//   String contents;
//
//   @HiveField(2)
//   String format;
//
//   @HiveField(3)
//   String type;
//
//   @HiveField(4)
//   String errorLevel;
//
//   @HiveField(5)
//   String origin;
//
//   @HiveField(6)
//   bool isFavorite;
//
//   @HiveField(7)
//   String notes;
//
//   HistoryItem({
//     required this.unixTime,
//     required this.contents,
//     required this.format,
//     required this.type,
//     required this.errorLevel,
//     required this.origin,
//     required this.isFavorite,
//     required this.notes,
//   });
//
//   HistoryFormat? get getFormat => HistoryFormat.values.fromName(format);
//   MyIconData get getFormatIconData => getFormat?.myIconData ?? MyIconData(Icons.help_center_outlined);
//
//   HistoryType? get getType => HistoryType.values.fromName(type);
//   MyIconData get getTypeIconData => getType?.myIconData ?? MyIconData(Icons.help_center);
//
//   Map<String, dynamic> toJson() {
//     return {
//       'unixTime': unixTime,
//       'contents': contents,
//       'format': format,
//       'type': type,
//       'errorLevel': errorLevel,
//       'origin': origin,
//       'isFavorite': isFavorite,
//       'notes': notes,
//     };
//   }
//
//   factory HistoryItem.fromJson(Map<String, dynamic> json) {
//     return HistoryItem(
//       unixTime: json['unixTime'] ?? 1,
//       contents: json['contents'] ?? 'ERROR: null?',
//       format: json['format'] ?? HistoryFormat.qrCode.name,
//       type: json['type'] ?? HistoryType.text.name,
//       errorLevel: json['errorLevel'] ?? HistoryErrorLevel.none.name,
//       origin: json['origin'] ?? HistoryOrigin.C.name,
//       isFavorite: json['isFavorite'] ?? false,
//       notes: json['notes'] ?? '',
//     );
//   }
// }


enum HistoryErrorLevel { // !! 改變name會影響之後HistoryItem儲存的值
  L(BarcodeQRCorrectionLevel.low),
  M(BarcodeQRCorrectionLevel.medium),
  Q(BarcodeQRCorrectionLevel.quartile),
  H(BarcodeQRCorrectionLevel.high),
  none;

  const HistoryErrorLevel([this.barcodeQRCorrectionLevel]);
  final BarcodeQRCorrectionLevel? barcodeQRCorrectionLevel;

  static HistoryErrorLevel? fromName(String n) => values.fromName(n);
  static String localeStrFromName(String? n, Language localeStr) => optionMap(localeStr)[n] ?? '?$n';

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