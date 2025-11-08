import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watashi_qr/common/database_services.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_history/page_code_view.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:string_validator/string_validator.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:watashi_qr/pages/widget/barcode_field.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';

class PageQrcodeForm extends StatefulWidget with RouterBridge<HistoryType> {
  const PageQrcodeForm({super.key});

  @override
  State<PageQrcodeForm> createState() => _PageQrcodeFormState();
}

class _PageQrcodeFormState extends State<PageQrcodeForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _eventAllday = false; // only for the EVENT form
  String _wifiSecurityType = 'SAE'; // only for the WIFI form
  final List<String> _contactMailType = <String>['home', 'home', 'home']; // only for the _CONTACT form
  final List<String> _contactPhoneType = <String>['cell', 'cell', 'cell']; // only for the _CONTACT form

  void _sendForm(String contents, HistoryType historyType) {
    if (contents.length > 2953) {
      Utils.showToast('${AppLocale.errorBarcodeWrongLengthMessage.s}< 2953');
      return;
    }
    final bool isCreateAddHistory = context.readPrefs.get(PrefsEnum.isCreateAddHistory);
    final String selectedQRErrorLevel = context.readPrefs.get<HistoryErrorLevel>(PrefsEnum.selectedQRErrorLevel).name;
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
    if (isCreateAddHistory) DatabaseServices.addItem(item, context:context);
    context.routeOf<PageCodeView>().arguments(item).to();
  }

  @override
  Widget build(BuildContext context) {
    final historyType = widget.argumentOf(context);
    if (historyType == null) throw 'widget.argumentOf(context) connot be null.';
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.titleBarCodeCreator.s),
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
              ItemTile(
                title: HistoryType.localeStrFromName(historyType.name),
                myIconData: historyType.myIconData,
              ),
              const SizedBox(height: 16),
              FormBuilder(
                key:_formKey,
                child: _formFromType(historyType),
              ),
            ],
          ),
        )
      )
    );
  }

  Future<void> _importContactFromVcard() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) {
        return Utils.showToast(AppLocale.cancelLabel.s);
      } else if (!result.files.single.path!.endsWith('.vcf')) {
        return Utils.showToast('Error: Not .vcf file');
      }

      final File file = File(result.files.single.path!);
      final String vCardString = await file.readAsString();
      _sendForm(vCardString, HistoryType.contact);
    } catch (e) {
      Utils.showToast('${AppLocale.snackBarMessageFileImportError.s}\n$e', true);
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

  Widget _formFromType(HistoryType historyType) {
    switch(historyType) {
      case HistoryType.website:
        return FormBuilderTextField(
          name: 'website',
          maxLines: null,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.web),
            labelText: AppLocale.qrCodeTextGeneratorHintUrlInputEditText.s,
          ),
          keyboardType: TextInputType.url,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
            FormBuilderValidators.startsWith('http', errorText: AppLocale.errorBarcodeQrUrlFormatMessage.s),
            FormBuilderValidators.url(errorText: AppLocale.errorBarcodeNoneCharacterMessage.s),
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
                //   onPressed: () => _importContactFromContact(), // todo
                //   child: Text(AppLocale.qrCodeTypeNameGenerateFromContact.s),
                // ),
                ElevatedButton(
                  onPressed: _importContactFromVcard,
                  child: Text(AppLocale.qrCodeImportContactFromVcard.s),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'name',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppLocale.qrCodeTextInputEditTextHintName.s,
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'firstname',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppLocale.qrCodeTextInputEditTextHintFirstName.s,
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'organisation',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppLocale.matrixContactOrganisationLabel.s,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'jobtitle',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppLocale.matrixContactJobTitleLabel.s,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'website',
                  maxLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.web),
                    labelText: AppLocale.qrCodeTextInputEditTextHintWebSite.s,
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 8),
                ...<int, String>{
                  0: AppLocale.qrCodeTextInputEditTextHintMail1.s,
                  1: AppLocale.qrCodeTextInputEditTextHintMail2.s,
                  2: AppLocale.qrCodeTextInputEditTextHintMail3.s,
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
                                DropdownMenuEntry(value: 'home', label: AppLocale.spinnerTypeHome.s),
                                DropdownMenuEntry(value: 'work', label: AppLocale.spinnerTypeWork.s),
                                DropdownMenuEntry(value: 'other', label: AppLocale.spinnerTypeOther.s),
                              ],
                              onSelected: (value) {
                                setState(() { //這不一定要setState
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
                  0: AppLocale.qrCodeTextInputEditTextHintPhone1.s,
                  1: AppLocale.qrCodeTextInputEditTextHintPhone2.s,
                  2: AppLocale.qrCodeTextInputEditTextHintPhone3.s,
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
                                DropdownMenuEntry(value: 'cell', label: AppLocale.spinnerTypeMobile.s),
                                DropdownMenuEntry(value: 'home', label: AppLocale.spinnerTypeHome.s),
                                DropdownMenuEntry(value: 'work', label: AppLocale.spinnerTypeWork.s),
                                DropdownMenuEntry(value: 'fax', label: AppLocale.spinnerTypeFax.s),
                                DropdownMenuEntry(value: 'other', label: AppLocale.spinnerTypeOther.s),
                              ],
                              onSelected: (value) {
                                setState(() { //這不一定要setState
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
                    labelText: AppLocale.qrCodeTextInputEditTextHintStreetAddress.s,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'city',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppLocale.qrCodeTextInputEditTextHintCity.s,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'region',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppLocale.qrCodeTextInputEditTextHintRegion.s,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'postalcode',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppLocale.qrCodeTextInputEditTextHintPostalCode.s,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'country',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppLocale.qrCodeTextInputEditTextHintCountry.s,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'notes',
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppLocale.qrCodeTextInputEditTextHintNotes.s,
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
                labelText: AppLocale.qrCodeTextInputEditTextHintEmail.s,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
                FormBuilderValidators.email(errorText: AppLocale.errorBarcodeNoneCharacterMessage.s),
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
                labelText: AppLocale.qrCodeTextInputEditTextHintEmailSubject.s,
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'message',
              maxLines: null,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.format_size),
                labelText: AppLocale.qrCodeTextInputEditTextHintMessage.s,
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
                labelText: AppLocale.qrCodeTextGeneratorHintPhoneInputEditText.s,
              ),
              keyboardType: TextInputType.phone,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
                FormBuilderValidators.phoneNumber(errorText: AppLocale.errorBarcodeQrPhoneNumberMissingMessage.s),
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
                labelText: AppLocale.qrCodeTextInputEditTextHintMessage.s,
              ),
              keyboardType: TextInputType.multiline,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
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
            labelText: AppLocale.qrCodeTextGeneratorHintPhoneInputEditText.s,
          ),
          keyboardType: TextInputType.phone,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
            FormBuilderValidators.phoneNumber(errorText: AppLocale.errorBarcodeQrPhoneNumberMissingMessage.s),
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
                labelText: AppLocale.qrCodeTextInputEditTextHintLocalisationLatitude.s,
              ),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
                FormBuilderValidators.numeric(errorText: AppLocale.errorBarcodeNoneCharacterMessage.s),
                FormBuilderValidators.between(-90,90, errorText: AppLocale.errorBarcodeNoneCharacterMessage.s),
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
                labelText: AppLocale.qrCodeTextInputEditTextHintLocalisationLongitude.s,
              ),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
                FormBuilderValidators.numeric(errorText: AppLocale.errorBarcodeNoneCharacterMessage.s),
                FormBuilderValidators.between(-180, 180, errorText: AppLocale.errorBarcodeNoneCharacterMessage.s),
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
                labelText: AppLocale.qrCodeTextInputEditTextHintLocalisationHeight.s,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value==null || value.isEmpty || value.isFloat){
                  return null;
                } else {
                  return AppLocale.errorBarcodeNoneCharacterMessage.s;
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
                labelText: AppLocale.qrCodeTextInputEditTextHintLocalisationRequest.s,
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
                labelText: AppLocale.qrCodeTextInputEditTextHintAgendaEventName.s,
              ),
              keyboardType: TextInputType.text,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
              ]),
              onEditingComplete: () {
                _formKey.currentState?.fields['summary']?.validate();
              },
            ),
            FormBuilderCheckbox(
              name: 'allday',
              initialValue: false,
              title: Text(AppLocale.checkBoxEventAllOfDay.s),
              onChanged: (value) {
                setState(() {
                  _eventAllday = value ?? false;
                });
              },
            ),
            Text('  ${AppLocale.beginLabel.s}', style: TextStyle(color: Colors.grey)),
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
                    visible: !_eventAllday,
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
            Text('  ${AppLocale.endLabel.s}', style: TextStyle(color: Colors.grey)),
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
                    visible: !_eventAllday,
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
                labelText: AppLocale.qrCodeTextInputEditTextHintAgendaPlace.s,
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'description',
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.format_size),
                labelText: AppLocale.qrCodeTextInputEditTextHintAgendaDescription.s,
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
                labelText: AppLocale.qrCodeTextInputEditTextHintWifiSsid.s,
              ),
              keyboardType: TextInputType.text,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
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
                DropdownMenuEntry(value: 'WEP', label: AppLocale.spinnerWifiEncryptionWep.s),
                DropdownMenuEntry(value: 'WPA', label: AppLocale.spinnerWifiEncryptionWpa.s),
                DropdownMenuEntry(value: 'SAE', label: AppLocale.spinnerWifiEncryptionSae.s),
                DropdownMenuEntry(value: 'nopass', label: AppLocale.spinnerWifiEncryptionNone.s),
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
                labelText: AppLocale.qrCodeTextInputEditTextHintWifiPassword.s,
              ),
              keyboardType: TextInputType.visiblePassword,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: AppLocale.errorEmptyFields.s),
              ]),
              onEditingComplete: () {
                _formKey.currentState?.fields['password']?.validate();
              },
            ),
            FormBuilderCheckbox(
              name: 'hide',
              initialValue: false,
              title: Text(AppLocale.qrCodeTextInputEditTextHintWifiHide.s),
            ),
          ],
        );
      case HistoryType.text:
        return BarcodeField(
            format: HistoryFormat.qrCode,
            name: 'text',
            formKey: _formKey
        );
      default:
        return const SizedBox.shrink();
    }
  }
}