import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/pages/widget/functions.dart';
import 'package:watashi_qr/pages/widget/my_menu_button.dart';
import 'package:watashi_qr/pages/menu_history/main_history_card.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/widget/selection_mixin.dart';

class MainHistoryView extends StatefulWidget {
  const MainHistoryView({super.key});

  @override
  State<MainHistoryView> createState() => _MainHistoryViewState();
}

class _MainHistoryViewState extends State<MainHistoryView> with SelectionMixin<MainHistoryView, dynamic> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSelectionMode
          ? colorScheme.primary.withValues(alpha:0.25)
          : null,
        leading: isSelectionMode
          ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: exitSelectionMode,
          )
          : null,
        title: ValueListenableBuilder(
          valueListenable: HiveService.getListenable,
          builder: (context, Box box, _) {
            return isSelectionMode
              ? Text('${selectedObjects.length}/${box.length}')
              : Text('${box.length}');
          }
        ),
        actions: [
          if (isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => showMyDialog(
                context: context,
                titleStr: localeStr.deleteLabel,
                content: Text(localeStr.popupMessageConfirmationDeleteSelectedItemsHistory),
                actions: [
                  TextButton(
                    child: Text(localeStr.deleteLabel),
                    onPressed: () {
                      Navigator.of(context).pop();
                      HiveService.deleteItems(selectedObjects);
                      Utils.showToast(localeStr.menuItemHistoryRemovedFromHistory);
                      exitSelectionMode();
                    },
                  ),
                ]
              ),
            ),
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () {
                final List<HistoryItem> items = HiveService.getReversedList(
                  sortF: true,
                  list: HiveService.getItems(selectedObjects),
                );
                final String combinedText = items.map((item) => item.contents).join('\n');
                Clipboard.setData(ClipboardData(text: combinedText));
                Utils.showToast(localeStr.barcodeCopiedLabel);
                exitSelectionMode();
              },
            ),
            MyMenuButton(
              optionMap: {
                localeStr.menuItemHistoryAddFavorite: null,
                localeStr.menuItemHistoryRemoveFavorite: null,
              },
              onSelectedEnd: (int option) {
                for (final key in selectedObjects){
                  final HistoryItem? item = HiveService.getItem(key);
                  if (item == null) continue;
                  item.isFavorite = (option == 0);
                  HiveService.updateItem(key, item);
                }
                exitSelectionMode();
              },
            ),
          ] else ...[
            MyMenuButton(
              icon: const Icon(Icons.swap_vert),
              optionMap: {
                localeStr.shareJsonLabel: () => HiveService.shareHistoriesToJson(localeStr),
                localeStr.exportJsonLabel: () => HiveService.exportHistoriesToJson(localeStr),
                localeStr.importJsonLabel: () => HiveService.importHistoriesFromJson(localeStr),
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => showMyDialog(
                context: context,
                titleStr: localeStr.deleteLabel,
                content: Text(localeStr.popupMessageConfirmationDeleteHistory),
                actions: [
                  TextButton(
                    child: Text(localeStr.deleteLabel),
                    onPressed: () {
                      Navigator.of(context).pop();
                      HiveService.clearHistories();
                      Utils.showToast(localeStr.menuItemHistoryRemovedFromHistory);
                    },
                  ),
                ]
              ),
            ),
          ],
        ],
      ),

      body: SafeArea(child: Scrollbar(
        controller: _scrollController,
        child: ValueListenableBuilder(
          valueListenable: HiveService.getListenable,
          builder: (context, Box box, _) {
            final List<HistoryItem> historiesList = HiveService.getReversedList(sortF: true);
            if (historiesList.isEmpty) return Center(child: Text(localeStr.labelHistoryEmpty));
            return ListView.builder(
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              padding: const EdgeInsets.all(4.0),
              controller: _scrollController,
              itemCount: historiesList.length,
              itemBuilder: (context, index) {
                final item = historiesList[index];
                final key = item.key;
                return MainHistoryCard(
                  historyItem: item,
                  selected: selectedObjects.contains(key),
                  onTap: () {
                    if (isSelectionMode) {
                      toggleSelection(key);
                    } else {
                      context.routeOf<PageItemView>().arguments(item).to();
                    }
                  },
                  onLongPress: () => enterSelectionMode(key),
                );
              },
            );
          }
        ),
      ))
    );
  }
}