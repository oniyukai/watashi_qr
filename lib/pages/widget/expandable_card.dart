import 'package:flutter/material.dart';
import 'package:watashi_qr/pages/widget/my_icon.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final MyIconData? myIconData;
  final bool? initialExpanded;
  final Widget? collapsedChild;
  final Widget? expandedChild;

  const ExpandableCard({
    super.key,
    required this.title,
    this.myIconData,
    this.initialExpanded = false,
    this.collapsedChild,
    this.expandedChild,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late final AnimationController _controller;
  late final Animation<double> _arrowAnimation;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded ?? false;
    _controller = AnimationController(
      vsync: this,
      duration: const .new(milliseconds: 200),
    );
    _arrowAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(_controller);
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            contentPadding: const .symmetric(horizontal: 16.0),
            leading: MyIcon(widget.myIconData),
            title: Text(widget.title),
            trailing: RotationTransition(
              turns: _arrowAnimation,
              child: const Icon(Icons.keyboard_arrow_down),
            ),
            onTap: _toggleExpand,
          ),
          if (widget.collapsedChild != null && !_isExpanded)
            Padding(
              padding: const .fromLTRB(16.0, 4.0, 16.0, 16.0),
              child: widget.collapsedChild,
            ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: (widget.expandedChild == null) ? null : Padding(
              padding: const .fromLTRB(16.0, 4.0, 16.0, 16.0),
              child: widget.expandedChild,
            ),
          ),
        ],
      ),
    );
  }
}
