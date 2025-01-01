import 'package:flutter/material.dart';

import '../../../../edit_profile/model/core_profile.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/other_preferences.dart';
import '../../../matching/model/user_profile.dart';
import '../../model/explore_filters.dart';
import '../repository/explore_repository.dart';

class ExploreNotifier extends ChangeNotifier {
  final _exploreRepository = ExploreRepository();

  CoreProfile? _profileData;

  // Used in filtering
  CorePreferences? _corePreferences;
  OtherPreferences? _otherPreferences;

  void saveFilters(CorePreferences? corePrefs, OtherPreferences? otherPrefs) {
    if (_otherPreferences == otherPrefs && _corePreferences == corePrefs) {
      return;
    }

    _otherPreferences = otherPrefs;
    _corePreferences = corePrefs;
    notifyListeners();
  }

  void saveProfile(CoreProfile? data) {
    if (_profileData == data) return;
    _profileData = data;
    notifyListeners();
  }

  Stream<List<UserProfile>> profileStream() {
    return _exploreRepository.streamFilteredProfiles(
      filters: _filters,
      blockedIds: _profileData?.blockedIds ?? [],
      preferences: _otherPreferences,
      corePreferences: _corePreferences,
      interests: _profileData?.interests ?? [],
    );
  }

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
