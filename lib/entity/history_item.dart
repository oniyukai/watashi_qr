import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

@Entity()
class HistoryItem {
  @Id()
  int id = 0;
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

  @Transient()
  HistoryFormat? get getFormat => HistoryFormat.values.fromName(format);

  @Transient()
  MyIconData get getFormatIconData =>
      getFormat?.myIconData ?? const MyIconData(Icons.help_center_outlined);

  @Transient()
  HistoryType? get getType => HistoryType.values.fromName(type);

  @Transient()
  IconData get getTypeIconData => getType?.iconData ?? Icons.help_center;

  @Transient()
  HistoryErrorLevel? get getErrorLevel =>
      HistoryErrorLevel.values.fromName(errorLevel);

  @Transient()
  HistoryOrigin? get getOrigin => HistoryOrigin.values.fromName(origin);

  @Transient()
  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
    unixTime: json['unixTime'] ?? 1,
    contents: json['contents'] ?? StaticString.nullString,
    format: json['format'] ?? HistoryFormat.qrCode.name,
    type: json['type'] ?? HistoryType.text.name,
    errorLevel: json['errorLevel'] ?? HistoryErrorLevel.none.name,
    origin: json['origin'] ?? HistoryOrigin.C.name,
    isFavorite: json['isFavorite'] ?? false,
    notes: json['notes'] ?? '',
  );

  @Transient()
  Map<String, dynamic> toJson() => <String, dynamic>{
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

/// !! 改變name會影響之後HistoryItem儲存的值
enum HistoryErrorLevel {
  L(.low),
  M(.medium),
  Q(.quartile),
  H(.high),
  none;

  final BarcodeQRCorrectionLevel? barcodeQRCorrectionLevel;

  const HistoryErrorLevel([this.barcodeQRCorrectionLevel]);

  static String localeStrFromName(String n) =>
      optionMap[values.fromName(n)] ?? '?$n';

  static Map<HistoryErrorLevel, String> get optionMap =>
      <HistoryErrorLevel, String>{
        L: DictKey.settingOptionQrErrorCorrectionLevelLow.s,
        M: DictKey.settingOptionQrErrorCorrectionLevelMedium.s,
        Q: DictKey.settingOptionQrErrorCorrectionLevelQuartile.s,
        H: DictKey.settingOptionQrErrorCorrectionLevelHigh.s,
      };
}

/// !! 改變name會影響之後HistoryItem儲存的值
enum HistoryOrigin {
  S(Icons.fullscreen), // scanner
  C(Icons.edit_outlined); // creator

  final IconData iconData;

  const HistoryOrigin(this.iconData);

  static String localeStrFromName(String n) =>
      switch (values.fromName(n)) {
        S => DictKey.navTitleScanner,
        C => DictKey.navTitleCreator,
        null => null,
      }?.s ??
      '?$n';
}
