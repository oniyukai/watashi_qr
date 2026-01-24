import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

enum HistoryType { // !! 改變name會影響之後HistoryItem儲存的值
  text(MyIconData(Icons.format_size)),
  website(MyIconData(Icons.web)),
  contact(MyIconData(Icons.contacts_outlined)),
  mail(MyIconData(Icons.mail_outline)),
  sms(MyIconData(Icons.sms_outlined)),
  phone(MyIconData(Icons.call)),
  location(MyIconData(Icons.location_on)),
  event(MyIconData(Icons.event)),
  wifi(MyIconData(Icons.wifi)),
  product(MyIconData(Icons.sell_outlined)),
  industrial(MyIconData(Icons.build_circle_outlined));

  final MyIconData myIconData;

  const HistoryType(this.myIconData);

  static String localeStrFromName(String n) => switch (values.fromName(n)) {
    text => AppLocale.qrCodeTypeNameText,
    website => AppLocale.qrCodeTypeNameWebSite,
    contact => AppLocale.qrCodeTypeNameContact,
    mail => AppLocale.qrCodeTypeNameMail,
    sms => AppLocale.qrCodeTypeNameSms,
    phone => AppLocale.qrCodeTypeNamePhone,
    location => AppLocale.qrCodeTypeNameLocation,
    event => AppLocale.qrCodeTypeNameEvent,
    wifi => AppLocale.qrCodeTypeNameWifi,
    product => AppLocale.barCodeTypeProduct,
    industrial => AppLocale.barCodeTypeIndustrial,
    null => null,
  }?.s ?? '?$n';

  factory HistoryType.fromDistinguish(HistoryFormat? format, String contents) {
    final String upperContents = contents.toUpperCase();
    switch (format) {
      case .qrCode:
      case .dataMatrix:
      case .aztec:
      case .pdf417:
      case null:
        if (upperContents.startsWith('BEGIN:VCARD\n')) {
          return contact;
        } else if (upperContents.startsWith('MAILTO:') || upperContents.startsWith('MATMSG:')) {
          return mail;
        } else if (upperContents.startsWith('SMSTO:')) {
          return sms;
        } else if (upperContents.startsWith('TEL:')) {
          return phone;
        } else if (upperContents.startsWith('GEO:')) {
          return location;
        } else if (upperContents.startsWith('BEGIN:VEVENT\n')) {
          return event;
        } else if (upperContents.startsWith('WIFI:')) {
          return wifi;
        } else if (UrlValidator().isURL(
            contents,
            protocols: const <String?>['http', 'https'],
            requireProtocol: true)) {
          return website;
        } else {
          return text;
        }
      case .ean13:
      case .ean8:
      case .upcE:
      case .upcA:
        return product;
      case .code128:
      case .code93:
      case .code39:
      case .codabar:
      case .itf:
        return industrial;
    }
  }
}
