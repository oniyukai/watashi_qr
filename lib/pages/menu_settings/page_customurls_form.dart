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
  late final PageCustomurlsFormArgs _args = widget.argumentOf(context)!;

  Future<void> _pressCheck() async {
    if (_formKey.currentState?.saveAndValidate() != true) return;
    Navigator.pop(context);
    final String formTitle = _formKey.currentState!.value['formTitle'];
    final String formUrl = _formKey.currentState!.value['formUrl'];
    if (_args.index == null) {
      _args.items.insert(0, CustomSearchUrl(title: formTitle, url: formUrl));
      Utils.showToast(AppLocale.customUrlAdded.s);
    } else {
      _args.items[_args.index!] = CustomSearchUrl(title: formTitle, url: formUrl);
      Utils.showToast(AppLocale.customUrlUpdated.s);
    }
    await context.readPrefs.update(.customSearchUrls, _args.items);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final CustomSearchUrl? argItem = _args.index == null ? null : _args.items[_args.index!];
    return Scaffold(
      appBar: AppBar(
        title: Text(argItem == null
            ? AppLocale.customSearchUrlsAddUrl.s
            : AppLocale.customSearchUrlsModifyUrl.s
        ),
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
              const SizedBox(height: 16),
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
                        labelText: AppLocale.matrixContactNameLabel.s,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'formUrl',
                      keyboardType: .url,
                      autovalidateMode: .onUserInteraction,
                      initialValue: argItem?.url,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.web),
                        labelText: AppLocale.matrixUriUrlLabel.s,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
                        FormBuilderValidators.startsWith('http', errorText: AppLocale.errorBarcodeQrUrlFormatMessage.s),
                        FormBuilderValidators.contains('{code}', errorText: AppLocale.customSearchUrlsErrorUrl.s),
                        FormBuilderValidators.url(errorText: AppLocale.errorBarcodeNoneCharacterMessage.s),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SelectableText('${AppLocale.customSearchUrlsAddInfo.s}\n\n${AppLocale.examples.s} ${StaticString.googleUrl}',
                style: textTheme.bodyMedium
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
