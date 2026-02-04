import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_creator/main_creator_view.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_widgets.dart';
import 'package:watashi_qr/pages/widget/barcode_field.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';

class PageQrcodeForm extends StatefulWidget with RouterBridge<HistoryType> {
  const PageQrcodeForm({super.key});

  @override
  State<PageQrcodeForm> createState() => _PageQrcodeFormState();
}

class _PageQrcodeFormState extends State<PageQrcodeForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final HistoryType _historyType = widget.getArgs(context)!;
  late String Function(Map<String, dynamic> valueMap) _valueDecode;

  Future<void> _pressCheck() async {
    if (_formKey.currentState?.saveAndValidate() != true) return;
    final Map<String, dynamic> valueMap = _formKey.currentState!.value;
    await MainCreatorView.createRouteTo(context, _valueDecode(valueMap), .qrCode);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DictKey.navTitleCreateQrCode.s),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _pressCheck,
          )
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Scrollbar(
          child: ListView(
            padding: const .fromLTRB(16.0, 0.0, 16.0, 16.0),
            children: [
              ItemTile(
                title: HistoryType.localeStrFromName(_historyType.name),
                myIconData: _historyType.myIconData,
              ),
              const SizedBox(height: 16),
              FormBuilder(
                key: _formKey,
                child: _TypeSwitchForm(
                  historyType: _historyType,
                  valueDecodeChange: (valueDecode) => _valueDecode = valueDecode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeSwitchForm extends StatefulWidget {
  final HistoryType historyType;
  final ValueChanged<String Function(Map<String, dynamic> valueMap)> valueDecodeChange;

  const _TypeSwitchForm({
    required this.historyType,
    required this.valueDecodeChange,
  });

  @override
  State<_TypeSwitchForm> createState() {
    // 為了替換Big switch且簡潔StatefulWidget，目前沒有辦法的辦法
    final _FormState widgetState = switch (historyType) {
      .text => _StateText(),
      .website => _StateWebsite(),
      .contact => _StateContact(),
      .mail => _StateMail(),
      .sms => _StateSms(),
      .phone => _StatePhone(),
      .location => _StateLocation(),
      .event => _StateEvent(),
      .wifi => _StateWifi(),
      .product || .industrial => _StateUnsupported(),
    };
    valueDecodeChange(widgetState._valueDecode);
    return widgetState;
  }
}

abstract class _FormState extends State<_TypeSwitchForm> {
  String _valueDecode(Map<String, dynamic> valueMap);
}

class _StateUnsupported extends _FormState {
  @override
  String _valueDecode(valueMap) {
    return StaticString.nullString;
  }

  @override
  Widget build(context) {
    return const Text('Unsupported');
  }
}

class _StateText extends _FormState {
  @override
  String _valueDecode(valueMap) {
    return valueMap['text'];
  }

  @override
  Widget build(context) {
    return BarcodeField(
      format: .qrCode,
      name: 'text',
    );
  }
}

class _StateWebsite extends _FormState {
  @override
  String _valueDecode(valueMap) {
    return valueMap['website'];
  }

  @override
  Widget build(context) {
    return FormBuilderTextField(
      name: 'website',
      keyboardType: .url,
      autovalidateMode: .onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.web),
        labelText: DictKey.creatorHintUrl.s,
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
        FormBuilderValidators.startsWith('http', errorText: DictKey.errorUrlFormat.s),
        FormBuilderValidators.url(errorText: DictKey.errorInvalidValue.s),
      ]),
    );
  }
}

class _StateContact extends _FormState {
  final List<String> _mailType = ['home', 'home', 'home'];
  final List<String> _phoneType = ['cell', 'cell', 'cell'];

  @override
  String _valueDecode(valueMap) {
    final String name = valueMap['name'] ?? '';
    final String firstname = valueMap['firstname'] ?? '';
    final String organisation = valueMap['organisation'] ?? '';
    final String jobTitle = valueMap['jobTitle'] ?? '';
    final String website = valueMap['website'] ?? '';
    final String email0 = valueMap['email0'] ?? '';
    final String email1 = valueMap['email1'] ?? '';
    final String email2 = valueMap['email2'] ?? '';
    final String phone0 = valueMap['phone0'] ?? '';
    final String phone1 = valueMap['phone1'] ?? '';
    final String phone2 = valueMap['phone2'] ?? '';
    final String streetAddress = valueMap['streetAddress'] ?? '';
    final String city = valueMap['city'] ?? '';
    final String region = valueMap['region'] ?? '';
    final String postalCode = valueMap['postalCode'] ?? '';
    final String country = valueMap['country'] ?? '';
    final String notes = valueMap['notes'] ?? '';
    return <String>[
      'BEGIN:VCARD',
      'VERSION:3.0',
      if ('$name$firstname'.isNotEmpty) ...[
        'N:$firstname;$name',
        'FN:$name $firstname',
      ],
      if (organisation.isNotEmpty) 'ORG:$organisation',
      if (jobTitle.isNotEmpty) 'TITLE:$jobTitle',
      if (website.isNotEmpty) 'URL:$website',
      if (email0.isNotEmpty) 'EMAIL;TYPE=${_mailType[0]}:$email0',
      if (email1.isNotEmpty) 'EMAIL;TYPE=${_mailType[1]}:$email1',
      if (email2.isNotEmpty) 'EMAIL;TYPE=${_mailType[2]}:$email2',
      if (phone0.isNotEmpty) 'TEL;TYPE=${_phoneType[0]}:$phone0',
      if (phone1.isNotEmpty) 'TEL;TYPE=${_phoneType[1]}:$phone1',
      if (phone2.isNotEmpty) 'TEL;TYPE=${_phoneType[2]}:$phone2',
      if ('$streetAddress$city$region$postalCode$country'.isNotEmpty)
        'ADR:;;$streetAddress;$city;$region;$postalCode;$country',
      if (notes.isNotEmpty) 'NOTE:$notes',
      'END:VCARD',
    ].join('\n');
  }

  Future<void> _importContactFromVcard() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: .custom,
        allowedExtensions: const ["vcf"],
      );
      if (result == null) {
        Utils.showToast(DictKey.commonUiCancel.s);
        return;
      }
      final File file = File(result.files.single.path!);
      final String vCardString = await file.readAsString();
      await MainCreatorView.createRouteTo(context, vCardString, .qrCode);
    } catch (e) {
      Utils.showToast('${DictKey.historyDataImportError.s}\n$e', true);
    }
  }

  @override
  Widget build(context) {
    return Column(
      spacing: 8.0,
      children: [
        // ElevatedButton(
        //   onPressed: // todo: _importContactFromContact,
        //   child: Text(AppLocale.qrCodeTypeNameGenerateFromContact.s),
        // ),
        ElevatedButton(
          onPressed: _importContactFromVcard,
          child: Text(DictKey.creatorContactFromVcard.s),
        ),
        FormBuilderTextField(
          name: 'name',
          keyboardType: .name,
          decoration: InputDecoration(
            labelText: DictKey.creatorContactHintName.s,
          ),
        ),
        FormBuilderTextField(
          name: 'firstname',
          keyboardType: .name,
          decoration: InputDecoration(
            labelText: DictKey.creatorContactHintFirstName.s,
          ),
        ),
        FormBuilderTextField(
          name: 'organisation',
          keyboardType: .text,
          decoration: InputDecoration(
            labelText: DictKey.analysisContactOrganisation.s,
          ),
        ),
        FormBuilderTextField(
          name: 'jobTitle',
          keyboardType: .text,
          decoration: InputDecoration(
            labelText: DictKey.analysisContactJobTitle.s,
          ),
        ),
        FormBuilderTextField(
          name: 'website',
          keyboardType: .url,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.web),
            labelText: DictKey.creatorContactHintWebSite.s,
          ),
        ),
        ...<int, String>{
          0: DictKey.creatorContactHintMail1.s,
          1: DictKey.creatorContactHintMail2.s,
          2: DictKey.creatorContactHintMail3.s,
        }.entries.map((entry) => Row(
          spacing: 4.0,
          children: [
            Expanded(
              flex: 7,
              child: FormBuilderTextField(
                name: 'email${entry.key}',
                keyboardType: .emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline),
                  labelText: entry.value,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: DropdownMenu(
                expandedInsets: .zero,
                initialSelection: _mailType[entry.key],
                inputDecorationTheme: const InputDecorationTheme(),
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 'home', label: DictKey.creatorOptionHome.s),
                  DropdownMenuEntry(value: 'work', label: DictKey.creatorOptionWork.s),
                  DropdownMenuEntry(value: 'other', label: DictKey.creatorOptionOther.s),
                ],
                onSelected: (value) {
                  if (value != null) _mailType[entry.key] = value;
                },
              ),
            ),
          ],
        ),),
        ...<int, String>{
          0: DictKey.creatorContactHintPhone1.s,
          1: DictKey.creatorContactHintPhone2.s,
          2: DictKey.creatorContactHintPhone3.s,
        }.entries.map((entry) => Row(
          spacing: 4.0,
          children: [
            Expanded(
              flex: 7,
              child: FormBuilderTextField(
                name: 'phone${entry.key}',
                keyboardType: .phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.call),
                  labelText: entry.value,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: DropdownMenu(
                expandedInsets: .zero,
                initialSelection: _phoneType[entry.key],
                inputDecorationTheme: const InputDecorationTheme(),
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 'cell', label: DictKey.creatorOptionMobile.s),
                  DropdownMenuEntry(value: 'home', label: DictKey.creatorOptionHome.s),
                  DropdownMenuEntry(value: 'work', label: DictKey.creatorOptionWork.s),
                  DropdownMenuEntry(value: 'fax', label: DictKey.creatorOptionFax.s),
                  DropdownMenuEntry(value: 'other', label: DictKey.creatorOptionOther.s),
                ],
                onSelected: (value) {
                  if (value != null) _phoneType[entry.key] = value;
                },
              ),
            ),
          ],
        ),),
        FormBuilderTextField(
          name: 'streetAddress',
          keyboardType: .text,
          decoration: InputDecoration(
            labelText: DictKey.creatorContactHintStreetAddress.s,
          ),
        ),
        FormBuilderTextField(
          name: 'city',
          keyboardType: .text,
          decoration: InputDecoration(
            labelText: DictKey.creatorContactHintCity.s,
          ),
        ),
        FormBuilderTextField(
          name: 'region',
          keyboardType: .text,
          decoration: InputDecoration(
            labelText: DictKey.creatorContactHintRegion.s,
          ),
        ),
        FormBuilderTextField(
          name: 'postalCode',
          keyboardType: .text,
          decoration: InputDecoration(
            labelText: DictKey.creatorContactHintPostalCode.s,
          ),
        ),
        FormBuilderTextField(
          name: 'country',
          keyboardType: .text,
          decoration: InputDecoration(
            labelText: DictKey.creatorContactHintCountry.s,
          ),
        ),
        FormBuilderTextField(
          name: 'notes',
          keyboardType: .text,
          decoration: InputDecoration(
            labelText: DictKey.creatorContactHintNotes.s,
          ),
        ),
      ],
    );
  }
}

