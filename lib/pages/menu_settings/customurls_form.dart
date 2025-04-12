import 'package:flutter/material.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/pages/menu_settings/appabout_page.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomurlsForm extends StatefulWidget with RouterBridge<String> {
  const CustomurlsForm({super.key});

  @override
  State<CustomurlsForm> createState() => _CustomurlsFormState();
}

class _CustomurlsFormState extends State<CustomurlsForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _title = '';
  String _url = '';
  bool _isAddorModify = true; // true:Add, false:Modify

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    final theme = Theme.of(context);
    final argument = widget.argumentOf(context);
    final List<String> customSearchUrls = context.settingsProvider.customSearchUrls;
    if (argument == null) return AppAboutPage();
    if (argument != '') {
      final List<String> parts = argument.split('<Separation.Object>');
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
                  customSearchUrls.add('$formTitle<Separation.Object>$formUrl');
                  Utils.showToast(localeStr.customUrlAdded);
                } else {
                  for (int i = 0; i<customSearchUrls.length; i++) {
                    if (customSearchUrls[i].startsWith('$_title<Separation.Object>')) {
                      customSearchUrls[i] = '$formTitle<Separation.Object>$formUrl';
                    }
                  }
                  Utils.showToast(localeStr.customUrlUpdated);
                }
                context.settingsProvider.updateSetting(PreferenceKey.customSearchUrls, customSearchUrls);
                Navigator.pop(context);
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
                          FormBuilderValidators.url(errorText: localeStr.errorBarcodeNoneCharacterMessage),
                          FormBuilderValidators.contains('{code}', errorText: localeStr.customSearchUrlsErrorUrl),
                          FormBuilderValidators.contains('http', errorText: localeStr.errorBarcodeQrUrlFormatMessage),
                        ]),
                        keyboardType: TextInputType.url,
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 16),
                Text(localeStr.customSearchUrlsAddInfo,
                  softWrap: true,
                  style: theme.textTheme.bodyMedium
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  bool _isDuplicatedTitle(String formTitle, List<String> customSearchUrls) {
    if (_title == formTitle) return false;
    for (int i = 0; i<customSearchUrls.length; i++) {
      if (customSearchUrls[i].startsWith('$formTitle<Separation.Object>')) {
        return true;
      }
    }
    return false;
  }
  
}