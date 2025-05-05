import 'package:flutter/material.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/pages/menu_history/code_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/widgets/barcode_text_field.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:watashi_qr/pages/widgets/list_tile_item.dart';
import 'package:watashi_qr/pages/widgets/expandable_card.dart';
import 'package:watashi_qr/pages/widgets/item_view_widgets.dart';
import 'package:watashi_qr/pages/widgets/settings_page_widgets.dart';

class ItemView extends StatefulWidget with RouterBridge<HistoryItem> {
  const ItemView({super.key});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final _formKey = GlobalKey<FormBuilderState>();
  late HistoryItem _historyItem;
  late bool _isExistInhistories;
  late bool _isSaveDuplicates;
  bool? _isWillExist;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument = widget.argumentOf(context);
    if (argument == null) return;
    _historyItem = argument;
    _isExistInhistories = HiveService.containsTime(_historyItem.unixTime);
    _isSaveDuplicates = context.readSettings.isSaveDuplicates;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    updateHistoryItem();
    super.dispose();
  }

  void updateHistoryItem() {
    _isWillExist ??= _isExistInhistories;
    if (_isExistInhistories != _isWillExist){
      if (_isWillExist == true){
        HiveService.addItem(_historyItem, isDuplicatedEnabled: _isSaveDuplicates);
      } else {
        HiveService.deleteItem(_historyItem.key);
      }
    } else if (_isExistInhistories) {
      HiveService.updateItem(_historyItem.key, _historyItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final formatNameStr = HistoryFormat.localeStrFromName(_historyItem.format, localeStr);
    final isFormatNameSupported = !(formatNameStr.startsWith('"') && formatNameStr.endsWith('"'));
    return Scaffold(
      appBar: AppBar(
        title: Text(HistoryType.localeStrFromName(_historyItem.type, localeStr)),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              ExpandableCard(
                title: localeStr.barCodeContentLabel,
                icon: _historyItem.getTypeIconData,
                initialExpanded: true,
                expandedChild: AnalyzedContentItem(
                  contents: _historyItem.contents,
                  format: _historyItem.getFormat,
                  type: _historyItem.getType,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      minTileHeight: 0,
                      contentPadding: const EdgeInsets.only(left: 16, top: 8),
                      leading: Icon(_historyItem.getFormatIconData),
                      title: Text(localeStr.aboutBarcodeInformationLabel),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.only(right: 16, left: 16, bottom: 8),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SelectableText('${localeStr.aboutBarcodeFormatLabel}$formatNameStr'),
                              SelectableText(Utils.formatUnixTimes(_historyItem.unixTime)),
                            ],
                          ),
                          SelectableText('${localeStr.aboutBarcodeOriginLabel}${
                              _historyItem.origin == HistoryOrigin.S.name ? localeStr.titleScan : localeStr.titleGenerate
                          }'),
                          if (_historyItem.errorLevel != HistoryErrorLevel.none.name)
                            SelectableText('${localeStr.qrCodeErrorCorrectionLevelLabel}: ${
                                HistoryErrorLevel.localeStrFromName(_historyItem.errorLevel, localeStr)
                            }'),
                          if (_historyItem.notes.isNotEmpty) Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText('${localeStr.matrixContactNotesLabel}: '),
                              Expanded(
                                child: SelectableText(
                                  _historyItem.notes,
                                  style: TextStyle(
                                    color: colorScheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: isFormatNameSupported ? const Icon(MaterialCommunityIcons.barcode_scan) : null,
                  onTap: isFormatNameSupported ? ()=>context.routeOf<CodeView>().arguments(_historyItem).to() : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Icon(_historyItem.isFavorite ? Icons.favorite : Icons.favorite_outline),
                        onTap: () => setState(() {
                          _historyItem.isFavorite = !_historyItem.isFavorite;
                        }),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        child: const Icon(Icons.share),
                        onTap: () => Utils.share(ShareParams(text: _historyItem.contents)),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        child: const Icon(Icons.edit),
                        onTap: () => _showModifyContentsSheet(localeStr),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        child: const Icon(Icons.copy),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: _historyItem.contents));
                          Utils.showToast(localeStr.barcodeCopiedLabel);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('  ${localeStr.actionsLabel}', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Builder(builder: (_) {
                final List<Widget> rows = [];
                final actionCards = _getActionGridList(localeStr);
                for (var i = 0; i < actionCards.length; i += 3) {
                  final end = i + 3 > actionCards.length ? actionCards.length : i + 3;
                  final List<Widget> rowChildren = [];
                  for (int j = 0; j < end - i; j++) {
                    rowChildren.add(Expanded(child: actionCards.sublist(i, end)[j]));
                    if (j < end - i - 1) {
                      rowChildren.add(const SizedBox(width: 8.0));
                    }
                  }
                  while (rowChildren.length < 5) {
                    rowChildren.add(const Expanded(child:SizedBox.shrink()));
                    if (rowChildren.length < 5) {
                      rowChildren.add(const SizedBox(width: 8.0));
                    }
                  }
                  rows.add(IntrinsicHeight(
                    child: Row(children: rowChildren),
                  ));
                  rows.add(const SizedBox(height: 8));
                }
                return Column(children: rows);
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  List<PressButtonGrid> _getActionGridList(Language localeStr) {
    final String type = _historyItem.type;
    final bool willExist = _isWillExist ?? _isExistInhistories;
    return <PressButtonGrid>[
      type != HistoryType.website.name ?
      PressButtonGrid(
          icon: Icons.search,
          description: localeStr.actionWebSearchLabel,
          onTap: () => _actionWebSearch()
      ) : PressButtonGrid(
        icon: Icons.open_in_browser,
        description: localeStr.actionOpenLink,
        onTap: () => Utils.openUrlInBrowser(_historyItem.contents),
      ),
      if (context.readSettings.customSearchUrls.isNotEmpty) PressButtonGrid(
        icon: Icons.search,
        description: localeStr.customSearchUrls,
        onTap: () => _showCustomSearchDialog(localeStr),
      ),
      PressButtonGrid(
        icon: Icons.edit_note,
        description: localeStr.actionModifyNotes,
        onTap: () {
          _showModifyNotesSheet(localeStr);
          setState(() {});
        },
      ),
      // if (type == 'CONTACT' || type == 'MAIL' || type == 'PHONE' || type == 'SMS') {
      //   'icon': Icons.contacts_outlined,
      //   'description': localeStr.actionAddToContacts,
      //   'onTap': () {}, // TODO CONTACT按鈕功能
      // },
      // if (type == 'MAIL') {
      //   'icon': Icons.mail_outline,
      //   'description': localeStr.actionSendMailLabel,
      //   'onTap': () {}, // TODO MAIL按鈕功能
      // },
      // if (type == 'PHONE' || type == 'SMS') {
      //   'icon': Icons.sms_outlined,
      //   'description': localeStr.actionSendSmsLabel,
      //   'onTap': () {}, // TODO SMS按鈕功能
      // },
      // if (type == 'PHONE' || type == 'SMS') {
      //     'icon': Icons.call,
      //     'description': localeStr.actionCallPhoneLabel,
      //     'onTap': () {}, // TODO PHONE按鈕功能
      //   },
      // if (type == 'LOCATION') {
      //     'icon': Icons.location_on,
      //     'description': localeStr.actionShowLocation,
      //     'onTap': () {}, // TODO LOCATION按鈕功能
      //   },
      // if (type == 'AGEND') {
      //     'icon': Icons.event,
      //     'description': localeStr.actionAddToCalendar,
      //     'onTap': () {}, // TODO AGEND按鈕功能
      //   },
      // if (type == 'WIFI') {
      //   'icon': Icons.wifi,
      //   'description': localeStr.qrCodeTypeNameWifi,
      //   'onTap': () {}, // TODO WIFI按鈕功能
      // },
      PressButtonGrid(
        icon: willExist ? Icons.delete_forever : Icons.add,
        description: willExist
            ? localeStr.menuItemHistoryDeleteFromHistory
            : localeStr.menuItemHistoryAddInHistory,
        onTap: () {
          Utils.showToast(willExist
              ? localeStr.menuItemHistoryRemovedFromHistory
              : localeStr.menuItemHistoryAddedInHistory);
          setState(() {
            _isWillExist = !willExist;
          });
        },
      ),
    ];
  }

  void _showModifyContentsSheet(Language localeStr){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(localeStr.actionModifyBarcode),
                    Text(HistoryFormat.localeStrFromName(_historyItem.format, localeStr)),
                  ],
                ),
                const SizedBox(height: 16),
                FormBuilder(
                  key:_formKey,
                  child: BarcodeTextField(
                    format: _historyItem.getFormat,
                    name: 'modifyContents',
                    formKey: _formKey,
                    initialValue: _historyItem.contents,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Text(localeStr.cancelLabel),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      child: Text(localeStr.actionModifyBarcode),
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          final value = _formKey.currentState?.value['modifyContents'];
                          _historyItem.contents = value;
                          _historyItem.type = HistoryType.fromDistinguish(_historyItem.getFormat, value).name;
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _actionWebSearch(){
    final String selectedSearchEngine = context.readSettings.selectedSearchEngine;
    final String searchEngine = SearchEngine.urlByName(selectedSearchEngine);
    Utils.searchInBrowser(searchEngine, _historyItem.contents);
  }

  void _showCustomSearchDialog(Language localeStr) {
    final List<String> customSearchUrls = context.readSettings.customSearchUrls;
    genericAlertDialog(
      context: context,
      titleStr: localeStr.customSearchUrls,
      noCancelButton: true,
      content: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: customSearchUrls.map((searchUrl) => ListTileItem(
              title: searchUrl.split(Language.separationObject)[0],
              description: searchUrl.split(Language.separationObject)[1],
              onTap: () {
                Utils.searchInBrowser(searchUrl.split(Language.separationObject)[1], _historyItem.contents);
                Navigator.pop(context);
              }
            )).toList(),
          ),
        ),
      ),
    );
  }

  void _showModifyNotesSheet(Language localeStr){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Text(localeStr.actionModifyNotes),
                const SizedBox(height: 16),
                FormBuilder(
                  key:_formKey,
                  child: FormBuilderTextField(
                    name: 'modifyNotes',
                    initialValue: _historyItem.notes,
                    maxLines: null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.format_size),
                      labelText: localeStr.barcodeTextCompositionLabel,
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Text(localeStr.cancelLabel),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      child: Text(localeStr.actionModifyNotes),
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          final String value = _formKey.currentState?.value['modifyNotes'];
                          _historyItem.notes = value;
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }





}