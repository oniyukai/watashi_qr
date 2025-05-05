import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/common/utils.dart';

class HistoryItemCard extends StatelessWidget {
  final HistoryItem historyItem;
  final bool selected;
  final Function() onTap;
  final Function() onLongPress;

  const HistoryItemCard({
    super.key,
    required this.historyItem,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        selected: selected,
        tileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
        selectedTileColor: theme.colorScheme.primaryContainer,
        onTap: onTap,
        onLongPress: onLongPress,
        minTileHeight: 40,
        horizontalTitleGap: 8,
        leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (historyItem.isFavorite)
                  ? colorScheme.tertiary
                  : colorScheme.primary
          ),
          child: Center(
            child: Icon(
                historyItem.getTypeIconData,
                color: colorScheme.onPrimary
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                historyItem.contents.replaceAll("\n", " "),
                style: theme.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4.0),
            Row(
              children: [
                if (historyItem.isFavorite) Icon(
                  Icons.favorite,
                  size: 16.0,
                  color: theme.hintColor
                ),
                const SizedBox(width: 2.0),
                Text(
                  HistoryFormat.localeStrFromName(historyItem.format, localeStr),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 2.0),
                Icon(
                    historyItem.getFormatIconData,
                    size: 16.0,
                    color: theme.hintColor
                ),
              ],
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(HistoryType.localeStrFromName(historyItem.type, localeStr),
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 8.0),
            Expanded(child: Text(
              historyItem.notes.replaceAll("\n", " "),
              style: TextStyle(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),),
            const SizedBox(width: 4.0),
            Row(
              children: [
                Icon(
                  (historyItem.origin == HistoryOrigin.S.name)
                    ? Icons.fullscreen
                    : Icons.edit_outlined,
                  size: 16.0, color: theme.hintColor
                ),
                const SizedBox(width: 2.0),
                Text(
                  Utils.formatUnixTimes(historyItem.unixTime),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}