import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../../common/utils/index.dart';

class MatchRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _geo = GeoFlutterFire();

  final _matchFilterSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: true,
    excludeBlockedAndSelf: true,
  );

  Stream<List<UserProfile>> fetchProfilesStream({
    int limit = 10,
    double radiusInKm = 300,
    double? longitude,
    double? latitude,
    required List<String> blockedIds,
  }) async* {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (latitude == null || longitude == null) {
      yield [];
      return;
    }

    final center = _geo.point(latitude: latitude, longitude: longitude);

    // Real-time listeners for likes and dislikes
    final likesStream = FirebaseFirestore.instance
        .collection('likes')
        .where('liker_id', isEqualTo: uid)
        .snapshots();

    final dislikesStream = FirebaseFirestore.instance
        .collection('dislikes')
        .where('disliker_id', isEqualTo: uid)
        .snapshots();

    // Combine liked and disliked IDs into a set
    final blacklist = <String>{};

    likesStream.listen((snapshot) {
      for (var doc in snapshot.docs) {
        blacklist.add(doc['liked_id']);
      }
    });

    dislikesStream.listen((snapshot) {
      for (var doc in snapshot.docs) {
        blacklist.add(doc['disliked_id']);
      }
    });

    // Main profiles query
    var query = _geo
        .collection(collectionRef: _profiles)
        .within(center: center, radius: radiusInKm, field: 'geography');

    await for (var documentSnapshots in query) {
      final List<UserProfile> userProfiles = [];

      if (documentSnapshots.isEmpty) {
        yield userProfiles;
        continue;
      }

      for (var doc in documentSnapshots) {
        if (doc.data() == null) {
          continue;
        }

        final profile =
            UserProfile.fromJson(doc.data() as Map<String, dynamic>);

        if (!AppUtils.excludeProfile(profile, uid, blockedIds,
                settings: _matchFilterSettings) &&
            !blacklist.contains(profile.user.uid)) {
          userProfiles.add(profile);
          if (userProfiles.length >= limit) {
            break;
          }
        }
      }

      yield userProfiles;
    }
  }
}