class _StateMail extends _FormState {
  @override
  String _valueDecode(valueMap) {
    final String email = valueMap['email'];
    final String subject = valueMap['subject'] ?? '';
    final String message = valueMap['message'] ?? '';
    if ('$subject$message'.isNotEmpty) {
      return 'MATMSG:TO:$email;SUB:$subject;BODY:$message;;';
    }
    return 'MAILTO:$email';
  }

  @override
  Widget build(context) {
    return Column(
      spacing: 16.0,
      children: [
        FormBuilderTextField(
          name: 'email',
          keyboardType: .emailAddress,
          autovalidateMode: .onUserInteraction,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail_outline),
            labelText: DictKey.creatorMailHintEmail.s,
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
            FormBuilderValidators.email(errorText: DictKey.errorInvalidValue.s),
          ]),
        ),
        FormBuilderTextField(
          name: 'subject',
          keyboardType: .text,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.format_size),
            labelText: DictKey.creatorMailHintSubject.s,
          ),
        ),
        FormBuilderTextField(
          name: 'message',
          keyboardType: .multiline,
          maxLines: null,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.format_size),
            labelText: DictKey.creatorHintMessage.s,
          ),
        ),
      ],
    );
  }
}

class _StateSms extends _FormState {
  @override
  String _valueDecode(valueMap) {
    return 'SMSTO:${valueMap['phone']}:${valueMap['message']}';
  }

