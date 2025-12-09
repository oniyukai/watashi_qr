import 'package:flutter/material.dart';

class MyMenuItem {
  final String? text;
  final IconData? iconData;
  final VoidCallback? onTap;

  const MyMenuItem({
    required this.text,
    this.onTap,
    this.iconData,
  });
}

class MyMenuButton extends StatelessWidget {
  final Widget? icon;
  final List<MyMenuItem> items;
  final ValueChanged<int>? onSelectedEnd;

  const MyMenuButton({
    super.key,
    this.icon,
    required this.items,
    this.onSelectedEnd,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: icon ?? const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => List.generate(
        items.length, (index) {
          final String? text = items[index].text;
          final IconData? iconData = items[index].iconData;
          return PopupMenuItem<int>(
            value: index,
            child: Row(
              mainAxisSize: .min,
              children: [
                if (iconData != null) Icon(iconData),
                if (iconData != null) const SizedBox(width: 8),
                if (text != null) Text(text),
              ],
            ),
          );
        },
      ),
      onSelected: (int value) {
        final VoidCallback? func = items[value].onTap;
        if (func != null) func();
        if (onSelectedEnd != null) onSelectedEnd!(value);
      },
    );
  }
}
