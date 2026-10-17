import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';

import '../../../../../../common/utils/utils.dart';
import '../../../explore/model/liked_user_profile.dart';

class MatchesRepository {
  final _matches = FirebaseFirestore.instance.collection('matches');
  final _userRepository = UserRepository();

  final excludeSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: false,
    excludeBlockedAndSelf: true,
  );

  /// Whether a `matches` doc exists connecting [uidA] and [uidB], in either
  /// `user1_id`/`user2_id` slot — same semantics as the web app's `isConnectedTo`.
  Future<bool> isMutualMatch(String uidA, String uidB) async {
    final result = await _matches.where(Filter.or(
      Filter.and(
        Filter('user1_id', isEqualTo: uidA),
        Filter('user2_id', isEqualTo: uidB),
      ),
      Filter.and(
        Filter('user1_id', isEqualTo: uidB),
        Filter('user2_id', isEqualTo: uidA),
      ),
    )).limit(1).get();

    return result.docs.isNotEmpty;
  }

  Stream<int> getMatchesCount() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _matches
        .where(Filter.or(
          Filter('user1_id', isEqualTo: userId),
          Filter('user2_id', isEqualTo: userId),
        ))
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<LikedUserProfile>> getMatchesWithProfile(
    List<String> blockedIds,
  ) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _matches
        .where(Filter.or(
          Filter('user1_id', isEqualTo: userId),
          Filter('user2_id', isEqualTo: userId),
        ))
        .snapshots()
        .asyncMap((matchesSnapshot) async {
      final otherUserIds = <String>{};

      for (final doc in matchesSnapshot.docs) {
        final user1 = doc['user1_id'];
        final user2 = doc['user2_id'];
        final otherUserId = (user1 == userId) ? user2 : user1;
        otherUserIds.add(otherUserId);
      }

      // Fetch the profiles of matched users
      final profiles = await _userRepository.getUserProfilesInBatches(
        userIds: otherUserIds.toList(),
        blockedIds: blockedIds,
        settings: excludeSettings,
      );

      // Map to LikedUserProfile with isLiked set to true
      return profiles
          .map(
            (profile) => LikedUserProfile(
              profile: profile,
              isLiked: true,
            ),
          )
          .toList();
    });
  }
}
