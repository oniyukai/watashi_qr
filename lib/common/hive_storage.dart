import 'package:hive_flutter/hive_flutter.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HiveStorage {
  HiveStorage._();

  static late Box<HistoryItem> histories;

  static Future<void> hiveInit() async {
    await Hive.initFlutter('${(await getApplicationSupportDirectory()).path}/hive');
    Hive.registerAdapter(HistoryItemAdapter());
    histories = await Hive.openBox<HistoryItem>('histories');
  }
  static Future<void> hiveClose() async {
    Hive.close();
  }

  // histories_helper.dart

  static Future<int> addItem(
      HistoryItem item, {
        BuildContext? context,
        bool? isDuplicatedEnabled,
      }
  ) async {
    bool isHistoryDuplicatedEnabled = (context==null)
      ? true
      : context.read<SettingsProvider>().isHistoryDuplicatedEnabled;
    isHistoryDuplicatedEnabled = isDuplicatedEnabled ?? isHistoryDuplicatedEnabled;
    if (isHistoryDuplicatedEnabled == true) return await histories.add(item);

    final List<HistoryItem> historiesList = getReversedList();
    historiesList.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) {
        return -1;
      } else if (!a.isFavorite && b.isFavorite) {
        return 1;
      } else {
        return 0;
      }
    });
    int latestDuplicateIndex = historiesList.indexWhere((e) =>
      (e.formatName==item.formatName) && (e.contents==item.contents)
    );
    if (latestDuplicateIndex==-1) {
      return await histories.add(item);
    } else {
      item.isFavorite = historiesList[latestDuplicateIndex].isFavorite;
      item.notes = historiesList[latestDuplicateIndex].notes;
      deleteItem(historiesList[latestDuplicateIndex].key);
      return await histories.add(item);
    }
  }

  static List<HistoryItem> getReversedList() {
    return histories.values.toList().reversed.toList();
  }

  static HistoryItem? getItem(dynamic key) {
    return histories.get(key);
  }

  static bool containsTime(int unixTime) {
    final List<int> unixTimeList = histories.values.map((value) => value.unixTime).toList();
    return (unixTimeList.contains(unixTime)) ? true : false;
  }

  static Future<void> updateItem(dynamic key, HistoryItem item) async {
    await histories.put(key, item);
  }

  static Future<void> deleteItem(dynamic key) async {
    await histories.delete(key);
  }

  static Future<void> deleteItemList(Iterable<dynamic> keys) async {
    await histories.deleteAll(keys);
  }

  static Future<int> clearHistories() async {
    return await histories.clear();
  }

  static Future<void> sortHistories() async {
    List<HistoryItem> historyItemList = histories.values.toList();
    historyItemList.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    await clearHistories();
    await histories.addAll(historyItemList);
    Utils.showToast('Histories Sorting has been rearranged!');
  }

  static Future<void> exportHistoriesToJson(Language localeStr) async {
    try {
      final List<HistoryItem> historiesList = getReversedList();
      if (historiesList.isEmpty) {
        Utils.showToast(localeStr.labelHistoryEmpty);
        return;
      }
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('yyyyMMdd-HH-mm').format(now);
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      Directory? directory = await getExternalStorageDirectory();
      late String initialDirectory;
      if (directory != null) initialDirectory = directory.path;
      String? directoryPath = await FilePicker.platform.getDirectoryPath(initialDirectory:initialDirectory);
      if (directoryPath == null) {
        Utils.showToast('${localeStr.cancelLabel}\nUnable to get storage directory.');
        return;
      }
      String filePath = '$directoryPath/WTSqr_$formattedDateTime.json';
      List<Map<String, dynamic>> jsonList = historiesList.map((item) => item.toJson()).toList();
      String jsonString = jsonEncode(jsonList);
      File file = File(filePath);
      await file.writeAsString(jsonString);
      Utils.showToast('${localeStr.snackBarMessageFileExportSuccess}\n$filePath', 8);
    } catch (e) {
      Utils.showToast('${localeStr.snackBarMessageFileExportError}\n$e', 8);
    }
  }

  static Future<void> importHistoriesFromJson(Language localeStr) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null) {
        Utils.showToast(localeStr.cancelLabel);
        return;
      }

      final File file = File(result.files.single.path!);
      final String jsonString = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(jsonString);
      int added = 0;
      int replaced = 0;

      Map<int, dynamic> timeKeyMap = histories.toMap().map((key, value) {
        return MapEntry(value.unixTime, key);
      }); // timeKeyMap的key, value要是相反的，使用要注意

      for (var item in jsonData) {
        final HistoryItem historyItem = HistoryItem.fromJson(item);
        if (timeKeyMap.keys.contains(historyItem.unixTime)) {
          await updateItem(timeKeyMap[historyItem.unixTime], historyItem);
          replaced++;
        } else {
          int historyItemKey = await addItem(historyItem);
          added++;
          timeKeyMap[historyItem.unixTime] = historyItemKey;
        }
      }

      String endTip = localeStr.snackBarMessageFileImportSuccess;
      endTip += '\nTotal ${jsonData.length} Items, Added: $added, Replaced: $replaced';
      Utils.showToast(endTip, 8);
      sortHistories();
    } catch (e) {
      Utils.showToast('${localeStr.snackBarMessageFileImportError}\n$e', 16);
    }
  }

}
