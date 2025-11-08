import 'package:flutter/material.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PageCustomurlsForm extends StatefulWidget with RouterBridge<String> {
  const PageCustomurlsForm({super.key});

  @override
  State<PageCustomurlsForm> createState() => _PageCustomurlsFormState();
}

class _PageCustomurlsFormState extends State<PageCustomurlsForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _title = '';
  String _url = '';
  bool _isAddorModify = true; // true:Add, false:Modify

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final argument = widget.argumentOf(context);
    final List<String> customSearchUrls = context.readPrefs.get(PrefsEnum.customSearchUrls);
    if (argument == null) throw 'widget.argumentOf(context) connot be null.';
    if (argument != '') {
      final List<String> parts = argument.split(StaticString.separationObject);
      _title = parts[0];
      _url = parts[1];
      _isAddorModify = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (argument == '')
            ? AppLocale.customSearchUrlsAddUrl.s
            : AppLocale.customSearchUrlsModifyUrl.s
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                String formTitle = _formKey.currentState?.value['formTitle'];
                formTitle = formTitle.replaceAll('<>', ' ');
                final formUrl = _formKey.currentState?.value['formUrl'];
                if (_isDuplicatedTitle(formTitle, customSearchUrls)) {
                  Utils.showToast(AppLocale.customSearchUrlsisDuplicated.s);
                  return;
                }
                if (_isAddorModify) {
                  customSearchUrls.add('$formTitle${StaticString.separationObject}$formUrl');
                  Utils.showToast(AppLocale.customUrlAdded.s);
                } else {
                  for (int i = 0; i<customSearchUrls.length; i++) {
                    if (customSearchUrls[i].startsWith('$_title${StaticString.separationObject}')) {
                      customSearchUrls[i] = '$formTitle${StaticString.separationObject}$formUrl';
                    }
                  }
                  Utils.showToast(AppLocale.customUrlUpdated.s);
                }
                context.readPrefs.update(PrefsEnum.customSearchUrls, customSearchUrls);
                Navigator.pop(context);
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
              const SizedBox(height: 16),
              FormBuilder(
                key:_formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'formTitle',
                      initialValue: _title,
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
                      initialValue: _url,
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
  
  bool _isDuplicatedTitle(String formTitle, List<String> customSearchUrls) {
    if (_title == formTitle) return false;
    for (int i = 0; i<customSearchUrls.length; i++) {
      if (customSearchUrls[i].startsWith('$formTitle${StaticString.separationObject}')) {
        return true;
      }
    }
    return false;
  }
}