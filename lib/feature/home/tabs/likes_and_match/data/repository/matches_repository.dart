import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';

import '../../../../../../common/utils/index.dart';
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

  Stream<int> getMatchesCount() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _matches
        .where('user_ids', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<LikedUserProfile>> getMatchesWithProfile(
    List<String> blockedIds,
  ) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Normal scenario
    return _matches
        .where('user_ids', arrayContains: userId)
        .snapshots()
        .asyncMap(
      (matchesSnapshot) async {
        final otherUserIds = <String>{};

        for (final doc in matchesSnapshot.docs) {
          final ids = List<String>.from(doc['user_ids']);
          ids.remove(userId); // Remove the current user's ID
          otherUserIds.addAll(ids);
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
      },
    );
  }
}
