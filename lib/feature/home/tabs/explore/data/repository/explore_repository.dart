import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../common/utils/units.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/other_preferences.dart';
import '../../../matching/data/repository/query_helper.dart';
import '../../../matching/model/user_profile.dart';
import '../../model/explore_filters.dart';
import '../../model/filter_configuration.dart';
import '../../model/liked_user_profile.dart';

// C5 — Discover/Online/New members/Looking to date (and Advanced Search's
// non-geo, non-interest combinations) paginate cleanly with a growing
// server-side limit. Similar interest (client-sorted by shared-interest
// count — see below), Outside my country (client-filtered) and Popular in
// my area (geo-bounded + sorted by popularity) don't compose with that in
// their current form; they get one capped page instead of true "load more"
// for now — documented, not silently unbounded.
const _kPageSize = 30;
const _kUnpaginatedBranchLimit = 60;

class ExploreRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _geo = GeoFlutterFire();

  final _pageSize = BehaviorSubject<int>.seeded(_kPageSize);

  final excludeSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: true,
    excludeBlockedAndSelf: true,
    excludePublicSearch: true,
  );

  /// Call when the active filter changes so a fresh filter starts at page 1
  /// rather than inheriting the previous filter's page size.
  void resetPaging() => _pageSize.add(_kPageSize);

  void loadMore() => _pageSize.add(_pageSize.value + _kPageSize);

  Stream<List<LikedUserProfile>> streamFilteredProfiles({
    required ExploreFilters filters,
    required List<String> blockedIds,
    required OtherPreferences? preferences,
    required CorePreferences? corePreferences,
    required List<String> interests,
    required int gender,
    double? latitude,
    double? longitude,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (filters.filters.containsKey(Filters.popularInMyArea)) {
      return _streamPopularInMyArea(
        uid: uid,
        blockedIds: blockedIds,
        latitude: latitude,
        longitude: longitude,
        radiusMiles: preferences?.distance,
      );
    }

    // Firestore's arrayContainsAny rejects an empty list outright, and
    // falling through to an unfiltered query used to silently show everyone
    // under a filter labeled "Similar interest" instead of telling the
    // viewer why there's nothing to show.
    if (filters.filters.containsKey(Filters.similarInterest) &&
        interests.isEmpty) {
      return Stream.value(<LikedUserProfile>[]);
    }

    // has_completed_onboarding wasn't filtered server-side at all before —
    // every batch relied entirely on the post-fetch removeWhere below,
    // which (combined with the old fixed limit) meant a page could shrink
    // well under what was requested with no backfill.
    Query baseQuery = _profiles.where('has_completed_onboarding', isEqualTo: true);

    filters.filters.forEach((filter, value) {
      // Outside my country needs client-side handling (below) — Firestore's
      // isNotEqualTo drops documents missing the field entirely.
      if (filter == Filters.outsideMyCountry) return;
      if (value != null && filterConfigs.containsKey(filter)) {
        baseQuery = filterConfigs[filter]!.apply(baseQuery, value);
      }
    });

    if (filters.filters.containsKey(Filters.advancedSearch)) {
      if (preferences != null || corePreferences != null) {
        baseQuery = QueryHelper.applyFilters(
          QueryHelper.buildFilters(
            preferences,
            corePreferences,
            userInterests: [
              ...interests,
              ...(preferences?.interests ?? []),
            ],
          ),
          baseQuery,
        );
      }
    } else {
      if (gender == 0) {
        baseQuery = baseQuery.where('gender', isEqualTo: 'Male');
      } else if (gender == 1) {
        baseQuery = baseQuery.where('gender', isEqualTo: 'Female');
      }
    }

    final outsideMyCountryValue =
        filters.filters[Filters.outsideMyCountry] as String?;
    // Similar interest re-sorts by shared-interest count and Advanced
    // Search stacks arbitrary combinations — neither composes with a
    // growing server cursor without more work (same tension noted on the
    // web side); everything else pages normally.
    final paginated = !filters.filters.containsKey(Filters.advancedSearch) &&
        !filters.filters.containsKey(Filters.similarInterest);

    // Growing the limit re-runs the whole query each time rather than
    // cursoring — safe and correct as long as ordering is stable across
    // calls, which requires an explicit orderBy (Firestore's default order
    // isn't guaranteed stable). Must match whichever field carries the
    // active range filter, if any — Firestore requires the first orderBy to
    // be the inequality's own field.
    final orderByField =
        filters.filters.containsKey(Filters.online) ? 'status.lastSeen' : 'created_at';

    final Stream<QuerySnapshot> queryStream = paginated
        ? _pageSize.stream.switchMap(
            (size) => baseQuery.orderBy(orderByField).limit(size).snapshots())
        : baseQuery.limit(_kUnpaginatedBranchLimit).snapshots();

    // Combine profile snapshots with blacklist stream
    return Rx.combineLatest2(
      queryStream,
      _likes.where('liker_id', isEqualTo: uid).snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => doc['liked_id'] as String).toSet(),
          ),
      (querySnapshot, likedIds) {
        final profiles = querySnapshot.docs
            .map((doc) =>
                UserProfile.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        // Apply local filtering
        profiles.removeWhere(
          (profile) => AppUtils.excludeProfile(
            profile,
            uid,
            blockedIds,
            settings: excludeSettings,
          ),
        );

        if (outsideMyCountryValue != null) {
          profiles.removeWhere(
            (profile) => profile.user.countryOfOrigin == outsideMyCountryValue,
          );
        }

        // Similar interest, most-shared-first — unchanged sort, now over a
        // capped single page (see `paginated` above).
        if (filters.filters.containsKey(Filters.similarInterest)) {
          profiles.sort((a, b) {
            final sharedA = interests
                .where((i) => a.preferences.ticks?.contains(i) ?? false)
                .length;
            final sharedB = interests
                .where((i) => b.preferences.ticks?.contains(i) ?? false)
                .length;
            return sharedB - sharedA;
          });
        }

        // Map profiles to LikedUserProfile, checking if the profile has been liked
        return profiles.map((profile) {
          final isLiked = likedIds.contains(profile.user.uid);
          return LikedUserProfile(profile: profile, isLiked: isLiked);
        }).toList();
      },
    );
  }

  /// C2 — "Popular in my area" built for real: a genuine geo bound (the
  /// viewer's saved search radius) and a genuine popularity signal
  /// (functions/src/popularity.ts's rolling 30-day like count), instead of
  /// re-running the "same country" query under a different label.
  Stream<List<LikedUserProfile>> _streamPopularInMyArea({
    required String uid,
    required List<String> blockedIds,
    required double? latitude,
    required double? longitude,
    required int? radiusMiles,
  }) {
    if (latitude == null || longitude == null) return Stream.value([]);

    final center = _geo.point(latitude: latitude, longitude: longitude);
    final radiusKm = milesToKm((radiusMiles ?? 50).toDouble());
    final onboardedQuery =
        _profiles.where('has_completed_onboarding', isEqualTo: true);

    final geoStream = _geo
        .collection(collectionRef: onboardedQuery)
        .within(center: center, radius: radiusKm, field: 'geography');

    final likedIdsStream = _likes
        .where('liker_id', isEqualTo: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['liked_id'] as String).toSet());

    return Rx.combineLatest2(geoStream, likedIdsStream, (docs, likedIds) {
      final profiles = docs
          .map((doc) =>
              UserProfile.fromJson(doc.data() as Map<String, dynamic>))
          .where((profile) => !AppUtils.excludeProfile(
                profile,
                uid,
                blockedIds,
                settings: excludeSettings,
              ))
          .toList()
        ..sort((a, b) {
          final scoreA = a.user.popularityScore30d ?? 0;
          final scoreB = b.user.popularityScore30d ?? 0;
          return scoreB.compareTo(scoreA);
        });

      return profiles.map((profile) {
        final isLiked = likedIds.contains(profile.user.uid);
        return LikedUserProfile(profile: profile, isLiked: isLiked);
      }).toList();
    });
  }
}
