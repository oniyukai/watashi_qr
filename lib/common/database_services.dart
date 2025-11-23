import 'package:share_plus/share_plus.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/objectbox.g.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:intl/intl.dart';

class DatabaseServices {
  const DatabaseServices._();

  static late Store _store;
  static late final Box<HistoryItem> _historyItemBox;

  static Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    _store = await openStore(directory: p.join(dir.path, 'objectbox'));
    _historyItemBox = _store.box<HistoryItem>();
  }

  static void dispose() => _store.close();

  static Stream<List<HistoryItem>> get historyItemsStream =>
      _applyOrder(_historyItemBox.query())
          .watch(triggerImmediately: true)
          .map((query) => query.find());

  static int addItem(HistoryItem item, BuildContext context) {
    assert(item.id == 0);
    if (context.readPrefs.get(PrefsEnum.isSaveDuplicates)) return _historyItemBox.put(item, mode: PutMode.insert);
    final query = _applyOrder(_historyItemBox
        .query(HistoryItem_.format.equals(item.format).and(HistoryItem_.contents.equals(item.contents)))
    ).build();
    final result = query.find();
    query.close();
    if (result.isEmpty) return _historyItemBox.put(item, mode: PutMode.insert);
    final latestDuplicate = result.first;
    item
      ..isFavorite = latestDuplicate.isFavorite
      ..notes = latestDuplicate.notes;
    deleteItem(latestDuplicate.id);
    return _historyItemBox.put(item, mode: PutMode.insert);
  }

  // static HistoryItem? getItem(int id) => _historyItemBox.get(id);

  static List<HistoryItem> getItems([List<int>? ids]) {
    final query = _applyOrder(_historyItemBox
        .query(ids != null ? HistoryItem_.id.oneOf(ids) : null)
    ).build();
    final result = query.find();
    query.close();
    return result;
  }

  static QueryBuilder<HistoryItem> _applyOrder(QueryBuilder<HistoryItem> queryBuilder) =>
      queryBuilder
          .order(HistoryItem_.isFavorite, flags: Order.descending)
          .order(HistoryItem_.unixTime, flags: Order.descending);

  static int updateItem(HistoryItem item) => _historyItemBox.put(item, mode: PutMode.update);

  static List<int> updateItems(List<HistoryItem> items) => _historyItemBox.putMany(items, mode: PutMode.update);

  static bool deleteItem(int id) => _historyItemBox.remove(id);

  static int deleteItems(List<int> ids) => _historyItemBox.removeMany(ids);

  static int clearHistories() => _historyItemBox.removeAll();

  static Future<void> shareHistoriesToJson() async {
    if (_historyItemBox.isEmpty()) return Utils.showToast(AppLocale.labelHistoryEmpty.s);
    final Directory tempDir = await getTemporaryDirectory();
    final File? file = await _getHistoriesJsonFile(tempDir.path);
    if (file != null) await Utils.share(ShareParams(files: [XFile(file.path)]));
  }

  static Future<void> exportHistoriesToJson() async {
    if (_historyItemBox.isEmpty()) return Utils.showToast(AppLocale.labelHistoryEmpty.s);
    final Directory? directory = await getDownloadsDirectory();
    final String? directoryPath = await FilePicker.platform.getDirectoryPath(initialDirectory:directory?.path);
    if (directoryPath == null) {
      return Utils.showToast('${AppLocale.cancelLabel.s}\nUnable to get storage directory.');
    }
    final File? file = await _getHistoriesJsonFile(directoryPath);
    if (file != null) {
      Utils.showToast('${AppLocale.snackBarMessageFileExportSuccess.s}\n${file.path}');
    } else {
      Utils.showToast(AppLocale.snackBarMessageFileExportError.s);
    }
  }

  static Future<File?> _getHistoriesJsonFile(String directory) async {
    try {
      if (_historyItemBox.isEmpty()) return null;
      final String jsonString = jsonEncode(getItems());
      final DateTime now = DateTime.now();
      final String formattedDateTime = DateFormat('yyyyMMdd-HH-mm').format(now);
      final String filePath = p.join(directory, 'qr_$formattedDateTime.json');
      final File file = File(filePath);
      await file.writeAsString(jsonString);
      return file;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<void> importHistoriesFromJson() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) {
        Utils.showToast(AppLocale.cancelLabel.s);
        return;
      } else if (!result.files.single.path!.endsWith('.json')) {
        Utils.showToast('Error: Not .json file');
        return;
      }

      final File file = File(result.files.single.path!);
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      int added = 0;
      int replaced = 0;

      final Map<int, HistoryItem> itemsToProcess = {};
      for (final itemJson in jsonData) {
        final HistoryItem historyItem = HistoryItem.fromJson(itemJson);
        itemsToProcess[historyItem.unixTime] = historyItem;
      }
      final query = _historyItemBox
          .query(HistoryItem_.unixTime.oneOf(itemsToProcess.keys.toList()))
          .build();
      final Map<int, int> existingTimeKeyMap = {
        for (final queryItem in query.find())
          queryItem.unixTime: queryItem.id,
      };
      query.close();
      for (final item in itemsToProcess.values) {
        final searchId = existingTimeKeyMap[item.unixTime];
        if (searchId != null) {
          item.id = searchId;
          replaced += 1;
        } else {
          added += 1;
        }
      }
      _historyItemBox.putMany(itemsToProcess.values.toList());
      final String endTip = '${AppLocale.snackBarMessageFileImportSuccess.s}'
          '\nTotal ${jsonData.length} Items, Added: $added, Replaced: $replaced';
      Utils.showToast(endTip, true);
    } catch (e) {
      Utils.showToast('${AppLocale.snackBarMessageFileImportError.s}\n$e', true);
    }
  }
}
