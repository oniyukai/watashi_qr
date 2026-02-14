import 'package:flutter/material.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

class ItemTile extends StatelessWidget {
  final String title;
  final MyIconData? myIconData;
  final String? description;
  final bool? selected;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ItemTile({
    super.key,
    required this.title,
    this.myIconData,
    this.description,
    this.selected,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: .circular(12.0)),
      contentPadding: const .all(8),
      minTileHeight: 40,
      minVerticalPadding: 0,
      selected: selected == true,
      selectedTileColor: colorScheme.primaryContainer,
      onTap: onTap,
      onLongPress: onLongPress,
      leading: (myIconData != null) ? Container(
        padding: const .symmetric(vertical: 8),
        decoration: BoxDecoration(
          shape: .circle,
          color: colorScheme.primary
        ),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: MyIcon(
            myIconData,
            color: colorScheme.onPrimary,
          ),
        ),
      ) : null,
      title: Text(
        title,
        style: theme.textTheme.titleMedium,
        overflow: .ellipsis,
      ),
      subtitle: (description != null) ? Text(
        description!,
        style: theme.textTheme.bodySmall,
        overflow: .ellipsis,
      ) : null,
      trailing: trailing,
    );
  }
}
