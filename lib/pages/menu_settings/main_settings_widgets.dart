import 'package:flutter/material.dart';
import 'package:watashi_qr/pages/widget/functions.dart';

class ListTileText extends StatelessWidget {
  final String str;
  final bool isSection;
  final Widget? trailing;
  final Function? onTap;

  const ListTileText({
    super.key,
    required this.str,
    this.isSection = false,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: isSection ? const EdgeInsets.only(top: 16, left: 16) : null,
      leading: const SizedBox(width: 48),

      minTileHeight: isSection ? 0 : null,
      title: Text(
        str,
        style: TextStyle(
          fontSize: isSection ? theme.textTheme.titleSmall?.fontSize : null,
        ),
      ),
      textColor: isSection ? colorScheme.primary : null,
      trailing: trailing,
      onTap: (onTap==null) ? null : ()=>onTap!(),
    );
  }
}


class ListTileSwitch extends StatelessWidget {
  final String str;
  final bool initialValue;
  final Function onToggle;
  final IconData? icon;
  final bool enabled;

  const ListTileSwitch({
    super.key,
    required this.str,
    required this.initialValue,
    required this.onToggle,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(width: 48, child: Icon(icon)),
      title: Text(str),
      enabled: enabled,
      onTap: ()=>onToggle(!initialValue),
      trailing: Switch.adaptive(
        value: initialValue,
        onChanged: (bool value) {
          if (enabled) onToggle(value);
        },
        activeColor: enabled ? null : Colors.grey,
      ),
    );
  }
}


class ListTilePicker extends StatelessWidget {
  final String str;
  final IconData? icon;
  final String? dialogTitleStr;
  final String selectedOption;
  final Map<String, String> optionMap;  // 只能是String key是因為SharedPreferences並不支援所有類與enum
  final Function onChanged;

  const ListTilePicker({
    super.key,
    required this.str,
    this.icon,
    this.dialogTitleStr,
    required this.selectedOption,
    required this.optionMap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(width: 48, child: Icon(icon)),
      title: Text(str),
      subtitle: Text(optionMap[selectedOption] ?? selectedOption),
      onTap: () => showMyDialog(
        context: context,
        titleStr: dialogTitleStr ?? str,
        content: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: optionMap.entries
                  .map((entry) => RadioListTile(
                title: Text(entry.value),
                value: entry.key,
                groupValue: selectedOption,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                    Navigator.pop(context);
                  }
                },
              ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}