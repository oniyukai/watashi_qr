import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/app_language.dart';

abstract final class OverlayShow {

  static Future<void> dialog({
    required BuildContext context,
    required String title,
    required Widget content,
    bool noCancelButton = false,
    List<Widget>? actions,})
  {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style:Theme.of(context).textTheme.titleMedium,
            textAlign: .center
        ),
        content: content,
        actions: [
          if (!noCancelButton) TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(DictKey.commonUiCancel.s),
          ),
          ...?actions,
        ],
      ),
    );
  }

  static Future<void> bottomSheet({
    required BuildContext context,
    Widget? title,
    Widget? content,
    bool noCancelButton = false,
    List<Widget>? actions,})
  {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        padding: .fromLTRB(16.0, 16.0, 16.0, MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            ?title,
            if (title != null) const SizedBox(height: 16),
            ?content,
            if (content != null) const SizedBox(height: 16),
            Row(
              mainAxisAlignment: .spaceAround,
              children: [
                if (!noCancelButton) ElevatedButton(
                  child: Text(DictKey.commonUiCancel.s),
                  onPressed: () => Navigator.pop(context),
                ),
                ...?actions,
              ],
            ),
            if (actions != null && actions.isNotEmpty && !noCancelButton) const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
