import 'dart:async';
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
  late final StreamSubscription<List<HistoryItem>> _historySubscription;
  List<HistoryItem> _historyItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _historySubscription = DatabaseServices.historyItemsStream.listen(
      (data) {
        setState(() {
          _historyItems = data;
          _isLoading = false;
          _errorMessage = null;
        });
      },
      onError: (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    _historySubscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }

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
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () {
                final List<HistoryItem> items = DatabaseServices.getItems(selectedObjects.toList());
                final String combinedText = items.map((item) => item.contents).join('\n');
                Clipboard.setData(ClipboardData(text: combinedText));
                Utils.showToast(AppLocale.barcodeCopiedLabel.s);
                exitSelectionMode();
              },
            ),
            MyMenuButton(
              items: [
                MyMenuItem(text: AppLocale.menuItemHistoryAddFavorite.s),
                MyMenuItem(text: AppLocale.menuItemHistoryRemoveFavorite.s),
              ],
              onSelectedEnd: (int option) {
                final selectedItems = DatabaseServices.getItems(selectedObjects.toList());
                for (final item in selectedItems) {
                  item.isFavorite = (option == 0);
                }
                DatabaseServices.updateItems(selectedItems);
                exitSelectionMode();
              },
            ),
          ] else ...[
            MyMenuButton(
              icon: const Icon(Icons.swap_vert),
              items: [
                MyMenuItem(
                  text: AppLocale.shareJsonLabel.s,
                  onTap: () => DatabaseServices.shareHistoriesToJson(),
                ),
                MyMenuItem(
                  text: AppLocale.exportJsonLabel.s,
                  onTap: () => DatabaseServices.exportHistoriesToJson(),
                ),
                MyMenuItem(
                  text: AppLocale.importJsonLabel.s,
                  onTap: () => DatabaseServices.importHistoriesFromJson(),
                ),
              ],
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
                ],
              ),
            ),
          ],
        ],
      ),

      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          child: Builder(
            builder: (context) {
              if (_isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (_errorMessage != null) {
                return Center(child: Text(_errorMessage!));
              } else if (_historyItems.isEmpty) {
                return Center(child: Text(AppLocale.labelHistoryEmpty.s));
              }
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
            },
          ),
        ),
      ),
    );
  }
}