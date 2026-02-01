import 'package:flutter/material.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_history/page_item_widgets.dart';
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
    text => DictKey.qrCodeTypeNameText,
    website => DictKey.qrCodeTypeNameWebSite,
    contact => DictKey.qrCodeTypeNameContact,
    mail => DictKey.qrCodeTypeNameMail,
    sms => DictKey.qrCodeTypeNameSms,
    phone => DictKey.qrCodeTypeNamePhone,
    location => DictKey.qrCodeTypeNameLocation,
    event => DictKey.qrCodeTypeNameEvent,
    wifi => DictKey.qrCodeTypeNameWifi,
    product => DictKey.barCodeTypeProduct,
    industrial => DictKey.barCodeTypeIndustrial,
    null => null,
  }?.s ?? '?$n';

  factory HistoryType.fromDistinguish(HistoryFormat? format, String contents) {
    switch (format) {
      case .qrCode:
      case .dataMatrix:
      case .aztec:
      case .pdf417:
      case null:
        if (ContactAnalyzer(contents).checkType) return contact;
        if (MailAnalyzer(contents).checkType) return mail;
        if (SmsAnalyzer(contents).checkType) return sms;
        if (PhoneAnalyzer(contents).checkType) return phone;
        if (LocationAnalyzer(contents).checkType) return location;
        if (EventAnalyzer(contents).checkType) return event;
        if (WifiAnalyzer(contents).checkType) return wifi;
        if (WebsiteAnalyzer(contents).checkType) return website;
        return text;
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
