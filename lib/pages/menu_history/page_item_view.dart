import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:watashi_qr/common/database_services.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_history/page_code_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_view.dart';
import 'package:watashi_qr/pages/widget/barcode_field.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watashi_qr/common/prefs.dart';
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
  late final HistoryItem _historyItem;
  late bool _isWillExist;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _historyItem = widget.argumentOf(context)!;
      _isWillExist = _historyItem.id > 0;
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_historyItem.id > 0 && _isWillExist) {
      DatabaseServices.updateItem(_historyItem);
    } else if (_historyItem.id > 0) {
      DatabaseServices.deleteItem(_historyItem.id);
    } else if (_isWillExist) { // todo debug: 當我關閉掃描加入 並手動加入 他並沒有加入記錄
      DatabaseServices.addItem(_historyItem, context);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const Center(child: CircularProgressIndicator());
    final colorScheme = Theme.of(context).colorScheme;
    final formatNameStr = HistoryFormat.localeStrFromName(_historyItem.format);
    final isFormatSupported = _historyItem.getFormat != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(HistoryType.localeStrFromName(_historyItem.type)),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              ExpandableCard(
                title: AppLocale.barCodeContentLabel.s,
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
                      title: Text(AppLocale.aboutBarcodeInformationLabel.s),
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
                              SelectableText('${AppLocale.aboutBarcodeFormatLabel.s}$formatNameStr'),
                              SelectableText(Utils.formatUnixTimes(_historyItem.unixTime)),
                            ],
                          ),
                          SelectableText('${AppLocale.aboutBarcodeOriginLabel.s}${
                              _historyItem.origin == HistoryOrigin.S.name ? AppLocale.titleScan.s : AppLocale.titleGenerate.s
                          }'),
                          if (_historyItem.errorLevel != HistoryErrorLevel.none.name)
                            SelectableText('${AppLocale.qrCodeErrorCorrectionLevelLabel.s}: '
                                '${HistoryErrorLevel.localeStrFromName(_historyItem.errorLevel)}'),
                          if (_historyItem.notes.isNotEmpty) Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText('${AppLocale.matrixContactNotesLabel.s}: '),
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: isFormatSupported ? const Icon(MaterialCommunityIcons.barcode_scan) : null,
                  onTap: isFormatSupported ? () => context.routeOf<PageCodeView>().arguments(_historyItem).to() : null,
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
                          Utils.showToast(AppLocale.barcodeCopiedLabel.s);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ListTile(
                minTileHeight: 0,
                subtitle: Text(AppLocale.actionsLabel.s),
              ),
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
    return <PressButtonGrid>[
      if (type != HistoryType.website) PressButtonGrid(
          iconData: Icons.search,
          description: AppLocale.actionWebSearchLabel.s,
          onTap: _actionWebSearch,
      ),
      if (type == HistoryType.website) PressButtonGrid(
        iconData: Icons.open_in_browser,
        description: AppLocale.actionOpenLink.s,
        onTap: () => Utils.openUrlInBrowser(_historyItem.contents),
      ),
      if (context.readPrefs.get(PrefsEnum.customSearchUrls).isNotEmpty) PressButtonGrid(
        iconData: Icons.search,
        description: AppLocale.customSearchUrls.s,
        onTap: _actionCustomSearch,
      ),
      PressButtonGrid(
        iconData: Icons.edit_note,
        description: AppLocale.actionModifyNotes.s,
        onTap: _actionModifyNotes,
      ),
      // if (const {HistoryType.contact, HistoryType.mail, HistoryType.phone, HistoryType.sms}
      //     .contains(type)) PressButtonGrid(
      //   icon: Icons.contacts_outlined,
      //   description: AppLocale.actionAddToContacts.s,
      //   onTap: () => _actionAddToContacts(type!), // todo
      // ),
      if (type == HistoryType.contact) PressButtonGrid(
        iconData: Icons.share,
        description: AppLocale.actionShareVcfFile.s,
        onTap: _actionShareVcfFile,
      ),
      if (type == HistoryType.mail) PressButtonGrid(
        iconData: Icons.mail_outline,
        description: AppLocale.actionSendMailLabel.s,
        onTap: _actionSendMail,
      ),
      if (type == HistoryType.phone || type == HistoryType.sms) PressButtonGrid(
        iconData: Icons.sms_outlined,
        description: AppLocale.actionSendSmsLabel.s,
        onTap: () => _actionSendSms(type!),
      ),
      if (type == HistoryType.phone || type == HistoryType.sms) PressButtonGrid(
        iconData: Icons.call,
        description: AppLocale.actionCallPhoneLabel.s,
        onTap: () => _actionCallPhone(type!),
      ),
      if (type == HistoryType.location) PressButtonGrid(
        iconData: Icons.location_on,
        description: AppLocale.actionShowLocation.s,
        onTap: _actionShowLocation,
      ),
      // if (type == HistoryType.agend) PressButtonGrid(
      //   icon: Icons.event,
      //   description: AppLocale.actionAddToCalendar.s,
      //   onTap: _actionShareAgend, // todo
      // ),
      // if (type == HistoryType.wifi) PressButtonGrid(
      //   icon: Icons.wifi,
      //   description: AppLocale.qrCodeTypeNameWifi.s,
      //   onTap: () {}, // Notodo: WIFI按鈕(決定不加入)
      // ),
      PressButtonGrid(
        iconData: _isWillExist ? Icons.delete_forever : Icons.add,
        description: _isWillExist
            ? AppLocale.menuItemHistoryDeleteFromHistory.s
            : AppLocale.menuItemHistoryAddInHistory.s,
        onTap: () {
          Utils.showToast(_isWillExist
              ? AppLocale.menuItemHistoryRemovedFromHistory.s
              : AppLocale.menuItemHistoryAddedInHistory.s);
          setState(() {
            _isWillExist = !_isWillExist;
          });
        },
      ),
    ];
  }

  Future<void> _showModifyContentsSheet() => showMyBottomSheet(
    context: context,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppLocale.actionModifyBarcode.s),
        Text(HistoryFormat.localeStrFromName(_historyItem.format)),
      ],
    ),
    content: FormBuilder(
      key:_formKey,
      child: BarcodeField(
        format: _historyItem.getFormat,
        name: 'modifyContents',
        initialValue: _historyItem.contents,
      ),
    ),
    actions: [
      ElevatedButton(
        child: Text(AppLocale.actionModifyBarcode.s),
        onPressed: () {
          if (_formKey.currentState?.saveAndValidate() != true) return;
          _historyItem.contents = _formKey.currentState!.value['modifyContents'];
          _historyItem.type = HistoryType.fromDistinguish(_historyItem.getFormat, _historyItem.contents).name;
          Navigator.pop(context);
        },
      ),
    ],
  );

  void _actionWebSearch(){
    final SearchEngine searchEngine = context.readPrefs.get(PrefsEnum.selectedSearchEngine);
    Utils.searchInBrowser(searchEngine.url, _historyItem.contents);
  }

  Future<void> _actionCustomSearch() => showMyDialog(
    context: context,
    title: AppLocale.customSearchUrls.s,
    noCancelButton: true,
    content: Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: context.readPrefs.get<List<CustomSearchUrl>>(PrefsEnum.customSearchUrls).map((searchUrl) => ItemTile(
            title: searchUrl.title,
            description: searchUrl.url,
            onTap: () {
              Utils.searchInBrowser(searchUrl.url, _historyItem.contents);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    ),
  );

  Future<void> _actionModifyNotes() => showMyBottomSheet(
    context: context,
    title: Text(AppLocale.actionModifyNotes.s),
    content: FormBuilder(
      key: _formKey,
      child: FormBuilderTextField(
        name: 'modifyNotes',
        keyboardType: .text,
        maxLines: null,
        initialValue: _historyItem.notes,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.format_size),
          labelText: AppLocale.barcodeTextCompositionLabel.s,
        ),
      ),
    ),
    actions: [
      ElevatedButton(
        child: Text(AppLocale.actionModifyNotes.s),
        onPressed: () {
          if (_formKey.currentState?.saveAndValidate() != true) return;
          final String value = _formKey.currentState!.value['modifyNotes'];
          _historyItem.notes = value;
          Navigator.pop(context);
        },
      ),
    ],
  );

  Future<void> _actionShareVcfFile() async {
    final directory = await getTemporaryDirectory();
    final file = File(p.join(directory.path, 'contact.vcf'));
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

enum SearchEngine {
  google(StaticString.googleUrl),
  bing(StaticString.bingUrl),
  wikipedia(StaticString.wikipediaUrl);

  const SearchEngine(this.url);
  final String url;

  static Map<SearchEngine, String> get optionMap => <SearchEngine, String>{
    google: StaticString.googleLabel,
    bing: StaticString.bingLabel,
    wikipedia: StaticString.wikipediaLabel,
  };
}
