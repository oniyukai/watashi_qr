import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:core';

class Utils {
  const Utils._();

  // static int getNowUnixTime() => DateTime.now().millisecondsSinceEpoch;
  static int get nowUnixTime => DateTime.now().millisecondsSinceEpoch;

  // 把13位UnixTime ms轉成系統時區的YYYY.MM.DD HH:MM字串
  static String formatUnixTimes(int unixTime) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime).toLocal();
    final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }

  static late SharedPreferences prefs;
  static Future<void> prefsInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  // true:為直屏狀態 false:為橫屏狀態
  static bool isPortrait(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait;
  }

  // 震動一下
  static Future<void> deviceVibrate() async {
    if ( await Vibration.hasVibrator() ) Vibration.vibrate();
  }

  // 嗶的一聲
  static Future<void> audioPlayBeep(AudioPlayer audioPlayer) async {
    try {
      audioPlayer.play(AssetSource('short_beep_tone.mp3'));
    } catch (e) {
      showToast(e.toString());
    }
  }

  //  一個簡易的Toast訊息提示
  static void showToast(String contentStr, [int? time]) {
    Fluttertoast.showToast(
      msg: contentStr,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: time ?? 2,
      fontSize: 16.0, // 文字大小
    );
  }

  // 在預設瀏覽器開啟網站
  static Future<void> openUrlInBrowser(String urlstr) async {
    final Uri url = Uri.parse(urlstr);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlstr');
    }
  }
  static Future<void> searchInBrowser(String searchUrl, String keyWord) async {
    openUrlInBrowser(searchUrl.replaceAll('{code}', Uri.encodeComponent(keyWord)));
  }

  // 一個可以支援使用enum的switch
  // static dynamic funcSwitch<T>(T value, {required Map<T, Function?> cases, Function? defaultCase}) {
  //   final keys = cases.keys.toList();
  //   final startIndex = keys.indexOf(value);
  //   if (startIndex != -1) {
  //     for (int i = startIndex; i < keys.length; i++) {
  //       final func = cases[ keys[i] ];
  //       if (func != null) return func();
  //     }
  //   }
  //   return (defaultCase != null) ? defaultCase() : null;
  // }

  // 把'Type'名轉成String
  static String typeName(Type type) => type.toString();
  static Map<String, T> typeNameMap<T>(Map<Type, T> map) {
    final Map<String, T> target = <String, T>{};
    map.forEach((key, value) => target[key.toString()] = value);
    return target;
  }

  // 看設定要不要鎖定螢幕轉向
  static Future<void> lockCurrentOrientation(BuildContext context) async {
    final bool isScreenRotationEnabled = context.settingsProvider.isScreenRotation;
    if (isScreenRotationEnabled) {
      if (isPortrait(context)) {
        await SystemChrome.setPreferredOrientations( const <DeviceOrientation>[
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        await SystemChrome.setPreferredOrientations( const <DeviceOrientation>[
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    } else {
      unlockCurrentOrientation();
    }
  }

  // 恢復允許螢幕所有旋轉方向
  static void unlockCurrentOrientation() {
    SystemChrome.setPreferredOrientations( const <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown, // 考量平板向下也可以
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }


  // <About barcode>
  static String formatTypeStr(String type, Language localeStr) {
    final Map<String, String> typeMap = <String, String>{
      'TEXT': localeStr.qrCodeTypeNameText,
      'WEBSITE': localeStr.qrCodeTypeNameWebSite,
      'CONTACT': localeStr.qrCodeTypeNameContact,
      'MAIL': localeStr.qrCodeTypeNameMail,
      'SMS': localeStr.qrCodeTypeNameSms,
      'PHONE': localeStr.qrCodeTypeNamePhone,
      'LOCATION': localeStr.qrCodeTypeNameGeographicCoordinates,
      'AGEND': localeStr.qrCodeTypeNameAgenda,
      'WIFI': localeStr.qrCodeTypeNameWifi,
      'PRODUCT': localeStr.barCodeTypeProduct,
      'INDUSTRIAL': localeStr.barCodeTypeIndustrial,
    };
    return typeMap[type] ?? '"$type"';
  }

  static IconData formatTypeIcon(String type) {
    final Map<String, IconData> typeMap = const <String, IconData>{
      'TEXT': Icons.format_size,
      'WEBSITE': Icons.web,
      'CONTACT': Icons.contacts_outlined,
      'MAIL': Icons.mail_outline,
      'SMS': Icons.sms_outlined,
      'PHONE': Icons.call,
      'LOCATION': Icons.location_on,
      'AGEND': Icons.event,
      'WIFI': Icons.wifi,
      'PRODUCT': MaterialCommunityIcons.barcode,
      'INDUSTRIAL': MaterialCommunityIcons.barcode,
    };
    return typeMap[type] ?? Icons.help_center;
  }

  static String formatNameStr(String formatName,Language localeStr) {
    final Map<String, String>  formatNameMap = <String, String>{
      'QR_CODE': localeStr.barcodeQrCodeLabel,
      'AZTEC': localeStr.barcodeAztecLabel,
      'DATA_MATRIX': localeStr.barcodeDataMatrixLabel,
      'PDF_417': localeStr.barcodePdf417Label,
      'EAN_13': localeStr.barcodeEan13Label,
      'EAN_8': localeStr.barcodeEan8Label,
      'UPC_A': localeStr.barcodeUpcALabel,
      'UPC_E': localeStr.barcodeUpcELabel,
      'Code_128': localeStr.barcodeCode128Label,
      'Code_93': localeStr.barcodeCode93Label,
      'Code_39': localeStr.barcodeCode39Label,
      'CODABAR': localeStr.barcodeCodabarLabel,
      'IFT': localeStr.barcodeItfLabel,
      'RSS_14': 'RSS 14',
    };
    return formatNameMap[formatName] ?? '"$formatName"';
  }

  static IconData formatNameIcon(String formatName) {
    final Map<String, IconData> formatNameMap = const <String, IconData>{
      'QR_CODE': Icons.qr_code,
      'AZTEC': MaterialCommunityIcons.data_matrix, // TODO: No corresponding icon has been found yet
      'DATA_MATRIX': MaterialCommunityIcons.data_matrix,
      'PDF_417': MaterialCommunityIcons.data_matrix, // TODO: No corresponding icon has been found yet
      'EAN_13': MaterialCommunityIcons.barcode,
      'EAN_8': MaterialCommunityIcons.barcode,
      'UPC_A': MaterialCommunityIcons.barcode,
      'UPC_E': MaterialCommunityIcons.barcode,
      'Code_128': MaterialCommunityIcons.barcode,
      'Code_93': MaterialCommunityIcons.barcode,
      'Code_39': MaterialCommunityIcons.barcode,
      'CODABAR': MaterialCommunityIcons.barcode,
      'IFT': MaterialCommunityIcons.barcode,
      'RSS_14': MaterialCommunityIcons.barcode,
    };
    return formatNameMap[formatName] ?? Icons.help_center_outlined;
  }

  static String? formatNameDescription(String formatName, Language localeStr) {
    final Map<String, String> formatNameMap = <String, String>{
      'EAN_13': localeStr.barcodeEan13DescriptionLabel,
      'EAN_8': localeStr.barcodeEan8DescriptionLabel,
      'UPC_A': localeStr.barcodeUpcADescriptionLabel,
      'UPC_E': localeStr.barcodeUpcEDescriptionLabel,
      'Code_128': localeStr.barcodeCode128DescriptionLabel,
      'Code_93': localeStr.barcodeCode93DescriptionLabel,
      'Code_39': localeStr.barcodeCode39DescriptionLabel,
      'CODABAR': localeStr.barcodeCodabarDescriptionLabel,
      'IFT': localeStr.barcodeItfDescriptionLabel,
    };
    return formatNameMap[formatName];
  }

  static String formatNameComposition(String formatName, Language localeStr) {
    final Map<String, String> formatNameMap = <String, String>{
      'QR_CODE': localeStr.barcodeTextCompositionLabel,
      'AZTEC': localeStr.barcodeTextNoSpecialCompositionLabel,
      'DATA_MATRIX': localeStr.barcodeTextNoSpecialCompositionLabel,
      'PDF_417': localeStr.barcodeTextCompositionLabel,
      'EAN_13': localeStr.barcode12Digits1CheckCompositionLabel,
      'EAN_8': localeStr.barcode7Digits1CheckCompositionLabel,
      'UPC_A': localeStr.barcode11Digits1CheckCompositionLabel,
      'UPC_E': localeStr.barcode7Digits1CheckCompositionLabel,
      'Code_128': localeStr.barcodeTextNoSpecialCompositionLabel,
      'Code_93': localeStr.barcodeTextUpperNoSpecialCompositionLabel,
      'Code_39': localeStr.barcodeTextUpperNoSpecialCompositionLabel,
      'CODABAR': localeStr.barcodeDigitsCompositionLabel,
      'IFT': localeStr.barcodeEvenDigitsCompositionLabel,
    };
    return formatNameMap[formatName] ?? localeStr.barcodeTextCompositionLabel;
  }

  static String determineType(String formatName, String contents) {
    final String upperContents = contents.toUpperCase();
    switch (formatName) {
      case 'QR_CODE':
      case 'DATA_MATRIX':
      case 'AZTEC':
      case 'PDF_417':
        if (isURL(contents)) {
          return 'WEBSITE';
        } else if (upperContents.startsWith('BEGIN:VCARD\n')) {
          return 'CONTACT';
        } else if (upperContents.startsWith('MAILTO:') || upperContents.startsWith('MATMSG:')) {
          return 'MAIL';
        } else if (upperContents.startsWith('SMSTO:')) {
          return 'SMS';
        } else if (upperContents.startsWith('TEL:')) {
          return 'PHONE';
        } else if (upperContents.startsWith('GEO:')) {
          return 'LOCATION';
        } else if (upperContents.startsWith('BEGIN:VEVENT\n')) {
          return 'AGEND';
        } else if (upperContents.startsWith('WIFI:')) {
          return 'WIFI';
        } else {
          return 'TEXT';
        }
      case 'EAN_13':
      case 'EAN_8':
      case 'UPC_A':
      case 'UPC_E':
        return 'PRODUCT';
      case 'Code_128':
      case 'Code_93':
      case 'Code_39':
      case 'CODABAR':
      case 'IFT':
        return 'INDUSTRIAL';
    }
    return 'TEXT';
  }

  static String formatMobileScannerType(BarcodeFormat barcodeFormat) {
    final Map<BarcodeFormat, String> typeStringMap = const <BarcodeFormat, String>{
      BarcodeFormat.qrCode: 'QR_CODE',
      BarcodeFormat.aztec: 'AZTEC',
      BarcodeFormat.dataMatrix: 'DATA_MATRIX',
      BarcodeFormat.pdf417: 'PDF_417',
      BarcodeFormat.ean13: 'EAN_13',
      BarcodeFormat.ean8: 'EAN_8',
      BarcodeFormat.upcA: 'UPC_A',
      BarcodeFormat.upcE: 'UPC_E',
      BarcodeFormat.code128: 'Code_128',
      BarcodeFormat.code93: 'Code_93',
      BarcodeFormat.code39: 'Code_39',
      BarcodeFormat.codebar: 'CODABAR',
      BarcodeFormat.itf: 'IFT',
    };
    return typeStringMap[barcodeFormat] ?? barcodeFormat.name;
  }
  // </About barcode>

}