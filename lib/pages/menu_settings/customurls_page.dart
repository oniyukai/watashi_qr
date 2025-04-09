import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/pages/menu_settings/customurls_form.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/widgets/list_tile_item.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/pages/widgets/settings_page_widgets.dart';

class CustomurlsPage extends StatefulWidget {
  const CustomurlsPage({super.key});

  @override
  State<CustomurlsPage> createState() => _CustomurlsPageState();
}

class _CustomurlsPageState extends State<CustomurlsPage> {
  bool _isSelectionMode = false;
  final List<String> _selectedTitles = [];

  void _enterSelectionMode(String title) {
    if (_isSelectionMode == true) {
      _toggleSelection(title);
    } else {
      setState(() {
        _isSelectionMode = true;
        _selectedTitles.add(title);
      });
    }
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedTitles.clear();
    });
  }

  void _toggleSelection(String title) {
    setState(() {
      if (_selectedTitles.contains(title)) {
        _selectedTitles.remove(title);
        if (_selectedTitles.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedTitles.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _isSelectionMode
          ? colorScheme.primary.withValues(alpha:0.25)
          : null,
        title: Text(localeStr.customSearchUrls),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.routeOf<CustomurlsForm>()
              .arguments('')
              .to(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              genericAlertDialog(
                context: context,
                titleStr: localeStr.deleteLabel,
                content: Text(
                  _isSelectionMode
                    ? localeStr.popupMessageConfirmationDeleteSelectedItemsHistory
                    : localeStr.popupMessageConfirmationDeleteHistory
                ),
                actions: [
                  TextButton(
                    child: Text(localeStr.deleteLabel),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (_isSelectionMode) {
                        List<String> customSearchUrls = context.read<SettingsProvider>().customSearchUrls;
                        customSearchUrls.removeWhere((searchUrl) {
                          for (final title in _selectedTitles) {
                            if (searchUrl.startsWith('$title<Separation.Object>')) {
                              return true;
                            }
                          }
                          return false;
                        });
                        Provider.of<SettingsProvider>(context,
                            listen: false)
                            .updateSetting(Language.preferencesCustomSearchUrlsKey, customSearchUrls);
                        _exitSelectionMode();
                      } else {
                        Provider.of<SettingsProvider>(context,
                          listen: false)
                          .updateSetting(Language.preferencesCustomSearchUrlsKey, <String>[]);
                      }
                      Utils.showToast(localeStr.customUrlDeleted);
                    },
                  ),
                ]
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Consumer<SettingsProvider>(
              builder:(context, settings, child) => ListView(
                children: [
                  const SizedBox(height: 16.0),
                  if (settings.customSearchUrls.isEmpty) Text(
                    localeStr.customSearchUrlsListIsEmptyMessage,
                    style: theme.textTheme.titleMedium,
                  )
                  else ...settings.customSearchUrls.map((searchUrl) {
                    List<String> parts = searchUrl.split('<Separation.Object>');
                    String title = parts[0];
                    return Column(
                      children: [
                        ListTileItem(
                          title: title,
                          description: parts[1],
                          selected: _selectedTitles.contains(title),
                          onTap: () {
                            if (_isSelectionMode) {
                              _toggleSelection(title);
                            } else {
                              context.routeOf<CustomurlsForm>()
                                  .arguments(searchUrl)
                                  .to();
                            }
                          },
                          onLongPress: () => _enterSelectionMode(title),
                        ),
                        SizedBox(height: 4)
                      ],
                    );
                  }),
                  const SizedBox(height: 16.0),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}