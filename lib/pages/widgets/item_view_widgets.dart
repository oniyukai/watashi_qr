import 'package:flutter/material.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/locale/language.dart';

class AnalyzedContentItem extends StatelessWidget {
  final String contents;
  final HistoryType? type;
  final HistoryFormat? format;

  const AnalyzedContentItem({
    super.key,
    required this.contents,
    required this.type,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    switch (type) {
      case HistoryType.contact: // TODO CONTACT內容分析
        break;
      case HistoryType.mail: // TODO MAIL內容分析
        break;
      case HistoryType.sms: // TODO SMS內容分析
        break;
      case HistoryType.phone:// TODO PHONE內容分析
        break;
      case HistoryType.location:// TODO LOCATION內容分析
        break;
      case HistoryType.agend:// TODO AGEND內容分析
        break;
      case HistoryType.wifi:// TODO WIFI內容分析
        break;

      case HistoryType.text:
      case HistoryType.website:
      case HistoryType.product:
      case HistoryType.industrial:
      case null:
    }
    return Text(contents, softWrap: true);
  }
}


class PressButtonGrid extends StatelessWidget {
  final double width;
  final double height;
  final IconData icon;
  final String description;
  final Function()? onTap;

  const PressButtonGrid({
    super.key,
    required this.width,
    required this.height,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: height*0.25,
                color: theme.textTheme.bodyMedium!.color,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
                softWrap:true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}