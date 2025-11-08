import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class _PageCustomurlsViewState extends State<PageCustomurlsView> with SelectionMixin<PageCustomurlsView, String>  {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSelectionMode
          ? colorScheme.primary.withValues(alpha:0.25)
          : null,
        title: Text(AppLocale.customSearchUrls.s),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.routeOf<PageCustomurlsForm>()
              .arguments('')
              .to(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => showMyDialog(
              context: context,
              titleStr: AppLocale.deleteLabel.s,
              content: Text(
                isSelectionMode
                  ? AppLocale.popupMessageConfirmationDeleteSelectedItemsHistory.s
                  : AppLocale.popupMessageConfirmationDeleteHistory.s
              ),
              actions: [
                TextButton(
                  child: Text(AppLocale.deleteLabel.s),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (isSelectionMode) {
                      final List<String> customSearchUrls = context.readPrefs.get(PrefsEnum.customSearchUrls);
                      customSearchUrls.removeWhere((searchUrl) {
                        for (final title in selectedObjects) {
                          if (searchUrl.startsWith('$title${StaticString.separationObject}')) {
                            return true;
                          }
                        }
                        return false;
                      });
                      context.readPrefs.update(PrefsEnum.customSearchUrls, customSearchUrls);
                      exitSelectionMode();
                    } else {
                      context.readPrefs.update(PrefsEnum.customSearchUrls, <String>[]);
                    }
                    Utils.showToast(AppLocale.customUrlDeleted.s);
                  },
                ),
              ]
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Consumer<PrefsProvider>(
            builder:(context, settings, child) {
              if (settings.get(PrefsEnum.customSearchUrls).isEmpty) {
                return Center(child: Text(AppLocale.customSearchUrlsListIsEmptyMessage.s));
              }
              return ListView.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                padding: const EdgeInsets.all(16.0),
                itemCount: settings.get(PrefsEnum.customSearchUrls).length,
                itemBuilder: (context, index) {
                  final String searchUrl = settings.get(PrefsEnum.customSearchUrls)[index];
                  final List<String> parts = searchUrl.split(StaticString.separationObject);
                  final String title = parts[0];
                  final String url = parts[1];
                  return Card(
                    elevation: 0,
                    child: ItemTile(
                      title: title,
                      description: url,
                      selected: selectedObjects.contains(title),
                      onTap: () {
                        if (isSelectionMode) {
                          toggleSelection(title);
                        } else {
                          context.routeOf<PageCustomurlsForm>()
                              .arguments(searchUrl)
                              .to();
                        }
                      },
                      onLongPress: () => enterSelectionMode(title),
                    ),
                  );
                }
              );
            }
          ),
        ),
      ),
    );
  }
}