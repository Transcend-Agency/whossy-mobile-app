import 'package:cloud_firestore/cloud_firestore.dart';

import 'explore_filters.dart';

class FilterConfig {
  final String firestoreKey;
  final dynamic Function(Query query, dynamic value) apply;

  const FilterConfig(this.firestoreKey, this.apply);
}

// Define filter configurations for each filter. Filters.similarInterest,
// Filters.outsideMyCountry and Filters.popularInMyArea are deliberately
// absent — all three need handling ExploreRepository does explicitly (C2):
// "similar interest" needs to skip the query entirely (and surface why)
// when the viewer has no interests recorded, since Firestore's
// arrayContainsAny rejects an empty list outright; "outside my country"
// needs a client-side check since Firestore's isNotEqualTo drops documents
// missing the field; "popular in my area" needs a real geo-bounded query
// sorted by popularity, not a single where() clause.
final Map<Filters, FilterConfig> filterConfigs = {
  Filters.discover: FilterConfig(
    'uid',
    (query, value) => query,
  ),
  Filters.online: FilterConfig(
    'status.lastSeen',
    (query, value) =>
        query.where('status.lastSeen', isGreaterThanOrEqualTo: value as int),
  ),
  Filters.newMembers: FilterConfig(
    'created_at',
    (query, value) => query.where(
      'created_at',
      isGreaterThanOrEqualTo: Timestamp.fromDate(value as DateTime),
    ),
  ),
  Filters.lookingToDate: FilterConfig(
    'preference',
    (query, value) => query.where('preference', isEqualTo: value as int),
  ),
  Filters.advancedSearch: FilterConfig(
    'uid',
    (query, value) => query,
  ),
};
