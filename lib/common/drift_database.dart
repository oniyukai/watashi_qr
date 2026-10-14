import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/v7.dart';
import 'package:watashi_qr/entity/history_basic.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/locale/app_language.dart';

part 'drift_database.g.dart';

const int chunkSize = 900;

class BasicTypeConverter<R, S> extends TypeConverter<R, S> {
  final S Function(R fromR) _toS;
  final R Function(S fromS) _toR;

  const BasicTypeConverter({required this._toS, required this._toR});

  S toS(R fromR) => _toS(fromR);

  R toR(S fromS) => _toR(fromS);

  @override
  S toSql(R value) => _toS(value);

  @override
  R fromSql(S fromDb) => _toR(fromDb);
}

final dateTimeConverter = BasicTypeConverter<DateTime, int>(
  toS: (fromR) => fromR.millisecondsSinceEpoch,
  toR: DateTime.fromMillisecondsSinceEpoch,
);

mixin UuidMixin on Table {
  static const v7 = UuidV7();

  late final uuid = text()
      .clientDefault(() => UuidMixin.v7.generate())
      .withLength(max: 36)();
}

@DriftDatabase(tables: [HistoryItems])
class MyDriftDatabase extends _$MyDriftDatabase {
  MyDriftDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection()) {
    if (executor == null) DriftService.appDb = this;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  static QueryExecutor _openConnection() => driftDatabase(
    name: 'drift',
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
  );

  @override
  int get schemaVersion => 1;

  late final HistoryDao dao = HistoryDao(this);
}

abstract final class DriftService {
  static late final MyDriftDatabase appDb;

  static Future<File> exportJson(String dirPath) async {
    final histories = await appDb.dao.queryStream().first;
    if (histories.isEmpty) throw DictKey.historyStatusEmpty.s;
    final dateTimeString = DateFormat('yyyyMMdd-HH-mm').format(DateTime.now());
    final file = File(p.join(dirPath, 'qr_$dateTimeString.json'));
    return await file.writeAsString(jsonEncode(histories));
  }

  static Future<(int, int, int)> importJson(String jsonString) async {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    final itemMap = <String, HistoryItem>{};
    for (final itemJson in jsonData) {
      final item = HistoryBasic.fromJson(itemJson);
      itemMap[item.uuid] = item;
    }
    final histories = await appDb.dao.queryStream().first;
    final historySet = histories.map((item) => item.uuid).toSet();
    final repLen = itemMap.keys.toSet().intersection(historySet).length;
    final addLen = itemMap.length - repLen;
    await appDb.dao.upsertMany(itemMap.values);
    return (jsonData.length, repLen, addLen);
  }
}
