import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../common/utils/units.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../constants/discovery_constants.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/other_preferences.dart';
import '../../model/user_profile.dart';
import 'query_helper.dart';

class MatchRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');
  final _geo = GeoFlutterFire();
  static const _kPageSize = 20;
  final _pageSize = BehaviorSubject<int>.seeded(_kPageSize);
  void resetPaging() => _pageSize.add(_kPageSize);

  void loadMore() => _pageSize.add(_pageSize.value + _kPageSize);

  final _matchFilterSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: true,
    excludeBlockedAndSelf: true,
    excludePublicSearch: true,
  );

  /// Nearby first, then everyone (same order as the web swipe deck).
  ///
  /// 1. Everyone within the viewer's search radius ([radiusMiles], the
  ///    Distance Radius preference) who passes the same filters, nearest
  ///    first.
  /// 2. Then everyone else, from the normal paged query, nearer first
  ///    within what has been loaded so far.
  ///
  /// Nobody is excluded for being far away or for having no location: the
  /// radius only decides who comes first. Without the viewer's location
  /// the first group is empty and the deck is just step 2.
  Stream<List<UserProfile>> fetchProfilesStream({
    double? longitude,
    double? latitude,
    int? radiusMiles,
    required List<String> blockedIds,
    OtherPreferences? preferences,
    CorePreferences? corePreferences,
    required List<String> interests,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    Stream<Set<String>> blacklistStream = Rx.combineLatest2(
      _likes.where('liker_id', isEqualTo: uid).snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => doc['liked_id'] as String).toSet(),
          ),
      _dislikes.where('disliker_id', isEqualTo: uid).snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => doc['disliked_id'] as String)
                .toSet(),
          ),
      (likes, dislikes) => likes.union(dislikes),
    );

    // C5: has_completed_onboarding pushed server-side (it wasn't filtered
    // at all before) so the batch this query returns is cleaner going into
    // the client-side exclusion pass below, rather than relying entirely
    // on post-fetch filtering to catch it.
    final Map<String, dynamic> filters =
        (preferences != null || corePreferences != null)
            ? QueryHelper.buildFilters(
                preferences,
                corePreferences,
                userInterests: [
                  ...interests,
                  ...(preferences?.interests ?? []),
                ],
              )
            : const {};

    Query profilesQuery =
        _profiles.where('has_completed_onboarding', isEqualTo: true);
    if (filters.isNotEmpty) {
      profilesQuery = QueryHelper.applyFilters(filters, profilesQuery);
    }

    // Growing the limit re-runs the whole query each time rather than
    // cursoring — safe and correct as long as ordering is stable across
    // calls, which requires an explicit orderBy (Firestore's default order
    // isn't guaranteed stable). That orderBy must match whichever field (if
    // any) carries the query's own inequality filter — age min/max both
    // target date_of_birth, hasBio targets bio, and Firestore allows at
    // most one inequality field per query, so there's never ambiguity in
    // picking between them. Same constraint ExploreRepository already
    // navigates for its own filters.
    final orderByField = preferences?.ageRange != null
        ? 'date_of_birth'
        : preferences?.hasBio == true
            ? 'bio'
            : 'created_at';

    final Stream<QuerySnapshot> queryStream = _pageSize.stream.switchMap(
      (size) => profilesQuery.orderBy(orderByField).limit(size).snapshots(),
    );

    // Read once per deck load rather than kept live: a live geo query would
    // re-read every nearby profile each time any of them changes (online
    // status updates included). Likes and dislikes still drop people out of
    // it straight away through the blacklist below. If it fails (no
    // location index, offline), the deck falls back to everyone.
    final Stream<List<DocumentSnapshot>> nearbyStream = (latitude != null &&
            longitude != null)
        ? Stream.fromFuture(
            _geo
                .collection(
                  collectionRef: _profiles.where(
                    'has_completed_onboarding',
                    isEqualTo: true,
                  ),
                )
                .withinAsSingleStreamSubscription(
                  center: _geo.point(
                    latitude: latitude,
                    longitude: longitude,
                  ),
                  radius: milesToKm(
                    (radiusMiles ?? kDefaultDiscoveryRadiusMiles).toDouble(),
                  ),
                  field: 'geography',
                  strictMode: true,
                )
                .first,
          ).onErrorReturnWith((error, _) {
            log('Nearby profiles unavailable, showing everyone: $error');
            return const <DocumentSnapshot>[];
          })
        : Stream.value(const <DocumentSnapshot>[]);

    double? distanceKmTo(UserProfile profile) {
      final geo = profile.user.geography?.geopoint;
      if (latitude == null || longitude == null || geo == null) return null;
      return Geolocator.distanceBetween(
            latitude,
            longitude,
            geo.latitude,
            geo.longitude,
          ) /
          1000;
    }

    // Unknown distance sorts last.
    int byDistance(
      MapEntry<UserProfile, double?> a,
      MapEntry<UserProfile, double?> b,
    ) =>
        (a.value ?? double.infinity).compareTo(b.value ?? double.infinity);

    return Rx.combineLatest3(
      nearbyStream,
      queryStream,
      blacklistStream,
      (
        List<DocumentSnapshot> nearbyDocs,
        QuerySnapshot querySnapshot,
        Set<String> blacklist,
      ) {
        bool isEligible(UserProfile profile) =>
            !AppUtils.excludeProfile(
              profile,
              uid,
              blockedIds,
              settings: _matchFilterSettings,
            ) &&
            !blacklist.contains(profile.user.uid);

        // The geo query only filters on onboarding, so the viewer's other
        // preferences (gender, age, ...) are applied here instead.
        final nearby = <MapEntry<UserProfile, double?>>[];
        final nearbyIds = <String>{};
        for (final doc in nearbyDocs) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data == null || !QueryHelper.matches(data, filters)) continue;
          final profile = UserProfile.fromJson(data);
          final profileUid = profile.user.uid;
          if (profileUid == null || !isEligible(profile)) continue;
          if (!nearbyIds.add(profileUid)) continue;
          nearby.add(MapEntry(profile, distanceKmTo(profile)));
        }
        nearby.sort(byDistance);

        final everyoneElse = querySnapshot.docs
            .map((doc) =>
                UserProfile.fromJson(doc.data() as Map<String, dynamic>))
            .where((profile) =>
                isEligible(profile) && !nearbyIds.contains(profile.user.uid))
            .map((profile) => MapEntry(profile, distanceKmTo(profile)))
            .toList()
          ..sort(byDistance);

        return [...nearby, ...everyoneElse].map((entry) => entry.key).toList();
      },
    );
  }
}
