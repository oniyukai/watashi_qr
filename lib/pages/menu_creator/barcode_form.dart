import 'package:flutter/material.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_history/code_view.dart';
import 'package:watashi_qr/pages/menu_settings/appabout_page.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/pages/widgets/barcode_text_field.dart';
import 'package:watashi_qr/pages/widgets/list_tile_item.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BarcodeForm extends StatefulWidget with RouterBridge<HistoryFormat> {
  const BarcodeForm({super.key});

  @override
  State<BarcodeForm> createState() => _BarcodeFormState();
}

class _BarcodeFormState extends State<BarcodeForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final format = widget.argumentOf(context);
    final localeStr = Language.of(context);
    final theme = Theme.of(context);
    if (format == null) return AppAboutPage();
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
                if (isCreateAddHistory) HiveService.addItem(item, context:context);
                context.routeOf<CodeView>().arguments(item).to();
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
              ListTileItem(
                title: HistoryFormat.localeStrFromName(format.name, localeStr),
                icon: format.iconData,
              ),
              const SizedBox(height: 16),
              FormBuilder(
                key:_formKey,
                child: BarcodeTextField(
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