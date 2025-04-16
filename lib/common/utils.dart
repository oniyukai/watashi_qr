import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    if ( await Vibration.hasVibrator() ) {
      if (await Vibration.hasCustomVibrationsSupport()) {
        Vibration.vibrate(duration: 250);
      } else {
        Vibration.vibrate();
      }
    }
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
}