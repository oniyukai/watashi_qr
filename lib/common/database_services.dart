import 'package:share_plus/share_plus.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/objectbox.g.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:intl/intl.dart';

abstract final class DatabaseServices {
  static late final Store _store;
  static late final Box<HistoryItem> _historyBox;

  static Future<void> init() async {
    final Directory dir = await getApplicationSupportDirectory();
    _store = await openStore(directory: p.join(dir.path, 'objectbox'));
    _historyBox = _store.box<HistoryItem>();
  }

  static Stream<List<HistoryItem>> get historyItemsStream =>
      _applyOrder(_historyBox.query())
          .watch(triggerImmediately: true)
          .map((query) => query.find());

  static int addItem(HistoryItem item, [bool force = false]) {
    assert(item.id == 0);
    if (force || PrefsEnum.isSaveDuplicates.get()) return _historyBox.put(item, mode: .insert);
    final Query<HistoryItem> query = _applyOrder(_historyBox
        .query(HistoryItem_.format.equals(item.format).and(HistoryItem_.contents.equals(item.contents)))
    ).build();
    final List<HistoryItem> result = query.find();
    query.close();
    if (result.isEmpty) return _historyBox.put(item, mode: .insert);
    final HistoryItem latestDuplicate = result.first;
    item
      ..isFavorite = latestDuplicate.isFavorite
      ..notes = latestDuplicate.notes;
    deleteItem(latestDuplicate.id);
    return _historyBox.put(item, mode: .insert);
  }

  static int updateItem(HistoryItem item) => _historyBox.put(item, mode: .update);

  static List<int> updateItems(List<HistoryItem> items) => _historyBox.putMany(items, mode: .update);

  // static HistoryItem? getItem(int id) => _historyBox.get(id);

  static List<HistoryItem> getItems([List<int>? ids]) {
    final Query<HistoryItem> query = _applyOrder(_historyBox
        .query(ids != null ? HistoryItem_.id.oneOf(ids) : null)
    ).build();
    final List<HistoryItem> result = query.find();
    query.close();
    return result;
  }

  static QueryBuilder<HistoryItem> _applyOrder(QueryBuilder<HistoryItem> queryBuilder) =>
      queryBuilder
          .order(HistoryItem_.isFavorite, flags: Order.descending)
          .order(HistoryItem_.unixTime, flags: Order.descending);

  static bool deleteItem(int id) => _historyBox.remove(id);

  static int deleteItems(List<int> ids) => _historyBox.removeMany(ids);

  static int clearHistoryBox() => _historyBox.removeAll();

  static Future<void> shareHistoryBoxToJson() async {
    if (_historyBox.isEmpty()) {
      await Utils.showToast(DictKey.historyStatusEmpty.s);
      return;
    }
    final Directory tempDir = await getTemporaryDirectory();
    final File? file = await _getHistoryBoxJsonFile(tempDir.path);
    if (file != null) await Utils.share(.new(files: [XFile(file.path)]));
  }

  static Future<void> exportHistoryBoxToJson() async {
    if (_historyBox.isEmpty()) {
      await Utils.showToast(DictKey.historyStatusEmpty.s);
      return;
    }
    final Directory? directory = await getDownloadsDirectory();
    final String? directoryPath = await FilePicker.platform.getDirectoryPath(initialDirectory:directory?.path);
    if (directoryPath == null) {
      await Utils.showToast('${DictKey.commonUiCancel.s}  Unable to get storage directory.');
      return;
    }
    final File? file = await _getHistoryBoxJsonFile(directoryPath);
    if (file != null) {
      await Utils.showToast('${DictKey.historyDataExportSuccess.s}  ${file.path}');
    } else {
      await Utils.showToast(DictKey.historyDataExportError.s);
    }
  }

  static Future<File?> _getHistoryBoxJsonFile(String directory) async {
    try {
      if (_historyBox.isEmpty()) return null;
      final String jsonString = jsonEncode(getItems());
      final DateTime now = .now();
      final String formattedDateTime = DateFormat('yyyyMMdd-HH-mm').format(now);
      final String filePath = p.join(directory, 'qr_$formattedDateTime.json');
      final File file = File(filePath);
      return await file.writeAsString(jsonString);
    } catch (e) {
      await Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<void> importHistoryBoxFromJson() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: .custom,
        allowedExtensions: const ['json'],
      );
      if (result == null) {
        await Utils.showToast(DictKey.commonUiCancel.s);
        return;
      }

      final File file = File(result.files.single.path!);
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      int added = 0;
      int replaced = 0;

      final Map<int, HistoryItem> itemsToProcess = {};
      for (final dynamic itemJson in jsonData) {
        final HistoryItem historyItem = HistoryItem.fromJson(itemJson);
        itemsToProcess[historyItem.unixTime] = historyItem;
      }
      final Query<HistoryItem> query = _historyBox
          .query(HistoryItem_.unixTime.oneOf(itemsToProcess.keys.toList()))
          .build();
      final Map<int, int> existingTimeKeyMap = {
        for (final HistoryItem queryItem in query.find())
          queryItem.unixTime: queryItem.id,
      };
      query.close();
      for (final HistoryItem item in itemsToProcess.values) {
        final int? searchId = existingTimeKeyMap[item.unixTime];
        if (searchId != null) {
          item.id = searchId;
          replaced += 1;
        } else {
          added += 1;
        }
      }
      _historyBox.putMany(itemsToProcess.values.toList());
      final String endTip = '${DictKey.historyDataImportSuccess.s}  Total:${jsonData.length}, Added:$added, Replaced:$replaced';
      await Utils.showToast(endTip, true);
    } catch (e) {
      await Utils.showToast('${DictKey.historyDataImportError.s}  $e', true);
    }
  }
}
