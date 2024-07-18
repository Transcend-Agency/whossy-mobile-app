import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  final Map<int, bool> _selections = {};

  bool isSelected(int pageIndex) => _selections[pageIndex] ?? false;

  void select(int pageIndex) {
    _selections[pageIndex] = true;
    notifyListeners();
  }
}
