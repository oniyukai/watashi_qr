import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/locale/map_en.dart';
import 'package:watashi_qr/locale/map_ja.dart';
import 'package:watashi_qr/locale/map_zh_hans.dart';
import 'package:watashi_qr/locale/map_zh_hant.dart';

void main() {

  for (final map in const [mapEn, mapJa, mapZhHans, mapZhHant]) {
    final entries = map.entries.where((e) => e.value != null);
    debugPrint('${entries.length / DictKey.values.length * 100.0} %');
  }

  for (final dictKey in DictKey.values) {
    String encode = jsonEncode(mapEn[dictKey]);
    if (encode.startsWith('"') && encode.endsWith('"')) {
      encode = '\'${encode.substring(1, encode.length - 1)}\'';
    }
    encode = encode
        .replaceAll('\\"', '"')
        .replaceAll('\$', '\\\$')
        .replaceAll(StaticString.searchReplaceWord, '\${StaticString.searchReplaceWord}');
    // debugPrint('.${dictKey.name}: $encode,');
  }
}
