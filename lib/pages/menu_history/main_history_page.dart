import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/pages/widgets/custom_menu_button.dart';
import 'package:watashi_qr/pages/widgets/history_item_card.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_history/item_view.dart';
import 'package:watashi_qr/pages/widgets/settings_page_widgets.dart';

class MainHistoryPage extends StatefulWidget {
  const MainHistoryPage({super.key});

  @override
  State<MainHistoryPage> createState() => _MainHistoryPageState();
}

class _MainHistoryPageState extends State<MainHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isSelectionMode = false;
  final Set<dynamic> _selectedKeys = <dynamic>{};

  void _enterSelectionMode(dynamic key) {
    if (_isSelectionMode == true) {
      _toggleSelection(key);
    } else {
      setState(() {
        _isSelectionMode = true;
        _selectedKeys.add(key);
      });
    }
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedKeys.clear();
    });
  }

  void _toggleSelection(dynamic key) {
    setState(() {
      if (_selectedKeys.contains(key)) {
        _selectedKeys.remove(key);
        if (_selectedKeys.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedKeys.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _isSelectionMode
          ? colorScheme.primary.withValues(alpha:0.25)
          : null,
        leading: _isSelectionMode
          ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _exitSelectionMode,
          )
          : null,
        title: ValueListenableBuilder(
          valueListenable: HiveService.getListenable,
          builder: (context, Box box, _) {
            return _isSelectionMode
              ? Text('${_selectedKeys.length}/${box.length}')
              : Text('${box.length}');
          }
        ),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => genericAlertDialog(
                context: context,
                titleStr: localeStr.deleteLabel,
                content: Text(localeStr.popupMessageConfirmationDeleteSelectedItemsHistory),
                actions: [
                  TextButton(
                    child: Text(localeStr.deleteLabel),
                    onPressed: () {
                      Navigator.of(context).pop();
                      HiveService.deleteItems(_selectedKeys);
                      Utils.showToast(localeStr.menuItemHistoryRemovedFromHistory);
                      _exitSelectionMode();
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
                  list: HiveService.getItems(_selectedKeys),
                );
                final String combinedText = items.map((item) => item.contents).join('\n');
                Clipboard.setData(ClipboardData(text: combinedText));
                Utils.showToast(localeStr.barcodeCopiedLabel);
                _exitSelectionMode();
              },
            ),
            CustomMenuButton(
              labelList: [localeStr.menuItemHistoryAddFavorite, localeStr.menuItemHistoryRemoveFavorite],
              onSelectedEnd: (int option) {
                for (final key in _selectedKeys){
                  final HistoryItem? item = HiveService.getItem(key);
                  if (item == null) continue;
                  item.isFavorite = (option == 0);
                  HiveService.updateItem(key, item);
                }
                _exitSelectionMode();
              },
            ),
          ] else ...[
            CustomMenuButton(
              icon: const Icon(Icons.swap_vert),
              labelList: [localeStr.shareJsonLabel, localeStr.exportJsonLabel, localeStr.importJsonLabel],
              onSelectedList: [
                () => HiveService.shareHistoriesToJson(localeStr),
                () => HiveService.exportHistoriesToJson(localeStr),
                () => HiveService.importHistoriesFromJson(localeStr),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => genericAlertDialog(
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
                      // setState( (){} );
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
                return HistoryItemCard(
                  historyItem: item,
                  selected: _selectedKeys.contains(key),
                  onTap: () {
                    if (_isSelectionMode) {
                      _toggleSelection(key);
                    } else {
                      context.routeOf<ItemView>().arguments(item).to();
                    }
                  },
                  onLongPress: () => _enterSelectionMode(key),
                );
              },
            );
          }
        ),
      ))
    );
  }
}