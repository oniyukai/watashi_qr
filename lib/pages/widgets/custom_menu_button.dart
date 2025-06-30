import 'package:flutter/material.dart';

class CustomMenuButton extends StatelessWidget {

  final Widget? icon;
  final Map<String, Function?> optionMap;
  final Function? onSelectedEnd;

  const CustomMenuButton({
    super.key,
    this.icon,
    required this.optionMap,
    this.onSelectedEnd,
  });

  @override
  Widget build(BuildContext context) {
    final entries = optionMap.entries.toList();
    return PopupMenuButton<int>(
      icon: icon ?? const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => List.generate(
        optionMap.length,
        (value) => PopupMenuItem<int>(
          value: value,
          child: Text(entries[value].key),
      )),
      onSelected: (int value) {
        final func = entries[value].value;
        if (func != null) func();
        if (onSelectedEnd != null) onSelectedEnd!(value);
      },
    );
  }
}