import 'package:flutter/material.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_view.dart';

class PageCustomurlsForm extends StatefulWidget with RouterBridge<PageCustomurlsFormArgs> {
  const PageCustomurlsForm({super.key});

  @override
  State<PageCustomurlsForm> createState() => _PageCustomurlsFormState();
}

class PageCustomurlsFormArgs {
  final int? index;
  final List<CustomSearchUrl> items;

  const PageCustomurlsFormArgs({
    this.index,
    required this.items,
  });
}

class _PageCustomurlsFormState extends State<PageCustomurlsForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final PageCustomurlsFormArgs _args = widget.getArgs(context)!;

  Future<void> _pressCheck() async {
    if (_formKey.currentState?.saveAndValidate() != true) return;
    Navigator.pop(context);
    final String formTitle = _formKey.currentState!.value['formTitle'];
    final String formUrl = _formKey.currentState!.value['formUrl'];
    if (_args.index == null) {
      _args.items.insert(0, CustomSearchUrl(title: formTitle, url: formUrl));
      Utils.showToast(DictKey.settingOptionCustomSearchAdded.s);
    } else {
      _args.items[_args.index!] = CustomSearchUrl(title: formTitle, url: formUrl);
      Utils.showToast(DictKey.settingOptionCustomSearchUpdated.s);
    }
    await context.readPrefs.update(.customSearchUrls, _args.items);
  }

  @override
  Widget build(context) {
    final CustomSearchUrl? argItem = _args.index == null ? null : _args.items[_args.index!];
    return Scaffold(
      appBar: AppBar(
        title: Text(argItem == null
            ? DictKey.settingOptionCustomSearchAdd.s
            : DictKey.settingOptionCustomSearchEdit.s
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _pressCheck,
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Scrollbar(
          child: ListView(
            padding: const .all(16.0),
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'formTitle',
                      keyboardType: .text,
                      autovalidateMode: .onUserInteraction,
                      initialValue: argItem?.title,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.format_size),
                        labelText: DictKey.analysisContactName.s,
                      ),
                      validator: FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'formUrl',
                      keyboardType: .url,
                      autovalidateMode: .onUserInteraction,
                      initialValue: argItem?.url,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.web),
                        labelText: DictKey.creatorHintUrl.s,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
                        FormBuilderValidators.startsWith('http', errorText: DictKey.errorUrlFormat.s),
                        FormBuilderValidators.contains(StaticString.searchReplaceWord, errorText: DictKey.settingErrorCustomUrl.s),
                        FormBuilderValidators.url(errorText: DictKey.errorInvalidValue.s),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SelectableText('${DictKey.settingOptionCustomSearchInfo.s}\n\n${DictKey.settingOptionCustomSearchExample.s} ${StaticString.googleUrl}'),
            ],
          ),
        ),
      ),
    );
  }
}
