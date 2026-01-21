import 'package:flutter/material.dart';

class MyMenuItem {
  final String? text;
  final IconData? iconData;
  final VoidCallback? onTap;

  const MyMenuItem({
    this.text,
    this.iconData,
    this.onTap,
  });
}

class MyMenuButton extends StatelessWidget {
  final List<MyMenuItem> items;
  final Widget? icon;
  final ValueChanged<int>? onSelectedEnd;

  const MyMenuButton({
    super.key,
    required this.items,
    this.icon,
    this.onSelectedEnd,
  });

  @override
  Widget build(context) {
    return PopupMenuButton<int>(
      icon: icon ?? const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => List.generate(
        items.length, (index) {
          final String? text = items[index].text;
          final IconData? iconData = items[index].iconData;
          assert (text != null || iconData != null);
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
      onSelected: (value) {
        final VoidCallback? func = items[value].onTap;
        if (func != null) func();
        if (onSelectedEnd != null) onSelectedEnd!(value);
      },
    );
  }
}
