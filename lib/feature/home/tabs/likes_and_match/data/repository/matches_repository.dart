import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../../common/utils/index.dart';

class MatchesRepository {
  final _matches = FirebaseFirestore.instance.collection('matches');
  final _userRepository = UserRepository();

  Stream<int> getMatchesCount() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _matches
        .where('user_ids', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<UserProfile>> getMatchesWithProfile(
    List<String> blockedIds, {
    List<String>? testLikerIds,
  }) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Don't forget to add the exclude settings while testing
    if (testLikerIds != null) {
      // For testing: directly use the provided liker IDs
      return Stream.value(testLikerIds).asyncMap((likerIds) async {
        return await _userRepository.getUserProfilesInBatches(
          userIds: likerIds,
          blockedIds: blockedIds,
        );
      });
    }

    return _matches
        .where('user1_id', isEqualTo: userId)
        .snapshots()
        .asyncMap((user1MatchesSnapshot) async {
      final user2Matches =
          await _matches.where('user2_id', isEqualTo: userId).get();

      // Extract other user IDs
      final otherUserIds = <String>{
        ...user1MatchesSnapshot.docs.map((doc) => doc['user2_id'] as String),
        ...user2Matches.docs.map((doc) => doc['user1_id'] as String),
      }.toList();

      // Use the helper function to fetch profiles in batches
      return await _userRepository.getUserProfilesInBatches(
        userIds: otherUserIds,
        blockedIds: blockedIds,
        settings: const ExcludeSettings(
          excludeIncompleteOnboarding: true,
          excludeBannedUsers: true,
          excludeUnapprovedUsers: false,
          excludeBlockedAndSelf: true,
        ),
      );
    });
  }
}