  @override
  Widget build(context) {
    return Column(
      spacing: 16.0,
      children: [
        FormBuilderTextField(
          name: 'phone',
          keyboardType: .phone,
          autovalidateMode: .onUserInteraction,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.call),
            labelText: DictKey.creatorHintPhone.s,
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
            FormBuilderValidators.phoneNumber(errorText: DictKey.errorPhoneNumber.s),
          ]),
        ),
        FormBuilderTextField(
          name: 'message',
          keyboardType: .multiline,
          autovalidateMode: .onUserInteraction,
          maxLines: null,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.format_size),
            labelText: DictKey.creatorHintMessage.s,
          ),
          validator: FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
        ),
      ],
    );
  }
}

class _StatePhone extends _FormState {
  @override
  String _valueDecode(valueMap) {
    return 'tel:${valueMap['phone']}';
  }

  @override
  Widget build(context) {
    return FormBuilderTextField(
      name: 'phone',
      keyboardType: .phone,
      autovalidateMode: .onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.call),
        labelText: DictKey.creatorHintPhone.s,
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
        FormBuilderValidators.phoneNumber(errorText: DictKey.errorPhoneNumber.s),
      ]),
    );
  }
}

class _StateLocation extends _FormState {
  @override
  String _valueDecode(valueMap) {
    final String latitude = valueMap['latitude'];
    final String longitude = valueMap['longitude'];
    final String height = valueMap['height'] ?? '';
    final String request = valueMap['request'] ?? '';
    return <String>[
      'geo:$latitude,$longitude',
      if (height.isNotEmpty) ',$height',
      if (request.isNotEmpty) '?q=$request',
    ].join();
  }

