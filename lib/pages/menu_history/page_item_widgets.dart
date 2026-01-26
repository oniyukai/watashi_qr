import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';
import 'package:flutter/services.dart';

class PressButtonGrid extends StatelessWidget {
  final IconData iconData;
  final String description;
  final VoidCallback? onTap;

  const PressButtonGrid({
    super.key,
    required this.iconData,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: onTap,
        title: Icon(iconData),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            description,
            textAlign: .center,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}

class AnalyzedContentItem extends StatelessWidget {
  final String contents;
  final HistoryType? type;

  const AnalyzedContentItem({
    super.key,
    required this.contents,
    required this.type,
  });

  @override
  Widget build(context) {
    Iterable<MapEntry<String, String?>> entryList = const [];
    String? error;
    try {
      entryList = switch (type) {
        .text || .website || .product || .industrial || null => _TextAnalyzer(contents),
        .contact => _ContactAnalyzer(contents),
        .mail => MailAnalyzer(contents),
        .sms => SmsAnalyzer(contents),
        .phone => _PhoneAnalyzer(contents),
        .location => _LocationAnalyzer(contents),
        .event => _EventAnalyzer(contents),
        .wifi => _WifiAnalyzer(contents),
      }.getEntryList().where((e) => e.value?.isNotEmpty == true);
    } catch (e) {
      error = e.toString();
    }
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (entryList.isEmpty) SelectableText(contents)
        else for (final MapEntry<String, String?> entry in entryList)
          ItemTile(
            title: entry.value!,
            description: entry.key,
            trailing: IconButton(
              padding: const EdgeInsets.all(0),
              visualDensity: .compact,
              onPressed: () => Clipboard.setData(ClipboardData(text: entry.value!)),
              icon: const Icon(Icons.copy),
            ),
          ),
        if (error != null && error.isNotEmpty) SelectableText(
          'Analysis Error: $error',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ],
    );
  }
}

class _TextAnalyzer {
  final String _contents;

  const _TextAnalyzer(this._contents);

  dynamic _parse() => true;

  List<MapEntry<String, String?>> getEntryList() {
    assert(_parse());
    return const [];
  }
}

class _ContactAnalyzer extends _TextAnalyzer {
  _ContactAnalyzer(super._contents);
  late final parse = _parse();

  @override
  ({String name, String organisation, String jobTitle, String website,
  String mail, String phone, String address, String notes}) _parse() {
    String name = '';
    String organisation = '';
    String jobTitle = '';
    String website = '';
    String mail = '';
    String phone = '';
    String address = '';
    String notes = '';
    for (final i in _contents.split('\n')) {
      final String upperI = i.toUpperCase();
      if (upperI.startsWith('FN:') ){
        if (name.isNotEmpty) name += '\n';
        name += i.substring(3);
      } else if (upperI.startsWith('ORG:') ) {
        if (organisation.isNotEmpty) organisation += '\n';
        organisation += i.substring(4);
      } else if (upperI.startsWith('TITLE:') ) {
        if (jobTitle.isNotEmpty) jobTitle += '\n';
        jobTitle += i.substring(6);
      } else if (upperI.startsWith('URL:') ) {
        if (website.isNotEmpty) website += '\n';
        website += i.substring(4);
      } else if (upperI.startsWith('EMAIL') ) {
        if (mail.isNotEmpty) mail += '\n';
        mail += i.split(':').last;
      } else if (upperI.startsWith('TEL') ) {
        if (phone.isNotEmpty) phone += '\n';
        phone += i.split(':').last;
      } else if (upperI.startsWith('ADR:') ) {
        if (address.isNotEmpty) address += '\n';
        address += i.substring(4).split(';').where((split) => split.isNotEmpty).join('\n');
      } else if (upperI.startsWith('NOTE:') ) {
        if (notes.isNotEmpty) notes += '\n';
        notes += i.substring(5);
      }
    }
    return (
    name: name,
    organisation: organisation,
    jobTitle: jobTitle,
    website: website,
    mail: mail,
    phone: phone,
    address: address,
    notes: notes,
    );
  }

