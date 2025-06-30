import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:watashi_qr/pages/widgets/my_icon.dart';
import 'package:watashi_qr/pages/widgets/settings_page_widgets.dart';
import 'dart:io';

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
    _updateHistoryItem();
    super.dispose();
  }

  void _updateHistoryItem() {
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
    final isFormatSupported = _historyItem.getFormat != null;
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
                myIconData: _historyItem.getTypeIconData,
                initialExpanded: true,
                expandedChild: AnalyzedContentItem(
                  contents: _historyItem.contents,
                  format: _historyItem.getFormat,
                  type: _historyItem.getType,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      minTileHeight: 0,
                      contentPadding: const EdgeInsets.only(left: 16, top: 8),
                      leading: MyIcon(_historyItem.getFormatIconData),
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
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: isFormatSupported ? const Icon(MaterialCommunityIcons.barcode_scan) : null,
                  onTap: isFormatSupported ? ()=>context.routeOf<CodeView>().arguments(_historyItem).to() : null,
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
              Builder(builder: (BuildContext context) {
                final List<Widget> rows = [];
                final actionGrids = _getActionGridList(localeStr);
                for (int i = 0; i < actionGrids.length; i += 3) {
                  final end = (i + 3 > actionGrids.length) ? actionGrids.length : i + 3;
                  final List<Widget> rowChildren = [];
                  while (rowChildren.length < 3) {
                    rowChildren.add( (rowChildren.length < end - i)
                        ? Expanded(child: actionGrids[i + rowChildren.length])
                        : const Expanded(child:SizedBox.shrink())
                    );
                  }
                  rows.add(IntrinsicHeight(
                    child: Row(children: rowChildren),
                  ));
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
    final type = _historyItem.getType;
    final bool willExist = _isWillExist ?? _isExistInhistories;
    return <PressButtonGrid>[
      if (type != HistoryType.website) PressButtonGrid(
          icon: Icons.search,
          description: localeStr.actionWebSearchLabel,
          onTap: () => _actionWebSearch()
      ),
      if (type == HistoryType.website) PressButtonGrid(
        icon: Icons.open_in_browser,
        description: localeStr.actionOpenLink,
        onTap: () => Utils.openUrlInBrowser(_historyItem.contents),
      ),
      if (context.readSettings.customSearchUrls.isNotEmpty) PressButtonGrid(
        icon: Icons.search,
        description: localeStr.customSearchUrls,
        onTap: () => _actionCustomSearch(localeStr),
      ),
      PressButtonGrid(
        icon: Icons.edit_note,
        description: localeStr.actionModifyNotes,
        onTap: () {
          _actionModifyNotes(localeStr);
          setState(() {});
        },
      ),
      // if (const {HistoryType.contact, HistoryType.mail, HistoryType.phone, HistoryType.sms}
      //     .contains(type)) PressButtonGrid(
      //   icon: Icons.contacts_outlined,
      //   description: localeStr.actionAddToContacts,
      //   onTap: () => _actionAddToContacts(_historyItem.contents, type!), // todo
      // ),
      if (type == HistoryType.contact) PressButtonGrid(
        icon: Icons.share,
        description: localeStr.actionShareVcfFile,
        onTap: () => _actionShareVcfFile(_historyItem.contents),
      ),
      if (type == HistoryType.mail) PressButtonGrid(
        icon: Icons.mail_outline,
        description: localeStr.actionSendMailLabel,
        onTap: () => _actionSendMail(_historyItem.contents),
      ),
      if (type == HistoryType.phone || type == HistoryType.sms) PressButtonGrid(
        icon: Icons.sms_outlined,
        description: localeStr.actionSendSmsLabel,
        onTap: () => _actionSendSms(_historyItem.contents, type!),
      ),
      if (type == HistoryType.phone || type == HistoryType.sms) PressButtonGrid(
        icon: Icons.call,
        description: localeStr.actionCallPhoneLabel,
        onTap: () => _actionCallPhone(_historyItem.contents, type!),
      ),
      if (type == HistoryType.location) PressButtonGrid(
        icon: Icons.location_on,
        description: localeStr.actionShowLocation,
        onTap: () => _actionShowLocation(_historyItem.contents),
      ),
      // if (type == HistoryType.agend) PressButtonGrid(
      //   icon: Icons.event,
      //   description: localeStr.actionAddToCalendar,
      //   onTap: () => _actionShareAgend(_historyItem.contents), // todo
      // ),
      // if (type == HistoryType.wifi) PressButtonGrid(
      //   icon: Icons.wifi,
      //   description: localeStr.qrCodeTypeNameWifi,
      //   onTap: () {}, // Notodo: WIFI按鈕(決定不加入)
      // ),
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

  void _showModifyContentsSheet(Language localeStr) => genericBottomSheet(
    context: context,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(localeStr.actionModifyBarcode),
        Text(HistoryFormat.localeStrFromName(_historyItem.format, localeStr)),
      ],
    ),
    content: FormBuilder(
      key:_formKey,
      child: BarcodeTextField(
        format: _historyItem.getFormat,
        name: 'modifyContents',
        formKey: _formKey,
        initialValue: _historyItem.contents,
      ),
    ),
    actions: [
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
    ]
  );

  void _actionWebSearch(){
    final String selectedSearchEngine = context.readSettings.selectedSearchEngine;
    final String searchEngine = SearchEngine.urlByName(selectedSearchEngine);
    Utils.searchInBrowser(searchEngine, _historyItem.contents);
  }

  void _actionCustomSearch(Language localeStr) => genericDialog(
    context: context,
    titleStr: localeStr.customSearchUrls,
    noCancelButton: true,
    content: Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: context.readSettings.customSearchUrls.map((searchUrl) => ListTileItem(
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

  void _actionModifyNotes(Language localeStr) => genericBottomSheet(
    context: context,
    title: Text(localeStr.actionModifyNotes),
    content: FormBuilder(
      key: _formKey,
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
    actions: [
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
    ]
  );

  Future<void> _actionShareVcfFile(String contents) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/contact.vcf');
    await file.writeAsString(contents);
    await Utils.share(ShareParams(files: [XFile(file.path)]));
  }

  void _actionSendMail(String contents) {
    final analyzed = analyzeMail(contents);
    final String? email = analyzed['email'];
    final String? subject = analyzed['subject'];
    final String? message = analyzed['message'];
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': message,
      },
    );
    if ((email ?? subject ?? message) != null) Utils.openUrlInBrowser(uri.toString());
  }

  void _actionSendSms(String contents, HistoryType type) {
    String? phone;
    String? message;
    if (type == HistoryType.sms) {
      final analyzed = analyzeSms(contents);
      phone = analyzed['phone'];
      message = analyzed['message'];
    } else if (type == HistoryType.phone) {
      phone = contents.substring(4);
    }
    if (phone == null) return;
    final Uri uri = Uri(
      scheme: 'smsto',
      path: phone,
      queryParameters: (message != null)
          ? {'body': message}
          : null,
    );
    Utils.openUrlInBrowser(uri.toString());
  }

  void _actionCallPhone(String contents, HistoryType type) {
    String? phone;
    if (type == HistoryType.sms) {
      final analyzed = analyzeSms(contents);
      phone = analyzed['phone'];
    } else if (type == HistoryType.phone) {
      phone = contents.substring(4);
    }
    if (phone != null) Utils.openUrlInBrowser('tel:$phone');
  }

  void _actionShowLocation(String contents) => Utils.openUrlInBrowser('geo:${contents.substring(4)}');
}