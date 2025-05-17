import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:intl/intl.dart';

class HiveService {
  const HiveService._();

  static late Box<HistoryItem> _histories;

  static Future<void> hiveInit() async {
    await Hive.initFlutter('${(await getApplicationSupportDirectory()).path}/hive');
    Hive.registerAdapter(HistoryItemAdapter());
    _histories = await Hive.openBox<HistoryItem>('histories');
  }
  static Future<void> hiveClose() async {
    await Hive.close();
  }

  static ValueListenable<Box<HistoryItem>> get getListenable => _histories.listenable();

  static Future<int> addItem(
      HistoryItem item, {
        BuildContext? context,
        bool? isDuplicatedEnabled,
      }
  ) async {
    bool isHistoryDuplicatedEnabled = (context==null)
      ? true : context.readSettings.isSaveDuplicates;
    isHistoryDuplicatedEnabled = isDuplicatedEnabled ?? isHistoryDuplicatedEnabled;
    if (isHistoryDuplicatedEnabled == true) return await _histories.add(item);

    final List<HistoryItem> historiesList = getReversedList(sortF: true);
    final int latestDuplicateIndex = historiesList.indexWhere((e) =>
      (e.format==item.format) && (e.contents==item.contents)
    );
    if (latestDuplicateIndex==-1) {
      return await _histories.add(item);
    } else {
      item.isFavorite = historiesList[latestDuplicateIndex].isFavorite;
      item.notes = historiesList[latestDuplicateIndex].notes;
      deleteItem(historiesList[latestDuplicateIndex].key);
      return await _histories.add(item);
    }
  }

  static List<HistoryItem> getReversedList({
    bool sortF = false,
    List<HistoryItem>? list }) {
    final List<HistoryItem> historiesList = (list == null)
        ? _histories.values.toList().reversed.toList()
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

  static HistoryItem? getItem(dynamic key) {
    return _histories.get(key);
  }

  static List<HistoryItem> getItems(Iterable<dynamic> keys) {
    final List<HistoryItem> historiesList = <HistoryItem>[];
    for (final key in keys) {
      final value = getItem(key);
      if (value != null) historiesList.add(value);
    }
    return historiesList;
  }

  static bool containsTime(int unixTime) {
    final List<int> unixTimeList = _histories.values.map((value) => value.unixTime).toList();
    return (unixTimeList.contains(unixTime)) ? true : false;
  }

  static Future<void> updateItem(dynamic key, HistoryItem item) async {
    await _histories.put(key, item);
  }

  static Future<void> deleteItem(dynamic key) async {
    await _histories.delete(key);
  }

  static Future<void> deleteItems(Iterable<dynamic> keys) async {
    await _histories.deleteAll(keys);
  }

  static Future<int> clearHistories() async {
    return await _histories.clear();
  }

  static Future<void> sortHistories() async {
    final List<HistoryItem> historyItemList = _histories.values.toList();
    historyItemList.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    await clearHistories();
    await _histories.addAll(historyItemList);
    Utils.showToast('Histories Sorting has been rearranged!');
  }

  static Future<void> shareHistoriesToJson(Language localeStr) async {
    if (_histories.values.isEmpty) {
      return Utils.showToast(localeStr.labelHistoryEmpty);
    }
    final Directory tempDir = await getTemporaryDirectory();
    final File? file = await _getHistoriesJsonFile(tempDir.path);
    if (file != null) await Utils.share(ShareParams(files: [XFile(file.path)]));
  }

  static Future<void> exportHistoriesToJson(Language localeStr) async {
    if (_histories.values.isEmpty) {
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

      final Map<int, dynamic> timeKeyMap = _histories.toMap().map((key, value) {
        return MapEntry(value.unixTime, key);
      }); // timeKeyMap的key, value要是相反的，使用要注意

      for (final item in jsonData) {
        final HistoryItem historyItem = HistoryItem.fromJson(item);
        if (timeKeyMap.keys.contains(historyItem.unixTime)) {
          await updateItem(timeKeyMap[historyItem.unixTime], historyItem);
          replaced++;
        } else {
          final int historyItemKey = await addItem(historyItem);
          added++;
          timeKeyMap[historyItem.unixTime] = historyItemKey;
        }
      }

      String endTip = localeStr.snackBarMessageFileImportSuccess;
      endTip += '\nTotal ${jsonData.length} Items, Added: $added, Replaced: $replaced';
      Utils.showToast(endTip, true);
      sortHistories();
    } catch (e) {
      Utils.showToast('${localeStr.snackBarMessageFileImportError}\n$e', true);
    }
  }
}