  @override
  List<MapEntry<String, String?>> getEntryList() => [
    MapEntry(DictKey.matrixContactNameLabel.s, parse.name),
    MapEntry(DictKey.matrixContactOrganisationLabel.s, parse.organisation),
    MapEntry(DictKey.matrixContactJobTitleLabel.s, parse.jobTitle),
    MapEntry(DictKey.matrixUriUrlLabel.s, parse.website),
    MapEntry(DictKey.matrixContactMailLabel.s, parse.mail),
    MapEntry(DictKey.matrixContactPhoneLabel.s, parse.phone),
    MapEntry(DictKey.matrixContactAddressLabel.s, parse.address),
    MapEntry(DictKey.matrixContactNotesLabel.s, parse.notes),
  ];
} // todo 重構解析

class MailAnalyzer extends _TextAnalyzer {
  MailAnalyzer(super._contents);
  late final parse = _parse();

  @override
  ({String? email, String? subject, String? message}) _parse() {
    String? email;
    String? subject;
    String? message;
    if (_contents.toUpperCase().startsWith('MAILTO:')) {
      final substring = _contents.substring(7);
      final Uri uri = Uri.parse('mailto:$substring');
      email = uri.path;
      subject = uri.queryParameters['subject'];
      message = uri.queryParameters['body'];
    } else {
      for (final i in _contents.substring(7).split(';')) {
        final String upperI = i.toUpperCase();
        if (upperI.startsWith('TO:')) {
          email = i.substring(3);
        } else if (upperI.startsWith('SUB:')) {
          subject = i.substring(4);
        } else if (upperI.startsWith('BODY:')) {
          message = i.substring(5);
        }
      }
    }
    return (
    email: email,
    subject: subject,
    message: message,
    );
  }

  @override
  List<MapEntry<String, String?>> getEntryList() => [
    MapEntry(DictKey.matrixEmailRecipientLabel.s, parse.email),
    MapEntry(DictKey.matrixSubjectLabel.s, parse.subject),
    MapEntry(DictKey.matrixBodyLabel.s, parse.message),
  ];
} // todo 重構解析

class SmsAnalyzer extends _TextAnalyzer {
  SmsAnalyzer(super._contents);
  late final parse = _parse();

  @override
  ({String phone, String? message}) _parse() {
    String? phone;
    String? message;
    final substring = _contents.substring(6);
    final Uri uri = Uri.parse('smsto:$substring');
    final uriPhone = uri.path;
    final uriMessage = uri.queryParameters['body'];
    if (uriMessage == null) {
      for (final i in substring.split(':')){
        if (phone == null) {
          phone = i;
        } else {
          message = i;
        }
      }
    }
    return (
    phone: phone ?? uriPhone,
    message: uriMessage ?? message,
    );
  }

  @override
  List<MapEntry<String, String?>> getEntryList() => [
    MapEntry(DictKey.matrixPhoneTelNumberLabel.s, parse.phone),
    MapEntry(DictKey.matrixBodyLabel.s, parse.message),
  ];
} // todo 重構解析

class _PhoneAnalyzer extends _TextAnalyzer {
  _PhoneAnalyzer(super._contents);
  late final parse = _parse();

  @override
  ({String phone}) _parse() => (
  phone: _contents.substring(4),
  );

  @override
  List<MapEntry<String, String?>> getEntryList() => [
    MapEntry(DictKey.matrixPhoneTelNumberLabel.s, parse.phone),
  ];
} // todo 重構解析

class _LocationAnalyzer extends _TextAnalyzer {
  _LocationAnalyzer(super._contents);
  late final parse = _parse();

