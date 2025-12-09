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
  final _formKey = GlobalKey<FormBuilderState>();
  late final PageCustomurlsFormArgs _args;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _args = widget.argumentOf(context)!;
      _isInitialized = true;
    }
  }

  Future<void> _pressedCheck() async {
    if (_formKey.currentState?.saveAndValidate() != true) return;
    Navigator.pop(context);
    final String formTitle = _formKey.currentState?.value['formTitle'];
    final String formUrl = _formKey.currentState?.value['formUrl'];
    if (_args.index == null) {
      _args.items.insert(0, CustomSearchUrl(title: formTitle, url: formUrl));
      Utils.showToast(AppLocale.customUrlAdded.s);
    } else {
      _args.items[_args.index!] = CustomSearchUrl(title: formTitle, url: formUrl);
      Utils.showToast(AppLocale.customUrlUpdated.s);
    }
    await context.readPrefs.update(PrefsEnum.customSearchUrls, _args.items);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const Center(child: CircularProgressIndicator());
    final theme = Theme.of(context);
    final argItem = _args.index == null ? null : _args.items[_args.index!];
    return Scaffold(
      appBar: AppBar(
        title: Text(argItem == null
            ? AppLocale.customSearchUrlsAddUrl.s
            : AppLocale.customSearchUrlsModifyUrl.s
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _pressedCheck,
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
                key:_formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'formTitle',
                      initialValue: argItem?.title,
                      maxLines: null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.format_size),
                        labelText: AppLocale.matrixContactNameLabel.s,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
                      ]),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'formUrl',
                      initialValue: argItem?.url,
                      maxLines: null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.web),
                        labelText: AppLocale.matrixUriUrlLabel.s,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
                        FormBuilderValidators.contains('{code}', errorText: AppLocale.customSearchUrlsErrorUrl.s),
                        FormBuilderValidators.startsWith('http', errorText: AppLocale.errorBarcodeQrUrlFormatMessage.s),
                        FormBuilderValidators.url(errorText: AppLocale.errorBarcodeNoneCharacterMessage.s),
                      ]),
                      keyboardType: TextInputType.url,
                    ),
                  ],
                )
              ),
              const SizedBox(height: 16),
              SelectableText('${AppLocale.customSearchUrlsAddInfo.s}\n\n${AppLocale.examples.s} ${StaticString.googleUrl}',
                style: theme.textTheme.bodyMedium
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
