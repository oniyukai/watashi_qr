import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/locale/language.dart';
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

  const HistoryType(this.myIconData);
  final MyIconData myIconData;

  static String localeStrFromName(String n, Language localeStr) => <HistoryType, String>{
    text: localeStr.qrCodeTypeNameText,
    website: localeStr.qrCodeTypeNameWebSite,
    contact: localeStr.qrCodeTypeNameContact,
    mail: localeStr.qrCodeTypeNameMail,
    sms: localeStr.qrCodeTypeNameSms,
    phone: localeStr.qrCodeTypeNamePhone,
    location: localeStr.qrCodeTypeNameLocation,
    event: localeStr.qrCodeTypeNameEvent,
    wifi: localeStr.qrCodeTypeNameWifi,
    product: localeStr.barCodeTypeProduct,
    industrial: localeStr.barCodeTypeIndustrial,
  }[values.fromName(n)] ?? '?$n';

  factory HistoryType.fromDistinguish(HistoryFormat? format, String contents) {
    final String upperContents = contents.toUpperCase();
    switch (format) {
      case HistoryFormat.qrCode:
      case HistoryFormat.dataMatrix:
      case HistoryFormat.aztec:
      case HistoryFormat.pdf417:
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
        } else if (isURL(contents, {
          'protocols': ['http', 'https'],
          'require_tld': true,
          'require_protocol': true,
          'allow_underscores': false,
        })) {
          return website;
        } else {
          return text;
        }
      case HistoryFormat.ean13:
      case HistoryFormat.ean8:
      case HistoryFormat.upcE:
      case HistoryFormat.upcA:
        return product;
      case HistoryFormat.code128:
      case HistoryFormat.code93:
      case HistoryFormat.code39:
      case HistoryFormat.codebar:
      case HistoryFormat.itf:
        return industrial;
      default:
        return text;
    }
  }
}