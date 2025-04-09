import 'package:flutter/material.dart';
import 'package:watashi_qr/common/hive_storage.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/pages/menu_history/barcode_view.dart';
import 'package:watashi_qr/pages/menu_settings/appabout_page.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/pages/widgets/barcode_text_field.dart';
import 'package:watashi_qr/pages/widgets/list_tile_item.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BarcodeForm extends StatefulWidget with RouterBridge<String> {
  const BarcodeForm({super.key});

  @override
  State<BarcodeForm> createState() => _BarcodeFormState();
}

class _BarcodeFormState extends State<BarcodeForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final barcodeType = widget.argumentOf(context);
    final localeStr = Language.of(context)!;
    final theme = Theme.of(context);
    if (barcodeType == null) return AppAboutPage();
    return Scaffold(
      appBar: AppBar(
        title: Text(localeStr.titleBarCodeCreator),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final value = _formKey.currentState?.value['name'];
                final bool isBarCodeGenerationHistoryEnabled = context.read<SettingsProvider>()
                  .isBarCodeGenerationHistoryEnabled;
                final HistoryItem item = HistoryItem(
                  unixTime: Utils.getNowUnixTime(),
                  contents: value,
                  formatName: barcodeType,
                  type: Utils.determineType(barcodeType, value),
                  errorCorrectionLevel: 'NONE',
                  origin: 'C',
                  isFavorite: false,
                  notes: '',
                );
                if (isBarCodeGenerationHistoryEnabled) HiveStorage.addItem(item, context:context);
                context.routeOf<BarcodeView>().arguments(item).to();
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                ListTileItem(
                  title:Utils.formatNameStr(barcodeType, localeStr),
                  icon:Utils.formatNameIcon(barcodeType),
                ),
                const SizedBox(height: 16),
                FormBuilder(
                  key:_formKey,
                  child: BarcodeTextField(
                    barcodeType: barcodeType,
                    name: 'name',
                    formKey: _formKey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(Utils.formatNameDescription(barcodeType, localeStr) ?? '',
                    softWrap: true,
                    style: theme.textTheme.bodyMedium
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        )
      )
    );
  }

}