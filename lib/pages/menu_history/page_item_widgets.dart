import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/widget/item_tile.dart';
import 'package:flutter/services.dart';

class AnalyzedContentItem extends StatelessWidget {
  const AnalyzedContentItem({
    super.key,
    required this.contents,
    required this.type,
    required this.format,
  });

  final String contents;
  final HistoryType? type;
  final HistoryFormat? format;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HistoryType.contact:
        String name = '';
        String organisation = '';
        String jobTitle = '';
        String website = '';
        String mail = '';
        String phone = '';
        String address = '';
        String notes = '';
        for (final i in contents.split('\n')) {
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
        return _AnalyzedContentColumn(map: {
          AppLocale.matrixContactNameLabel.s: name,
          AppLocale.matrixContactOrganisationLabel.s: organisation,
          AppLocale.matrixContactJobTitleLabel.s: jobTitle,
          AppLocale.matrixUriUrlLabel.s: website,
          AppLocale.matrixContactMailLabel.s: mail,
          AppLocale.matrixContactPhoneLabel.s: phone,
          AppLocale.matrixContactAddressLabel.s: address,
          AppLocale.matrixContactNotesLabel.s: notes,
        });
      case HistoryType.mail:
        final analyzed = analyzeMail(contents);
        final String? email = analyzed['email'];
        final String? subject = analyzed['subject'];
        final String? message = analyzed['message'];
        if ((email ?? subject ?? message) == null) break;
        return _AnalyzedContentColumn(map: {
          AppLocale.matrixEmailRecipientLabel.s: email,
          AppLocale.matrixSubjectLabel.s: subject,
          AppLocale.matrixBodyLabel.s: message,
        });
      case HistoryType.sms:
        final analyzed = analyzeSms(contents);
        final String? phone = analyzed['phone'];
        final String? message = analyzed['message'];
        if ((phone ?? message) == null) break;
        return _AnalyzedContentColumn(map: {
          AppLocale.matrixPhoneTelNumberLabel.s: phone,
          AppLocale.matrixBodyLabel.s: message,
        });
      case HistoryType.phone:
        return _AnalyzedContentColumn(map: {
          AppLocale.matrixPhoneTelNumberLabel.s: contents.substring(4),
        });
      case HistoryType.location:
        String? latitude;
        String? longitude;
        String? height;
        String? request;
        final substring = contents.substring(4);
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
        if ((latitude ?? longitude ?? height ?? request) == null) break;
        return _AnalyzedContentColumn(map: {
          AppLocale.matrixLocalisationLatitudeLabel.s: latitude,
          AppLocale.matrixLocalisationLongitudeLabel.s: longitude,
          AppLocale.matrixLocalisationAltitudeLabel.s: height,
          AppLocale.matrixLocalisationQueryLabel.s: request,
        });
      case HistoryType.event:
        String? summary;
        String? startDate;
        String? endDate;
        String? location;
        String? description;
        for (final i in contents.split('\n')){
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
        return _AnalyzedContentColumn(map: {
          AppLocale.matrixAgendaNameEventLabel.s: summary,
          AppLocale.matrixAgendaStartDateEventLabel.s: startDate,
          AppLocale.matrixAgendaEndDateEventLabel.s: endDate,
          AppLocale.matrixAgendaPlaceEventLabel.s: location,
          AppLocale.matrixAgendaDescriptionEventLabel.s: description,
        });
      case HistoryType.wifi:
        String? ssid;
        String? password;
        String? security;
        String? hide;
        for (final i in contents.substring(5).split(';')){
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
        if ((ssid ?? password ?? security ?? hide) == null) break;
        return _AnalyzedContentColumn(map: {
          AppLocale.matrixWifiSsidLabel.s: ssid,
          AppLocale.matrixWifiPasswordLabel.s: password,
          AppLocale.matrixWifiEncryptionLabel.s: security,
          AppLocale.matrixWifiIsHiddenLabel.s: hide,
        });
      case HistoryType.text:
      case HistoryType.website:
      case HistoryType.product:
      case HistoryType.industrial:
      default:
    }
    return SelectableText(contents);
  }
}


class _AnalyzedContentColumn extends StatelessWidget {
  final Map<String, String?> map;
  const _AnalyzedContentColumn({required this.map});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: map.entries.map((entry) {
        if (entry.value != null && entry.value!.isNotEmpty) {
          return ItemTile(
            title: entry.value!,
            description: entry.key,
            trailing: IconButton(
              iconSize: 20,
              onPressed: () => Clipboard.setData(ClipboardData(text: entry.value!)),
              icon: const Icon(Icons.copy),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}


class PressButtonGrid extends StatelessWidget {
  final IconData iconData;
  final String description;
  final void Function()? onTap;

  const PressButtonGrid({
    super.key,
    required this.iconData,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: onTap,
        title: Icon(iconData),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: theme.textTheme.bodyMedium!.fontSize),
            softWrap: true,
          ),
        )
      ),
    );
  }
}

Map<String, String?> analyzeMail(String contents) {
  String? email;
  String? subject;
  String? message;
  if (contents.toUpperCase().startsWith('MAILTO:')) {
    final substring = contents.substring(7);
    final Uri uri = Uri.parse('mailto:$substring');
    email = uri.path;
    subject = uri.queryParameters['subject'];
    message = uri.queryParameters['body'];
  } else {
    for (final i in contents.substring(7).split(';')) {
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
  return {
    'email': email,
    'subject': subject,
    'message': message,
  };
}

Map<String, String?> analyzeSms(String contents) {
  String? phone;
  String? message;
  final substring = contents.substring(6);
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
  return {
    'phone': phone ?? uriPhone,
    'message': uriMessage ?? message,
  };
}
