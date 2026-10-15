import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:watashi_qr/common/drift_database.dart';
import 'package:watashi_qr/common/prefs.dart';

class HistoryItems extends Table with UuidMixin {
  late final createdAt = integer()
      .clientDefault(() => DateTime.now().millisecondsSinceEpoch)
      .map(dateTimeConverter)();
  late final contents = text()();
  late final format = text()();
  late final type = text()();
  late final errorLevel = text()();
  late final origin = text()();
  late final isFavorite = boolean()();
  late final notes = text()();

  @override
  Set<Column> get primaryKey => {uuid};
}

class HistoryDao extends DatabaseAccessor<MyDriftDatabase> {
  HistoryDao(super.attachedDatabase);

  $HistoryItemsTable get _history => attachedDatabase.historyItems;

  Stream<List<HistoryItem>> queryStream({String? format, String? contents}) {
    final statement = _history.select();
    if (format != null) {
      statement.where((tbl) => tbl.format.isValue(format));
    }
    if (contents != null) {
      statement.where((tbl) => tbl.contents.isValue(contents));
    }
    statement.orderBy([
      (tbl) =>
          OrderingTerm(expression: tbl.isFavorite, mode: OrderingMode.desc),
      (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      (tbl) => OrderingTerm(expression: tbl.uuid, mode: OrderingMode.desc),
    ]);
    return statement.watch().distinct(const ListEquality().equals);
  }

  Future<void> upsertMany(Iterable<HistoryItem> list) {
    assert(list.every((item) => item.uuid.length == 36));
    return batch((batch) {
      batch.insertAllOnConflictUpdate(_history, list);
    });
  }

  Future<void> removeMany(Iterable<String> uuids) {
    return batch((batch) {
      uuids
          .toSet()
          .slices(chunkSize)
          .forEach(
            (chunk) =>
                batch.deleteWhere(_history, (tbl) => tbl.uuid.isIn(chunk)),
          );
    });
  }

  Future<int> removeAll() => _history.deleteAll();

  Future<HistoryItem> insert(HistoryItem item) async {
    assert(item.uuid.isEmpty);
    item = item.copyWith(uuid: UuidMixin.v7.generate());
    if (!PrefsEnum.isSaveDuplicates.get()) {
      final last = await queryStream(
        format: item.format,
        contents: item.contents,
      ).first.then((ls) => ls.firstOrNull);
      if (last != null) {
        item = item.copyWith(isFavorite: last.isFavorite, notes: last.notes);
        await batch((batch) {
          batch.delete(_history, last);
          batch.insert(_history, item);
        });
        return item;
      }
    }
    await _history.insertOne(item);
    return item;
  }
}
