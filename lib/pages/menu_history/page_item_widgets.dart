import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';
import 'package:flutter/services.dart';

class PressButtonGrid extends StatelessWidget {
  final IconData iconData;
  final String description;
  final AsyncValueGetter onTap;

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
        contentPadding: const .all(12),
        onTap: () async {
          try {
            await onTap();
          } catch (e) {
            Utils.showToast(e.toString());
          }
        },
        title: Icon(iconData),
        subtitle: Padding(
          padding: const .symmetric(vertical: 4),
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
        .text || .product || .industrial || null => _TextAnalyzer(contents),
        .website => WebsiteAnalyzer(contents),
        .contact => ContactAnalyzer(contents),
        .mail => MailAnalyzer(contents),
        .sms => SmsAnalyzer(contents),
        .phone => PhoneAnalyzer(contents),
        .location => LocationAnalyzer(contents),
        .event => EventAnalyzer(contents),
        .wifi => WifiAnalyzer(contents),
      }._getEntryList().where((e) => e.value?.isNotEmpty == true);
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
              padding: const .all(0),
              visualDensity: .compact,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: entry.value!));
                Utils.showToast(DictKey.analysisStatusCopied.s);
              },
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
  final String _text;

  _TextAnalyzer(this._text);

  String get _upper => _text.toUpperCase();

  bool get checkType {
    try {
      if (!_checkType) return false;
      _parse();
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  bool get _checkType => true;

  List<MapEntry<String, String?>> _getEntryList() => const [];

  dynamic _parse() => true;
}

class WebsiteAnalyzer extends _TextAnalyzer {
  WebsiteAnalyzer(super._text);

  @override
  bool get _checkType => UrlValidator().isURL(
      _text,
      protocols: const <String?>['http', 'https'],
      requireProtocol: true
  );
}

class ContactAnalyzer extends _TextAnalyzer {
  ContactAnalyzer(super._text);

  late final _parseValue = _parse();

  @override
  bool get _checkType => _upper.startsWith('BEGIN:VCARD\n');

  @override
  List<MapEntry<String, String?>> _getEntryList() => [
    MapEntry(DictKey.analysisContactName.s, _parseValue.name),
    MapEntry(DictKey.analysisContactOrganisation.s, _parseValue.organisation),
    MapEntry(DictKey.analysisContactJobTitle.s, _parseValue.jobTitle),
    MapEntry(DictKey.analysisUriUrl.s, _parseValue.website),
    MapEntry(DictKey.analysisContactMail.s, _parseValue.mail),
    MapEntry(DictKey.analysisContactPhone.s, _parseValue.phone),
    MapEntry(DictKey.analysisContactAddress.s, _parseValue.address),
    MapEntry(DictKey.analysisContactNotes.s, _parseValue.notes),
  ];

  @override
  ({String name, String organisation, String jobTitle, String website,
  String mail, String phone, String address, String notes}) _parse() {
    final List<String> name = [];
    final List<String> organisation = [];
    final List<String> jobTitle = [];
    final List<String> website = [];
    final List<String> mail = [];
    final List<String> phone = [];
    final List<String> address = [];
    final List<String> notes = [];
    for (final String subText in _text.split('\n')) {
      final List<String> subParts = subText.split(':');
      if (subParts.length <= 1) continue;
      final String upperFirst = subParts.removeAt(0).toUpperCase();
      final String subValue = subParts.join(':');
      if (upperFirst == 'FN') name.add(subValue);
      if (upperFirst == 'ORG') organisation.add(subValue);
      if (upperFirst == 'TITLE') jobTitle.add(subValue);
      if (upperFirst == 'URL') website.add(subValue);
      if (upperFirst.startsWith('EMAIL')) mail.add(subValue);
      if (upperFirst.startsWith('TEL')) phone.add(subValue);
      if (upperFirst.startsWith('ADR')) address.add(subValue.split(';').where((sp) => sp.isNotEmpty).join(' '));
      if (upperFirst == 'NOTE') notes.add(subValue);
    }
    return (
    name: name.join('\n'),
    organisation: organisation.join('\n'),
    jobTitle: jobTitle.join('\n'),
    website: website.join('\n'),
    mail: mail.join('\n'),
    phone: phone.join('\n'),
    address: address.join('\n'),
    notes: notes.join('\n'),
    );
  }
}

class MailAnalyzer extends _TextAnalyzer {
  MailAnalyzer(super._text);

  late final parseValue = _parse();

  @override
  bool get _checkType => _upper.startsWith('MAILTO:') || _upper.startsWith('MATMSG:');

  @override
  List<MapEntry<String, String?>> _getEntryList() => [
    MapEntry(DictKey.analysisMailRecipient.s, parseValue.email),
    MapEntry(DictKey.analysisMailSubject.s, parseValue.subject),
    MapEntry(DictKey.analysisMailBody.s, parseValue.message),
  ];

  @override
  ({String? email, String? subject, String? message}) _parse() {
    String? email;
    String? subject;
    String? message;
    if (_upper.startsWith('MATMSG:')) {
      for (final String subText in _text.substring(7).split(';')) {
        final List<String> subParts = subText.split(':');
        if (subParts.length <= 1) continue;
        final String upperFirst = subParts.removeAt(0).toUpperCase();
        final String subValue = subParts.join(':');
        if (upperFirst.startsWith('TO')) email = subValue;
        if (upperFirst.startsWith('SUB')) subject = subValue;
        if (upperFirst.startsWith('BODY')) message = subValue;
      }
    } else if (_upper.startsWith('MAILTO:')) {
      final Uri uri = .parse(_text);
      email = uri.path;
      subject = uri.queryParameters['subject'];
      message = uri.queryParameters['body'];
    }
    return (
    email: email,
    subject: subject,
    message: message,
    );
  }
}

class SmsAnalyzer extends _TextAnalyzer {
  SmsAnalyzer(super._text);

  late final parseValue = _parse();

  @override
  bool get _checkType => _upper.startsWith('SMSTO:');

  @override
  List<MapEntry<String, String?>> _getEntryList() => [
    MapEntry(DictKey.analysisPhoneNumber.s, parseValue.phone),
    MapEntry(DictKey.analysisMailBody.s, parseValue.message),
  ];

  @override
  ({String phone, String? message}) _parse() {
    final Uri uri = .parse(_text);
    String? phone;
    String? message;
    for (final String subText in uri.path.split(':')) {
      if (phone == null) {phone = subText; continue;}
      if (message == null) {message = subText; continue;}
    }
    return (
    phone: phone ?? uri.path,
    message: message ?? uri.queryParameters['body'],
    );
  }
}

class PhoneAnalyzer extends _TextAnalyzer {
  PhoneAnalyzer(super._text);

  late final parseValue = _parse();

  @override
  bool get _checkType => _upper.startsWith('TEL:');

  @override
  List<MapEntry<String, String?>> _getEntryList() => [
    MapEntry(DictKey.analysisPhoneNumber.s, parseValue.phone),
  ];

  @override
  ({String phone}) _parse() => (
  phone: _text.substring(4),
  );
}

class LocationAnalyzer extends _TextAnalyzer {
  LocationAnalyzer(super._text);

  late final _parseValue = _parse();

  @override
  bool get _checkType => _upper.startsWith('GEO:');

  @override
  List<MapEntry<String, String?>> _getEntryList() => [
    MapEntry(DictKey.analysisGeoLatitude.s, _parseValue.latitude),
    MapEntry(DictKey.analysisGeoLongitude.s, _parseValue.longitude),
    MapEntry(DictKey.analysisGeoAltitude.s, _parseValue.height),
    MapEntry(DictKey.analysisGeoQuery.s, _parseValue.request),
  ];

  @override
  ({String? latitude, String? longitude, String? height, String? request}) _parse() {
    final Uri uri = .parse(_text);
    final String? request = uri.queryParameters['q'];
    String? latitude;
    String? longitude;
    String? height;
    for (final String subText in uri.path.split(',')) {
      if (latitude == null) {latitude = subText; continue;}
      if (longitude == null) {longitude = subText; continue;}
      if (height == null) {height = subText; continue;}
    }
    return (
    latitude: latitude,
    longitude: longitude,
    height: height,
    request: request,
    );
  }
}

class EventAnalyzer extends _TextAnalyzer {
  EventAnalyzer(super._text);

  late final _parseValue = _parse();

  @override
  bool get _checkType => _upper.startsWith('BEGIN:VEVENT\n');

  @override
  List<MapEntry<String, String?>> _getEntryList() => [
    MapEntry(DictKey.analysisEventName.s, _parseValue.summary),
    MapEntry(DictKey.analysisEventStart.s, _parseValue.startDate),
    MapEntry(DictKey.analysisEventEnd.s, _parseValue.endDate),
    MapEntry(DictKey.analysisEventPlace.s, _parseValue.location),
    MapEntry(DictKey.analysisEventDescription.s, _parseValue.description),
  ];

  @override
  ({String? summary, String? startDate, String? endDate, String? location, String? description}) _parse() {
    String? summary;
    String? startDate;
    String? endDate;
    String? location;
    String? description;
    for (final String subText in _text.split('\n')) {
      final List<String> subParts = subText.split(':');
      if (subParts.length <= 1) continue;
      final String upperFirst = subParts.removeAt(0).toUpperCase();
      final String subValue = subParts.join(':');
      if (upperFirst.startsWith('SUMMARY')) summary = subValue;
      if (upperFirst.startsWith('DTSTART')) startDate = Utils.formatUnixTimes(DateTime.parse(subValue).millisecondsSinceEpoch);
      if (upperFirst.startsWith('DTEND')) endDate = Utils.formatUnixTimes(DateTime.parse(subValue).millisecondsSinceEpoch);
      if (upperFirst.startsWith('LOCATION')) location = subValue;
      if (upperFirst.startsWith('DESCRIPTION')) description = subValue;
    }
    return (
    summary: summary,
    startDate: startDate,
    endDate: endDate,
    location: location,
    description: description,
    );
  }
}

class WifiAnalyzer extends _TextAnalyzer {
  WifiAnalyzer(super._text);

  late final _parseValue = _parse();

  @override
  bool get _checkType => _upper.startsWith('WIFI:');

  @override
  List<MapEntry<String, String?>> _getEntryList() => [
    MapEntry(DictKey.analysisWifiSsid.s, _parseValue.ssid),
    MapEntry(DictKey.analysisWifiPassword.s, _parseValue.password),
    MapEntry(DictKey.analysisWifiEncryption.s, _parseValue.security),
    MapEntry(DictKey.analysisWifiIsHidden.s, _parseValue.hide),
  ];

  @override
  ({String? ssid, String? password, String? security, String? hide}) _parse() {
    String? ssid;
    String? password;
    String? security;
    String? hide;
    for (final String subText in _text.substring(5).split(';')) {
      final List<String> subParts = subText.split(':');
      if (subParts.length <= 1) continue;
      final String upperFirst = subParts.removeAt(0).toUpperCase();
      final String subValue = subParts.join(':');
      if (upperFirst.startsWith('S')) ssid = subValue;
      if (upperFirst.startsWith('P')) password = subValue;
      if (upperFirst.startsWith('T')) security = subValue;
      if (upperFirst.startsWith('H')) hide = subValue;
    }
    return (
    ssid: ssid,
    password: password,
    security: security,
    hide: hide,
    );
  }
}
