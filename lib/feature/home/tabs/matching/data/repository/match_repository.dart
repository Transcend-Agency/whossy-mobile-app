import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../common/utils/utils.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/other_preferences.dart';
import '../../model/user_profile.dart';
import 'query_helper.dart';

class MatchRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');

  final _matchFilterSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: true,
    excludeBlockedAndSelf: true,
    excludePublicSearch: true,
  );

  /// C6: no geo bound here — reach is unlimited by default (this used to
  /// hard-cap via a geoflutterfire `within(center, radius, ...)` query,
  /// exactly the cap the plan wants gone, contrary to its own assumption
  /// that only web's swipe deck capped by distance). Distance only ranks
  /// results below, when both parties have coordinates — nobody is
  /// excluded for lacking them or being far away.
  Stream<List<UserProfile>> fetchProfilesStream({
    int limit = 20,
    double? longitude,
    double? latitude,
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
    Query profilesQuery =
        _profiles.where('has_completed_onboarding', isEqualTo: true);
    if (preferences != null || corePreferences != null) {
      profilesQuery = QueryHelper.applyFilters(
        QueryHelper.buildFilters(
          preferences,
          corePreferences,
          userInterests: [
            ...interests,
            ...(preferences?.interests ?? []),
          ],
        ),
        profilesQuery,
      );
    }
    profilesQuery = profilesQuery.limit(limit);

    return Rx.combineLatest2(
      profilesQuery.snapshots(),
      blacklistStream,
      (QuerySnapshot querySnapshot, Set<String> blacklist) {
        final ranked = querySnapshot.docs
            .where((doc) {
              final profile =
                  UserProfile.fromJson(doc.data() as Map<String, dynamic>);
              return !AppUtils.excludeProfile(
                    profile,
                    uid,
                    blockedIds,
                    settings: _matchFilterSettings,
                  ) &&
                  !blacklist.contains(profile.user.uid);
            })
            .map((doc) {
              final profile =
                  UserProfile.fromJson(doc.data() as Map<String, dynamic>);
              final geo = profile.user.geography?.geopoint;
              final distanceKm = (latitude != null &&
                      longitude != null &&
                      geo != null)
                  ? Geolocator.distanceBetween(
                        latitude,
                        longitude,
                        geo.latitude,
                        geo.longitude,
                      ) /
                      1000
                  : null;
              return MapEntry(profile, distanceKm);
            })
            .toList()
          ..sort((a, b) {
            final da = a.value ?? double.infinity;
            final db = b.value ?? double.infinity;
            return da.compareTo(db);
          });

        return ranked.map((entry) => entry.key).toList();
      },
    );
  }
}
