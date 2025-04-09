import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watashi_qr/common/hive_storage.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/pages/menu_history/barcode_view.dart';
import 'package:watashi_qr/pages/menu_settings/appabout_page.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:string_validator/string_validator.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:watashi_qr/pages/widgets/barcode_text_field.dart';
import 'package:watashi_qr/pages/widgets/list_tile_item.dart';

class QrcodeForm extends StatefulWidget with RouterBridge<String> {
  const QrcodeForm({super.key});

  @override
  State<QrcodeForm> createState() => _QrcodeFormState();
}

class _QrcodeFormState extends State<QrcodeForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _agendAllday = false; // only for the AGEND form
  String _wifiSecurityType = 'SAE'; // only for the WIFI form
  List<String> _contactMailType = ['home', 'home', 'home']; // only for the _CONTACT form
  List<String> _contactPhoneType = ['cell', 'cell', 'cell']; // only for the _CONTACT form

  void _sendForm(String contents, String qrcodeType) {
    if (contents.length > 4296) {
      Utils.showToast('Error: contents.length > 4296');
      return;
    }
    final bool isBarCodeGenerationHistoryEnabled = context.read<SettingsProvider>()
        .isBarCodeGenerationHistoryEnabled;
    final String qrCodeErrorLevel = context.read<SettingsProvider>().qrCodeErrorLevel;
    final HistoryItem item = HistoryItem(
      unixTime: Utils.getNowUnixTime(),
      contents: contents,
      formatName: 'QR_CODE',
      type: qrcodeType,
      errorCorrectionLevel: qrCodeErrorLevel,
      origin: 'C',
      isFavorite: false,
      notes: '',
    );
    if (isBarCodeGenerationHistoryEnabled) HiveStorage.addItem(item, context:context);
    context.routeOf<BarcodeView>().arguments(item).to();
  }

  @override
  Widget build(BuildContext context) {
    final qrcodeType = widget.argumentOf(context);
    final localeStr = Language.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    if (qrcodeType == null) return AppAboutPage();
    return Scaffold(
      appBar: AppBar(
        title: Text(localeStr.titleBarCodeCreator),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final valueMap = _formKey.currentState?.value;
                if (valueMap == null) return;
                final String contents = _getFormValuetoContents(qrcodeType, valueMap);
                _sendForm(contents, qrcodeType);
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
                  title:Utils.formatTypeStr(qrcodeType, localeStr),
                  icon:Utils.formatTypeIcon(qrcodeType),
                ),
                const SizedBox(height: 16),
                FormBuilder(
                  key:_formKey,
                  child: _typeFormSwitch(
                    qrcodeType: qrcodeType,
                    localeStr: localeStr,
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }

  Future<void> importContactFromVcard(Language localeStr)  async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['vcf'],
      );
      if (result == null) {
        Utils.showToast(localeStr.cancelLabel);
        return;
      }

      final File file = File(result.files.single.path!);
      final String vCardString = await file.readAsString();
      _sendForm(vCardString, 'CONTACT');
    } catch (e) {
      Utils.showToast('${localeStr.snackBarMessageFileImportError}\n$e', 16);
    }
  }

  String _getFormValuetoContents(String qrcodeType, Map<String, dynamic> valueMap) {
    switch(qrcodeType) {
      case 'TEXT':
        return valueMap['text'];
      case 'WEBSITE':
        return valueMap['website'];
      case 'CONTACT':
        final String name = valueMap['name'] ?? '';
        final String firstname = valueMap['firstname'] ?? '';
        final String organisation = valueMap['organisation'] ?? '';
        final String jobtitle = valueMap['jobtitle'] ?? '';
        final String website = valueMap['website'] ?? '';
        final String email0 = valueMap['email0'] ?? '';
        final String email1 = valueMap['email1'] ?? '';
        final String email2 = valueMap['email2'] ?? '';
        final String phone0 = valueMap['phone0'] ?? '';
        final String phone1 = valueMap['phone1'] ?? '';
        final String phone2 = valueMap['phone2'] ?? '';
        final String streetaddress = valueMap['streetaddress'] ?? '';
        final String city = valueMap['city'] ?? '';
        final String region = valueMap['region'] ?? '';
        final String postalcode = valueMap['postalcode'] ?? '';
        final String country = valueMap['country'] ?? '';
        final String notes = valueMap['notes'] ?? '';
        String vCardString = 'BEGIN:VCARD\nVERSION:3.0\n';
        if ('$name$firstname'.isNotEmpty) {
          vCardString += 'N:$firstname;$name\n';
          vCardString += 'FN:$name $firstname\n';
        }
        if (organisation.isNotEmpty) vCardString += 'ORG:$organisation\n';
        if (jobtitle.isNotEmpty) vCardString += 'TITLE:$jobtitle\n';
        if (website.isNotEmpty) vCardString += 'URL:$website\n';
        if (email0.isNotEmpty) vCardString += 'EMAIL;TYPE=${_contactMailType[0]}:$email0\n';
        if (email1.isNotEmpty) vCardString += 'EMAIL;TYPE=${_contactMailType[1]}:$email1\n';
        if (email2.isNotEmpty) vCardString += 'EMAIL;TYPE=${_contactMailType[2]}:$email2\n';
        if (phone0.isNotEmpty) vCardString += 'TEL;TYPE=${_contactPhoneType[0]}:$phone0\n';
        if (phone1.isNotEmpty) vCardString += 'TEL;TYPE=${_contactPhoneType[1]}:$phone1\n';
        if (phone2.isNotEmpty) vCardString += 'TEL;TYPE=${_contactPhoneType[2]}:$phone2\n';
        if ('$streetaddress$city$region$postalcode$country'.isNotEmpty) {
          vCardString += 'ADR:;;$streetaddress;$city;$region;$postalcode;$country\n';
        }
        if (notes.isNotEmpty) vCardString += 'NOTE:$notes\n';
        return '${vCardString}END:VCARD';
      case 'MAIL':
        final String subject = valueMap['subject'] ?? '';
        final String message = valueMap['message'] ?? '';
        if ( subject.isNotEmpty || message.isNotEmpty){
          return 'MATMSG:TO:${valueMap['email']};SUB:$subject;BODY:$message;;';
        } else {
          return 'MAILTO:${valueMap['email']}';
        }
      case 'SMS':
        return 'SMSTO:${valueMap['phone']}:${valueMap['message']}';
      case 'PHONE':
        return 'tel:${valueMap['phone']}';
      case 'LOCATION':
        String height = valueMap['height'] ?? '';
        String request = valueMap['height'] ?? '';
        height = height.isNotEmpty ? ',$height' : '';
        request = request.isNotEmpty ? '?q=$request' : '';
        return 'geo:${valueMap['latitude']},${valueMap['longitude']}$height$request';
      case 'AGEND':
        final String summary = valueMap['summary'] ?? '';
        String location = valueMap['location'] ?? '';
        String description = valueMap['description'] ?? '';
        final isAllDay = valueMap['allday'] as bool? ?? false;
        final beginDate = valueMap['begindate'] as DateTime?;
        final beginTime = valueMap['begintime'] as DateTime?;
        final endDate = valueMap['enddate'] as DateTime?;
        final endTime = valueMap['endtime'] as DateTime?;

        if (beginDate == null || endDate == null) break;
        if (location.isNotEmpty) location = 'LOCATION:$location\n';
        if (description.isNotEmpty) description = 'DESCRIPTION:$description\n';

        DateTime beginDateTime;
        DateTime endDateTime;

        if (isAllDay) {
          beginDateTime = beginDate;
          endDateTime = endDate;
        } else {
          // Combine date and time
          beginDateTime = DateTime(
            beginDate.year,
            beginDate.month,
            beginDate.day,
            beginTime?.hour ?? 0,
            beginTime?.minute ?? 0,
          ).toUtc();

          endDateTime = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            endTime?.hour ?? 0,
            endTime?.minute ?? 0,
          ).toUtc();
        }

        // Swap dates if begin is after end
        if (beginDateTime.isAfter(endDateTime)) {
          final temp = beginDateTime;
          beginDateTime = endDateTime;
          endDateTime = temp;
        }

        final beginFormatter = isAllDay ? DateFormat("';VALUE=DATE:'yyyyMMdd") : DateFormat("':'yyyyMMdd'T'HHmm00'Z'");
        final endFormatter = isAllDay ? DateFormat("';VALUE=DATE:'yyyyMMdd") : DateFormat("':'yyyyMMdd'T'HHmm00'Z'");
        final dtstart = 'DTSTART${beginFormatter.format(beginDateTime)}\n';
        final dtend = 'DTEND${endFormatter.format(endDateTime)}\n';

        return 'BEGIN:VEVENT\nSUMMARY:$summary\n$dtstart$dtend$location${description}END:VEVENT';
      case 'WIFI':
        final String ssid = valueMap['ssid'] ?? '';
        final String password = (_wifiSecurityType!='nopass') ? (valueMap['password'] ?? '') : '';
        final bool hide = valueMap['hide'] ?? false;
        return 'WIFI:S:$ssid;T:$_wifiSecurityType;P:$password;H:$hide;';
    }
    return 'null';
  }

  Widget _typeFormSwitch({
    required String qrcodeType,
    required Language localeStr,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    switch(qrcodeType) {
      case 'WEBSITE':
        return FormBuilderTextField(
          name: 'website',
          maxLines: null,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.web),
            labelText: localeStr.qrCodeTextGeneratorHintUrlInputEditText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          keyboardType: TextInputType.url,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
            FormBuilderValidators.url(errorText: localeStr.errorBarcodeNoneCharacterMessage),
          ]),
          onEditingComplete: () {
            _formKey.currentState?.fields['website']?.validate();
          },
        );
      case 'CONTACT':
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final textFieldWidth = constraints.maxWidth * 0.65;
            final menuFieldWidth = constraints.maxWidth * 0.35 - 6;
            return Column(
              children: [
                // // todo: 從手機選擇聯絡人功能
                // ElevatedButton(
                //   child: Text(localeStr.qrCodeTypeNameGenerateFromContact),
                //   onPressed: ()=>(),
                // ),
                ElevatedButton(
                  onPressed: () => importContactFromVcard(localeStr),
                  child: Text(localeStr.qrCodeImportContactFromVcard),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'name',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'firstname',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintFirstName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'organisation',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.matrixContactOrganisationLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'jobtitle',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.matrixContactJobTitleLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'website',
                  maxLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.web),
                    labelText: localeStr.qrCodeTextInputEditTextHintWebSite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 8),
                ...{
                  0: localeStr.qrCodeTextInputEditTextHintMail1,
                  1: localeStr.qrCodeTextInputEditTextHintMail2,
                  2: localeStr.qrCodeTextInputEditTextHintMail3,
                }.entries.map((entry) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: textFieldWidth,
                          child: FormBuilderTextField(
                            name: 'email${entry.key}',
                            maxLines: 1,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.mail_outline),
                              labelText: entry.value,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                          width: menuFieldWidth,
                          child: DropdownMenu(
                              initialSelection: _contactMailType[entry.key],
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: 'home', label: localeStr.spinnerTypeHome),
                                DropdownMenuEntry(value: 'work', label: localeStr.spinnerTypeWork),
                                DropdownMenuEntry(value: 'other', label: localeStr.spinnerTypeOther),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  _contactMailType[entry.key] = value ?? _contactMailType[entry.key];
                                });
                              }
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                )),
                ...{
                  0: localeStr.qrCodeTextInputEditTextHintPhone1,
                  1: localeStr.qrCodeTextInputEditTextHintPhone2,
                  2: localeStr.qrCodeTextInputEditTextHintPhone3,
                }.entries.map((entry) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: textFieldWidth,
                          child: FormBuilderTextField(
                            name: 'phone${entry.key}',
                            maxLines: 1,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.call),
                              labelText: entry.value,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(
                          width: menuFieldWidth,
                          child: DropdownMenu(
                              initialSelection: _contactPhoneType[entry.key],
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: 'cell', label: localeStr.spinnerTypeMobile),
                                DropdownMenuEntry(value: 'home', label: localeStr.spinnerTypeHome),
                                DropdownMenuEntry(value: 'work', label: localeStr.spinnerTypeWork),
                                DropdownMenuEntry(value: 'fax', label: localeStr.spinnerTypeFax),
                                DropdownMenuEntry(value: 'other', label: localeStr.spinnerTypeOther),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  _contactPhoneType[entry.key] = value ?? _contactPhoneType[entry.key];
                                });
                              }
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                )),
                FormBuilderTextField(
                  name: 'streetaddress',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintStreetAddress,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'city',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintCity,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'region',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintRegion,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'postalcode',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintPostalCode,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'country',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintCountry,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'notes',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintNotes,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      case 'MAIL':
        return Column(
        children: [
          FormBuilderTextField(
            name: 'email',
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail_outline),
              labelText: localeStr.qrCodeTextInputEditTextHintEmail,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
              FormBuilderValidators.email(errorText: localeStr.errorBarcodeNoneCharacterMessage),
            ]),
            onEditingComplete: () {
              _formKey.currentState?.fields['email']?.validate();
            },
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'subject',
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.format_size),
              labelText: localeStr.qrCodeTextInputEditTextHintEmailSubject,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'message',
            maxLines: null,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.format_size),
              labelText: localeStr.qrCodeTextInputEditTextHintMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.multiline,
          ),
        ],
      );
      case 'SMS':
        return Column(
          children: [
            FormBuilderTextField(
              name: 'phone',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.call),
                labelText: localeStr.qrCodeTextGeneratorHintPhoneInputEditText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
                FormBuilderValidators.phoneNumber(errorText: localeStr.errorBarcodeQrPhoneNumberMissingMessage),
              ]),
              onEditingComplete: () {
                _formKey.currentState?.fields['phone']?.validate();
              },
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'message',
              maxLines: null,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.format_size),
                labelText: localeStr.qrCodeTextInputEditTextHintMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.multiline,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
              ]),
              onEditingComplete: () {
                _formKey.currentState?.fields['message']?.validate();
              },
            )
          ],
        );
      case 'PHONE':
        return FormBuilderTextField(
          name: 'phone',
          maxLines: 1,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.call),
            labelText: localeStr.qrCodeTextGeneratorHintPhoneInputEditText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
            FormBuilderValidators.phoneNumber(errorText: localeStr.errorBarcodeQrPhoneNumberMissingMessage),
          ]),
          onEditingComplete: () {
            _formKey.currentState?.fields['phone']?.validate();
          },
        );
      case 'LOCATION':
        return Column(
          children: [
            FormBuilderTextField(
              name: 'latitude',
              maxLines: 1,
              decoration: InputDecoration(
                labelText: localeStr.qrCodeTextInputEditTextHintLocalisationLatitude,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
                FormBuilderValidators.numeric(errorText: localeStr.errorBarcodeNoneCharacterMessage),
                FormBuilderValidators.between(-90,90, errorText: localeStr.errorBarcodeNoneCharacterMessage),
              ]),
              onEditingComplete: () {
                _formKey.currentState?.fields['latitude']?.validate();
              },
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'longitude',
              maxLines: 1,
              decoration: InputDecoration(
                labelText: localeStr.qrCodeTextInputEditTextHintLocalisationLongitude,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
                FormBuilderValidators.numeric(errorText: localeStr.errorBarcodeNoneCharacterMessage),
                FormBuilderValidators.between(-180, 180, errorText: localeStr.errorBarcodeNoneCharacterMessage),
              ]),
              onEditingComplete: () {
                _formKey.currentState?.fields['longitude']?.validate();
              },
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'height',
              maxLines: 1,
              decoration: InputDecoration(
                labelText: localeStr.qrCodeTextInputEditTextHintLocalisationHeight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value==null || value.isEmpty || value.isFloat){
                  return null;
                } else {
                  return localeStr.errorBarcodeNoneCharacterMessage;
                }
              },
              onEditingComplete: () {
                _formKey.currentState?.fields['height']?.validate();
              },
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'request',
              maxLines: 1,
              decoration: InputDecoration(
                labelText: localeStr.qrCodeTextInputEditTextHintLocalisationRequest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        );
      case 'AGEND':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              name: 'summary',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.format_size),
                labelText: localeStr.qrCodeTextInputEditTextHintAgendaEventName,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.text,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
              ]),
              onEditingComplete: () {
                _formKey.currentState?.fields['summary']?.validate();
              },
            ),
            FormBuilderCheckbox(
              name: 'allday',
              initialValue: false,
              title: Text(localeStr.checkBoxEventAllOfDay),
              onChanged: (value) {
                setState(() {
                  _agendAllday = value ?? false;
                });
              },
            ),
            Text('  ${localeStr.beginLabel}', style: TextStyle(color: Colors.grey)),
            Row(
              children: [
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'begindate',
                    decoration:
                    const InputDecoration(icon: Icon(Icons.event)),
                    initialValue: DateTime.now(),
                    inputType: InputType.date,
                    format: DateFormat('yyyy-MM-dd'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Visibility(
                    visible: !_agendAllday,
                    child: FormBuilderDateTimePicker(
                      name: 'begintime',
                      decoration:
                      const InputDecoration(icon: Icon(Icons.schedule)),
                      initialValue: DateTime.now(),
                      inputType: InputType.time,
                      format: DateFormat('HH:mm'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('  ${localeStr.endLabel}', style: TextStyle(color: Colors.grey)),
            Row(
              children: [
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'enddate',
                    decoration:
                    const InputDecoration(icon: Icon(Icons.event)),
                    initialValue: DateTime.now(),
                    inputType: InputType.date,
                    format: DateFormat('yyyy-MM-dd'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Visibility(
                    visible: !_agendAllday,
                    child: FormBuilderDateTimePicker(
                      name: 'endtime',
                      decoration:
                      const InputDecoration(icon: Icon(Icons.schedule)),
                      initialValue: DateTime.now(),
                      inputType: InputType.time,
                      format: DateFormat('HH:mm'),

                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FormBuilderTextField(
              name: 'location',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                labelText: localeStr.qrCodeTextInputEditTextHintAgendaPlace,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'description',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.format_size),
                labelText: localeStr.qrCodeTextInputEditTextHintAgendaDescription,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        );
      case 'WIFI':
        return Column(
          children: [
            FormBuilderTextField(
              name: 'ssid',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.format_size),
                labelText: localeStr.qrCodeTextInputEditTextHintWifiSsid,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.text,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
              ]),
              onEditingComplete: () {
                _formKey.currentState?.fields['ssid']?.validate();
              },
            ),
            const SizedBox(height: 16),
            DropdownMenu(
              initialSelection: _wifiSecurityType,
              expandedInsets: EdgeInsets.zero,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 'WEP', label: localeStr.spinnerWifiEncryptionWep),
                DropdownMenuEntry(value: 'WPA', label: localeStr.spinnerWifiEncryptionWpa),
                DropdownMenuEntry(value: 'SAE', label: localeStr.spinnerWifiEncryptionSae),
                DropdownMenuEntry(value: 'nopass', label: localeStr.spinnerWifiEncryptionNone),
              ],
              onSelected: (value) {
                setState(() {
                  _wifiSecurityType = value ?? _wifiSecurityType;
                });
              }
            ),
            const SizedBox(height: 16),
            if (_wifiSecurityType != 'nopass') FormBuilderTextField(
              name: 'password',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password),
                labelText: localeStr.qrCodeTextInputEditTextHintWifiPassword,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
              ]),
              onEditingComplete: () {
                _formKey.currentState?.fields['password']?.validate();
              },
            ),
            FormBuilderCheckbox(
              name: 'hide',
              initialValue: false,
              title: Text(localeStr.qrCodeTextInputEditTextHintWifiHide),
            ),
          ],
        );
      case 'TEXT':
        return BarcodeTextField(
            barcodeType: 'QR_CODE',
            name: 'text',
            formKey: _formKey
        );
    }
    return const SizedBox.shrink();
  }
}