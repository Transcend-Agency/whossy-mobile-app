import 'package:flutter/material.dart';

class TourNotifier extends ChangeNotifier {
  int _currentIndex = 0;
  bool _tutorialActive = false;
  Function(BuildContext)? _onTutorialStart;

  int get currentIndex => _currentIndex;
  bool get tutorialActive => _tutorialActive;

  void setTab(int index, BuildContext context) {
    _currentIndex = index;
    notifyListeners();

    // Start tutorial only if it's active
    if (_tutorialActive) {
      _onTutorialStart?.call(context);
    }
  }

  void setTutorialStarter(Function(BuildContext) onTutorialStart) {
    _onTutorialStart = onTutorialStart;
  }

  void startTutorial() {
    _tutorialActive = true;
    notifyListeners();
  }

  void endTutorial() {
    _tutorialActive = false;
    notifyListeners();
  }

  /// Resets the notifier to its default state
  void reset() {
    _currentIndex = 0;
    _tutorialActive = false;
    _onTutorialStart = null;
    notifyListeners();
  }
}
