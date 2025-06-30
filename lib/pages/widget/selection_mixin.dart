import 'package:flutter/material.dart';

mixin SelectionMixin<T extends StatefulWidget, E> on State<T> {
  bool _isSelectionMode = false;
  final Set<E> _selectedObjects = <E>{};
  bool get isSelectionMode => _isSelectionMode;
  Set<E> get selectedObjects => _selectedObjects;

  void enterSelectionMode(E item) {
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

  void toggleSelection(E item) {
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