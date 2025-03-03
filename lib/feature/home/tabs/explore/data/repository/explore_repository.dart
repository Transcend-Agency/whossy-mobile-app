import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../common/utils/utils.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/other_preferences.dart';
import '../../../matching/data/repository/query_helper.dart';
import '../../../matching/model/user_profile.dart';
import '../../model/explore_filters.dart';
import '../../model/filter_configuration.dart';
import '../../model/liked_user_profile.dart';

class ExploreRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _limit = 30;

  final excludeSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: true,
    excludeBlockedAndSelf: true,
    excludePublicSearch: true,
  );

  Stream<List<LikedUserProfile>> streamFilteredProfiles({
    required ExploreFilters filters,
    required List<String> blockedIds,
    required OtherPreferences? preferences,
    required CorePreferences? corePreferences,
    required List<String> interests,
    required int gender,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Build the base query using filters
    Query baseQuery = _profiles;

    filters.filters.forEach((filter, value) {
      if (value != null && filterConfigs.containsKey(filter)) {
        baseQuery = filterConfigs[filter]!.apply(baseQuery, value);
      }
    });

    // Conditionally apply advanced search filters
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

    baseQuery = baseQuery.limit(_limit);

    // Combine profile snapshots with blacklist stream
    return Rx.combineLatest2(
      baseQuery.snapshots(),
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

        // Map profiles to LikedUserProfile, checking if the profile has been liked
        return profiles.map((profile) {
          final isLiked = likedIds.contains(profile.user.uid);
          return LikedUserProfile(profile: profile, isLiked: isLiked);
        }).toList();
      },
    );
  }
}
