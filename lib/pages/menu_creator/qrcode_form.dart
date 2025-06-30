import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watashi_qr/common/hive_service.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/pages/menu_history/code_view.dart';
import 'package:watashi_qr/pages/menu_settings/appabout_page.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:string_validator/string_validator.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:watashi_qr/pages/widgets/barcode_text_field.dart';
import 'package:watashi_qr/pages/widgets/list_tile_item.dart';

class QrcodeForm extends StatefulWidget with RouterBridge<HistoryType> {
  const QrcodeForm({super.key});

  @override
  State<QrcodeForm> createState() => _QrcodeFormState();
}

class _QrcodeFormState extends State<QrcodeForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _agendAllday = false; // only for the AGEND form
  String _wifiSecurityType = 'SAE'; // only for the WIFI form
  final List<String> _contactMailType = <String>['home', 'home', 'home']; // only for the _CONTACT form
  final List<String> _contactPhoneType = <String>['cell', 'cell', 'cell']; // only for the _CONTACT form

  void _sendForm(String contents, HistoryType historyType) {
    if (contents.length > 2953) {
      Utils.showToast('${Language.of(context).errorBarcodeWrongLengthMessage}< 2953');
      return;
    }
    final bool isCreateAddHistory = context.readSettings.isCreateAddHistory;
    final String selectedQRErrorLevel = context.readSettings.selectedQRErrorLevel;
    final HistoryItem item = HistoryItem(
      unixTime: Utils.nowUnixTime,
      contents: contents,
      format: HistoryFormat.qrCode.name,
      type: historyType.name,
      errorLevel: selectedQRErrorLevel,
      origin: HistoryOrigin.C.name,
      isFavorite: false,
      notes: '',
    );
    if (isCreateAddHistory) HiveService.addItem(item, context:context);
    context.routeOf<CodeView>().arguments(item).to();
  }

  @override
  Widget build(BuildContext context) {
    final historyType = widget.argumentOf(context);
    final localeStr = Language.of(context);
    if (historyType == null) return AppAboutPage();
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
                final String contents = _contentsFromForm(historyType, valueMap);
                _sendForm(contents, historyType);
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
                title: HistoryType.localeStrFromName(historyType.name, localeStr),
                myIconData: historyType.myIconData,
              ),
              const SizedBox(height: 16),
              FormBuilder(
                key:_formKey,
                child: _formFromType(historyType, localeStr),
              ),
            ],
          ),
        )
      )
    );
  }

  Future<void> _importContactFromVcard(Language localeStr) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) {
        return Utils.showToast(localeStr.cancelLabel);
      } else if (!result.files.single.path!.endsWith('.vcf')) {
        return Utils.showToast('Error: Not .vcf file');
      }

      final File file = File(result.files.single.path!);
      final String vCardString = await file.readAsString();
      _sendForm(vCardString, HistoryType.contact);
    } catch (e) {
      Utils.showToast('${localeStr.snackBarMessageFileImportError}\n$e', true);
    }
  }

  String _contentsFromForm(HistoryType historyType, Map<String, dynamic> valueMap) {
    switch(historyType) {
      case HistoryType.text:
        return valueMap['text'];
      case HistoryType.website:
        return valueMap['website'];
      case HistoryType.contact:
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
      case HistoryType.mail:
        final String subject = valueMap['subject'] ?? '';
        final String message = valueMap['message'] ?? '';
        if ( subject.isNotEmpty || message.isNotEmpty){
          return 'MATMSG:TO:${valueMap['email']};SUB:$subject;BODY:$message;;';
        } else {
          return 'MAILTO:${valueMap['email']}';
        }
      case HistoryType.sms:
        return 'SMSTO:${valueMap['phone']}:${valueMap['message']}';
      case HistoryType.phone:
        return 'tel:${valueMap['phone']}';
      case HistoryType.location:
        String height = valueMap['height'] ?? '';
        String request = valueMap['request'] ?? '';
        height = height.isNotEmpty ? ',$height' : '';
        request = request.isNotEmpty ? '?q=$request' : '';
        return 'geo:${valueMap['latitude']},${valueMap['longitude']}$height$request';
      case HistoryType.event:
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
      case HistoryType.wifi:
        final String ssid = valueMap['ssid'] ?? '';
        final String password = (_wifiSecurityType!='nopass') ? (valueMap['password'] ?? '') : '';
        final bool hide = valueMap['hide'] ?? false;
        return 'WIFI:S:$ssid;T:$_wifiSecurityType;P:$password;H:$hide;';
      default:
    }
    return 'null';
  }

  Widget _formFromType(HistoryType historyType, Language localeStr) {
    switch(historyType) {
      case HistoryType.website:
        return FormBuilderTextField(
          name: 'website',
          maxLines: null,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.web),
            labelText: localeStr.qrCodeTextGeneratorHintUrlInputEditText,
          ),
          keyboardType: TextInputType.url,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: localeStr.errorEmptyFields),
            FormBuilderValidators.startsWith('http', errorText: localeStr.errorBarcodeQrUrlFormatMessage),
            FormBuilderValidators.url(errorText: localeStr.errorBarcodeNoneCharacterMessage),
          ]),
          onEditingComplete: () {
            _formKey.currentState?.fields['website']?.validate();
          },
        );
      case HistoryType.contact:
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final textFieldWidth = constraints.maxWidth * 0.65;
            final menuFieldWidth = constraints.maxWidth * 0.35 - 6;
            return Column(
              children: [
                // ElevatedButton(
                //   child: Text(localeStr.qrCodeTypeNameGenerateFromContact),
                //   onPressed: () => _importContactFromContact(localeStr), // todo
                // ),
                ElevatedButton(
                  child: Text(localeStr.qrCodeImportContactFromVcard),
                  onPressed: () => _importContactFromVcard(localeStr),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'name',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintName,
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'firstname',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintFirstName,
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'organisation',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.matrixContactOrganisationLabel,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'jobtitle',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.matrixContactJobTitleLabel,
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
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 8),
                ...<int, String>{
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
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                          width: menuFieldWidth,
                          child: DropdownMenu(
                              initialSelection: _contactMailType[entry.key],
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: const InputDecorationTheme(),
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
                ...<int, String>{
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
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(
                          width: menuFieldWidth,
                          child: DropdownMenu(
                              initialSelection: _contactPhoneType[entry.key],
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: const InputDecorationTheme(),
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
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'city',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintCity,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'region',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintRegion,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'postalcode',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintPostalCode,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'country',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintCountry,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'notes',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: localeStr.qrCodeTextInputEditTextHintNotes,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      case HistoryType.mail:
        return Column(
          children: [
            FormBuilderTextField(
              name: 'email',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline),
                labelText: localeStr.qrCodeTextInputEditTextHintEmail,
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
              ),
              keyboardType: TextInputType.multiline,
            ),
          ],
        );
      case HistoryType.sms:
        return Column(
          children: [
            FormBuilderTextField(
              name: 'phone',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.call),
                labelText: localeStr.qrCodeTextGeneratorHintPhoneInputEditText,
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
      case HistoryType.phone:
        return FormBuilderTextField(
          name: 'phone',
          maxLines: 1,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.call),
            labelText: localeStr.qrCodeTextGeneratorHintPhoneInputEditText,
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
      case HistoryType.location:
        return Column(
          children: [
            FormBuilderTextField(
              name: 'latitude',
              maxLines: 1,
              decoration: InputDecoration(
                labelText: localeStr.qrCodeTextInputEditTextHintLocalisationLatitude,
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
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        );
      case HistoryType.event:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              name: 'summary',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.format_size),
                labelText: localeStr.qrCodeTextInputEditTextHintAgendaEventName,
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
                    decoration: const InputDecoration(
                      icon: Icon(Icons.event),
                      border: UnderlineInputBorder(),
                    ),
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
                      decoration: const InputDecoration(
                        icon: Icon(Icons.schedule),
                        border: UnderlineInputBorder(),
                      ),
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
                    decoration: const InputDecoration(
                      icon: Icon(Icons.event),
                      border: UnderlineInputBorder(),
                    ),
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
                      decoration: const InputDecoration(
                        icon: Icon(Icons.schedule),
                        border: UnderlineInputBorder(),
                      ),
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
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        );
      case HistoryType.wifi:
        return Column(
          children: [
            FormBuilderTextField(
              name: 'ssid',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.format_size),
                labelText: localeStr.qrCodeTextInputEditTextHintWifiSsid,
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
              inputDecorationTheme: const InputDecorationTheme(),
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
      case HistoryType.text:
        return BarcodeTextField(
            format: HistoryFormat.qrCode,
            name: 'text',
            formKey: _formKey
        );
      default:
        return const SizedBox.shrink();
    }
  }
}