  @override
  ({String? latitude, String? longitude, String? height, String? request}) _parse() {
    String? latitude;
    String? longitude;
    String? height;
    String? request;
    final substring = _contents.substring(4);
    final temp = substring.split('?');
    for (final i in temp.first.split(',')){
      if (latitude == null) {
        latitude = i;
      } else if (longitude == null) {
        longitude = i;
      } else {
        height = i;
      }
    }
    if (temp.length >= 2) request = temp.last.substring(2);
    return (
    latitude: latitude,
    longitude: longitude,
    height: height,
    request: request,
    );
  }

  @override
  List<MapEntry<String, String?>> getEntryList() => [
    MapEntry(DictKey.matrixLocalisationLatitudeLabel.s, parse.latitude),
    MapEntry(DictKey.matrixLocalisationLongitudeLabel.s, parse.longitude),
    MapEntry(DictKey.matrixLocalisationAltitudeLabel.s, parse.height),
    MapEntry(DictKey.matrixLocalisationQueryLabel.s, parse.request),
  ];
} // todo 重構解析

class _EventAnalyzer extends _TextAnalyzer {
  _EventAnalyzer(super._contents);
  late final parse = _parse();

  @override
  ({String? summary, String? startDate, String? endDate, String? location, String? description}) _parse() {
    String? summary;
    String? startDate;
    String? endDate;
    String? location;
    String? description;
    for (final i in _contents.split('\n')){
      final String upperI = i.toUpperCase();
      if (upperI.startsWith('SUMMARY:') ){
        summary = i.substring(8);
      } else if (upperI.startsWith('DTSTART') ) {
        final DateTime dateTime = DateTime.parse(i.split(':').last).toLocal();
        final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
        startDate = formatter.format(dateTime);
      } else if (upperI.startsWith('DTEND') ) {
        final DateTime dateTime = DateTime.parse(i.split(':').last).toLocal();
        final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
        endDate = formatter.format(dateTime);
      } else if (upperI.startsWith('LOCATION:') ) {
        location = i.substring(9);
      } else if (upperI.startsWith('DESCRIPTION:') ) {
        description = i.substring(12);
      }
    }
    return (
    summary: summary,
    startDate: startDate,
    endDate: endDate,
    location: location,
    description: description,
    );
  }

  @override
  List<MapEntry<String, String?>> getEntryList() => [
    MapEntry(DictKey.matrixAgendaNameEventLabel.s, parse.summary),
    MapEntry(DictKey.matrixAgendaStartDateEventLabel.s, parse.startDate),
    MapEntry(DictKey.matrixAgendaEndDateEventLabel.s, parse.endDate),
    MapEntry(DictKey.matrixAgendaPlaceEventLabel.s, parse.location),
    MapEntry(DictKey.matrixAgendaDescriptionEventLabel.s, parse.description),
  ];
} // todo 重構解析

class _WifiAnalyzer extends _TextAnalyzer {
  _WifiAnalyzer(super._contents);
  late final parse = _parse();

  @override
  ({String? ssid, String? password, String? security, String? hide}) _parse() {
    String? ssid;
    String? password;
    String? security;
    String? hide;
    for (final i in _contents.substring(5).split(';')){
      final String upperI = i.toUpperCase();
      final String? substring = i.length>2 ? i.substring(2) : null;
      if (upperI.startsWith('S:') ){
        ssid = substring;
      } else if (upperI.startsWith('P:') ) {
        password = substring;
      } else if (upperI.startsWith('T:') ) {
        security = substring;
      } else if (upperI.startsWith('H:') ) {
        hide = substring;
      }
    }
    return (
    ssid: ssid,
    password: password,
    security: security,
    hide: hide,
    );
  }

  @override
  List<MapEntry<String, String?>> getEntryList() => [
    MapEntry(DictKey.matrixWifiSsidLabel.s, parse.ssid),
    MapEntry(DictKey.matrixWifiPasswordLabel.s, parse.password),
    MapEntry(DictKey.matrixWifiEncryptionLabel.s, parse.security),
    MapEntry(DictKey.matrixWifiIsHiddenLabel.s, parse.hide),
  ];
} // todo重構解析