  @override
  Widget build(context) {
    return Column(
      spacing: 16.0,
      children: [
        FormBuilderTextField(
          name: 'latitude',
          keyboardType: .number,
          autovalidateMode: .onUserInteraction,
          decoration: InputDecoration(
            labelText: DictKey.creatorGeoHintLatitude.s,
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
            FormBuilderValidators.numeric(errorText: DictKey.errorInvalidValue.s),
            FormBuilderValidators.between(-90,90, errorText: DictKey.errorInvalidValue.s),
          ]),
        ),
        FormBuilderTextField(
          name: 'longitude',
          keyboardType: .number,
          autovalidateMode: .onUserInteraction,
          decoration: InputDecoration(
            labelText: DictKey.creatorGeoHintLongitude.s,
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
            FormBuilderValidators.numeric(errorText: DictKey.errorInvalidValue.s),
            FormBuilderValidators.between(-180.0, 180.0, errorText: DictKey.errorInvalidValue.s),
          ]),
        ),
        FormBuilderTextField(
          name: 'height',
          keyboardType: .number,
          autovalidateMode: .onUserInteraction,
          decoration: InputDecoration(
            labelText: DictKey.creatorGeoHintAltitude.s,
          ),
          validator: FormBuilderValidators.numeric(errorText: DictKey.errorInvalidValue.s, checkNullOrEmpty: false),
        ),
        FormBuilderTextField(
          name: 'request',
          keyboardType: .text,
          decoration: InputDecoration(
            labelText: DictKey.creatorGeoHintQuery.s,
          ),
        ),
      ],
    );
  }
}

class _StateEvent extends _FormState {
  bool _isAllDay = false;

