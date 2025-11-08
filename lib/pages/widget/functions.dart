import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/app_language.dart';

void showMyDialog({
  required BuildContext context,
  required String titleStr,
  required Widget content,
  bool noCancelButton = false,
  List<Widget>? actions,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(titleStr, style:Theme.of(context).textTheme.titleMedium),
        ),
        content: content,
        actions: <Widget>[
          if (!noCancelButton) TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocale.cancelLabel.s),
          ),
          if (actions != null) ...actions,
        ],
      );
    },
  );
}


void showMyBottomSheet({
  required BuildContext context,
  Widget? title,
  Widget? content,
  bool noCancelButton = false,
  List<Widget>? actions,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              if (title != null) title,
              if (title != null) const SizedBox(height: 16),
              if (content != null) content,
              if (content != null) const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!noCancelButton) ElevatedButton(
                    child: Text(AppLocale.cancelLabel.s),
                    onPressed: () => Navigator.pop(context),
                  ),
                  if (actions != null) ...actions,
                ],
              ),
              if (actions != null && actions.isNotEmpty && !noCancelButton) const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}