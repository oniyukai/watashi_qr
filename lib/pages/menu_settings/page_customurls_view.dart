import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_form.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';
import 'package:watashi_qr/locale/language.dart';
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
    final localeStr = Language.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSelectionMode
          ? colorScheme.primary.withValues(alpha:0.25)
          : null,
        title: Text(localeStr.customSearchUrls),
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
              titleStr: localeStr.deleteLabel,
              content: Text(
                isSelectionMode
                  ? localeStr.popupMessageConfirmationDeleteSelectedItemsHistory
                  : localeStr.popupMessageConfirmationDeleteHistory
              ),
              actions: [
                TextButton(
                  child: Text(localeStr.deleteLabel),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (isSelectionMode) {
                      final List<String> customSearchUrls = context.readSettings.customSearchUrls;
                      customSearchUrls.removeWhere((searchUrl) {
                        for (final title in selectedObjects) {
                          if (searchUrl.startsWith('$title${Language.separationObject}')) {
                            return true;
                          }
                        }
                        return false;
                      });
                      context.readSettings.updateSetting(PreferenceKey.customSearchUrls, customSearchUrls);
                      exitSelectionMode();
                    } else {
                      context.readSettings.updateSetting(PreferenceKey.customSearchUrls, <String>[]);
                    }
                    Utils.showToast(localeStr.customUrlDeleted);
                  },
                ),
              ]
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Consumer<SettingsProvider>(
            builder:(context, settings, child) {
              if (settings.customSearchUrls.isEmpty) {
                return Center(child: Text(localeStr.customSearchUrlsListIsEmptyMessage));
              }
              return ListView.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                padding: const EdgeInsets.all(16.0),
                itemCount: settings.customSearchUrls.length,
                itemBuilder: (context, index) {
                  final String searchUrl = settings.customSearchUrls[index];
                  final List<String> parts = searchUrl.split(Language.separationObject);
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