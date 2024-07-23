import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  // Selected items set
  final Set<String> _selectedItems = {};

  // Getter to access selected items
  Set<String> get selectedItems => _selectedItems;

  // Getter to access the count of selected items
  int get selectedCount => _selectedItems.length;

  // Method to check if an item is selected
  bool isSelectedTile(String item) => _selectedItems.contains(item);

  // Method to toggle the selection of an item
  void toggleSelection(String item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }

  // Page selections map
  final Map<int, bool> _selections = {};

  // Method to check if a page is selected
  bool isSelected(int pageIndex) {
    // Special condition for page index 4
    if (pageIndex == 4 && selectedItems.length > 4) {
      return true;
    }
    return _selections[pageIndex] ?? false;
  }

  // Method to mark a page as selected
  void select(int pageIndex) {
    _selections[pageIndex] = true;
    notifyListeners();
  }
}
