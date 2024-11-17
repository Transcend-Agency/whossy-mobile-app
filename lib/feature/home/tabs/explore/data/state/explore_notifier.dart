import 'package:flutter/material.dart';

import '../../../matching/model/user_profile.dart';
import '../../model/explore_filters.dart';
import '../repository/explore_repository.dart';

class ExploreNotifier extends ChangeNotifier {
  final _exploreRepository = ExploreRepository();

  // Get the current stream of filtered profiles
  Stream<List<UserProfile>> get profileStream =>
      _exploreRepository.streamFilteredProfiles(filters: _filters);

  var _filters = ExploreFilters(filters: {});

  /// Getter for filters
  ExploreFilters get filters => _filters;

  /// Update filters object entirely
  void updateFilters(ExploreFilters newFilters) {
    _filters = newFilters;
    notifyListeners();
  }

  /// Add or update a single filter
  void addFilter(Filters filter, dynamic value) {
    _filters = _filters.addFilter(filter, value);
    notifyListeners();
  }

  /// Remove a filter
  void removeFilter(Filters filter) {
    _filters = _filters.removeFilter(filter);
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _filters = ExploreFilters(filters: {});
    notifyListeners();
  }

  dynamic getFilter(Filters type) => _filters.filters[type];
}
