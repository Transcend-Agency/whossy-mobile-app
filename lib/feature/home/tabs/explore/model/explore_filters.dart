import '../../../../../constants/index.dart';

typedef FilterCondition = bool Function(dynamic filterValue);

class ExploreFilters {
  final Map<Filters, dynamic> filters;

  ExploreFilters({required this.filters});

  /// Helper to add a filter dynamically
  ExploreFilters addFilter(Filters filter, dynamic value) {
    final updatedFilters = Map<Filters, dynamic>.from(filters);
    updatedFilters[filter] = value;
    return ExploreFilters(filters: updatedFilters);
  }

  /// Helper to remove a filter dynamically
  ExploreFilters removeFilter(Filters filter) {
    final updatedFilters = Map<Filters, dynamic>.from(filters);
    updatedFilters.remove(filter);
    return ExploreFilters(filters: updatedFilters);
  }
}

enum Filters {
  similarInterest('Similar Interest'),
  online('Online'),
  newMembers('New members'),
  popularInMyArea('Popular in my area'),
  lookingToDate('Looking to date'),
  outsideMyCountry('Outside my country'),
  advancedSearch('Advanced search', AppAssets.wwSearch);

  final String label;
  final String? avatar;

  const Filters(this.label, [this.avatar]);
}
