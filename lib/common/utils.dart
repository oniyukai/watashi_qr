import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'dart:core';
import 'package:watashi_qr/locale/app_language.dart';

extension EnumFromName<T extends Enum> on Iterable<T> {
  T? fromName(String? n) => firstWhereOrNull((value) => value.name == n);
}

class Utils {
  const Utils._();

  static int get nowUnixTime => DateTime.now().millisecondsSinceEpoch;

  /// 把13位UnixTime ms轉成系統時區的YYYY.MM.DD HH:MM字串
  static String formatUnixTimes(int unixTime) {
    final DateTime dateTime = .fromMillisecondsSinceEpoch(unixTime);
    final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }

  /// true:為直屏狀態 false:為橫屏狀態
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == .portrait;

  /// 震動一下
  static Future<void> deviceVibrate() async {
    if (await Vibration.hasVibrator()) {
      if (await Vibration.hasCustomVibrationsSupport()) {
        await Vibration.vibrate(duration: 250);
      } else {
        await Vibration.vibrate();
      }
    }
  }

  /// 嗶的一聲
  static Future<void> audioPlayBeep(AudioPlayer audioPlayer) async {
    try {
      await audioPlayer.play(AssetSource(p.join('assets/', 'short_beep_tone.mp3')));
    } catch (e) {
      await showToast(e.toString());
    }
  }

  /// 一個簡易的Toast訊息提示
  static Future<bool?> showToast(String msg, [bool longTime = false]) => Fluttertoast.showToast(
    msg: msg,
    toastLength: longTime ? .LENGTH_LONG : .LENGTH_SHORT,
    timeInSecForIosWeb: longTime ? 4 : 2,
  );

  /// 在預設瀏覽器開啟網站
  static Future<void> openUrlInBrowser(String url) async {
    final Uri uri = .parse(url);
    if (!await launchUrl(uri, mode: .externalApplication)) {
      await showToast('Could not launch $url');
    }
  }
  static Future<void> searchInBrowser(String searchUrl, String keyWord) =>
    openUrlInBrowser(searchUrl.replaceAll(StaticString.searchReplaceWord, Uri.encodeComponent(keyWord)));

  /// 鎖定螢幕轉向
  static Future<void> lockCurrentOrientation(BuildContext context) {
    if (isPortrait(context)) {
      return SystemChrome.setPreferredOrientations(const [
        .portraitUp,
        .portraitDown,
      ]);
    } else {
      return SystemChrome.setPreferredOrientations(const [
        .landscapeLeft,
        .landscapeRight,
      ]);
    }
  }

  /// 恢復允許螢幕所有旋轉方向
  static Future<void> unlockCurrentOrientation() =>
      SystemChrome.setPreferredOrientations(const [
        .portraitUp,
        .portraitDown,
        .landscapeLeft,
        .landscapeRight,
      ]);

  /// 統一使用這個來對外分享內容
  static Future<ShareResult> share(ShareParams shareParams) => SharePlus.instance.share(shareParams);
}
