import 'package:flutter/material.dart';

class CustomMenuButton extends StatelessWidget {
  final Widget? icon;
  final List<String> labelList;
  final List<Function> onSelectedList;
  final Function? onSelectedEnd;
  const CustomMenuButton({
    super.key,
    this.icon,
    required this.labelList,
    this.onSelectedList = const <Function>[],
    this.onSelectedEnd,
  });

  void _showCustomMenu(BuildContext context, Offset offset) async {
    final option = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx,
        offset.dy,
      ),
      items: List.generate(labelList.length, (value) {
        return PopupMenuItem<int>(
          value: value,
          child: Text(labelList[value]),
        );
      }),
    );

    if (option != null) {
      if ((onSelectedList.length-1) >= option) onSelectedList[option]();
      if (onSelectedEnd != null) onSelectedEnd!(option);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? Icon(Icons.adaptive.more),
      onPressed: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        final offset = button.localToGlobal(Offset.zero, ancestor: overlay);
        _showCustomMenu(context, offset);
      },
    );
  }
}