import 'package:flutter/material.dart';

class NotifierSet<T> extends ChangeNotifier {
  final Set<T> _set = {};

  bool contains(T value) => _set.contains(value);

  void add(T value) {
    _set.add(value);
    notifyListeners();
  }

  void remove(T value) {
    _set.remove(value);
    notifyListeners();
  }

  Set<T> toSet() => Set.from(_set);

  bool get isEmpty => _set.isEmpty;
  bool get isNotEmpty => _set.isNotEmpty;

  List<T> get items => _set.toList();
  int get length => _set.length;
}
