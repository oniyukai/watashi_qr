import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watashi_qr/common/database_services.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/pages/menu_history/page_code_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/widget/barcode_field.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';
import 'package:watashi_qr/pages/widget/functions.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';
import 'package:watashi_qr/pages/widget/expandable_card.dart';
import 'package:watashi_qr/pages/menu_history/page_item_widgets.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';
import 'dart:io';

class PageItemView extends StatefulWidget with RouterBridge<HistoryItem> {
  const PageItemView({super.key});

  @override
  State<PageItemView> createState() => _PageItemViewState();
}

class _PageItemViewState extends State<PageItemView> {
  final _formKey = GlobalKey<FormBuilderState>();
  late HistoryItem _historyItem;
  late bool _isExistInhistories;
  late Language _localeStr;
  bool? _isWillExist;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localeStr = Language.of(context);
    final argument = widget.argumentOf(context);
    if (argument == null) throw 'widget.argumentOf(context) connot be null.';
    _historyItem = argument;
    _isExistInhistories = DatabaseServices.containsTime(_historyItem.unixTime);
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
        DatabaseServices.addItem(_historyItem, isDuplicatedEnabled: context.readSettings.isSaveDuplicates);
      } else {
        DatabaseServices.deleteItem(_historyItem.id);
      }
    } else if (_isExistInhistories) {
      DatabaseServices.updateItem(_historyItem.id, _historyItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatNameStr = HistoryFormat.localeStrFromName(_historyItem.format, _localeStr);
    final isFormatSupported = _historyItem.getFormat != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(HistoryType.localeStrFromName(_historyItem.type, _localeStr)),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              ExpandableCard(
                title: _localeStr.barCodeContentLabel,
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
                      title: Text(_localeStr.aboutBarcodeInformationLabel),
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
                              SelectableText('${_localeStr.aboutBarcodeFormatLabel}$formatNameStr'),
                              SelectableText(Utils.formatUnixTimes(_historyItem.unixTime)),
                            ],
                          ),
                          SelectableText('${_localeStr.aboutBarcodeOriginLabel}${
                              _historyItem.origin == HistoryOrigin.S.name ? _localeStr.titleScan : _localeStr.titleGenerate
                          }'),
                          if (_historyItem.errorLevel != HistoryErrorLevel.none.name)
                            SelectableText('${_localeStr.qrCodeErrorCorrectionLevelLabel}: ${
                              HistoryErrorLevel.localeStrFromName(_historyItem.errorLevel, _localeStr)
                            }'),
                          if (_historyItem.notes.isNotEmpty) Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText('${_localeStr.matrixContactNotesLabel}: '),
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
                  onTap: isFormatSupported ? ()=>context.routeOf<PageCodeView>().arguments(_historyItem).to() : null,
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
                        onTap: _showModifyContentsSheet,
                        child: const Icon(Icons.edit),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        child: const Icon(Icons.copy),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: _historyItem.contents));
                          Utils.showToast(_localeStr.barcodeCopiedLabel);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('  ${_localeStr.actionsLabel}', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Builder(builder: (BuildContext context) {
                final List<Widget> rows = [];
                final actionGrids = _getActionGridList();
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

  List<PressButtonGrid> _getActionGridList() {
    final type = _historyItem.getType;
    final bool willExist = _isWillExist ?? _isExistInhistories;
    return <PressButtonGrid>[
      if (type != HistoryType.website) PressButtonGrid(
          iconData: Icons.search,
          description: _localeStr.actionWebSearchLabel,
          onTap: _actionWebSearch,
      ),
      if (type == HistoryType.website) PressButtonGrid(
        iconData: Icons.open_in_browser,
        description: _localeStr.actionOpenLink,
        onTap: () => Utils.openUrlInBrowser(_historyItem.contents),
      ),
      if (context.readSettings.customSearchUrls.isNotEmpty) PressButtonGrid(
        iconData: Icons.search,
        description: _localeStr.customSearchUrls,
        onTap: _actionCustomSearch,
      ),
      PressButtonGrid(
        iconData: Icons.edit_note,
        description: _localeStr.actionModifyNotes,
        onTap: _actionModifyNotes,
      ),
      // if (const {HistoryType.contact, HistoryType.mail, HistoryType.phone, HistoryType.sms}
      //     .contains(type)) PressButtonGrid(
      //   icon: Icons.contacts_outlined,
      //   description: localeStr.actionAddToContacts,
      //   onTap: () => _actionAddToContacts(type!), // todo
      // ),
      if (type == HistoryType.contact) PressButtonGrid(
        iconData: Icons.share,
        description: _localeStr.actionShareVcfFile,
        onTap: _actionShareVcfFile,
      ),
      if (type == HistoryType.mail) PressButtonGrid(
        iconData: Icons.mail_outline,
        description: _localeStr.actionSendMailLabel,
        onTap: _actionSendMail,
      ),
      if (type == HistoryType.phone || type == HistoryType.sms) PressButtonGrid(
        iconData: Icons.sms_outlined,
        description: _localeStr.actionSendSmsLabel,
        onTap: () => _actionSendSms(type!),
      ),
      if (type == HistoryType.phone || type == HistoryType.sms) PressButtonGrid(
        iconData: Icons.call,
        description: _localeStr.actionCallPhoneLabel,
        onTap: () => _actionCallPhone(type!),
      ),
      if (type == HistoryType.location) PressButtonGrid(
        iconData: Icons.location_on,
        description: _localeStr.actionShowLocation,
        onTap: _actionShowLocation,
      ),
      // if (type == HistoryType.agend) PressButtonGrid(
      //   icon: Icons.event,
      //   description: localeStr.actionAddToCalendar,
      //   onTap: _actionShareAgend, // todo
      // ),
      // if (type == HistoryType.wifi) PressButtonGrid(
      //   icon: Icons.wifi,
      //   description: localeStr.qrCodeTypeNameWifi,
      //   onTap: () {}, // Notodo: WIFI按鈕(決定不加入)
      // ),
      PressButtonGrid(
        iconData: willExist ? Icons.delete_forever : Icons.add,
        description: willExist
            ? _localeStr.menuItemHistoryDeleteFromHistory
            : _localeStr.menuItemHistoryAddInHistory,
        onTap: () {
          Utils.showToast(willExist
              ? _localeStr.menuItemHistoryRemovedFromHistory
              : _localeStr.menuItemHistoryAddedInHistory);
          setState(() {
            _isWillExist = !willExist;
          });
        },
      ),
    ];
  }

  void _showModifyContentsSheet() => showMyBottomSheet(
    context: context,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_localeStr.actionModifyBarcode),
        Text(HistoryFormat.localeStrFromName(_historyItem.format, _localeStr)),
      ],
    ),
    content: FormBuilder(
      key:_formKey,
      child: BarcodeField(
        format: _historyItem.getFormat,
        name: 'modifyContents',
        formKey: _formKey,
        initialValue: _historyItem.contents,
      ),
    ),
    actions: [
      ElevatedButton(
        child: Text(_localeStr.actionModifyBarcode),
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

  void _actionCustomSearch() => showMyDialog(
    context: context,
    titleStr: _localeStr.customSearchUrls,
    noCancelButton: true,
    content: Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: context.readSettings.customSearchUrls.map((searchUrl) => ItemTile(
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

  void _actionModifyNotes() => showMyBottomSheet(
    context: context,
    title: Text(_localeStr.actionModifyNotes),
    content: FormBuilder(
      key: _formKey,
      child: FormBuilderTextField(
        name: 'modifyNotes',
        initialValue: _historyItem.notes,
        maxLines: null,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.format_size),
          labelText: _localeStr.barcodeTextCompositionLabel,
        ),
        keyboardType: TextInputType.text,
      ),
    ),
    actions: [
      ElevatedButton(
        child: Text(_localeStr.actionModifyNotes),
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

  Future<void> _actionShareVcfFile() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/contact.vcf');
    await file.writeAsString(_historyItem.contents);
    await Utils.share(ShareParams(files: [XFile(file.path)]));
  }

  void _actionSendMail() {
    final analyzed = analyzeMail(_historyItem.contents);
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

  void _actionSendSms(HistoryType type) {
    String? phone;
    String? message;
    if (type == HistoryType.sms) {
      final analyzed = analyzeSms(_historyItem.contents);
      phone = analyzed['phone'];
      message = analyzed['message'];
    } else if (type == HistoryType.phone) {
      phone = _historyItem.contents.substring(4);
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

  void _actionCallPhone(HistoryType type) {
    String? phone;
    if (type == HistoryType.sms) {
      final analyzed = analyzeSms(_historyItem.contents);
      phone = analyzed['phone'];
    } else if (type == HistoryType.phone) {
      phone = _historyItem.contents.substring(4);
    }
    if (phone != null) Utils.openUrlInBrowser('tel:$phone');
  }

  void _actionShowLocation() => Utils.openUrlInBrowser('geo:${_historyItem.contents.substring(4)}');
}