import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_form.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/pages/widget/overlay_show.dart';
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

class _PageCustomurlsViewState extends State<PageCustomurlsView> with SelectionMixin<int> {
  List<CustomSearchUrl> _customSearchUrls = [];

  Future<void> _pressDelete() => OverlayShow.dialog(
    context: context,
    title: DictKey.commonLabelDelete.s,
    content: Text(isSelectionMode
        ? DictKey.settingOptionCustomSearchClearSelected.s
        : DictKey.settingOptionCustomSearchClearAll.s
    ),
    actions: [
      TextButton(
        child: Text(DictKey.commonLabelDelete.s),
        onPressed: () async {
          Navigator.pop(context);
          if (isSelectionMode) {
            _customSearchUrls = _customSearchUrls.whereIndexed((i, e) => !selectedObjects.contains(i)).toList();
            await context.readPrefs.update(.customSearchUrls, _customSearchUrls);
            exitSelectionMode();
          } else {
            await context.readPrefs.update(.customSearchUrls, _customSearchUrls..clear());
          }
          Utils.showToast(DictKey.settingOptionCustomSearchDeleted.s);
        },
      ),
    ],
  );

  @override
  Widget build(context) {
    _customSearchUrls = context.watchPrefs.get(.customSearchUrls);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSelectionMode
          ? Theme.of(context).colorScheme.inversePrimary
          : null,
        title: Text(DictKey.settingOptionCustomSearch.s),
        actions: [
          if (!isSelectionMode) IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.routeOf<PageCustomurlsForm>().toPass(.new(
              items: _customSearchUrls,
            )),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _pressDelete,
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Scrollbar(
          child: _customSearchUrls.isEmpty
            ? Center(child: Text(DictKey.settingOptionCustomSearchEmpty.s))
            : ListView.builder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            padding: const .all(16.0),
            itemCount: _customSearchUrls.length,
            itemBuilder: (context, index) {
              final CustomSearchUrl item = _customSearchUrls[index];
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
                      context.routeOf<PageCustomurlsForm>().toPass(.new(
                        index: index,
                        items: _customSearchUrls,
                      ));
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
