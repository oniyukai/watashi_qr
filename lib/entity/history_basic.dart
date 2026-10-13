import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:material_ui/material_ui.dart';
import 'package:uuid/data.dart';
import 'package:watashi_qr/common/drift_database.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

extension HistoryBasic on HistoryItem {
  HistoryFormat? get getFormat => HistoryFormat.values.fromName(format);

  MyIconData get getFormatIconData =>
      getFormat?.myIconData ?? const MyIconData(Icons.help_center_outlined);

  HistoryType? get getType => HistoryType.values.fromName(type);

  IconData get getTypeIconData => getType?.iconData ?? Icons.help_center;

  HistoryErrorLevel? get getErrorLevel =>
      HistoryErrorLevel.values.fromName(errorLevel);

  HistoryOrigin? get getOrigin => HistoryOrigin.values.fromName(origin);

  static HistoryItem fromJson(Map<String, dynamic> json) {
    final int unixTime = json['createdAt'] ?? json['unixTime'] ?? 1;
    final String uuid =
        json['uuid'] ??
        UuidMixin.v7.generate(options: V7Options(unixTime, Uint8List(10)));
    final String contents = json['contents'] ?? StaticString.nullString;
    final String format = json['format'] ?? HistoryFormat.qrCode.name;
    return HistoryItem(
      uuid: uuid,
      createdAt: dateTimeConverter.toR(unixTime),
      contents: contents,
      format: format,
      type:
          json['type'] ??
          HistoryType.fromDistinguish(
            HistoryFormat.values.fromName(format),
            contents,
          ),
      errorLevel: json['errorLevel'] ?? HistoryErrorLevel.none.name,
      origin: json['origin'] ?? HistoryOrigin.C.name,
      isFavorite: json['isFavorite'] ?? false,
      notes: json['notes'] ?? '',
    );
  }
}

/// !! 改變name會影響之後HistoryItem儲存的值
enum HistoryErrorLevel {
  L(BarcodeQRCorrectionLevel.low),
  M(BarcodeQRCorrectionLevel.medium),
  Q(BarcodeQRCorrectionLevel.quartile),
  H(BarcodeQRCorrectionLevel.high),
  none;

  final BarcodeQRCorrectionLevel? barcodeQRCorrectionLevel;

  const HistoryErrorLevel([this.barcodeQRCorrectionLevel]);

  static String localeFromName(String n) =>
      optionMap[values.fromName(n)] ?? '?$n';

  static Map<HistoryErrorLevel, String> get optionMap => {
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

  static String localeFromName(String n) =>
      switch (values.fromName(n)) {
        S => DictKey.navTitleScanner,
        C => DictKey.navTitleCreator,
        null => null,
      }?.s ??
      '?$n';
}
