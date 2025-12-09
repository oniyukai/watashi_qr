import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_form.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:watashi_qr/pages/widget/functions.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/pages/widget/selection_mixin.dart';

class PageCustomurlsView extends StatefulWidget {
  const PageCustomurlsView({super.key});

  @override
  State<PageCustomurlsView> createState() => _PageCustomurlsViewState();
}

class CustomSearchUrl {
  final String title;
  final String url;

  const CustomSearchUrl({
    required this.title,
    required this.url,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
  };

  factory CustomSearchUrl.fromString(String jsonString) {
    String? title;
    String? url;
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      title = json['title'];
      url = json['url'];
    } catch (e) {
      debugPrint(e.toString());
    }
    return CustomSearchUrl(
      title: title ?? StaticString.nullString,
      url: url ?? StaticString.nullString,
    );
  }
}

class _PageCustomurlsViewState extends State<PageCustomurlsView> with SelectionMixin<PageCustomurlsView, int> {
  List<CustomSearchUrl> _customSearchUrls = [];

  @override
  Widget build(BuildContext context) {
    _customSearchUrls = context.readPrefs.get(PrefsEnum.customSearchUrls);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSelectionMode
          ? colorScheme.primary.withValues(alpha:0.25)
          : null,
        title: Text(AppLocale.customSearchUrls.s),
        actions: [
          if (!isSelectionMode) IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.routeOf<PageCustomurlsForm>().arguments(PageCustomurlsFormArgs(
              items: _customSearchUrls,
            )).to(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => showMyDialog(
              context: context,
              title: AppLocale.deleteLabel.s,
              content: Text(
                isSelectionMode
                  ? AppLocale.popupMessageConfirmationDeleteSelectedItemsHistory.s
                  : AppLocale.popupMessageConfirmationDeleteHistory.s
              ),
              actions: [
                TextButton(
                  child: Text(AppLocale.deleteLabel.s),
                  onPressed: () {
                    Navigator.pop(context);
                    if (isSelectionMode) {
                      _customSearchUrls = [
                        for (final entry in _customSearchUrls.asMap().entries)
                          if (!selectedObjects.contains(entry.key)) entry.value
                      ];
                      context.readPrefs.update(PrefsEnum.customSearchUrls, _customSearchUrls);
                      exitSelectionMode();
                    } else {
                      context.readPrefs.update(PrefsEnum.customSearchUrls, PrefsEnum.customSearchUrls.defaultValue());
                    }
                    Utils.showToast(AppLocale.customUrlDeleted.s);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: _customSearchUrls.isEmpty
            ? Center(child: Text(AppLocale.customSearchUrlsListIsEmptyMessage.s))
            : ListView.builder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            padding: const EdgeInsets.all(16.0),
            itemCount: _customSearchUrls.length,
            itemBuilder: (context, index) {
              final item = _customSearchUrls[index];
              return Card(
                elevation: 0,
                child: ItemTile(
                  title: item.title,
                  description: item.url,
                  selected: selectedObjects.contains(index),
                  onTap: () {
                    if (isSelectionMode) {
                      toggleSelection(index);
                    } else {
                      context.routeOf<PageCustomurlsForm>().arguments(PageCustomurlsFormArgs(
                        index: index,
                        items: _customSearchUrls,
                      )).to();
                    }
                  },
                  onLongPress: () => enterSelectionMode(index),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
