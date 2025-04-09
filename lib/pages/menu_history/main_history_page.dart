import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:watashi_qr/common/hive_storage.dart';
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
  final List<dynamic> _selectedKeys = [];

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

  void _sortSelectedKeys() {
    _selectedKeys.sort((a, b) => b.compareTo(a));
    _selectedKeys.sort((a, b) {
      final itemA = HiveStorage.getItem(a);
      final itemB = HiveStorage.getItem(b);
      if (itemA==null || itemB==null){
        return 0;
      } else if (itemA.isFavorite && !itemB.isFavorite) {
        return -1;
      } else if (!itemA.isFavorite && itemB.isFavorite) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
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
          valueListenable: HiveStorage.histories.listenable(),
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
                      HiveStorage.deleteItemList(_selectedKeys);
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
                String combinedText = '';
                _sortSelectedKeys();
                for (dynamic key in _selectedKeys) {
                  final item = HiveStorage.getItem(key);
                  if (item != null) combinedText += '${item.contents}\n';
                }
                Clipboard.setData(ClipboardData(text: combinedText));
                Utils.showToast(localeStr.barcodeCopiedLabel);
                _exitSelectionMode();
              },
            ),
            CustomMenuButton(
              labelList: [localeStr.menuItemHistoryAddFavorite, localeStr.menuItemHistoryRemoveFavorite],
              onSelectedEnd: (int option) {
                for (dynamic key in _selectedKeys){
                  HistoryItem? item = HiveStorage.getItem(key);
                  if (item == null) continue;
                  item.isFavorite = (option == 0);
                  HiveStorage.updateItem(key, item);
                }
                _exitSelectionMode();
              },
            ),
          ] else ...[
            CustomMenuButton(
              icon: const Icon(Icons.swap_vert),
              labelList: [localeStr.exportJsonLabel, localeStr.importJsonLabel],
              onSelectedList: [
                () => HiveStorage.exportHistoriesToJson(localeStr),
                () => HiveStorage.importHistoriesFromJson(localeStr),
              ],
              onSelectedEnd: _exitSelectionMode,
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
                      HiveStorage.clearHistories();
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ValueListenableBuilder(
            valueListenable: HiveStorage.histories.listenable(),
            builder: (context, Box box, _) {
              List<HistoryItem> historiesList = HiveStorage.getReversedList();
              if (historiesList.isEmpty) return Center(child: Text(localeStr.labelHistoryEmpty));
              historiesList.sort((a, b) {
                if (a.isFavorite && !b.isFavorite) {
                  return -1;
                } else if (!a.isFavorite && b.isFavorite) {
                  return 1;
                } else {
                  return 0;
                }
              });
              return ListView.builder(
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
        )
      ))
    );
  }

}