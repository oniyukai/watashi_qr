import 'package:flutter/material.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

class ItemTile extends StatelessWidget {
  final String title;
  final MyIconData? myIconData;
  final String? description;
  final bool? selected;
  final Widget? trailing;
  final Function()? onTap;
  final Function()? onLongPress;

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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      contentPadding: const EdgeInsets.all(8),
      minTileHeight: 40,
      minVerticalPadding: 0,
      selected: selected==true,
      selectedTileColor: theme.colorScheme.primaryContainer,
      onTap: onTap,
      onLongPress: onLongPress,
      leading: (myIconData != null) ? Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary
        ),
        child: Center(
          child: MyIcon(
            myIconData,
            color: colorScheme.onPrimary,
          ),
          // child: Icon(iconData, color: colorScheme.onPrimary)
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
      trailing: trailing,
    );
  }
}