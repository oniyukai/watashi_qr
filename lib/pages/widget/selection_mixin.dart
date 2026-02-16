import 'package:flutter/material.dart';

mixin SelectionMixin<T> {
  bool _isSelectionMode = false;
  final Set<T> _selectedObjects = <T>{};
  bool get isSelectionMode => _isSelectionMode;
  Set<T> get selectedObjects => _selectedObjects.toSet();

  void setState(VoidCallback fn);

  void enterSelectionMode(T item) {
    if (_isSelectionMode == true) {
      toggleSelection(item);
    } else {
      setState(() {
        _isSelectionMode = true;
        _selectedObjects.add(item);
      });
    }
  }

  void exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedObjects.clear();
    });
  }

  void toggleSelection(T item) {
    setState(() {
      if (_selectedObjects.contains(item)) {
        _selectedObjects.remove(item);
        if (_selectedObjects.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedObjects.add(item);
      }
    });
  }
}
