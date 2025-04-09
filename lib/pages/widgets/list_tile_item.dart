import 'package:flutter/material.dart';

class ListTileItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? description;
  final bool? selected;
  final Function()? onTap;
  final Function()? onLongPress;

  const ListTileItem({
    super.key,
    required this.title,
    this.icon,
    this.description,
    this.selected,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      minTileHeight: 40,
      minVerticalPadding: 0,
      tileColor: (selected==true) ? colorScheme.primary.withValues(alpha:0.5) : null,
      onTap: onTap,
      onLongPress: onLongPress,
      leading: (icon != null) ? Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary
        ),
        child: Center(
            child: Icon(icon, color: colorScheme.onPrimary)
        ),
      ) : null,
      title: Text(
        title,
        style: theme.textTheme.titleMedium,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: (description!=null) ? Text(
        description!,
        style: theme.textTheme.bodySmall,
        overflow: TextOverflow.ellipsis,
      ) : null,
    );
  }
}