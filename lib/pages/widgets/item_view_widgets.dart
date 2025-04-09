import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/language.dart';

class AnalyzedContentItem extends StatelessWidget {
  final String contents;
  final String type;
  final String formatName;

  const AnalyzedContentItem({
    super.key,
    required this.contents,
    required this.type,
    required this.formatName,
  });

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    switch (type) {
      case 'CONTACT': // TODO CONTACT內容分析
        break;
      case 'MAIL': // TODO MAIL內容分析
        break;
      case 'SMS': // TODO SMS內容分析
        break;
      case 'PHONE':// TODO PHONE內容分析
        break;
      case 'LOCATION':// TODO LOCATION內容分析
        break;
      case 'AGEND':// TODO AGEND內容分析
        break;
      case 'WIFI':// TODO WIFI內容分析
        break;

      case 'TEXT':
      case 'WEBSITE':
      case 'PRODUCT':
      case 'INDUSTRIAL':
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
    final colorScheme = Theme.of(context).colorScheme;
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