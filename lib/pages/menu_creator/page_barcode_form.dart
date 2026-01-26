import 'package:flutter/material.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_creator/main_creator_view.dart';
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
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final HistoryFormat _historyFormat = widget.getArgs(context)!;

  Future<void> _pressCheck() async {
    if (_formKey.currentState?.saveAndValidate() != true) return;
    final String contents = _formKey.currentState!.value['barcodeFieldName'];
    await MainCreatorView.createRouteTo(context, contents, _historyFormat);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DictKey.titleBarCodeCreator.s),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _pressCheck,
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              ItemTile(
                title: HistoryFormat.localeStrFromName(_historyFormat.name),
                myIconData: _historyFormat.myIconData,
              ),
              const SizedBox(height: 16),
              FormBuilder(
                key: _formKey,
                child: BarcodeField(
                  format: _historyFormat,
                  name: 'barcodeFieldName',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _historyFormat.description ?? '',
                softWrap: true,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
