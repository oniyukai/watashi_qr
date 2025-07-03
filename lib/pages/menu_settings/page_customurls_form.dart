import 'package:flutter/material.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_provider.dart';
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
    final localeStr = Language.of(context);
    final theme = Theme.of(context);
    final argument = widget.argumentOf(context);
    final List<String> customSearchUrls = context.readSettings.customSearchUrls;
    if (argument == null) throw 'widget.argumentOf(context) connot be null.';
    if (argument != '') {
      final List<String> parts = argument.split(Language.separationObject);
      _title = parts[0];
      _url = parts[1];
      _isAddorModify = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (argument == '')
            ? localeStr.customSearchUrlsAddUrl
            : localeStr.customSearchUrlsModifyUrl
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
                  Utils.showToast(localeStr.customSearchUrlsisDuplicated);
                  return;
                }
                if (_isAddorModify) {
                  customSearchUrls.add('$formTitle${Language.separationObject}$formUrl');
                  Utils.showToast(localeStr.customUrlAdded);
                } else {
                  for (int i = 0; i<customSearchUrls.length; i++) {
                    if (customSearchUrls[i].startsWith('$_title${Language.separationObject}')) {
                      customSearchUrls[i] = '$formTitle${Language.separationObject}$formUrl';
                    }
                  }
                  Utils.showToast(localeStr.customUrlUpdated);
                }
                context.readSettings.updateSetting(PreferenceKey.customSearchUrls, customSearchUrls);
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
                        labelText: localeStr.matrixContactNameLabel,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
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
                        labelText: localeStr.matrixUriUrlLabel,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
                        FormBuilderValidators.contains('{code}', errorText: localeStr.customSearchUrlsErrorUrl),
                        FormBuilderValidators.startsWith('http', errorText: localeStr.errorBarcodeQrUrlFormatMessage),
                        FormBuilderValidators.url(errorText: localeStr.errorBarcodeNoneCharacterMessage),
                      ]),
                      keyboardType: TextInputType.url,
                    ),
                  ],
                )
              ),
              const SizedBox(height: 16),
              SelectableText('${localeStr.customSearchUrlsAddInfo}\n\n${localeStr.examples} ${Language.googleUrl}',
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
      if (customSearchUrls[i].startsWith('$formTitle${Language.separationObject}')) {
        return true;
      }
    }
    return false;
  }
}