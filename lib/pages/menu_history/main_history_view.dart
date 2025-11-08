import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watashi_qr/common/database_services.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/widget/functions.dart';
import 'package:watashi_qr/pages/widget/my_menu_button.dart';
import 'package:watashi_qr/pages/menu_history/main_history_card.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/widget/selection_mixin.dart';

class MainHistoryView extends StatefulWidget {
  const MainHistoryView({super.key});

  @override
  State<MainHistoryView> createState() => _MainHistoryViewState();
}

class _MainHistoryViewState extends State<MainHistoryView> with SelectionMixin<MainHistoryView, int> {
  final ScrollController _scrollController = ScrollController();
  final List<HistoryItem> _historyItems = [];
  @override
  Widget build(BuildContext context) {
    AppLocale.load(context);
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
        title: isSelectionMode
            ? Text('${selectedObjects.length}/${_historyItems.length}')
            : Text('${_historyItems.length}'),
        actions: [
          if (isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => showMyDialog(
                context: context,
                titleStr: AppLocale.deleteLabel.s,
                content: Text(AppLocale.popupMessageConfirmationDeleteSelectedItemsHistory.s),
                actions: [
                  TextButton(
                    child: Text(AppLocale.deleteLabel.s),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseServices.deleteItems(selectedObjects.toList());
                      Utils.showToast(AppLocale.menuItemHistoryRemovedFromHistory.s);
                      exitSelectionMode();
                    },
                  ),
                ]
              ),
            ),
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () {
                final List<HistoryItem> items = DatabaseServices.getReversedList(
                  sortF: true,
                  list: DatabaseServices.getItems(selectedObjects),
                );
                final String combinedText = items.map((item) => item.contents).join('\n');
                Clipboard.setData(ClipboardData(text: combinedText));
                Utils.showToast(AppLocale.barcodeCopiedLabel.s);
                exitSelectionMode();
              },
            ),
            MyMenuButton(
              optionMap: {
                AppLocale.menuItemHistoryAddFavorite.s: null,
                AppLocale.menuItemHistoryRemoveFavorite.s: null,
              },
              onSelectedEnd: (int option) {
                for (final key in selectedObjects){
                  final HistoryItem? item = DatabaseServices.getItem(key);
                  if (item == null) continue;
                  item.isFavorite = (option == 0);
                  DatabaseServices.updateItem(key, item);
                }
                exitSelectionMode();
              },
            ),
          ] else ...[
            MyMenuButton(
              icon: const Icon(Icons.swap_vert),
              optionMap: {
                AppLocale.shareJsonLabel.s: () => DatabaseServices.shareHistoriesToJson(),
                AppLocale.exportJsonLabel.s: () => DatabaseServices.exportHistoriesToJson(),
                AppLocale.importJsonLabel.s: () => DatabaseServices.importHistoriesFromJson(),
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => showMyDialog(
                context: context,
                titleStr: AppLocale.deleteLabel.s,
                content: Text(AppLocale.popupMessageConfirmationDeleteHistory.s),
                actions: [
                  TextButton(
                    child: Text(AppLocale.deleteLabel.s),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseServices.clearHistories();
                      Utils.showToast(AppLocale.menuItemHistoryRemovedFromHistory.s);
                    },
                  ),
                ]
              ),
            ),
          ],
        ],
      ),

      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          child: StreamBuilder<List<HistoryItem>>(
              stream: DatabaseServices.historyItemStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('snapshot.hasData:${snapshot.hasData}\nsnapshot.data:snapshot.data'));
              }
              _historyItems.clear();
              _historyItems.addAll(snapshot.data!);
              if (_historyItems.isEmpty) return Center(child: Text(AppLocale.labelHistoryEmpty.s));
              return ListView.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                padding: const EdgeInsets.all(4.0),
                controller: _scrollController,
                itemCount: _historyItems.length,
                itemBuilder: (context, index) {
                  final item = _historyItems[index];
                  final id = item.id;
                  return MainHistoryCard(
                    historyItem: item,
                    selected: selectedObjects.contains(id),
                    onTap: () {
                      if (isSelectionMode) {
                        toggleSelection(id);
                      } else {
                        context.routeOf<PageItemView>().arguments(item).to();
                      }
                    },
                    onLongPress: () => enterSelectionMode(id),
                  );
                },
              );
            }
          ),
        )
      )
    );
  }
}