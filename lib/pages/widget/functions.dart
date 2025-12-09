import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/app_language.dart';

void showMyDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  bool noCancelButton = false,
  List<Widget>? actions,})
=> showDialog(
  context: context,
  builder: (BuildContext context) => AlertDialog(
    title: Center(
      child: Text(title, style:Theme.of(context).textTheme.titleMedium),
    ),
    content: content,
    actions: [
      if (!noCancelButton) TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(AppLocale.cancelLabel.s),
      ),
      if (actions != null) ...actions,
    ],
  ),
);


void showMyBottomSheet({
  required BuildContext context,
  Widget? title,
  Widget? content,
  bool noCancelButton = false,
  List<Widget>? actions,})
=> showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (BuildContext context) => SingleChildScrollView(
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
            mainAxisAlignment: .spaceAround,
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
  ),
);
