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
  late final HistoryItem _historyItem = widget.getArgs(context)!;
  late final HistoryFormat? _historyFormat = _historyItem.getFormat;
  late HistoryType? _historyType = _historyItem.getType;
  late bool _isWillExist = _historyItem.id > 0;

  @override
  void dispose() {
    if (_historyItem.id > 0 && _isWillExist) {
      DatabaseServices.updateItem(_historyItem);
    } else if (_historyItem.id > 0) {
      DatabaseServices.deleteItem(_historyItem.id);
    } else if (_isWillExist) {
      DatabaseServices.addItem(_historyItem);
    }
    super.dispose();
  }

  void _pressItemFavorite() => setState(() {
    _historyItem.isFavorite = !_historyItem.isFavorite;
  });

  Future<void> _pressShareContents() => Utils.share(ShareParams(text: _historyItem.contents));

  Future<void> _pressModifyContents() => showMyBottomSheet(
    context: context,
    title: Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(DictKey.actionModifyBarcode.s),
        Text(HistoryFormat.localeStrFromName(_historyItem.format)),
      ],
    ),
    content: FormBuilder(
      key: _formKey,
      child: BarcodeField(
        format: _historyFormat,
        name: 'modifyContents',
        initialValue: _historyItem.contents,
      ),
    ),
    actions: [
      ElevatedButton(
        child: Text(DictKey.actionModifyBarcode.s),
        onPressed: () {
          if (_formKey.currentState?.saveAndValidate() != true) return;
          _historyItem.contents = _formKey.currentState!.value['modifyContents'];
          _historyItem.type = HistoryType.fromDistinguish(_historyFormat, _historyItem.contents).name;
          _historyType = _historyItem.getType;
          Navigator.pop(context);
        },
      ),
    ],
  );

  Future<void> _pressCopyContents() async {
    await Clipboard.setData(ClipboardData(text: _historyItem.contents));
    Utils.showToast(DictKey.barcodeCopiedLabel.s);
  }

  @override
  Widget build(context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
                title: DictKey.barCodeContentLabel.s,
                myIconData: _historyItem.getTypeIconData,
                initialExpanded: true,
                expandedChild: AnalyzedContentItem(
                  contents: _historyItem.contents,
                  type: _historyType,
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
                      title: Text(DictKey.aboutBarcodeInformationLabel.s),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.only(right: 16, left: 16, bottom: 8),
                      subtitle: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              SelectableText(
                                DictKey.aboutBarcodeFormatLabel.s +
                                HistoryFormat.localeStrFromName(_historyItem.format)
                              ),
                              SelectableText(Utils.formatUnixTimes(_historyItem.unixTime)),
                            ],
                          ),
                          SelectableText(
                            DictKey.aboutBarcodeOriginLabel.s +
                            HistoryOrigin.localeStrFromName(_historyItem.origin)
                          ),
                          if (_historyItem.getErrorLevel != .none) SelectableText(
                            '${DictKey.qrCodeErrorCorrectionLevelLabel.s}: '
                            '${HistoryErrorLevel.localeStrFromName(_historyItem.errorLevel)}',
                          ),
                          if (_historyItem.notes.isNotEmpty) Row(
                            crossAxisAlignment: .start,
                            children: [
                              SelectableText('${DictKey.matrixContactNotesLabel.s}: '),
                              Expanded(
                                child: SelectableText(
                                  _historyItem.notes,
                                  style: TextStyle(
                                    color: colorScheme.tertiary,
                                    fontWeight: .bold,
                                  ),
                                ),
                              ),
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
                  leading: const Icon(MaterialCommunityIcons.barcode_scan),
                  onTap: () => context.routeOf<PageCodeView>().toPass(_historyItem),
                  trailing: Row(
                    mainAxisSize: .min,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        visualDensity: .compact,
                        onPressed: _pressItemFavorite,
                        icon: Icon(_historyItem.isFavorite ? Icons.favorite : Icons.favorite_outline),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        visualDensity: .compact,
                        onPressed: _pressShareContents,
                        icon: const Icon(Icons.share),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        visualDensity: .compact,
                        onPressed: _pressModifyContents,
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        visualDensity: .compact,
                        onPressed: _pressCopyContents,
                        icon: const Icon(Icons.copy),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ListTile(
                minTileHeight: 0,
                subtitle: Text(DictKey.actionsLabel.s),
              ),
              Builder(
                builder: (context) {
                  const int crossAxisCount = 3;
                  final List<PressButtonGrid> actionGrids = _getActionGridList();
                  final int rowCount = (actionGrids.length / crossAxisCount).ceil();
                  return Column(
                    children: List.generate(rowCount, (rowIndex) {
                      return IntrinsicHeight(
                        child: Row(
                          children: List.generate(crossAxisCount, (columnIndex) {
                            final int index = rowIndex * crossAxisCount + columnIndex;
                            return index < actionGrids.length
                                ? Expanded(child: actionGrids[index])
                                : const Expanded(child: SizedBox.shrink());
                          }),
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  List<PressButtonGrid> _getActionGridList() => [
    if (_historyType != .website) PressButtonGrid(
      iconData: Icons.search,
      description: DictKey.actionWebSearchLabel.s,
      onTap: () async {
        final SearchEngine searchEngine = context.readPrefs.get(.selectedSearchEngine);
        await Utils.searchInBrowser(searchEngine.url, _historyItem.contents);
      },
    ),

    if (_historyType == .website) PressButtonGrid(
      iconData: Icons.open_in_browser,
      description: DictKey.actionOpenLink.s,
      onTap: () => Utils.openUrlInBrowser(_historyItem.contents),
    ),

    if (context.readPrefs.get<List<CustomSearchUrl>>(.customSearchUrls).isNotEmpty) PressButtonGrid(
      iconData: Icons.search,
      description: DictKey.customSearchUrls.s,
      onTap: () => showMyDialog(
        context: context,
        title: DictKey.customSearchUrls.s,
        noCancelButton: true,
        content: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: .min,
              children: [
                for (final searchUrl in context.readPrefs.get<List<CustomSearchUrl>>(.customSearchUrls))
                  ItemTile(
                    title: searchUrl.title,
                    description: searchUrl.url,
                    onTap: () {
                      Utils.searchInBrowser(searchUrl.url, _historyItem.contents);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    ),

    PressButtonGrid(
      iconData: Icons.edit_note,
      description: DictKey.actionModifyNotes.s,
      onTap: () => showMyBottomSheet(
        context: context,
        title: Text(DictKey.actionModifyNotes.s),
        content: FormBuilder(
          key: _formKey,
          child: FormBuilderTextField(
            name: 'modifyNotes',
            keyboardType: .text,
            maxLines: null,
            initialValue: _historyItem.notes,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.format_size),
              labelText: DictKey.barcodeTextCompositionLabel.s,
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text(DictKey.actionModifyNotes.s),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() != true) return;
              _historyItem.notes = _formKey.currentState!.value['modifyNotes'];
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),

    // if (const <HistoryType>{.contact, .mail, .phone, .sms}.contains(_historyType)) PressButtonGrid(
    //   iconData: Icons.contacts_outlined,
    //   description: AppLocale.actionAddToContacts.s,
    //   onTap: // todo: _actionAddToContacts,
    // ),

    if (_historyType == .contact) PressButtonGrid(
      iconData: Icons.share,
      description: DictKey.actionShareVcfFile.s,
      onTap: () async {
        final Directory tempDir = await getTemporaryDirectory();
        final File file = File(p.join(tempDir.path, 'contact.vcf'));
        await file.writeAsString(_historyItem.contents);
        await Utils.share(ShareParams(files: [XFile(file.path)]));
      },
    ),

    if (_historyType == .mail) PressButtonGrid(
      iconData: Icons.mail_outline,
      description: DictKey.actionSendMailLabel.s,
      onTap: () {
        final analyzed = MailAnalyzer(_historyItem.contents).parse;
        if ((analyzed.email ?? analyzed.subject ?? analyzed.message) == null) return;
        final Uri uri = Uri(
          scheme: 'mailto',
          path: analyzed.email,
          queryParameters: {
            'subject': analyzed.subject,
            'body': analyzed.message,
          },
        );
        Utils.openUrlInBrowser(uri.toString());
      },
    ), // todo: 檢視方式

    if (_historyType == .phone || _historyType == .sms) PressButtonGrid(
      iconData: Icons.sms_outlined,
      description: DictKey.actionSendSmsLabel.s,
      onTap: () {
        String? phone;
        String? message;
        if (_historyType == .sms) {
          final analyzed = SmsAnalyzer(_historyItem.contents).parse;
          phone = analyzed.phone;
          message = analyzed.message;
        } else if (_historyType == .phone) {
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
      },
    ), // todo: 檢視方式

    if (_historyType == .phone || _historyType == .sms) PressButtonGrid(
      iconData: Icons.call,
      description: DictKey.actionCallPhoneLabel.s,
      onTap: () {
        String? phone;
        if (_historyType == .sms) {
          final analyzed = SmsAnalyzer(_historyItem.contents).parse;
          phone = analyzed.phone;
        } else if (_historyType == .phone) {
          phone = _historyItem.contents.substring(4);
        }
        if (phone != null) Utils.openUrlInBrowser('tel:$phone');
      },
    ), // todo: 檢視方式

    if (_historyType == .location) PressButtonGrid(
      iconData: Icons.location_on,
      description: DictKey.actionShowLocation.s,
      onTap: () => Utils.openUrlInBrowser('geo:${_historyItem.contents.substring(4)}'),
    ), // todo: 檢視方式

    // if (_historyType == .event) PressButtonGrid(
    //   iconData: Icons.event,
    //   description: AppLocale.actionAddToCalendar.s,
    //   onTap: // todo: _actionShareAgend,
    // ),

    PressButtonGrid(
      iconData: _isWillExist ? Icons.delete_forever : Icons.add,
      description: _isWillExist
          ? DictKey.menuItemHistoryDeleteFromHistory.s
          : DictKey.menuItemHistoryAddInHistory.s,
      onTap: () {
        Utils.showToast(_isWillExist
            ? DictKey.menuItemHistoryRemovedFromHistory.s
            : DictKey.menuItemHistoryAddedInHistory.s);
        setState(() => _isWillExist = !_isWillExist);
      },
    ),
  ];
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
