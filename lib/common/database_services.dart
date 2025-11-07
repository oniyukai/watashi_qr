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
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';
import 'package:intl/intl.dart';

class DatabaseServices {

  static late Store _store;
  static late final Box<HistoryItem> _historyItemBox;

  static Future<void> hiveInit() async {
    final dir = await getApplicationSupportDirectory();
    _store = await openStore(directory: p.join(dir.path, 'objectbox'));
    _historyItemBox = _store.box<HistoryItem>();
  }

  static void dispose() => _store.close();

  static Stream<List<HistoryItem>> get historyItemStream =>
      _historyItemBox.query()
          .order(HistoryItem_.unixTime, flags: Order.descending)
          .watch(triggerImmediately: true)
          .map((query) => query.find());

  static int addItem(
      HistoryItem item, {
      BuildContext? context,
      bool? isDuplicatedEnabled,})
  {
    assert(item.id == 0);
    bool isHistoryDuplicatedEnabled = (context==null)
      ? true : context.readSettings.isSaveDuplicates;
    isHistoryDuplicatedEnabled = isDuplicatedEnabled ?? isHistoryDuplicatedEnabled;
    if (isHistoryDuplicatedEnabled == true) return _historyItemBox.put(item);

    final List<HistoryItem> historiesList = getReversedList(sortF: true);
    final int latestDuplicateIndex = historiesList.indexWhere((e) =>
      (e.format==item.format) && (e.contents==item.contents)
    );
    if (latestDuplicateIndex==-1) {
      return _historyItemBox.put(item);
    } else {
      item.isFavorite = historiesList[latestDuplicateIndex].isFavorite;
      item.notes = historiesList[latestDuplicateIndex].notes;
      deleteItem(historiesList[latestDuplicateIndex].id);
      return _historyItemBox.put(item);
    }
  }

  static List<HistoryItem> getReversedList({
    bool sortF = false,
    List<HistoryItem>? list }) {
    final List<HistoryItem> historiesList = (list == null)
        ? _historyItemBox.getAll()
        : <HistoryItem>[...list];
    historiesList.sort((a, b) {
      if (sortF && a.isFavorite && !b.isFavorite) {
        return -1;
      } else if (sortF && !a.isFavorite && b.isFavorite) {
        return 1;
      } else if (a.unixTime > b.unixTime) {
        return -1;
      } else if (a.unixTime < b.unixTime) {
        return 1;
      }
      return 0;
    });
    return historiesList;
  }

  static HistoryItem? getItem(int id) => _historyItemBox.get(id);

  static List<HistoryItem> getItems(Iterable<int> ids) {
    final List<HistoryItem> historiesList = <HistoryItem>[];
    for (final key in ids) {
      final value = getItem(key);
      if (value != null) historiesList.add(value);
    }
    return historiesList;
  }

  static bool containsTime(int unixTime) {
    final List<int> unixTimeList = _historyItemBox.getAll().map((value) => value.unixTime).toList();
    return (unixTimeList.contains(unixTime)) ? true : false;
  }

  static void updateItem(int id, HistoryItem item) => _historyItemBox.put(item);

  static void deleteItem(int id) => _historyItemBox.remove(id);

  static int deleteItems(List<int> ids) => _historyItemBox.removeMany(ids);

  static int clearHistories() => _historyItemBox.removeAll();

  static Future<void> shareHistoriesToJson(Language localeStr) async {
    if (_historyItemBox.isEmpty()) {
      return Utils.showToast(localeStr.labelHistoryEmpty);
    }
    final Directory tempDir = await getTemporaryDirectory();
    final File? file = await _getHistoriesJsonFile(tempDir.path);
    if (file != null) await Utils.share(ShareParams(files: [XFile(file.path)]));
  }

  static Future<void> exportHistoriesToJson(Language localeStr) async {
    if (_historyItemBox.isEmpty()) {
      return Utils.showToast(localeStr.labelHistoryEmpty);
    }
    final Directory? directory = await getDownloadsDirectory();
    final String? directoryPath = await FilePicker.platform.getDirectoryPath(initialDirectory:directory?.path);
    if (directoryPath == null) {
      return Utils.showToast('${localeStr.cancelLabel}\nUnable to get storage directory.');
    }
    final File? file = await _getHistoriesJsonFile(directoryPath);
    if (file != null) {
      Utils.showToast('${localeStr.snackBarMessageFileExportSuccess}\n${file.path}');
    } else {
      Utils.showToast(localeStr.snackBarMessageFileExportError);
    }
  }

  static Future<File?> _getHistoriesJsonFile(String directory) async {
    try {
      final List<HistoryItem> historiesList = getReversedList();
      if (historiesList.isEmpty) return null;
      final List<Map<String, dynamic>> jsonList = historiesList.map((item) => item.toJson()).toList();
      final String jsonString = jsonEncode(jsonList);
      final DateTime now = DateTime.now();
      final String formattedDateTime = DateFormat('yyyyMMdd-HH-mm').format(now);
      final String filePath = '$directory/qr_$formattedDateTime.json';
      final File file = File(filePath);
      await file.writeAsString(jsonString);
      return file;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<void> importHistoriesFromJson(Language localeStr) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) {
        Utils.showToast(localeStr.cancelLabel);
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

      final Map<int, int> timeKeyMap = Map.fromIterable(
          _historyItemBox.getAll(),
          key: (item)=>item.unixTime,
          value: (item)=>item.id
      ); // timeKeyMap的key, value要是相反的，使用要注意

      for (final item in jsonData) {
        final HistoryItem historyItem = HistoryItem.fromJson(item);
        if (timeKeyMap.keys.contains(historyItem.unixTime)) {
          updateItem(timeKeyMap[historyItem.unixTime]!, historyItem);
          replaced++;
        } else {
          final int historyItemKey = addItem(historyItem);
          added++;
          timeKeyMap[historyItem.unixTime] = historyItemKey;
        }
      }

      String endTip = localeStr.snackBarMessageFileImportSuccess;
      endTip += '\nTotal ${jsonData.length} Items, Added: $added, Replaced: $replaced';
      Utils.showToast(endTip, true);
    } catch (e) {
      Utils.showToast('${localeStr.snackBarMessageFileImportError}\n$e', true);
    }
  }
}
