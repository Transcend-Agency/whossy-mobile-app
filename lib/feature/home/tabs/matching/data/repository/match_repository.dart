import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/other_preferences.dart';
import '../../model/user_profile.dart';
import 'query_helper.dart';

class MatchRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');
  final _matches = FirebaseFirestore.instance.collection('matches');
  final _geo = GeoFlutterFire();
  final double radiusInKm = 50; // Default radius in kilometers

  final _matchFilterSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: true,
    excludeBlockedAndSelf: true,
    excludePublicSearch: true,
  );

  Stream<List<UserProfile>> fetchProfilesStream({
    int limit = 20,
    double? longitude,
    double? latitude,
    required List<String> blockedIds,
    OtherPreferences? preferences,
    CorePreferences? corePreferences,
    required List<String> interests,
  }) 
  
  {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (latitude == null || longitude == null) {
      return Stream.value([]);
    }

    double radius = preferences?.distance?.toDouble() ?? radiusInKm;
    if (preferences?.outreach == true) {
      radius = 300;
    }

    final center = _geo.point(latitude: latitude, longitude: longitude);

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

    var geoQueryStream = _geo
        .collection(collectionRef: _profiles)
        .within(center: center, radius: radius, field: 'geography');

    // Combine geoQueryStream with blacklistStream
    return Rx.combineLatest2(
      geoQueryStream,
      blacklistStream,
      (List<DocumentSnapshot> geoSnapshots, Set<String> blacklist) {
        if (geoSnapshots.isEmpty) return Stream.value([]);

        // Reactive profiles query based on preferences
        Query profilesQuery = _profiles;
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

        // Transform geoSnapshots and profilesQuery into a stream of List<UserProfile>
        return profilesQuery.snapshots().map(
          (querySnapshot) {
            final filteredIds = querySnapshot.docs.map((doc) => doc.id).toSet();

            final userProfiles = geoSnapshots
                .where((doc) {
                  final profile =
                      UserProfile.fromJson(doc.data() as Map<String, dynamic>);

                  // final distance = (Geolocator.distanceBetween(
                  //             latitude,
                  //             longitude,
                  //             profile.user.geography!.geopoint!.latitude,
                  //             profile.user.geography!.geopoint!.longitude) /
                  //         1000)
                  //     .floor();

                  // log('${profile.name} and distance is $distance -- Search radius $radius');

                  return !AppUtils.excludeProfile(
                        profile,
                        uid,
                        blockedIds,
                        settings: _matchFilterSettings,
                      ) &&
                      !blacklist.contains(profile.user.uid) &&
                      filteredIds.contains(doc.id);
                     // && radius.toInt() >= distance;
                })
                .map((doc) {
                  return UserProfile.fromJson(
                      doc.data() as Map<String, dynamic>);
                })
                .take(limit)
                .toList();

            return userProfiles;
          },
        );
      },
    ).switchMap((stream) => stream.cast<List<UserProfile>>());
  }
}
