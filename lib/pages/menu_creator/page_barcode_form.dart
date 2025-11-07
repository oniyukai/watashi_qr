import 'package:flutter/material.dart';
import 'package:watashi_qr/common/database_services.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_history/page_code_view.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/pages/widget/barcode_field.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PageBarcodeForm extends StatefulWidget with RouterBridge<HistoryFormat> {
  const PageBarcodeForm({super.key});

  @override
  State<PageBarcodeForm> createState() => _PageBarcodeFormState();
}

class _PageBarcodeFormState extends State<PageBarcodeForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final format = widget.argumentOf(context);
    final localeStr = Language.of(context);
    final theme = Theme.of(context);
    if (format == null) throw 'widget.argumentOf(context) connot be null.';
    return Scaffold(
      appBar: AppBar(
        title: Text(localeStr.titleBarCodeCreator),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final value = _formKey.currentState?.value['name'];
                final bool isCreateAddHistory = context.readSettings.isCreateAddHistory;
                final HistoryItem item = HistoryItem(
                  unixTime: Utils.nowUnixTime,
                  contents: value,
                  format: format.name,
                  type: HistoryType.fromDistinguish(format, value).name,
                  errorLevel: HistoryErrorLevel.none.name,
                  origin: HistoryOrigin.C.name,
                  isFavorite: false,
                  notes: '',
                );
                if (isCreateAddHistory) DatabaseServices.addItem(item, context:context);
                context.routeOf<PageCodeView>().arguments(item).to();
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              ItemTile(
                title: HistoryFormat.localeStrFromName(format.name, localeStr),
                myIconData: format.myIconData,
              ),
              const SizedBox(height: 16),
              FormBuilder(
                key:_formKey,
                child: BarcodeField(
                  format: format,
                  name: 'name',
                  formKey: _formKey,
                ),
              ),
              const SizedBox(height: 16),
              Text(format.description(localeStr) ?? '',
                  softWrap: true,
                  style: theme.textTheme.bodyMedium
              ),
              const SizedBox(height: 16),
            ],
          ),
        )
      )
    );
  }
}