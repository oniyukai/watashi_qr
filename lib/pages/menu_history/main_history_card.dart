import 'package:flutter/material.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:watashi_qr/entity/history_type.dart';
import 'package:watashi_qr/entity/history_item.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

class MainHistoryCard extends StatelessWidget {
  final HistoryItem historyItem;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const MainHistoryCard({
    super.key,
    required this.historyItem,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Card(
      elevation: 0,
      child: ListTile(
        contentPadding: const .symmetric(horizontal: 12.0),
        selected: selected,
        tileColor: colorScheme.primaryContainer.withValues(alpha: 0.25),
        selectedTileColor: colorScheme.primaryContainer,
        onTap: onTap,
        onLongPress: onLongPress,
        minTileHeight: 40,
        horizontalTitleGap: 8,
        leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            shape: .circle,
            color: historyItem.isFavorite
                ? colorScheme.tertiary
                : colorScheme.primary
          ),
          child: Center(
            child: MyIcon(
              historyItem.getTypeIconData,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                historyItem.contents.replaceAll('\n', ' '),
                style: theme.textTheme.titleMedium,
                overflow: .ellipsis,
              ),
            ),
            const SizedBox(width: 4.0),
            if (historyItem.isFavorite) Icon(
                Icons.favorite,
                size: 16.0,
                color: theme.hintColor
            ),
            const SizedBox(width: 2.0),
            Text(
              HistoryFormat.localeStrFromName(historyItem.format),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 2.0),
            MyIcon(
              historyItem.getFormatIconData,
              size: 16.0,
              color: theme.hintColor,
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              HistoryType.localeStrFromName(historyItem.type),
              style: theme.textTheme.bodySmall,
              overflow: .ellipsis,
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                historyItem.notes.replaceAll('\n', ' '),
                style: TextStyle(
                  color: colorScheme.tertiary,
                  fontWeight: .bold,
                ),
                overflow: .ellipsis,
              ),
            ),
            const SizedBox(width: 4.0),
            Icon(
              historyItem.getOrigin?.iconData ?? Icons.help_center_outlined,
              size: 16.0,
              color: theme.hintColor
            ),
            const SizedBox(width: 2.0),
            Text(
              Utils.formatUnixTimes(historyItem.unixTime),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
