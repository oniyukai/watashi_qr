import 'package:material_ui/material_ui.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_history/page_item_widgets.dart';

/// !! 改變name會影響之後HistoryItem儲存的值
enum HistoryType {
  text(Icons.format_size),
  website(Icons.web),
  contact(Icons.contacts_outlined),
  mail(Icons.mail_outline),
  sms(Icons.sms_outlined),
  phone(Icons.call),
  location(Icons.location_on),
  event(Icons.event),
  wifi(Icons.wifi),
  product(Icons.sell_outlined),
  industrial(Icons.build_circle_outlined);

  final IconData iconData;

  const HistoryType(this.iconData);

  static String localeStrFromName(String n) =>
      switch (values.fromName(n)) {
        text => DictKey.barcodeTypeText,
        website => DictKey.barcodeTypeWebsite,
        contact => DictKey.barcodeTypeContact,
        mail => DictKey.barcodeTypeMail,
        sms => DictKey.barcodeTypeSms,
        phone => DictKey.barcodeTypePhone,
        location => DictKey.barcodeTypeLocation,
        event => DictKey.barcodeTypeEvent,
        wifi => DictKey.barcodeTypeWifi,
        product => DictKey.barcodeTypeProduct,
        industrial => DictKey.barcodeTypeIndustrial,
        null => null,
      }?.s ??
      '?$n';

  factory HistoryType.fromDistinguish(HistoryFormat? format, String contents) {
    switch (format) {
      case HistoryFormat.qrCode:
      case HistoryFormat.dataMatrix:
      case HistoryFormat.aztec:
      case HistoryFormat.pdf417:
      case null:
        if (WebsiteAnalyzer(contents).checkType) return website;
        if (ContactAnalyzer(contents).checkType) return contact;
        if (MailAnalyzer(contents).checkType) return mail;
        if (SmsAnalyzer(contents).checkType) return sms;
        if (PhoneAnalyzer(contents).checkType) return phone;
        if (LocationAnalyzer(contents).checkType) return location;
        if (EventAnalyzer(contents).checkType) return event;
        if (WifiAnalyzer(contents).checkType) return wifi;
        return text;
      case HistoryFormat.ean13:
      case HistoryFormat.ean8:
      case HistoryFormat.upcE:
      case HistoryFormat.upcA:
        return product;
      case HistoryFormat.code128:
      case HistoryFormat.code93:
      case HistoryFormat.code39:
      case HistoryFormat.codabar:
      case HistoryFormat.itf:
        return industrial;
    }
  }
}