  @override
  String _valueDecode(valueMap) {
    final String summary = valueMap['summary'];
    final DateTime beginDate = valueMap['beginDate'];
    final DateTime endDate = valueMap['endDate'];
    final DateTime? beginTime = valueMap['beginTime'];
    final DateTime? endTime = valueMap['endTime'];
    final String location = valueMap['location'] ?? '';
    final String description = valueMap['description'] ?? '';
    final DateFormat dateFormat = _isAllDay ? DateFormat("';VALUE=DATE:'yyyyMMdd") : DateFormat("':'yyyyMMdd'T'HHmm00'Z'");
    late DateTime beginDateTime;
    late DateTime endDateTime;

    if (_isAllDay) {
      beginDateTime = beginDate;
      endDateTime = endDate;
    } else {
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
    if (beginDateTime.isAfter(endDateTime)) {
      final DateTime temp = beginDateTime;
      beginDateTime = endDateTime;
      endDateTime = temp;
    }

    return <String>[
      'BEGIN:VEVENT',
      'SUMMARY:$summary',
      'DTSTART${dateFormat.format(beginDateTime)}',
      'DTEND${dateFormat.format(endDateTime)}',
      if (location.isNotEmpty) 'LOCATION:$location',
      if (description.isNotEmpty) 'DESCRIPTION:$description',
      'END:VEVENT',
    ].join('\n');
  }

  @override
  Widget build(context) {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'summary',
          keyboardType: .text,
          autovalidateMode: .onUserInteraction,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.format_size),
            labelText: DictKey.creatorEventHintSummary.s,
          ),
          validator: FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
        ),
        const SizedBox(height: 4),
        ListTileSwitch(
          text: DictKey.creatorEventOptionAllDay.s,
          iconData: Icons.history_toggle_off,
          initialValue: _isAllDay,
          shape: RoundedRectangleBorder(borderRadius: .circular(64.0)),
          onToggle: (value) {
            setState(() => _isAllDay = value);
          },
        ),
        ListTile(
          minTileHeight: 0,
          subtitle: Text(DictKey.commonUiBegin.s),
        ),
        Row(
          children: [
            Expanded(
              child: FormBuilderDateTimePicker(
                name: 'beginDate',
                inputType: .date,
                initialValue: .now(),
                format: DateFormat('yyyy-MM-dd'),
                decoration: const InputDecoration(
                  icon: Icon(Icons.event),
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Visibility(
                visible: !_isAllDay,
                child: FormBuilderDateTimePicker(
                  name: 'beginTime',
                  inputType: .time,
                  initialValue: .now(),
                  format: DateFormat('HH:mm'),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.schedule),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ListTile(
          minTileHeight: 0,
          subtitle: Text(DictKey.commonUiEnd.s),
        ),
        Row(
          children: [
            Expanded(
              child: FormBuilderDateTimePicker(
                name: 'endDate',
                inputType: .date,
                initialValue: .now(),
                format: DateFormat('yyyy-MM-dd'),
                decoration: const InputDecoration(
                  icon: Icon(Icons.event),
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Visibility(
                visible: !_isAllDay,
                child: FormBuilderDateTimePicker(
                  name: 'endTime',
                  inputType: .time,
                  format: DateFormat('HH:mm'),
                  initialValue: .now(),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.schedule),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FormBuilderTextField(
          name: 'location',
          keyboardType: .text,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.location_on),
            labelText: DictKey.creatorEventHintPlace.s,
          ),
        ),
        const SizedBox(height: 16),
        FormBuilderTextField(
          name: 'description',
          keyboardType: .text,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.format_size),
            labelText: DictKey.creatorEventHintDescription.s,
          ),
        ),
      ],
    );
  }
}

class _StateWifi extends _FormState {
  String _securityType = 'SAE';
  bool _isHide = false;

  @override
  String _valueDecode(valueMap) {
    final String ssid = valueMap['ssid'];
    final String password = _securityType != 'nopass' ? valueMap['password'] : '';
    return 'WIFI:S:$ssid;T:$_securityType;P:$password;H:$_isHide;';
  }

  @override
  Widget build(context) {
    return Column(
      spacing: 16.0,
      children: [
        FormBuilderTextField(
          name: 'ssid',
          keyboardType: .text,
          autovalidateMode: .onUserInteraction,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.format_size),
            labelText: DictKey.creatorWifiHintSsid.s,
          ),
          validator: FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
        ),
        DropdownMenu(
          initialSelection: _securityType,
          expandedInsets: .zero,
          inputDecorationTheme: const InputDecorationTheme(),
          dropdownMenuEntries: [
            DropdownMenuEntry(value: 'WEP', label: DictKey.creatorWifiEncryptionWep.s),
            DropdownMenuEntry(value: 'WPA', label: DictKey.creatorWifiEncryptionWpa.s),
            DropdownMenuEntry(value: 'SAE', label: DictKey.creatorWifiEncryptionSae.s),
            DropdownMenuEntry(value: 'nopass', label: DictKey.creatorWifiEncryptionNone.s),
          ],
          onSelected: (value) {
            if (value != null) setState(() => _securityType = value);
          },
        ),
        if (_securityType != 'nopass') FormBuilderTextField(
          name: 'password',
          keyboardType: .visiblePassword,
          autovalidateMode: .onUserInteraction,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.password),
            labelText: DictKey.creatorWifiHintPassword.s,
          ),
          validator: FormBuilderValidators.required(errorText: DictKey.errorEmptyFields.s),
        ),
        ListTileSwitch(
          text: DictKey.creatorWifiHintHide.s,
          iconData: Icons.visibility_off_outlined,
          initialValue: _isHide,
          shape: RoundedRectangleBorder(borderRadius: .circular(64.0)),
          onToggle: (value) {
            setState(() => _isHide = value);
          },
        ),
      ],
    );
  }
}
