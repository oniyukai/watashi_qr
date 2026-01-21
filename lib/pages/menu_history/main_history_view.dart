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
      (data) => setState(() {
        _historyItems = data;
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
    _historySubscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _pressSelectedDelete() {
    Navigator.pop(context);
    DatabaseServices.deleteItems(selectedObjects.toList());
    Utils.showToast(AppLocale.menuItemHistoryRemovedFromHistory.s);
    exitSelectionMode();
  }

  Future<void> _pressSelectedCopy() async {
    final List<HistoryItem> items = DatabaseServices.getItems(selectedObjects.toList());
    final String combinedText = items.map((item) => item.contents).join('\n');
    await Clipboard.setData(ClipboardData(text: combinedText));
    Utils.showToast(AppLocale.barcodeCopiedLabel.s);
    exitSelectionMode();
  }

  void _pressSelectedFavorite(int option) {
    final List<HistoryItem> selectedItems = DatabaseServices.getItems(selectedObjects.toList());
    for (final HistoryItem item in selectedItems) {
      item.isFavorite = option == 0;
    }
    DatabaseServices.updateItems(selectedItems);
    exitSelectionMode();
  }

  void _pressDeleteAll() {
    Navigator.pop(context);
    DatabaseServices.clearHistoryBox();
    Utils.showToast(AppLocale.menuItemHistoryRemovedFromHistory.s);
  }

  @override
  Widget build(context) {
    AppLocale.load(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
        actions: isSelectionMode
            ? [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async => showMyDialog(
              context: context,
              title: AppLocale.deleteLabel.s,
              content: Text(AppLocale.popupMessageConfirmationDeleteSelectedItemsHistory.s),
              actions: [
                TextButton(
                  onPressed: _pressSelectedDelete,
                  child: Text(AppLocale.deleteLabel.s),
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
              MyMenuItem(text: AppLocale.menuItemHistoryAddFavorite.s),
              MyMenuItem(text: AppLocale.menuItemHistoryRemoveFavorite.s),
            ],
            onSelectedEnd: _pressSelectedFavorite,
          ),
        ]
            : [
          MyMenuButton(
            icon: const Icon(Icons.swap_vert),
            items: [
              MyMenuItem(
                text: AppLocale.shareJsonLabel.s,
                onTap: DatabaseServices.shareHistoryBoxToJson,
              ),
              MyMenuItem(
                text: AppLocale.exportJsonLabel.s,
                onTap: DatabaseServices.exportHistoryBoxToJson,
              ),
              MyMenuItem(
                text: AppLocale.importJsonLabel.s,
                onTap: DatabaseServices.importHistoryBoxFromJson,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async => showMyDialog(
              context: context,
              title: AppLocale.deleteLabel.s,
              content: Text(AppLocale.popupMessageConfirmationDeleteHistory.s),
              actions: [
                TextButton(
                  onPressed: _pressDeleteAll,
                  child: Text(AppLocale.deleteLabel.s),
                ),
              ],
            ),
          ),
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
                  final HistoryItem item = _historyItems[index];
                  return MainHistoryCard(
                    historyItem: item,
                    selected: selectedObjects.contains(item.id),
                    onTap: isSelectionMode
                        ? () => toggleSelection(item.id)
                        : () => context.routeOf<PageItemView>().arguments(item).to(),
                    onLongPress: () => enterSelectionMode(item.id),
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
