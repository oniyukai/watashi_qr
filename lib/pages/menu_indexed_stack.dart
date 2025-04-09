import 'package:flutter/material.dart';

// 客制了 IndexedStack 第一頁一進入會建構，一離開會解構
class CustomIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const CustomIndexedStack({
    super.key,
    this.index = 0,
    required this.children,
  });

  @override
  State<CustomIndexedStack> createState() => _CustomIndexedStackState();
}

class _CustomIndexedStackState extends State<CustomIndexedStack> {
  late int _currentIndex;
  late Widget _currentFirstPage;
  bool _firstPageActive = true; // 追蹤第一頁是否處於活動狀態

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _currentFirstPage = _buildFirstPage();
    _firstPageActive = widget.index == 0; // 初始化時判斷第一頁是否活動
  }

  @override
  void didUpdateWidget(covariant CustomIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      setState(() {
        if (_currentIndex == 0 && widget.index != 0) {
          // 當離開第一頁時，解構第一頁
          _firstPageActive = false;
          // 這裡沒有實際的解構動作，只是不再顯示，讓Flutter框架自動解構
        } else if (widget.index == 0) {
          _firstPageActive = true; // 進入第一頁時，重新建構第一頁
          _currentFirstPage = _buildFirstPage();
        }

        _currentIndex = widget.index;
      });
    }
  }

  Widget _buildFirstPage() {
    return KeyedSubtree(
      key: UniqueKey(),
      child: widget.children[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: [
        (_firstPageActive)? _currentFirstPage : const SizedBox.shrink(), // 僅當第一頁處於活動狀態時顯示
        ...widget.children.sublist(1),
      ],
    );
  }
}