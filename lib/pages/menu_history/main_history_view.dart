import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watashi_qr/common/drift_database.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_history/main_history_card.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/widget/my_menu_button.dart';
import 'package:watashi_qr/pages/widget/overlay_show.dart';
import 'package:watashi_qr/pages/widget/selection_mixin.dart';

class MainHistoryView extends StatefulWidget {
  const MainHistoryView({super.key});

  @override
  State<MainHistoryView> createState() => _MainHistoryViewState();
}

class _MainHistoryViewState extends State<MainHistoryView>
    with SelectionMixin<String> {
  final ScrollController _scrollController = ScrollController();
  late final StreamSubscription<List<HistoryItem>> _historySubscription;
  var _histories = const <HistoryItem>[];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _historySubscription = DriftService.appDb.dao.queryStream().listen(
      (data) => setState(() {
        _histories = data;
        _isLoading = false;
        _errorMessage = null;
      }),
      onError: (e) => setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _historySubscription.cancel();
    _scrollController.dispose();
  }

  Future<void> _pressSelectedDelete() async {
    await DriftService.appDb.dao.removeMany(selectedObjects);
    exitSelectionMode();
    Navigator.pop(context);
    Utils.showToast(DictKey.historyStatusRemoved.s);
  }

  Future<void> _pressSelectedCopy() async {
    final String combinedText = _histories
        .where((item) => selectedObjects.contains(item.uuid))
        .map((item) => item.contents)
        .join('\n');
    await Clipboard.setData(ClipboardData(text: combinedText));
    exitSelectionMode();
    Utils.showToast(DictKey.commonUiCopied.s);
  }

  Future<void> _pressSelectedFavorite(int option) async {
    await DriftService.appDb.dao.upsertMany([
      for (final item in _histories)
        if (selectedObjects.contains(item.uuid))
          item.copyWith(isFavorite: option == 0),
    ]);
    exitSelectionMode();
  }

  Future<void> _pressDeleteAll() async {
    await DriftService.appDb.dao.removeAll();
    Navigator.pop(context);
    Utils.showToast(DictKey.historyStatusRemoved.s);
  }

  Future<void> _tapShareJson() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final File file = await DriftService.exportJson(tempDir.path);
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } catch (e) {
      Utils.showToast('${DictKey.historyDataExportError.s}  $e');
    }
  }

  Future<void> _tapExportJson() async {
    try {
      final Directory? downloadsDir = await getDownloadsDirectory();
      final String? dirPath = await FilePicker.getDirectoryPath(
        initialDirectory: downloadsDir?.path,
      );
      if (dirPath == null) {
        Utils.showToast(
          '${DictKey.commonUiCancel.s}  Unable to get storage directory.',
        );
        return;
      }
      final File file = await DriftService.exportJson(dirPath);
      Utils.showToast('${DictKey.historyDataExportSuccess.s}  ${file.path}');
    } catch (e) {
      Utils.showToast('${DictKey.historyDataExportError.s}  $e');
    }
  }

  Future<void> _tapImportJson() async {
    try {
      final PlatformFile? result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['json'],
      );
      if (result == null) {
        await Utils.showToast(DictKey.commonUiCancel.s);
        return;
      }
      final String jsonString = await result.xFile.readAsString();
      final (totLen, repLen) = await DriftService.importJson(jsonString);
      await Utils.showToast(
        '${DictKey.historyDataImportSuccess.s}  '
        'Total:$totLen, Added:${totLen - repLen}, Replaced:$repLen',
        true,
      );
    } catch (e) {
      await Utils.showToast('${DictKey.historyDataImportError.s}  $e', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    DictKey.load(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSelectionMode
            ? Theme.of(context).colorScheme.inversePrimary
            : null,
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: exitSelectionMode,
              )
            : null,
        title: isSelectionMode
            ? Text('${selectedObjects.length}/${_histories.length}')
            : Text('${_histories.length}'),
        actions: isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () => OverlayShow.dialog(
                    context: context,
                    title: DictKey.commonLabelDelete.s,
                    content: Text(DictKey.historyDialogDeleteSelected.s),
                    actions: [
                      TextButton(
                        onPressed: _pressSelectedDelete,
                        child: Text(DictKey.commonLabelDelete.s),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  onPressed: _pressSelectedCopy,
                ),
                MyMenuButton(
                  items: [
                    MyMenuItem(text: DictKey.historyMenuFavAdd.s),
                    MyMenuItem(text: DictKey.historyMenuFavRemove.s),
                  ],
                  onSelectedEnd: _pressSelectedFavorite,
                ),
              ]
            : [
                MyMenuButton(
                  icon: const Icon(Icons.swap_vert),
                  items: [
                    MyMenuItem(
                      text: DictKey.historyDataShareJson.s,
                      onTap: _tapShareJson,
                    ),
                    MyMenuItem(
                      text: DictKey.historyDataExportJson.s,
                      onTap: _tapExportJson,
                    ),
                    MyMenuItem(
                      text: DictKey.historyDataImportJson.s,
                      onTap: _tapImportJson,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () => OverlayShow.dialog(
                    context: context,
                    title: DictKey.commonLabelDelete.s,
                    content: Text(DictKey.historyDialogDeleteAll.s),
                    actions: [
                      TextButton(
                        onPressed: _pressDeleteAll,
                        child: Text(DictKey.commonLabelDelete.s),
                      ),
                    ],
                  ),
                ),
              ],
      ),
      body: SafeArea(
        bottom: false,
        child: Scrollbar(
          controller: _scrollController,
          child: Builder(
            builder: (context) {
              if (_isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (_errorMessage != null) {
                return Center(child: Text(_errorMessage!));
              } else if (_histories.isEmpty) {
                return Center(child: Text(DictKey.historyStatusEmpty.s));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 16.0),
                controller: _scrollController,
                itemCount: _histories.length,
                itemBuilder: (context, index) {
                  final HistoryItem item = _histories[index];
                  return MainHistoryCard(
                    historyItem: item,
                    selected: selectedObjects.contains(item.uuid),
                    onTap: isSelectionMode
                        ? () => toggleSelection(item.uuid)
                        : () => context.routeOf<PageItemView>().toPass(item),
                    onLongPress: () => enterSelectionMode(item.uuid),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
