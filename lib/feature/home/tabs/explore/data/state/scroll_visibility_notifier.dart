import 'package:flutter/material.dart';

class ScrollVisibilityNotifier extends ChangeNotifier {
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void updateVisibility(bool visible) {
    if (_isVisible != visible) {
      _isVisible = visible;
      notifyListeners();
    }
  }
}
